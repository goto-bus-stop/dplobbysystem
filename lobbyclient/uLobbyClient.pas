unit uLobbyClient;

interface

uses
  Contnrs, Classes, SysUtils, DPlay;

type
  TRequestType = (rtRegisterUser = 0, rtLoginUser, rtLogoutUser, rtGetHostedGames,
    rtHostGame, rtJoinGame, rtLeaveGame, rtGameStats, rtGetRatings, rtUnknown);

  TRequest = class
  private
    FRequestType: TRequestType;
    procedure SetRequestType(const ARequestType: TRequestType);
  protected
    Params: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TRequest);
    function GetParamAsString(const Param: String): String;
    function GetParamAsInt(const Param: String): Integer;
    function GetParamAsBool(const Param: String): Boolean;
    procedure AddStringParam(const Param, Value: String; Base64Encode: Boolean = False);
    procedure AddIntParam(const Param: String; const Value: Integer);
    procedure AddBoolParam(const Param: String; const Value: Boolean);
    property RequestType: TRequestType read FRequestType write SetRequestType;
  end;

  TResponse = TRequest;

  TThreadException = procedure(Sender: TObject; Exception: Exception) of object;

  THttpRequestThread = class(TThread)
  private
    FException: Exception;
    FOnException: TThreadException;
    FRequest: TRequest;
    FResponse: TResponse;
    FLobbyServerUrl: String;
  protected
    procedure Execute; override;
    procedure HandleThreadException;
  public
    constructor Create(const LobbyServerUrl: String; const Request: TRequest);
    destructor Destroy; override;
  published
    property OnException: TThreadException read FOnException write FOnException;
    property Request: TRequest read FRequest;
    property Response: TResponse read FResponse;
  end;

  TGameStatus = (gsWaiting, gsJoinInProgress, gsInProgress);
  THostedGame = class(TObject)
    Id: Integer;
    Game: String;
    Guid: TGUID;
    SessionGuid: TGUID;
    IP: String;
    Title: String;
    Description: String;
    MaxPlayers: Integer;
    DateTime: TDateTime;
    Password: Boolean;
    Status: TGameStatus;
    RoomId: Integer;
    HostPing: Integer;
    PlayerList: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: THostedGame);
    function IsFull: Boolean;
  end;

  TServerSettings = record
    IRCServer: String;
    IRCPort: Integer;
    IRCChannel: String;
    ClientJoins: Boolean;
    WelcomeMessage: String;
    LobbyUrl: String;
  end;

  TOnRegisterUser = procedure(const Username, Email: String; ResponseCode: Integer;
    const ResponseText, ServerVersion: String) of object;
  { Token or ResponseText if UserId = 0 }
  TOnLoginUser = procedure(const Username, Password: String; UserId: Integer; const Token: String;
    Rating: Integer; const ServerVersion: String; const ServerSettings: TServerSettings) of object;
  TOnLogoutUser = procedure(Result: Boolean) of object;
  TOnGetHostedGames = procedure(HostedGames: TObjectList) of object;
  TOnHostGame = procedure(Result: Boolean; GameId: Integer) of object;
  TOnJoinGame = TOnHostGame;
  TOnLeaveGame = TOnHostGame;
  TOnGetRatings = procedure(Result: Boolean; var Players: TStringList) of object;

  TOnRequestException = procedure(RequestType: TRequestType; Exception: Exception) of object;
  {$IFDEF DEBUG}
  TOnGameStats = procedure(const Response: String) of object;
  {$ENDIF}

  TLobbyClient = class(TObject)
  private
    FThreadRefCount: Integer;
    FLobbyServerUrl: String;
    FVersion: String;
    FOnRegisterUser: TOnRegisterUser;
    FOnLoginUser: TOnLoginUser;
    FOnLogoutUser: TOnLogoutUser;
    FOnGetHostedGames: TOnGetHostedGames;
    FOnHostGame: TOnHostGame;
    FOnJoinGame: TOnJoinGame;
    FOnLeaveGame: TOnLeaveGame;
    FOnGetRatings: TOnGetRatings;
    FOnRequestException: TOnRequestException;
    {$IFDEF DEBUG}FOnGameStats: TOnGameStats;{$ENDIF}
    procedure HandleHttpRequestTerminate(Sender: TObject);
    procedure HandleHttpRequestException(Sender: TObject; Exception: Exception);
    function HasThreads: Boolean;
  protected
    procedure SendRequest(const Request: TRequest);
    function ServerTimeToDateTime(DateTime: String): TDateTime;
  public
    constructor Create;
    procedure RegisterUser(const Username, Email{$IFDEF HAMACHI}, IP{$ENDIF}: String);
    procedure LoginUser(const Username, Password: String);
    procedure LogoutUser(const UserId: Integer; const Token: String);
    procedure GetHostedGames(const UserId: Integer; const Token: String);
    procedure HostGame(const UserId: Integer; const Token: String; Game: THostedGame);
    procedure JoinGame(const UserId: Integer; const Token: String; Game: THostedGame);
    procedure LeaveGame(const UserId: Integer; const Token: String; Game: THostedGame);
    procedure SendGameStats(const UserId: Integer; const Token: String; G: THostedGame;
      const GameStats: TGameStats);
    procedure GetRatings(const UserId: Integer; const Token: String; Players: TStringList);
    property LobbyServerUrl: String read FLobbyServerUrl write FLobbyServerUrl;
    property OnRegisterUser: TOnRegisterUser read FOnRegisterUser write FOnRegisterUser;
    property OnLoginUser: TOnLoginUser read FOnLoginUser write FOnLoginUser;
    property OnLogoutUser: TOnLogoutUser read FOnLogoutUser write FOnLogoutUser;
    property OnGetHostedGames: TOnGetHostedGames read FOnGetHostedGames write FOnGetHostedGames;
    property OnHostGame: TOnHostGame read FOnHostGame write FOnHostGame;
    property OnJoinGame: TOnJoinGame read FOnJoinGame write FOnJoinGame;
    property OnLeaveGame: TOnLeaveGame read FOnLeaveGame write FOnLeaveGame;
    property OnGetRatings: TOnGetRatings read FOnGetRatings write FOnGetRatings;
    property OnRequestException: TOnRequestException read FOnRequestException write FOnRequestException;
    {$IFDEF DEBUG}property OnGameStats: TOnGameStats read FOnGameStats write FOnGameStats;{$ENDIF}
    property HasActiveThreads: Boolean read HasThreads;
    property Version: String read FVersion;
  end;

