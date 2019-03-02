unit DPlay;

interface

uses
  DirectPlay, ActiveX, Classes, Windows;

type
  TMilitaryStats = packed record
    MilitaryScore: WORD;
    UnitsKilled: WORD;
    u1: WORD;
    UnitsLost: WORD;
    BuildingsRazed: WORD;
    u2: WORD;
    BuildingsLost: WORD;
    UnitsConverted: WORD;
  end;

  TEconomyStats = packed record
    EconomyScore: WORD;
    u1: WORD;
    FoodCollected: DWORD;
    WoodCollected: DWORD;
    StoneCollected: DWORD;
    GoldCollected: DWORD;
    TributeSent: WORD;
    TributeRcvd: WORD;
    TradeProfit: WORD;
    RelicGold: WORD;
  end;

  TTechnologyStats = packed record
    TechnologyScore: WORD;
    u1: WORD;
    FeudalAge: DWORD;
    CastleAge: DWORD;
    ImperialAge: DWORD;
    MapExplored: Byte;
    ResearchCount: Byte;
    ResearchPercent: Byte;
  end;

  TSocietyStats = packed record
    SocietyScore: WORD;
    TotalWonders: Byte;
    TotalCastles: Byte;
    RelicsCaptured: Byte;
    u1: Byte;
    VillagerHigh: WORD;
  end;

  TPlayerStats = packed record
    PlayerName: array[0..15] of Char;
    TotalScore: WORD;
    TotalScores: array[0..7] of WORD; { Total Scores of all players }
    u0: Byte;
    Civilization: Byte;
    Index: Byte;
    Team: Byte; { team - 1 }
    u1: array[0..1] of Byte;
    Medal: Byte; { 0 No, 1 Yes }
    u2: array[0..2] of Byte;
    Result: Byte; { 0 loss, 1 win, 2 survival to finish, 3 disconnect }
    u3: array[0..2] of Byte;
    MilitaryStats: TMilitaryStats;
    u4: array[0..31] of Byte;
    EconomyStats: TEconomyStats;
    u5: array[0..15] of Byte;
    TechnologyStats: TTechnologyStats;
    u6: Byte;
    SocietyStats: TSocietyStats;
    u7: array[0..83] of Byte;
  end;

  TGameStats = packed record
    u1: array[0..43] of Byte;
    ScenarioFileName: array[0..31] of Char;
    u2: array[0..3] of Byte;
    Duration: DWORD; { in seconds }
    AllowCheats: Byte;
    Complete: Byte;
    u3: array[0..13] of Byte;
    MapSize: Byte; { 0 tiny, 1 small, 2 medium, 3 normal, 4 large, 5 giant }
    Map: Byte; { map id }
    Population: Byte; { 25 - 200 }
    u4: Byte;
    Victory: Byte; { 0 standard, 1 conquest, 7 time limit, 8 score, 11 last man standing }
    StartingAge: Byte; { standard - post-imperial }
    Resources: Byte; { 0 standard, 1 low, 2 medium, 3 high }
    AllTechs: Byte;
    TeamTogether: Byte; { 0 = yes, 1 = no }
    RevealMap: Byte; { 0 normal, 1 explored, 2 all visible }
    u5: array[0..2] of Byte;
    LockTeams: Byte;
    LockSpeed: Byte;
    u6: Byte;
    PlayerStats: array[0..7] of TPlayerStats;
    Index: Byte; { Index of the player we received this data from }
    u7: array[0..6] of Byte;
  end;

  PAgePresetData = ^TAgePresetData;
  TAgePresetData = packed record
  { stub }
  end;

