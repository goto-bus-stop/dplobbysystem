unit LobbyClasses;

interface

uses
  Contnrs, Classes, Graphics, uLobbyClient;

type
  TUserFont = class(TObject)
  public
    Name: String;
    Style: TFontStyle;
    Size: Integer;
    Color: TColor;
  end;
  { TLobbyUser }
  TUserStatus = (usLooking = 0, usWaiting = 1, usPlaying = 2);
  TOnStatusChanged = procedure(Sender: TObject; OldStatus, NewStatus: TUserStatus) of object;
  TLobbyUser = class(TObject)
  private
    FStatus: TUserStatus;
    FOnStatusChanged: TOnStatusChanged;
    procedure SetStatus(AStatus: TUserStatus);
  public
    Name: String;
    Rating: Integer;
    Ping: Cardinal;
    RoomId: Integer; { user je v miestnosti RoomId }
    Font: TUserFont;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TLobbyUser);
    property Status: TUserStatus read FStatus write SetStatus;
    property OnStatusChanged: TOnStatusChanged read FOnStatusChanged write FOnStatusChanged;
  end;

  { TLobbyUsers }
  TOnAddLobbyUser = procedure(Sender: TObject; User: TLobbyUser) of object;
  TOnRemoveLobbyUser = TOnAddLobbyUser;
  TLobbyUsers = class(TObject)
  private
    FItems: TObjectList;
    FOnAddUser: TOnAddLobbyUser;
    FOnRemoveUser: TOnRemoveLobbyUser;
    FOnUserStatusChanged: TOnStatusChanged;
    FOnClear: TNotifyEvent;
    function GetItem(Index: Integer): TLobbyUser;
    procedure SetItem(Index: Integer; AUser: TLobbyUser);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AUser: TLobbyUser): Integer;
    function Remove(AUser: TLobbyUser): Integer;
    function Get(Name: String): TLobbyUser;
    procedure Clear;
    property Items[Index: Integer]: TLobbyUser read GetItem write SetItem; default;
    property Count: Integer read GetCount;
    property OnAddUser: TOnAddLobbyUser read FOnAddUser write FOnAddUser;
    property OnRemoveUser: TOnRemoveLobbyUser read FOnRemoveUser write FOnRemoveUser;
    property OnUserStatusChanged: TOnStatusChanged read FOnUserStatusChanged write FOnUserStatusChanged;
    property OnClear: TNotifyEvent read FOnClear write FOnClear;
  end;

  { TUser }  { = me }
  TUser = class(TLobbyUser)
  public
    Password: String;
    Id: Integer;
    Token: String;
    HostedGame: THostedGame;
    IsInGame: Boolean;
    IsStartingSession: Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TMessageType = (mError, mSystem, mEnter, mExit, mUser);
  TSystemMessageType = (smUpdate, smJoin, smLeave, smRating, smFont);

implementation

{ TLobbyUser }

constructor TLobbyUser.Create;
begin
  FStatus := usLooking;
  FOnStatusChanged := nil;
  Name := '';
  Rating := DEFAULT_RATING;
  RoomId := -1;
  Randomize;
  Ping := Random(400) + 1;
  Font := TUserFont.Create;
  Font.Name := '';
  Font.Style := fsUnderline;
  Font.Size := 0;
  Font.Color := 0;
end;

destructor TLobbyUser.Destroy;
begin
  Font.Free;
end;

procedure TLobbyUser.Assign(Source: TLobbyUser);
begin
  FStatus := Source.FStatus;
  Name := Source.Name;
  Rating := Source.Rating;
  RoomId := Source.RoomId;
  Ping := Source.Ping;
  Font.Name := Source.Font.Name;
  Font.Style := Source.Font.Style;
  Font.Size := Source.Font.Size;
  Font.Color := Font.Color;
end;

procedure TLobbyUser.SetStatus(AStatus: TUserStatus);
var
  OldStatus: TUserStatus;
begin
  if (FStatus <> AStatus) then
  begin
    OldStatus := FStatus;
    FStatus := AStatus;
    if Assigned(FOnStatusChanged) then
      FOnStatusChanged(Self, OldStatus, FStatus);
  end;
end;

{ TLobbyUsers }

constructor TLobbyUsers.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
  FOnAddUser := nil;
  FOnRemoveUser := nil;
  FOnUserStatusChanged := nil;
  FOnClear := nil;
end;

destructor TLobbyUsers.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TLobbyUsers.GetItem(Index: Integer): TLobbyUser;
begin
  Result := FItems[Index] as TLobbyUser;
end;

procedure TLobbyUsers.SetItem(Index: Integer; AUser: TLobbyUser);
begin
  FItems[Index] := AUser;
end;

function TLobbyUsers.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TLobbyUsers.Add(AUser: TLobbyUser): Integer;
begin
  AUser.OnStatusChanged := FOnUserStatusChanged;
  Result := FItems.Add(AUser);
  if Assigned(FOnAddUser) then
    FOnAddUser(Self, AUser);
end;

function TLobbyUsers.Remove(AUser: TLobbyUser): Integer;
begin
  if Assigned(FOnRemoveUser) then
    FOnRemoveUser(Self, AUser);
  Result := FItems.Remove(AUser);
end;

function TLobbyUsers.Get(Name: String): TLobbyUser;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if (Items[i].Name = Name) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
end;

procedure TLobbyUsers.Clear;
begin
  if Assigned(FOnClear) then
    FOnClear(Self);
  FItems.Clear;
end;

{ TUser }

constructor TUser.Create;
begin
  inherited Create;
  IsInGame := False;
  IsStartingSession := False;
  HostedGame := THostedGame.Create;
end;

destructor TUser.Destroy;
begin
  HostedGame.Free;
  inherited Destroy;
end;

end.