const
  DEFAULT_RATING = 1600;
  JOIN_MINS = 10; { after 10 mins change join in progress to game in progress }

implementation

uses
  IdHttp, IdCoderMIME, ActiveX, Windows, DateUtils;

const
  CLIENT_VERSION = '2.01';

{ TRequest }

constructor TRequest.Create;
begin
  inherited Create;
  FRequestType := rtUnknown;
  Params := TStringList.Create;
end;

destructor TRequest.Destroy;
begin
  Params.Free;
  inherited Destroy;
end;

procedure TRequest.Assign(Source: TRequest);
begin
  FRequestType := Source.FRequestType;
  Params.Assign(Source.Params);
end;

procedure TRequest.SetRequestType(const ARequestType: TRequestType);
begin
  FRequestType := ARequestType;
  AddIntParam('req', Ord(FRequestType));
end;

function TRequest.GetParamAsString(const Param: String): String;
begin
  Result := Params.Values[Param];
end;

function TRequest.GetParamAsInt(const Param: String): Integer;
begin
  Result := StrToIntDef(Params.Values[Param], 0);
end;

function TRequest.GetParamAsBool(const Param: String): Boolean;
begin
  Result := StrToIntDef(Params.Values[Param], 0) <> 0;
end;

procedure TRequest.AddStringParam(const Param, Value: String; Base64Encode: Boolean = False);
var
  i: Integer;