type
  TOnLog = procedure(Sender: TObject; LogCode: Integer; const LogMsg: String) of object;
  TOnHostSession = procedure(Sender: TObject; Result: Boolean; const guidInstance: TGUID) of object;
  TOnJoinSession = TOnHostSession;
  TOnAge2x1Stats = procedure(Sender: TObject; const GameStats: TGameStats) of object;

  TDPlay = class
  private
    FDPApplications: TStringList;
    FLastError: String;
    FIPAddr: String;
    FInitialized: Boolean;

    dwAppID: DWORD;
    hReceiveEvent: THandle;
    ReceiveThread: TThread;
    bHost: Boolean;
    IsAge2x1: Boolean;
    AgePresetData: TAgePresetData;

    FOnHostSession: TOnHostSession;
    FOnJoinSession: TOnJoinSession;
    FOnAppTerminated: TNotifyEvent;
    FOnAge2x1Stats: TOnAge2x1Stats;
    FOnLog: TOnLog;

    function CreateAddress(var lpAddress: Pointer; var dwAddressSize: DWORD): Boolean;
    function RunApplication(const applicationGUID, instanceGUID: TGUID;
        const strSessionName, strPlayerName, strPassword: String; pAddress: Pointer;
        dwAddrSize: Cardinal; bHostSession: Boolean; MaxPlayers: Integer = 0): Boolean;
    function GetLastError: String;
    procedure ReceiveLobbyMessage;
    procedure ReceiveThreadTerminate(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;

    function Initialize: Boolean;
    function GetDPApplications: Boolean;
    function HostSession(const ApplicationGUID: TGUID; const SessionName,
      PlayerName: String; const Password: String = ''; MaxPlayers: Integer = 0; AgePresetDataPtr: PAgePresetData = nil): Boolean;
    function JoinSession(const ApplicationGUID, guidInstance: TGUID;
      const IPAddr, PlayerName: String; const Password: String = ''): Boolean;

    property LastError: String read GetLastError;
    property DPApplications: TStringList read FDPApplications;

    property Initialized: Boolean read FInitialized;
    property OnHostSession: TOnHostSession read FOnHostSession write FOnHostSession;
    property OnJoinSession: TOnJoinSession read FOnJoinSession write FOnJoinSession;
    property OnAppTerminated: TNotifyEvent read FOnAppTerminated write FOnAppTerminated;
    property OnAge2x1Stats: TOnAge2x1Stats read FOnAge2x1Stats write FOnAge2x1Stats;
    property OnLog: TOnLog read FOnLog write FOnLog;
  end;

const
  { log codes }
  LC_DP_ERROR                   = $00;
  LC_INIT_DP_INTERFACES         = $01;
  LC_INIT_DP_INTERFACES_DONE    = $02;
  LC_ENUM_DP_LOCAL_APPS         = $05;
  LC_ENUM_DP_LOCAL_APPS_DONE    = $06;
  LC_HOSTING_SESSION            = $07;
  LC_HOSTING_SESSION_DONE       = $08;
  LC_JOINING_SESSION            = $09;
  LC_JOINING_SESSION_DONE       = $0A;
  LC_ERROR_CREATING_GUID        = $0B;
  LC_ERROR_CREATING_EVENT       = $0C;

const
  AGE2X1_GUID: TGUID = '{5DE93F3F-FC90-4ee1-AE5A-63DAFA055950}';

implementation

uses
  SysUtils;

type
  TDPlayReceiveThread = class(TThread)
  private
    FDPlay: TDPlay;
  protected
    procedure Execute; override;
  public
    constructor Create(DPlay: TDPlay);
  end;

var
  lpDPLobby: IDirectPlayLobby3A;

function LogString(LogCode: Integer): String;
begin
  case LogCode of
    LC_DP_ERROR: Result := '';
    LC_INIT_DP_INTERFACES: Result := 'Initializing DirectPlay interfaces...';
    LC_INIT_DP_INTERFACES_DONE: Result := 'DirectPlay interfaces initialized';
    LC_ENUM_DP_LOCAL_APPS: Result := 'Enumerating local DirectPlay aplications...';
    LC_ENUM_DP_LOCAL_APPS_DONE: Result := 'Local DirectPlay aplications enumerated';
    LC_HOSTING_SESSION: Result := 'Starting hosting a session...';
    LC_HOSTING_SESSION_DONE: Result := 'Session created';
    LC_JOINING_SESSION: Result := 'Starting joining session...';
    LC_JOINING_SESSION_DONE: Result := 'Session joined';
    LC_ERROR_CREATING_GUID: Result := 'Error creating GUID';
    LC_ERROR_CREATING_EVENT: Result := 'Failed creating event';
    else Result := '';
  end;
end;

{ TDPlayReceiveThread }

constructor TDPlayReceiveThread.Create(DPlay: TDPlay);
begin
  FDPlay := DPlay;
  inherited Create(True);
end;

procedure TDPlayReceiveThread.Execute;
begin
  if (FDPlay.hReceiveEvent = 0) then
    Exit;
  while (not Terminated and (WaitForSingleObject(FDPlay.hReceiveEvent, INFINITE) = WAIT_OBJECT_0)) do
  begin
    Synchronize(FDPlay.ReceiveLobbyMessage);
  end;
end;

{ TDPlay }

constructor TDPlay.Create;
begin
  inherited Create;
  lpDPLobby := nil;
  FDPApplications := TStringList.Create;
  FLastError := '';
  FIPAddr := '';
  FInitialized := False;
  FOnHostSession := nil;
  FOnJoinSession := nil;
  FOnAppTerminated := nil;
  FOnAge2x1Stats := nil;
  FOnLog := nil;
  dwAppID := 0;
  hReceiveEvent := 0;
  ReceiveThread := nil;
  bHost := True;
  IsAge2x1 := False;
  FillChar(AgePresetData, SizeOf(TAgePresetData), 0);
end;

destructor TDPlay.Destroy;
var
  lpGUID: PGUID;
  i: Integer;
begin
  for i := 0 to FDPApplications.Count - 1 do
  begin
    lpGUID := PGUID(FDPApplications.Objects[i]);
    Dispose(lpGUID);
  end;
  FDPApplications.Free;

  if Assigned(ReceiveThread) then
  begin
    ReceiveThread.Terminate;
    SetEvent(hReceiveEvent);
    ReceiveThread.WaitFor;
    ReceiveThread.Free;
  end;
  inherited Destroy;
end;

function TDPlay.GetLastError: String;
begin
  Result := FLastError;
end;

function TDPlay.Initialize: Boolean;
var
  hr: HRESULT;
begin
  Result := False;

  if Assigned(FOnLog) then
    FOnLog(Self, LC_INIT_DP_INTERFACES, LogString(LC_INIT_DP_INTERFACES));

  if FInitialized then
  begin
    FLastError := DPErrorString(DPERR_ALREADYINITIALIZED);
    if Assigned(FOnLog) then
      FOnLog(Self, LC_DP_ERROR, FLastError);
    Exit;
  end;

  hr := CoCreateInstance(CLSID_DirectPlayLobby, nil, CLSCTX_INPROC_SERVER,
            IID_IDirectPlayLobby3A, lpDPLobby);

  if FAILED(hr) then
  begin
    FLastError := DPErrorString(hr);
    if Assigned(FOnLog) then
      FOnLog(Self, LC_DP_ERROR, FLastError);
    Exit;
  end;

  FInitialized := True;

  if Assigned(FOnLog) then
    FOnLog(Self, LC_INIT_DP_INTERFACES_DONE, LogString(LC_INIT_DP_INTERFACES_DONE));

  Result := True;
end;

function TDPlay.GetDPApplications: Boolean;

  function EnumLocalApplicationsCallback(const lpAppInfo: TDPLAppInfo;
      lpContext: Pointer; dwFlags: DWORD) : BOOL; stdcall;
  var
    lpGUID: PGUID;
  begin
    New(lpGUID);
    lpGUID^ := lpAppInfo.guidApplication;
    TStrings(lpContext).AddObject(lpAppInfo.lpszAppNameA, TObject(lpGUID));
    Result := True;
  end;

var
  hr: HRESULT;
begin
  if Assigned(FOnLog) then
    FOnLog(Self, LC_ENUM_DP_LOCAL_APPS, LogString(LC_ENUM_DP_LOCAL_APPS));

  if not FInitialized then
  begin
    FLastError := DPErrorString(DPERR_UNINITIALIZED);
    if Assigned(FOnLog) then
      FOnLog(Self, LC_DP_ERROR, FLastError);
    Result := False;
    Exit;
  end;

  FDPApplications.Clear;

  hr := lpDPLobby.EnumLocalApplications(@EnumLocalApplicationsCallback, FDPApplications, 0);

  if FAILED(hr) then
    FLastError := DPErrorString(hr);

  Result := not FAILED(hr);

  if Assigned(FOnLog) then
  begin
    if Result then
      FOnLog(Self, LC_ENUM_DP_LOCAL_APPS_DONE, LogString(LC_ENUM_DP_LOCAL_APPS_DONE))
    else
      FOnLog(Self, LC_DP_ERROR, FLastError);
  end;
end;

function TDPlay.CreateAddress(var lpAddress: Pointer; var dwAddressSize: DWORD): Boolean;
var
  addressElements: array[0..2] of TDPCompoundAddressElement;
  dwElementCount: DWORD;
  hr: HRESULT;
begin
  Result := False;

  ZeroMemory(@addressElements, SizeOf(addressElements));
  dwElementCount := 0;

  addressElements[dwElementCount].guidDataType := DPAID_ServiceProvider;
  addressElements[dwElementCount].dwDataSize := SizeOf(TGUID);
  addressElements[dwElementCount].lpData := @DPSPGUID_TCPIP;
  Inc(dwElementCount);

  addressElements[dwElementCount].guidDataType := DPAID_INet;
  addressElements[dwElementCount].dwDataSize := Length(FIPAddr) + 1;
  addressElements[dwElementCount].lpData := PChar(FIPAddr);
  Inc(dwElementCount);

  { See how much room is needed to store this address }
  hr := lpDPLobby.CreateCompoundAddress(addressElements[0], dwElementCount, nil, dwAddressSize);
  if (hr <> DPERR_BUFFERTOOSMALL) then
  begin
    FLastError := DPErrorString(hr);
    Exit;
  end;

  try
    GetMem(lpAddress, dwAddressSize);

    { Create the address }
    hr := lpDPLobby.CreateCompoundAddress(addressElements[0], dwElementCount, lpAddress, dwAddressSize);

    if FAILED(hr) then
    begin
      FreeMem(lpAddress);
      lpAddress := nil;
      FLastError := DPErrorString(hr);
      Exit;
    end;

    Result := True;
  except
    on E: EOutOfMemory do
    begin
      FLastError := 'There is not enough free memory';
      Exit;
    end;
  end;
end;

function TDPlay.RunApplication(const applicationGUID, instanceGUID: TGUID;
    const strSessionName, strPlayerName, strPassword: String; pAddress: Pointer;
    dwAddrSize: Cardinal; bHostSession: Boolean; MaxPlayers: Integer = 0): Boolean;
var
  connectInfo: TDPLConnection;
  sessionInfo: TDPSessionDesc2;
  playerName: TDPName;
  hr: HRESULT;
begin
  { Fill out session description }
  ZeroMemory(@sessionInfo, SizeOf(TDPSessionDesc2));
  with sessionInfo do
  begin
    dwSize := SizeOf(TDPSessionDesc2);
    dwFlags := 0;
    guidInstance := instanceGUID;        // ID for the session instance
    guidApplication := applicationGUID;  // GUID of the DirectPlay application {5DE93F3F-FC90-4ee1-AE5A-63DAFA055950}
    dwMaxPlayers := MaxPlayers;          // Maximum # of players allowed in session
    dwCurrentPlayers := 0;               // Current # of players in session (read only)
    lpszSessionNameA := PAnsiChar(strSessionName);  // ANSI name of the session
    if (strPassword = '') then
      lpszPasswordA := nil               // ANSI password of the session
    else
      lpszPasswordA := PAnsiChar(strPassword);
    dwReserved1 := 0;                    // Reserved for future MS use
    dwReserved2 := 0;
    dwUser1 := 0;                        // For use by the application
    dwUser2 := 0;
    dwUser3 := 0;
    dwUser4 := 0;
  end;

  { Fill out player name }
  ZeroMemory(@playerName, SizeOf(TDPName));
  with playerName do
  begin
    dwSize := SizeOf(TDPName);
    dwFlags := 0;                                // Not used, must be zero
    lpszShortNameA := PAnsiChar(strPlayerName);  // ANSI short or friendly name
    lpszLongNameA := PAnsiChar(strPlayerName);   // ANSI long or formal name
  end;

  { Fill out connection description }
  ZeroMemory(@connectInfo, SizeOf(TDPLConnection));
  with connectInfo do
  begin
    dwSize := SizeOf(TDPLConnection);
    if (bHostSession) then
      dwFlags := DPLCONNECTION_CREATESESSION
    else
      dwFlags := DPLCONNECTION_JOINSESSION;
    lpSessionDesc := @sessionInfo;  // Pointer to session desc to use on connect
    lpPlayerName := @playerName;    // Pointer to Player name structure
    guidSP := DPSPGUID_TCPIP;       // GUID of the DPlay SP to use
    lpAddress := pAddress;          // Address for service provider
    dwAddressSize := dwAddrSize;    // Size of address data
  end;

  bHost := bHostSession;

  if Assigned(ReceiveThread) then
  begin
    ReceiveThread.Terminate;
    SetEvent(hReceiveEvent);
    ReceiveThread.WaitFor;
    ReceiveThread.Free;
  end;

  hReceiveEvent := CreateEvent(nil, False, False, nil);
  if (hReceiveEvent = 0) then
  begin
    if Assigned(FOnLog) then
      FOnLog(Self, LC_ERROR_CREATING_EVENT, LogString(LC_ERROR_CREATING_EVENT));
    Result := False;
    Exit;
  end;

  { launch and connect the game }
  hr := lpDPLobby.RunApplication(0, dwAppID, connectInfo, hReceiveEvent);

  if FAILED(hr) then
    FLastError := DPErrorString(hr)
  else
  begin
    IsAge2x1 := IsEqualGUID(applicationGUID, AGE2X1_GUID);
    ReceiveThread := TDPlayReceiveThread.Create(Self);
    ReceiveThread.OnTerminate := ReceiveThreadTerminate;
    ReceiveThread.Resume;
  end;

  Result := SUCCEEDED(hr);
end;

function TDPlay.HostSession(const ApplicationGUID: TGUID; const SessionName,
  PlayerName: String; const Password: String = ''; MaxPlayers: Integer = 0; AgePresetDataPtr: PAgePresetData = nil): Boolean;
var
  lpAddress: Pointer;
  dwAddressSize: DWORD;
  guidInstance: TGUID;
begin
  Result := False;
  if not FInitialized then
  begin
    FLastError := DPErrorString(DPERR_UNINITIALIZED);
    if Assigned(FOnLog) then
      FOnLog(Self, LC_DP_ERROR, FLastError);
    Exit;
  end;

  if (CoCreateGuid(guidInstance) <> S_OK) then
  begin
    if Assigned(FOnLog) then
      FOnLog(Self, LC_ERROR_CREATING_GUID, LogString(LC_ERROR_CREATING_GUID));
    Exit;
  end;

  if Assigned(FOnLog) then
    FOnLog(Self, LC_HOSTING_SESSION, LogString(LC_HOSTING_SESSION));

  lpAddress := nil;
  dwAddressSize := 0;
  { Get address to use with this service provider }
  CreateAddress(lpAddress, dwAddressSize);
  { Ignore the error because pAddress will just be null }

  if Assigned(AgePresetDataPtr) then
    CopyMemory(@AgePresetData, AgePresetDataPtr, SizeOf(TAgePresetData))
  else
    FillChar(AgePresetData, SizeOf(TAgePresetData), 0);

  Result := RunApplication(ApplicationGUID, guidInstance, SessionName, PlayerName,
    Password, lpAddress, dwAddressSize, True, MaxPlayers);

  if Assigned(lpAddress) then
    FreeMem(lpAddress);

  if Assigned(FOnLog) then
  begin
    if Result then
      FOnLog(Self, LC_HOSTING_SESSION_DONE, LogString(LC_HOSTING_SESSION_DONE))
    else
      FOnLog(Self, LC_DP_ERROR, FLastError);
  end;
end;

function TDPlay.JoinSession(const ApplicationGUID, guidInstance: TGUID;
  const IPAddr, PlayerName: String; const Password: String = ''): Boolean;
var
  lpAddress: Pointer;
  dwAddressSize: DWORD;
begin
  if not FInitialized then
  begin
    FLastError := DPErrorString(DPERR_UNINITIALIZED);
    if Assigned(FOnLog) then
      FOnLog(Self, LC_DP_ERROR, FLastError);
    Result := False;
    Exit;
  end;

  if Assigned(FOnLog) then
    FOnLog(Self, LC_JOINING_SESSION, LogString(LC_JOINING_SESSION));

  FIPAddr := IPAddr;

  lpAddress := nil;
  dwAddressSize := 0;
  { Get address to use with this service provider }
  CreateAddress(lpAddress, dwAddressSize);
  { Ignore the error because pAddress will just be null }

  Result := RunApplication(ApplicationGUID, guidInstance, '', PlayerName,
    Password, lpAddress, dwAddressSize, False);

  if Assigned(lpAddress) then
    FreeMem(lpAddress);

  if Assigned(FOnLog) then
  begin
    if Result then
      FOnLog(Self, LC_JOINING_SESSION_DONE, LogString(LC_JOINING_SESSION_DONE))
    else
      FOnLog(Self, LC_DP_ERROR, FLastError);
  end;
end;

procedure TDPlay.ReceiveLobbyMessage;
var
  hr: HRESULT;
  lpdwMessageFlags: DWORD;
  lpData: Pointer;
  lpdwDataSize: DWORD;
  systemMsg: PDPLMsg_SystemMessage;
  GameStats: TGameStats;
  getPropertyMsg: PDPLMsg_GetProperty;
  getPropertyResponse: TDPLMsg_GetPropertyResponse;
  i: Integer;
begin
  lpdwMessageFlags := 0;
  lpData := nil;
  lpdwDataSize := 0;
  hr := lpDPLobby.ReceiveLobbyMessage(0, dwAppID, lpdwMessageFlags, nil, lpdwDataSize);
  if (hr <> DPERR_BUFFERTOOSMALL) then
    Exit;
  try
    try
      GetMem(lpData, lpdwDataSize);
      lpdwMessageFlags := 0;
      hr := lpDPLobby.ReceiveLobbyMessage(0, dwAppID, lpdwMessageFlags, lpData, lpdwDataSize);

      if FAILED(hr) or (lpdwDataSize < SizeOf(TDPLMsg_Generic)) then
        Exit;

      if (lpdwMessageFlags = DPLMSG_STANDARD) then
        { do not process a standard message }
        Exit;

      { Get the game statistics for Age of Empires II - The Conquerors Expansion }
      if IsAge2x1 and (lpdwMessageFlags = 0) and (lpdwDataSize = SizeOf(TGameStats)) then
      begin
        CopyMemory(@GameStats, lpData, lpdwDataSize);
        for i := 0 to 7 do
        begin
          if (GameStats.PlayerStats[i].TechnologyStats.FeudalAge = High(DWORD)) then
            GameStats.PlayerStats[i].TechnologyStats.FeudalAge := 0;
          if (GameStats.PlayerStats[i].TechnologyStats.CastleAge = High(DWORD)) then
            GameStats.PlayerStats[i].TechnologyStats.CastleAge := 0;
          if (GameStats.PlayerStats[i].TechnologyStats.ImperialAge = High(DWORD)) then
            GameStats.PlayerStats[i].TechnologyStats.ImperialAge := 0;
        end;
        if Assigned(FOnAge2x1Stats) then
          FOnAge2x1Stats(Self, GameStats);
        Exit;
      end;
(*
      if (lpdwMessageFlags = 0) then
        { do not process custom-defined message }
        Exit;
*)
      systemMsg := lpData;
      case systemMsg^.dwType of
        DPLSYS_GETPROPERTY:
          begin
            getPropertyMsg := lpData;
            ZeroMemory(@getPropertyResponse, SizeOf(TDPLMsg_GetPropertyResponse));
            with getPropertyResponse do
            begin
              dwType := DPLSYS_GETPROPERTYRESPONSE;
              dwRequestID := getPropertyMsg^.dwRequestID;
              guidPlayer := getPropertyMsg^.guidPlayer;
              guidPropertyTag := getPropertyMsg^.guidPropertyTag;
              hr := DPERR_UNKNOWNMESSAGE;
              dwDataSize := 0;
              dwPropertyData[0] := 0;
            end;
            lpDPLobby.SendLobbyMessage(0, dwAppID, getPropertyResponse, SizeOf(TDPLMsg_GetPropertyResponse));
          end;
        DPLSYS_NEWSESSIONHOST:
          begin
          end;
        DPLSYS_CONNECTIONSETTINGSREAD:
          begin
          end;
        DPLSYS_DPLAYCONNECTFAILED:
          begin
            if bHost and Assigned(FOnHostSession) then
              FOnHostSession(Self, False, systemMsg^.guidInstance)
            else if not bHost and Assigned(FOnJoinSession) then
              FOnJoinSession(Self, False, systemMsg^.guidInstance);
          end;
        DPLSYS_DPLAYCONNECTSUCCEEDED:
          begin
            if bHost and Assigned(FOnHostSession) then
              FOnHostSession(Self, True, systemMsg^.guidInstance)
            else if not bHost and Assigned(FOnJoinSession) then
              FOnJoinSession(Self, True, systemMsg^.guidInstance);
          end;
        DPLSYS_APPTERMINATED:
          begin
            ReceiveThread.Terminate;
            SetEvent(hReceiveEvent);
            if Assigned(OnAppTerminated) then
              OnAppTerminated(Self);
          end;
      end;
    finally
      FreeMem(lpData);
    end;
  except
    on E: EOutOfMemory do
      Exit;
  end;
end;

procedure TDPlay.ReceiveThreadTerminate(Sender: TObject);
begin
  if (hReceiveEvent <> 0) then
  begin
    CloseHandle(hReceiveEvent);
    hReceiveEvent := 0;
  end;
end;

initialization
  CoInitialize(nil);

finalization
  CoUninitialize;

end.