begin
  i := Params.IndexOfName(Param);
  if (i <> -1) then
  begin
    if Base64Encode then
      Params.ValueFromIndex[i] := TIdEncoderMIME.EncodeString(Value)
    else
      Params.ValueFromIndex[i] := Value;
  end else
  begin
    if Base64Encode then
      Params.Add(Format('%s=%s', [Param, TIdEncoderMIME.EncodeString(Value)]))
    else
      Params.Add(Format('%s=%s', [Param, Value]))
  end;
end;

procedure TRequest.AddIntParam(const Param: String; const Value: Integer);
begin
  AddStringParam(Param, IntToStr(Value));
end;

procedure TRequest.AddBoolParam(const Param: String; const Value: Boolean);
begin
  AddIntParam(Param, Ord(Value));
end;

{ THttpRequestThread }

constructor THttpRequestThread.Create(const LobbyServerUrl: String; const Request: TRequest);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FException := nil;
  FOnException := nil;
  FRequest := TRequest.Create;
  FRequest.Assign(Request);
  FResponse := TResponse.Create;
  FLobbyServerUrl := LobbyServerUrl;
end;

destructor THttpRequestThread.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  inherited Destroy;
end;

procedure THttpRequestThread.Execute;
var
  IdHTTP: TIdHTTP;
  Params: TStringList;
  Responses: TStringList;
begin
  IdHTTP := TIdHTTP.Create(nil);
  { bypass apache mod_security2 filters }
  IdHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; LobbyClient)';
  Responses := TStringList.Create;
  Params := TStringList.Create;
  try
    try
      { IdHTTP.HTTPOptions = [hoForceEncodeParams] => Post modifies Params }
      Params.Assign(FRequest.Params);
      Responses.Text := IdHTTP.Post(FLobbyServerUrl, Params);
      case FRequest.RequestType of
      {$IFDEF DEBUG}
        rtGameStats:
          begin
            FResponse.AddStringParam('debug', Responses.Text);
          end;
      {$ENDIF}
        rtRegisterUser:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
            if (Responses.Count > 1) then
              FResponse.AddStringParam('version', Responses[1]);
            if (Responses.Count > 2) then
              FResponse.AddStringParam('text', Responses[2]);
          end;
        rtLoginUser:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
            if (Responses.Count > 1) then
              FResponse.AddStringParam('version', Responses[1]);
            if (FResponse.GetParamAsInt('code') = 0) then
            begin
              FResponse.AddIntParam('id', 0);
              if (Responses.Count > 2) then
                FResponse.AddStringParam('token', Responses[2]);
            end else
            begin
              if (Responses.Count > 2) then
                FResponse.AddIntParam('id', StrToIntDef(Responses[2], 0));
              if (Responses.Count > 3) then
                FResponse.AddStringParam('token', Responses[3]);
              if (Responses.Count > 4) then
                FResponse.AddStringParam('username', Responses[4]);
              if (Responses.Count > 5) then
                FResponse.AddIntParam('rating', StrToIntDef(Responses[5], DEFAULT_RATING));
              if (Responses.Count > 6) then
                FResponse.AddStringParam('ircserver', Responses[6]);
              if (Responses.Count > 7) then
                FResponse.AddIntParam('ircport', StrToIntDef(Responses[7], 0));
              if (Responses.Count > 8) then
                FResponse.AddStringParam('ircchannel', Responses[8]);
              if (Responses.Count > 9) then
                FResponse.AddStringParam('clientjoins', Responses[9]);
              if (Responses.Count > 10) then
                FResponse.AddStringParam('message', Responses[10]);
              if (Responses.Count > 11) then
                FResponse.AddStringParam('lobbyurl', Responses[11]);
            end;
          end;
        rtLogoutUser:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
          end;
        rtGetHostedGames:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
            if (Responses.Count > 1) then
            begin
              with TStringList.Create do
                try
                  Assign(Responses);
                  Delete(0);
                  FResponse.AddStringParam('games', Text);
                finally
                  Free;
                end;
            end;
          end;
        rtHostGame:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
            if (FResponse.GetParamAsInt('code') <> 0) then
              if (Responses.Count > 1) then
                FResponse.AddIntParam('gameid', StrToIntDef(Responses[1], 0));
          end;
        rtJoinGame, rtLeaveGame:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
          end;
        rtGetRatings:
          begin
            if (Responses.Count > 0) then
              FResponse.AddIntParam('code', StrToIntDef(Responses[0], 0));
            if (Responses.Count > 1) then
            begin
              with TStringList.Create do
                try
                  Assign(Responses);
                  Delete(0);
                  FResponse.AddStringParam('ratings', Text);
                finally
                  Free;
                end;
            end;
          end;
      end;
    except
      if not(ExceptObject is EAbort) then
      begin
        FException := Exception(ExceptObject);
        Synchronize(HandleThreadException);
      end;
    end;
  finally
    FreeAndNil(IdHTTP);
    Params.Free;
    Responses.Free;
  end;
end;

procedure THttpRequestThread.HandleThreadException;
begin
  try
    if Assigned(FOnException) then
      FOnException(Self, FException);
  finally
    FException := nil;
  end;
end;

{ THostedGame }

constructor THostedGame.Create;
begin
  inherited Create;
  Id := 0;
  Password := False;
  HostPing := 0;
  Status := gsJoinInProgress;
  PlayerList := TStringList.Create;
end;

destructor THostedGame.Destroy;
begin
  FreeAndNil(PlayerList);
  inherited Destroy;
end;

procedure THostedGame.Assign(Source: THostedGame);
begin
  PlayerList.Clear;
  Id := Source.Id;
  Game := Source.Game;
  Guid := Source.Guid;
  SessionGuid := Source.SessionGuid;
  IP := Source.IP;
  Title := Source.Title;
  Description := Source.Description;
  MaxPlayers := Source.MaxPlayers;
  DateTime := Source.DateTime;
  Password := Source.Password;
  RoomId := Source.RoomId;
  HostPing := Source.HostPing;
  PlayerList.Assign(Source.PlayerList);
end;

function THostedGame.IsFull: Boolean;
begin
  Result := PlayerList.Count = MaxPlayers;
end;

{ TLobbyClient }

constructor TLobbyClient.Create;
begin
  FThreadRefCount := 0;
  FLobbyServerUrl := '';
  FVersion := CLIENT_VERSION;
  FOnRegisterUser := nil;
  FOnLoginUser := nil;
  FOnLogoutUser := nil;
  FOnGetHostedGames := nil;
  FOnHostGame := nil;
  FOnJoinGame := nil;
  FOnLeaveGame := nil;
  FOnGetRatings := nil;
  FOnRequestException := nil;
  {$IFDEF DEBUG}FOnGameStats := nil;{$ENDIF DEBUG}
end;

procedure TLobbyClient.HandleHttpRequestTerminate(Sender: TObject);
var
  T: THttpRequestThread;
  Username, Email, Password, ResponseText, Token, Version, PlayerName: String;
  UserId, Rating, ResponseCode, GameId, i, j: Integer;
  Games, Game, PlayerList, Ratings: TStringList;
  HostedGames: TObjectList;
  G: THostedGame;
  ServerSettings: TServerSettings;
begin
  Dec(FThreadRefCount);
  T := Sender as THttpRequestThread;
  case T.Request.RequestType of
  {$IFDEF DEBUG}
    rtGameStats:
      begin
        if Assigned(FOnGameStats) then
          FOnGameStats(T.Response.GetParamAsString('debug'));
      end;
  {$ENDIF}
    rtRegisterUser:
      begin
        Username := T.Request.GetParamAsString('username');
        Email := T.Request.GetParamAsString('email');
        ResponseCode := T.Response.GetParamAsInt('code');
        ResponseText := T.Response.GetParamAsString('text');
        Version := T.Response.GetParamAsString('version');
        if Assigned(FOnRegisterUser) then
          FOnRegisterUser(Username, Email, ResponseCode, ResponseText, Version);
      end;
    rtLoginUser:
      begin
        Password := T.Request.GetParamAsString('password');
        UserId := T.Response.GetParamAsInt('id');
        Token := T.Response.GetParamAsString('token');
        Username := T.Response.GetParamAsString('username');
        Rating := T.Response.GetParamAsInt('rating');
        Version := T.Response.GetParamAsString('version');
        with ServerSettings do
        begin
          IRCServer := T.Response.GetParamAsString('ircserver');
          IRCPort := T.Response.GetParamAsInt('ircport');
          IRCChannel := T.Response.GetParamAsString('ircchannel');
          ClientJoins := T.Response.GetParamAsBool('clientjoins');
          WelcomeMessage := T.Response.GetParamAsString('message');
          LobbyUrl := T.Response.GetParamAsString('lobbyurl');
        end;
        if Assigned(FOnLoginUser) then
          FOnLoginUser(Username, Password, UserId, Token, Rating, Version, ServerSettings);
      end;
    rtLogoutUser:
      begin
        ResponseCode := T.Response.GetParamAsInt('code');
        if Assigned(FOnLogoutUser) then
          FOnLogoutUser(ResponseCode <> 0);
      end;
    rtGetHostedGames:
      begin
        Games := TStringList.Create;
        Game := TStringList.Create;
        PlayerList := TStringList.Create;
        Game.Delimiter := ';';
        PlayerList.Delimiter := ';';
        try
          Games.Text := T.Response.GetParamAsString('games');
          HostedGames := TObjectList.Create;
          try
            for i := 0 to Games.Count - 1 do
            begin
              Game.Clear;
              Game.DelimitedText := Games[i];
              if (Game.Count < 13) then
                Continue;
              G := THostedGame.Create;
              G.Id := StrToIntDef(Game[0], 0);
              G.Game := TIdDecoderMIME.DecodeString(Game[1]);
              G.Guid := StringToGUID(Game[2]);
              G.SessionGuid := StringToGUID(Game[3]);
              G.IP := Game[4];
              G.Title := TIdDecoderMIME.DecodeString(Game[5]);
              G.Description := TIdDecoderMIME.DecodeString(Game[6]);
              G.MaxPlayers := StrToIntDef(Game[7], 8);
              G.Password := (StrToIntDef(Game[8], 0) <> 0);
              G.DateTime := ServerTimeToDateTime(TIdDecoderMIME.DecodeString(Game[9]));
              G.Status := TGameStatus(StrToIntDef(Game[10], 0));
              if (G.Status = gsJoinInProgress) and (MinutesBetween(Now, G.DateTime) > JOIN_MINS) then
                G.Status := gsInProgress;
              G.RoomId := StrToIntDef(Game[11], 0);
              PlayerList.Clear;
              PlayerList.DelimitedText := TIdDecoderMIME.DecodeString(Game[12]);
              for j := 0 to PlayerList.Count - 1 do
                G.PlayerList.AddObject(PlayerList.Names[j], Pointer(StrToIntDef(PlayerList.ValueFromIndex[j], DEFAULT_RATING)));
              HostedGames.Add(G);
            end;
          except
            HostedGames.Clear;
          end;
        finally
          Games.Free;
          Game.Free;
          PlayerList.Free;
        end;
        if Assigned(FOnGetHostedGames) then
          FOnGetHostedGames(HostedGames);
      end;
    rtHostGame:
      begin
        GameId := T.Response.GetParamAsInt('gameid');
        ResponseCode := T.Response.GetParamAsInt('code');
        if Assigned(FOnHostGame) then
          FOnHostGame(ResponseCode <> 0, GameId);
      end;
    rtJoinGame:
      begin
        GameId := T.Request.GetParamAsInt('gid');
        ResponseCode := T.Response.GetParamAsInt('code');
        if Assigned(FOnJoinGame) then
          FOnJoinGame(ResponseCode <> 0, GameId);
      end;
    rtLeaveGame:
      begin
        GameId := T.Request.GetParamAsInt('gid');
        ResponseCode := T.Response.GetParamAsInt('code');
        if Assigned(FOnLeaveGame) then
          FOnLeaveGame(ResponseCode <> 0, GameId);
      end;
    rtGetRatings:
      begin
        ResponseCode := T.Response.GetParamAsInt('code');
        Ratings := TStringList.Create;
        PlayerList := TStringList.Create;
        try
          Ratings.Text := T.Response.GetParamAsString('ratings');
          for i := 0 to Ratings.Count - 1 do
          begin
            j := Pos(';', Ratings[i]);
            if (j = 0) then
              Continue;
            PlayerName := Copy(Ratings[i], 1, j - 1);
            try
              Rating := StrToInt(Copy(Ratings[i], j + 1, Length(Ratings[i])));
              PlayerList.AddObject(PlayerName, Pointer(Rating));
            except
              Continue;
            end;
          end;
        finally
          Ratings.Free;
        end;
        if Assigned(FOnGetRatings) then
          FOnGetRatings(ResponseCode <> 0, PlayerList);
      end;
    rtUnknown:
      begin
      end;
  end;
end;

procedure TLobbyClient.HandleHttpRequestException(Sender: TObject; Exception: Exception);
var
  T: THttpRequestThread;
begin
  T := Sender as THttpRequestThread;
  if Assigned(FOnRequestException) then
    FOnRequestException(T.Request.RequestType, Exception);
  T.Request.RequestType := rtUnknown;
end;

function TLobbyClient.HasThreads: Boolean;
begin
  Result := (FThreadRefCount > 0);
end;

procedure TLobbyClient.SendRequest(const Request: TRequest);
var
  HttpRequestThread: THttpRequestThread;
begin
  HttpRequestThread := THttpRequestThread.Create(FLobbyServerUrl, Request);
  HttpRequestThread.OnTerminate := HandleHttpRequestTerminate;
  HttpRequestThread.OnException := HandleHttpRequestException;
  Inc(FThreadRefCount);
  HttpRequestThread.Resume;
end;

function TLobbyClient.ServerTimeToDateTime(DateTime: String): TDateTime;
var
  FormatSettings: TFormatSettings;
  GMTST, LocalST: TSystemTime;
begin
  with FormatSettings do
  begin
    DateSeparator := '-';
    TimeSeparator := ':';
    ShortDateFormat := 'yyyy-mm-dd';
    LongTimeFormat := 'hhnnss';
  end;

  try
    Result := StrToDateTime(DateTime, FormatSettings);
  except
    Result := Now;
  end;

  DateTimeToSystemTime(Result, GMTST);
  SystemTimeToTzSpecificLocalTime(nil, GMTST, LocalST);
  Result := SystemTimeToDateTime(LocalST);
end;

procedure TLobbyClient.RegisterUser(const Username, Email{$IFDEF HAMACHI}, IP{$ENDIF}: String);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtRegisterUser;
    Request.AddStringParam('version', CLIENT_VERSION);
    Request.AddStringParam('username', Username);
    Request.AddStringParam('email', Email);
    {$IFDEF HAMACHI}Request.AddStringParam('ip', IP);{$ENDIF}
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.LoginUser(const Username, Password: String);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtLoginUser;
    Request.AddStringParam('version', CLIENT_VERSION);
    Request.AddStringParam('username', Username);
    Request.AddStringParam('password', Password);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.LogoutUser(const UserId: Integer; const Token: String);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtLogoutUser;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.GetHostedGames(const UserId: Integer; const Token: String);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtGetHostedGames;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.HostGame(const UserId: Integer; const Token: String; Game: THostedGame);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtHostGame;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    Request.AddStringParam('game', Game.Game, True);
    Request.AddStringParam('guid', GUIDToString(Game.Guid));
    Request.AddStringParam('sessguid', GUIDToString(Game.SessionGuid));
    Request.AddStringParam('title', Game.Title, True);
    Request.AddStringParam('desc', Game.Description, True);
    Request.AddIntParam('max', Game.MaxPlayers);
    Request.AddBoolParam('pwd', Game.Password);
    Request.AddIntParam('roomid', Game.RoomId);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.JoinGame(const UserId: Integer; const Token: String; Game: THostedGame);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtJoinGame;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    Request.AddIntParam('gid', Game.Id);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.LeaveGame(const UserId: Integer; const Token: String; Game: THostedGame);
var
  Request: TRequest;
begin
  Request := TRequest.Create;
  try
    Request.RequestType := rtLeaveGame;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    Request.AddIntParam('gid', Game.Id);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.SendGameStats(const UserId: Integer; const Token: String;
  G: THostedGame; const GameStats: TGameStats);
var
  Request: TRequest;
  DataString: String;
  strPlayerName: String;
  i: Integer;
begin
  try
    DataString := '';
    with GameStats do
    begin
      DataString := Format('%d;%d;%d;%d;%d', [Duration, AllowCheats, Complete, Map, Index]);
      for i := 0 to 7 do
      begin
        with PlayerStats[i] do
        begin
          strPlayerName := PlayerName;
          if (Length(strPlayerName) = 0) then
            Continue;
          DataString := DataString + '#';
          DataString := DataString + Format('%s;%d;%d;%d;%d;%d;%d',
            [TIdEncoderMIME.EncodeString(strPlayerName), TotalScore, Civilization,
            Index, Team, Medal, Result]);
          with MilitaryStats do
          begin
            DataString := DataString + '|';
            DataString := DataString + Format('%d;%d;%d;%d;%d;%d', [MilitaryScore,
              UnitsKilled, UnitsLost, BuildingsRazed, BuildingsLost, UnitsConverted]);
          end;
          with EconomyStats do
          begin
            DataString := DataString + '|';
            DataString := DataString + Format('%d;%d;%d;%d;%d;%d;%d;%d;%d',
              [EconomyScore, FoodCollected, WoodCollected, StoneCollected,
              GoldCollected, TributeSent, TributeRcvd, TradeProfit, RelicGold]);
          end;
          with TechnologyStats do
          begin
            DataString := DataString + '|';
            DataString := DataString + Format('%d;%d;%d;%d;%d;%d;%d',
              [TechnologyScore, FeudalAge, CastleAge, ImperialAge,
              MapExplored, ResearchCount, ResearchPercent]);
          end;
          with SocietyStats do
          begin
            DataString := DataString + '|';
            DataString := DataString + Format('%d;%d;%d;%d;%d',
              [SocietyScore, TotalWonders, TotalCastles, RelicsCaptured,
              VillagerHigh]);
          end;
        end;
      end;
    end;
  except
    Exit;
  end;

  Request := TRequest.Create;
  try
    Request.RequestType := rtGameStats;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    Request.AddIntParam('gid', G.Id);
    Request.AddStringParam('sessguid', GuidToString(G.SessionGuid));
    Request.AddStringParam('data', DataString, True);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

procedure TLobbyClient.GetRatings(const UserId: Integer; const Token: String; Players: TStringList);
var
  Request: TRequest;
  sRequestString: String;
begin
  Request := TRequest.Create;
  try
    Players.Delimiter := ';';
    sRequestString := Players.DelimitedText;
    Request.RequestType := rtGetRatings;
    Request.AddIntParam('id', UserId);
    Request.AddStringParam('token', Token);
    Request.AddStringParam('players', sRequestString);
    SendRequest(Request);
  finally
    Request.Free;
  end;
end;

end.
