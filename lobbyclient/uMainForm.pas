unit uMainForm;

interface

uses
  Windows, Dialogs, ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdIRC, Menus, OleCtrls, SHDocVw_TLB, StdCtrls, Controls, ComCtrls,
  JvExComCtrls, JvListView, MyJvListView, JvComCtrls, JvExStdCtrls, JvRichEdit,
  JvExExtCtrls, JvImage, JvExtComponent, JvPanel, ToolWin, Classes, Messages, Forms,
  Contnrs, SysUtils, IdThread,
  uSplashForm, LobbyClasses, DPlay, uLobbyClient, Bubbles, Language;

const
  WM_AFTER_SHOW = WM_USER + 300; // custom message

type
  TSortType = (stNameUp, stNameDown, stRatingUp, stRatingDown, stPingUp, stPingDown);

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    Room1: TMenuItem;
    Options1: TMenuItem;
    Zone1: TMenuItem;
    Help1: TMenuItem;
    ToolBar: TToolBar;
    QuickHostBrn: TToolButton;
    QuickJoinBtn: TToolButton;
    SeparatorBtn: TToolButton;
    TableViewBtn: TToolButton;
    ListViewBtn: TToolButton;
    VSplitter: TSplitter;
    MainPanel: TPanel;
    HSplitter: TSplitter;
    TopPanel: TPanel;
    BannerImage: TImage;
    LogoImage: TImage;
    RightPanel: TPanel;
    PlayersTreeView: TJvTreeView;
    SortPanel: TPanel;
    PlayerPopupMenu: TPopupMenu;
    Profile1: TMenuItem;
    SendMessage1: TMenuItem;
    AddtoFriends1: TMenuItem;
    Ignore1: TMenuItem;
    QuickHost1: TMenuItem;
    QuickJoin1: TMenuItem;
    N1: TMenuItem;
    UnignoreAll1: TMenuItem;
    EnableAllTips1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    ChatOptions1: TMenuItem;
    N3: TMenuItem;
    ViewToolbar1: TMenuItem;
    N4: TMenuItem;
    TableView1: TMenuItem;
    ListView1: TMenuItem;
    N5: TMenuItem;
    SortUsersbyLatency1: TMenuItem;
    SortUsersbyName1: TMenuItem;
    SortUsersbyRating1: TMenuItem;
    SendZoneMessage1: TMenuItem;
    ViewProfiles1: TMenuItem;
    GameHelp1: TMenuItem;
    ZoneSupport1: TMenuItem;
    CodeofConduct1: TMenuItem;
    N6: TMenuItem;
    AboutRoom1: TMenuItem;
    IdIRC: TIdIRC;
    TimeoutTimer: TTimer;
    BottomPanel: TJvPanel;
    ChatPanel: TPanel;
    EmotImage: TJvImage;
    SendImage: TJvImage;
    ChatEdit: TEdit;
    ChatSplitter: TSplitter;
    FontImage: TJvImage;
    ChatRichEdit: TJvRichEdit;
    FontDialog: TFontDialog;
    GamesTimer: TTimer;
    GamesPopupMenu: TPopupMenu;
    Teamize1: TMenuItem;
    ToolButton1: TToolButton;
    GamesToolBtn: TToolButton;
    TeamizerToolBtn: TToolButton;
    JvPageControl: TJvPageControl;
    GamesTab: TTabSheet;
    TeamizerTab: TTabSheet;
    GamesListView: TMyJvListView;
    PlayersGroupBox: TGroupBox;
    P5Edit: TEdit;
    P1Edit: TEdit;
    P3Edit: TEdit;
    P7Edit: TEdit;
    P2Edit: TEdit;
    P4Edit: TEdit;
    P6Edit: TEdit;
    P8Edit: TEdit;
    R1Edit: TEdit;
    R3Edit: TEdit;
    R5Edit: TEdit;
    R7Edit: TEdit;
    R2Edit: TEdit;
    R4Edit: TEdit;
    R6Edit: TEdit;
    R8Edit: TEdit;
    TeamizeBtn: TButton;
    BrowserTab: TTabSheet;
    BrowserToolBtn: TToolButton;
    WebBrowser: TWebBrowser;
    N7: TMenuItem;
    ClientOptions1: TMenuItem;
    UseWidescreenPatch1: TMenuItem;
    TeamizeInfoLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PlayersTreeViewCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure VSplitterMoved(Sender: TObject);
    procedure SortPanelClick(Sender: TObject);
    procedure PlayersTreeViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PlayersTreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Ignore1Click(Sender: TObject);
    procedure PlayersTreeViewMouseLeave(Sender: TObject);
    procedure PlayerPopupMenuPopup(Sender: TObject);
    procedure SortPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SortPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayersTreeViewHorizontalScroll(Sender: TObject);
    procedure TimeoutTimerTimer(Sender: TObject);
    procedure IdIRCError(Sender: TObject; AUser: TIdIRCUser; ANumeric,
      AError: String);
    procedure IdIRCJoin(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel);
    procedure IdIRCJoined(Sender: TObject; AChannel: TIdIRCChannel);
    procedure IdIRCStateChange(Sender: TObject);
    procedure IdIRCSystem(Sender: TObject; AUser: TIdIRCUser;
      ACmdCode: Integer; ACommand, AContent: String);
    procedure IdIRCParted(Sender: TObject; AChannel: TIdIRCChannel);
    procedure IdIRCPart(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel);
    procedure IdIRCQuit(Sender: TObject; AUser: TIdIRCUser);
    procedure IdIRCNames(Sender: TObject; AUsers: TIdIRCUsers;
      AChannel: TIdIRCChannel);
    procedure IdIRCMessage(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel; Content: String);
    procedure IdIRCPingPong(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlayersTreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayersTreeViewCollapsed(Sender: TObject; Node: TTreeNode);
    procedure Exit1Click(Sender: TObject);
    procedure SendMessage1Click(Sender: TObject);
    procedure AddtoFriends1Click(Sender: TObject);
    procedure ChatEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SendImageClick(Sender: TObject);
    procedure FontImageClick(Sender: TObject);
    procedure VSplitterCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure GamesListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure GamesListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure GamesListViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GamesListViewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GamesListViewMouseLeave(Sender: TObject);
    procedure GamesTimerTimer(Sender: TObject);
    procedure GamesListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AboutRoom1Click(Sender: TObject);
    procedure TeamizerToolBtnClick(Sender: TObject);
    procedure GamesToolBtnClick(Sender: TObject);
    procedure TeamizeBtnClick(Sender: TObject);
    procedure Teamize1Click(Sender: TObject);
    procedure GamesListViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ChatOptions1Click(Sender: TObject);
    procedure ViewToolbar1Click(Sender: TObject);
    procedure SortUsersbyLatency1Click(Sender: TObject);
    procedure UnignoreAll1Click(Sender: TObject);
    procedure QuickHostBrnClick(Sender: TObject);
    procedure QuickJoinBtnClick(Sender: TObject);
    procedure BrowserToolBtnClick(Sender: TObject);
    procedure EnableAllTips1Click(Sender: TObject);
    procedure ClientOptions1Click(Sender: TObject);
    procedure UseWidescreenPatch1Click(Sender: TObject);
    procedure Profile1Click(Sender: TObject);
  private
    IgnoreList: TStringList;
    FriendsList: TStringList;
    FirstNode,
    MemPlusNode,
    FriendsNode,
    LookingNode,
    WaitingNode,
    PlayingNode: TTreeNode;
    SortType: TSortType;
    SplashForm: TSplashForm;
    ShowTips: Boolean;
    DPApplicationIndex: Integer; { GameParamsForm }
    GameTitle: String; { GameParamsForm }
    GameDescription: String; { GameParamsForm }
    GamePassword: String; { GameParamsForm }
    GameMaxPlayers: Integer; { GameParamsForm }
    User: TUser;
    DPlay: TDPlay;
    HostedGames: TObjectList;
    LobbyClient: TLobbyClient;
    LastPingPong: DWORD;
    ServerSettings: TServerSettings;
    MousePos: TPoint;
    Bubbles: TBubbleList;
    {$IFDEF HAMACHI}HamachiPath: String;{$ENDIF}
    LangFile: String;
    WidescreenPatch: String;
    OriginalPath: String;
    WSPatchUsed: Boolean;
    AgePresetData: TAgePresetData;
    PEdit: array[0..7] of TEdit;
    REdit: array[0..7] of TEdit;
    procedure ReadIniFile;
    procedure SetLanguage;
    procedure AddChatMessage(const Message: String;
      MessageType: TMessageType = mSystem; const Sender: String = '');
    function PlayTimeToString(const DateTime: TDateTime): String;
    procedure DisconnectUI(Repaint: Boolean = True);
    procedure DoTeamize;
    {$IFDEF DEBUG}procedure SendLogFile;{$ENDIF}
    procedure LobbyClientGetHostedGames(AHostedGames: TObjectList);
    procedure LobbyClientHostGame(Result: Boolean; GameId: Integer);
    procedure LobbyClientJoinGame(Result: Boolean; GameId: Integer);
    procedure LobbyClientLeaveGame(Result: Boolean; GameId: Integer);
    procedure LobbyClientLogoutUser(Result: Boolean);
    procedure LobbyClientRequestException(RequestType: TRequestType; Exception: Exception);
    {$IFDEF DEBUG}procedure LobbyClientGameStats(const Response: String);{$ENDIF}
    procedure LobbyClientGetRatings(Result: Boolean; var Players: TStringList);
    procedure DPlayHostSession(Sender: TObject; Result: Boolean; const guidInstance: TGUID);
    procedure DPlayJoinSession(Sender: TObject; Result: Boolean; const guidInstance: TGUID);
    procedure DPlayAppTerminated(Sender: TObject);
    procedure DPlayAge2x1Stats(Sender: TObject; const GameStats: TGameStats);
    procedure RefreshHostedGames(GameId: Integer; UserName: String; UserRating: Integer;
      Join: Boolean);
    procedure HostGame(ARoomId: Integer);
    procedure JoinGame(G: THostedGame);
    procedure HandleIRCThreadException(AThread: TIdThread; AException: Exception);
    procedure HandleIRCThreadTerminate(Sender: TObject);

    procedure SortPlayersTreeView(Sender: TObject; SortType: TSortType);
    procedure WMAfterShow(var Msg: TMessage); message WM_AFTER_SHOW;

    procedure LobbyUsersAddUser(Sender: TObject; User: TLobbyUser);
    procedure LobbyUsersRemoveUser(Sender: TObject; User: TLobbyUser);
    procedure LobbyUsersUserStatusChanged(Sender: TObject; OldStatus, NewStatus: TUserStatus);
    procedure LobbyUsersClear(Sender: TObject);
    function IsMainChannel(AChannel: TIdIRCChannel): Boolean;
    procedure SendSystemMessage(SystemMessageType: TSystemMessageType;
      const Args: array of const; const Receiver: String = '');
    {$IFDEF AGE4GREEKS}procedure TeamSpeakClick(Sender: TObject);{$ENDIF}
  public
    LobbyUsers: TLobbyUsers;
    Language: TLanguage;
    procedure SendMessage(const Receiver, Message: String);
  end;

var
  MainForm: TMainForm;

implementation

uses
  uAppDataModule, DateUtils, IniFiles, Graphics, VistaAltFixUnit, CommCtrl,
  uConsts, IdCoderMIME, uInformationDlg, uHintForm, uMessageForm, StrUtils,
  Teamizer, uTipsForm, uMessageOptions, uGameParamsForm, uInfoForm, ActiveX,
  uPasswordForm, uAboutForm{$IFDEF DEBUG}, uLogger{$ENDIF}
  {$IFDEF HAMACHI}, Hamachi{$ENDIF}{$IFDEF AGE4GREEKS}, ShellApi{$ENDIF},
  uClientOptions, AOCRegistry;

{$R *.dfm}

const
  USERNAME_SUFFIX = 'd41d'; { do not localize }
  SESSION_PWD = 'dplobbysystem'; { do not localize }
  SYS_UPDATE = '@UPDATE@';  // param: none { do not localize }
  SYS_JOIN   = '@JOIN@';    // param: int  { do not localize }
  SYS_LEAVE  = '@LEAVE@';   // param: int  { do not localize }
  SYS_PONG   = '@PONG@';    // param: none { do not localize }
  SYS_RATING = '@RATING@';  // param: int  { do not localize }
  SYS_FONT   = '@FONT@';    // param: string, int, int, int
  PINGPONG_TIMEOUT = 8 * 60 * 1000; { 8 mins }
  ROOMS = 50; { number of bubbles }

resourcestring
  c_no_language = 'Unable to load language file.'; { do not localize }

function RemoveNickNameSuffix(const Str: String): String;
begin
  Result := Copy(Str, 0, Length(Str) - Length(USERNAME_SUFFIX));
end;

function AddNickNameSuffix(const Str: String): String;
begin
  Result := Str + USERNAME_SUFFIX;
end;

function PrependTime(const Str: String): String;
begin
  Result := Format('(%s) %s', [FormatDateTime('hh:nn', Now), Str]); { do not localize }
end;

function LatencySort(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
var
  U1, U2: TLobbyUser;
begin
  Result := 0;
  if Assigned(Node1.Data) and Assigned(Node2.Data) then
  begin
    U1 := Node1.Data;
    U2 := Node2.Data;
    if (U1.Ping = U2.Ping) then
      Result := 0
    else
    if (U1.Ping = 0) then
      Result := 1
    else
    if (U2.Ping = 0) then
      Result := -1
    else
    if (U1.Ping < U2.Ping) then
      Result := -1
    else
      Result := 1;
    if (Data <> 0) then
      Result := -Result;
  end;
end;

function RatingSort(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
var
  U1, U2: TLobbyUser;
begin
  Result := 0;
  if Assigned(Node1.Data) and Assigned(Node2.Data) then
  begin
    U1 := Node1.Data;
    U2 := Node2.Data;
    if (U1.Rating < U2.Rating) then
      Result := 1
    else
    if (U1.Rating > U2.Rating) then
      Result := -1
    else
      Result := 0;
    if (Data <> 0) then
    Result := -Result;
  end;
end;

function TMainForm.PlayTimeToString(const DateTime: TDateTime): String;
var
  Mins: Int64;
begin
  Mins := MinutesBetween(Now, DateTime);
  if (Mins = 1) then
    Result := Language.GetValueFmt('min', [Mins]) { do not localize }
  else
    Result := Language.GetValueFmt('mins', [Mins]); { do not localize }
end;

procedure TMainForm.ReadIniFile;
var
  IniFile: TIniFile;
  FontStyle: Integer;
const
  GENERAL_S = 'General'; { do not localize }
  IRC_S = 'IRC'; { do not localize }
  FRIENDS_S = 'Friends'; { do not localize }
  IGNORE_S = 'Ignore'; { do not localize }
  FONT_S = 'Font'; { do not localize }
  {$IFDEF HAMACHI}HAMACHI_S = 'Hamachi';{$ENDIF} { do not localize }
begin
  {$IFDEF HAMACHI}HamachiPath := '';{$ENDIF}
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
  try
    User.Name := IniFile.ReadString(GENERAL_S, 'Username', ''); { do not localize }
    User.Password := IniFile.ReadString(GENERAL_S, 'Password', ''); { do not localize }
    User.Id := IniFile.ReadInteger(GENERAL_S, 'Id', 0);{ do not localize }
    User.Token := IniFile.ReadString(GENERAL_S, 'Token', ''); { do not localize }
    User.Rating := IniFile.ReadInteger(GENERAL_S, 'R', DEFAULT_RATING);
    IniFile.DeleteKey(GENERAL_S, 'Id'); { do not localize }
    IniFile.DeleteKey(GENERAL_S, 'Token'); { do not localize }
    IniFile.DeleteKey(GENERAL_S, 'R'); { do not localize }
    ServerSettings.IRCServer := IniFile.ReadString(IRC_S, 'Server', ''); { do not localize }
    ServerSettings.IRCPort := IniFile.ReadInteger(IRC_S, 'Port', -1); { do not localize }
    ServerSettings.IRCChannel := IniFile.ReadString(IRC_S, 'Channel', ''); { do not localize }
    ServerSettings.ClientJoins := IniFile.ReadBool(GENERAL_S, 'ClientJoins', False);
    ServerSettings.WelcomeMessage := IniFile.ReadString(GENERAL_S, 'WMessage', ''); { do not localize }
    ServerSettings.LobbyUrl := IniFile.ReadString(GENERAL_S, 'LobbyUrl', ''); { do not localize }
    IniFile.EraseSection(IRC_S);
    IniFile.DeleteKey(GENERAL_S, 'ClientJoins'); { do not localize }
    IniFile.DeleteKey(GENERAL_S, 'WMessage'); { do not localize }
    IniFile.DeleteKey(GENERAL_S, 'LobbyUrl'); { do not localize }
    LobbyClient.LobbyServerUrl := IniFile.ReadString(GENERAL_S, 'LobbyServer', ''); { do not localize }
    LangFile := IniFile.ReadString(GENERAL_S, 'Language', 'english.lng'); { do not localize }
    ShowTips := IniFile.ReadBool(GENERAL_S, 'ShowTips', True); { do not localize }
    OriginalPath := IniFile.ReadString(GENERAL_S, 'AOCPath', ''); { do not localize }
    if (OriginalPath = '') then
      try
        OriginalPath := GetAOCRegistryPath;
        IniFile.WriteString(GENERAL_S, 'AOCPath', OriginalPath); { do not localize }
      except
      end;
    WidescreenPatch := IniFile.ReadString(GENERAL_S, 'WSPatch', ''); { do not localize }
    UseWidescreenPatch1.Checked := IniFile.ReadBool(GENERAL_S, 'UseWSPatch', False); { do not localize }
    IniFile.ReadSection(FRIENDS_S, FriendsList);
    IniFile.ReadSection(IGNORE_S, IgnoreList);
    User.Font.Name := IniFile.ReadString(FONT_S, 'Name', ''); { do not localize }
    FontStyle := IniFile.ReadInteger(FONT_S, 'Style', 2); { do not localize }
    if not FontStyle in [0..2] then
      FontStyle := 2;
    User.Font.Style := TFontStyle(FontStyle);
    User.Font.Size := IniFile.ReadInteger(FONT_S, 'Size', 10);
    User.Font.Color := IniFile.ReadInteger(FONT_S, 'Color', clBlack);
    {$IFDEF HAMACHI}HamachiPath := IniFile.ReadString(HAMACHI_S, 'Path', '');{$ENDIF} { do not localize }
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  B: TBubble;
  i: Integer;
  Bmp: TBitmap;
  {$IFDEF AGE4GREEKS}MI: TMenuItem;{$ENDIF}
begin
  DoubleBuffered := True;
  GamesListView.DoubleBuffered := True;
  TVistaAltFix.Create(Self);
  { adjust GUI }
  GamesTab.TabVisible := False;
  TeamizerTab.TabVisible := False;
  BrowserTab.TabVisible := False;
  JvPageControl.ActivePageIndex := 0;

  ChatSplitter.Enabled := False;
  with AppDataModule do
  begin
    LogoImage.Picture.Assign(LogoBitmap);
    BannerImage.Picture.Assign(BannerBitmap);
    PlayersTreeView.Images := PingImageList;
    ToolBar.Images := ToolImageList;
    TopPanel.Height := BannerImage.Height;

    with GamesListView do
    begin
      ViewStyle := vsIcon;
      LargeImages := RoomImageList;
      Picture.Assign(Age2Lobby);
      BevelInner := bvNone;
      BevelOuter := bvNone;
      BorderStyle := bsNone;
      Color := clBlack;
      ReadOnly := True;
      AutoSelect := False;
      IconOptions.AutoArrange := True;
      ListView_SetIconSpacing(Handle, C.Room.Width + C.BubbleHSpacing, C.Room.Height + C.BubbleVSpacing);
    end;
    MainPanel.Constraints.MinWidth := 4 * (C.Room.Width + C.BubbleHSpacing) + 20; { nech sa tam zmestia aspon styri bubliny na riadok }

    Bmp := TBitmap.Create;
    try
      EmoFontImageList.GetBitmap(FONT_UP_IDX, Bmp);
      FontImage.Width := Bmp.Width;
      FontImage.Height := Bmp.Height;
      FontImage.Picture.Assign(Bmp);
      EmoFontImageList.GetBitmap(FONT_HOVER_IDX, Bmp);
      FontImage.Pictures.PicEnter.Assign(Bmp);
      EmoFontImageList.GetBitmap(FONT_DOWN_IDX, Bmp);
      FontImage.Pictures.PicDown.Assign(Bmp);

      EmotImage.Width := Bmp.Width;
      EmotImage.Height := Bmp.Height;
      EmoFontImageList.GetBitmap(EMOT_UP_IDX, Bmp);
      EmotImage.Picture.Assign(Bmp);
      EmoFontImageList.GetBitmap(EMOT_HOVER_IDX, Bmp);
      EmotImage.Pictures.PicEnter.Assign(Bmp);
      EmoFontImageList.GetBitmap(EMOT_DOWN_IDX, Bmp);
      EmotImage.Pictures.PicDown.Assign(Bmp);

      SendImageList.GetBitmap(SEND_UP_IDX, Bmp);
      SendImage.Width := Bmp.Width;
      SendImage.Height := Bmp.Height;
      SendImage.Picture.Assign(Bmp);
      SendImageList.GetBitmap(SEND_HOVER_IDX, Bmp);
      SendImage.Pictures.PicEnter.Assign(Bmp);
      SendImageList.GetBitmap(SEND_DOWN_IDX, Bmp);
      SendImage.Pictures.PicDown.Assign(Bmp);
    finally
      Bmp.Free;
    end;
  end;
  if (FontImage.Height > SendImage.Height) then
    ChatPanel.ClientHeight := FontImage.Height
  else
    ChatPanel.ClientHeight := SendImage.Height;
  ChatPanel.Color := clWhite;
  ChatEdit.Align := alClient;
  ChatEdit.Align := alNone;
  ChatEdit.Top := ChatEdit.Top + 4;
  ChatEdit.Height := ChatEdit.Height - 8;
  ChatEdit.Left := ChatEdit.Left + 4;
  ChatEdit.Width := ChatEdit.Width - 8;
  ChatEdit.Anchors := [akLeft, akTop, akRight, akBottom];

  LobbyUsers := TLobbyUsers.Create;
  LobbyUsers.OnAddUser := LobbyUsersAddUser;
  LobbyUsers.OnRemoveUser := LobbyUsersRemoveUser;
  LobbyUsers.OnUserStatusChanged := LobbyUsersUserStatusChanged;
  LobbyUsers.OnClear := LobbyUsersClear;

  SortType := stNameUp;

  User := TUser.Create;
  User.OnStatusChanged := LobbyUsersUserStatusChanged;

  LobbyClient := TLobbyClient.Create;
  HostedGames := TObjectList.Create;
  IgnoreList := TStringList.Create;
  FriendsList := TStringList.Create;
  { read settings }
  ReadIniFile;
  WSPatchUsed := False;
  { load language }
  Language := TLanguage.Create;
  try
    Language.LoadFromFile(LangFile);
  except
    MessageDlg(c_no_language, mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;
  SetLanguage;
  TeamizeInfoLabel.Caption := 'Right-click hosted game to fill edit boxes with player names.';

  { set user's font }
  if (Screen.Fonts.IndexOf(User.Font.Name) <> -1) then
    ChatEdit.Font.Name := User.Font.Name;
  ChatEdit.Font.Style := [User.Font.Style] - [fsUnderline, fsStrikeOut];
  if User.Font.Size in [8..12] then
    ChatEdit.Font.Size := User.Font.Size;
  ChatEdit.Font.Color := User.Font.Color;

  FirstNode   := PlayersTreeView.Items.Add(nil, TOTAL_PLAYERS);
  MemPlusNode := PlayersTreeView.Items.Add(nil, MEMBER_PLUS);
  FriendsNode := PlayersTreeView.Items.Add(nil, FRIENDS);
  LookingNode := PlayersTreeView.Items.Add(nil, LOOKING);
  WaitingNode := PlayersTreeView.Items.Add(nil, WAITING);
  PlayingNode := PlayersTreeView.Items.Add(nil, PLAYING);

  Bubbles := TBubbleList.Create;
  for i := 0 to ROOMS - 1 do
  begin
    B := TBubble.Create;
    Bubbles.Add(B);
    GamesListView.AddItem(Format(GAME_ID, [i + 1]), B);
  end;

  LobbyClient.OnGetHostedGames := LobbyClientGetHostedGames;
  LobbyClient.OnHostGame := LobbyClientHostGame;
  LobbyClient.OnJoinGame := LobbyClientJoinGame;
  LobbyClient.OnLeaveGame := LobbyClientLeaveGame;
  LobbyClient.OnLogoutUser := LobbyClientLogoutUser;
  LobbyClient.OnRequestException := LobbyClientRequestException;
  {$IFDEF DEBUG}LobbyClient.OnGameStats := LobbyClientGameStats;{$ENDIF}
  LobbyClient.OnGetRatings := LobbyClientGetRatings;
  {$IFDEF AGE4GREEKS}
  MI := TMenuItem.Create(Zone1);
  MI.Caption := '-';
  Zone1.Add(MI);
  MI := TMenuItem.Create(Zone1);
  MI.Caption := 'TeamSpeak';
  MI.OnClick := TeamSpeakClick;
  Zone1.Add(MI);
  {$ENDIF}
  ZeroMemory(@AgePresetData, SizeOf(TAgePresetData));
  DPlay := TDPlay.Create;
  DPlay.OnHostSession := DPlayHostSession;
  DPlay.OnJoinSession := DPlayJoinSession;
  DPlay.OnAppTerminated := DPlayAppTerminated;
  DPlay.OnAge2x1Stats := DPlayAge2x1Stats;
  if DPlay.Initialize then
    DPlay.GetDPApplications;

  DPApplicationIndex := -1;
  GameTitle := '';
  GameDescription := '';
  GamePassword := '';
  GameMaxPlayers := 8;
  {$IFDEF DEBUG}
  MailSender := TDebugMailSender.Create;
  SendLogFile;
  {$ENDIF}
  PEdit[0] := P1Edit; REdit[0] := R1Edit;
  PEdit[1] := P2Edit; REdit[1] := R2Edit;
  PEdit[2] := P3Edit; REdit[2] := R3Edit;
  PEdit[3] := P4Edit; REdit[3] := R4Edit;
  PEdit[4] := P5Edit; REdit[4] := R5Edit;
  PEdit[5] := P6Edit; REdit[5] := R6Edit;
  PEdit[6] := P7Edit; REdit[6] := R7Edit;
  PEdit[7] := P8Edit; REdit[7] := R8Edit;

  { If we are here, we have successfully logged in. Connect to the IRC channel. }
  if (ServerSettings.IRCServer <> '') and (ServerSettings.IRCPort <> -1) and (ServerSettings.IRCChannel <> '') then
  begin
    IdIRC.Host := ServerSettings.IRCServer;
    IdIRC.Port := ServerSettings.IRCPort;
    IdIRC.Nick := AddNickNameSuffix(User.Name);
    IdIRC.AltNick := ''; { see IdIRC.pas, line 3150 }
    IdIRC.UserName := AddNickNameSuffix(User.Name);
    IdIRC.RealName := AddNickNameSuffix(User.Name);
    try
      IdIRC.Connect; { nemozem dat do vlakna (pozri zdrojaky) }
      IdIRC.IRCThread.OnException := HandleIRCThreadException;
      IdIRC.IRCThread.OnTerminate := HandleIRCThreadTerminate;
    except
      Tag := 1;
      AddChatMessage(Language.GetValue('unable_to_connect')); { do not localize }
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
 IniFile: TIniFile;
 i: Integer;
const
  GENERAL_S = 'General'; { do not localize }
  FRIENDS_S = 'Friends'; { do not localize }
  IGNORE_S = 'Ignore'; { do not localize }
  FONT_S = 'Font'; { do not localize }
begin
  if WSPatchUsed then
    WSPatchUsed := not SetAOCRegistry(OriginalPath);

  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
  try
    IniFile.WriteString(FONT_S, 'Name', User.Font.Name); { do not localize }
    IniFile.WriteInteger(FONT_S, 'Style', Ord(User.Font.Style)); { do not localize }
    IniFile.WriteInteger(FONT_S, 'Size', User.Font.Size); { do not localize }
    IniFile.WriteInteger(FONT_S, 'Color', User.Font.Color); { do not localize }
    IniFile.WriteBool(GENERAL_S, 'UseWSPatch', UseWidescreenPatch1.Checked); { do not localize }
    for i := 0 to FriendsList.Count - 1 do
      IniFile.WriteString(FRIENDS_S, FriendsList[i], '');
    for i := 0 to IgnoreList.Count - 1 do
      IniFile.WriteString(IGNORE_S, IgnoreList[i], '');
  finally
    IniFile.Free;
  end;
  TimeoutTimer.Enabled := False;
  if Assigned(IdIRC.IRCThread) then
    IdIRC.IRCThread.OnException := nil;
  { Logout from server (send UPDATE if required) }
  LobbyClient.LogoutUser(User.Id, User.Token);
  while LobbyClient.HasActiveThreads do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  { Leave channel and quit IRC }
  try
    if IdIRC.Connected then
    begin
      if (IdIRC.State = csConnected) then
      begin
        IdIRC.Part(ServerSettings.IRCChannel);
        IdIRC.Quit('');
      end else
        IdIRC.Disconnect;
    end;
  except
    //
  end;
  while IdIRC.Connected do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  {$IFDEF DEBUG}
  TLogger.FreeInstances;
  SendLogFile;
  while MailSender.HasActiveThreads do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  MailSender.Free;
  {$ENDIF}
  DisconnectUI(False);
  Language.Free;
  DPlay.Free;
  if Assigned(HostedGames) then
    HostedGames.Free;
  User.Free;
  LobbyClient.Free;
  Bubbles.Free;
  LobbyUsers.Free;
  IgnoreList.Free;
  FriendsList.Free;
end;

procedure TMainForm.SetLanguage;
begin
(*
  GamesLabel.Caption := Language.GetValue('games'); { do not localize }
  ChatRoomLabel.Caption := Language.GetValue('chat_room'); { do not localize }
  UsersLabel.Caption := Language.GetValueFmt('users', [0]); { do not localize }
  HostBtn.Caption := Language.GetValue('host'); { do not localize }
  JoinBtn.Caption := Language.GetValue('join'); { do not localize }
  GamesListView.Columns[0].Caption := Language.GetValue('game'); { do not localize }
  GamesListView.Columns[1].Caption := Language.GetValue('host_user'); { do not localize }
  GamesListView.Columns[2].Caption := Language.GetValue('description'); { do not localize }
  GamesListView.Columns[3].Caption := Language.GetValue('players'); { do not localize }
  GamesListView.Columns[4].Caption := Language.GetValue('play_time'); { do not localize }
  GamesListView.Columns[5].Caption := Language.GetValue('password'); { do not localize }
  File1.Caption := Language.GetValue('file'); { do not localize }
  Exit1.Caption := Language.GetValue('exit'); { do not localize }
  About1.Caption := Language.GetValue('about'); { do not localize }
*)
end;

procedure TMainForm.DisconnectUI(Repaint: Boolean = True);
var
  i: Integer;
begin
  TimeoutTimer.Enabled := False;
  GamesTimer.Enabled := False;
  for i := 0 to Bubbles.Count - 1 do
    Bubbles[i].Data := nil;
  HostedGames.Clear;
  LobbyUsers.Clear;
  if Repaint then
    GamesListView.Invalidate;
end;

{ Add chat message to ChatMemo }
procedure TMainForm.AddChatMessage(const Message: String;
  MessageType: TMessageType = mSystem; const Sender: String = '');
var
  sTimeStamp: String;
  Font: TFont;
  U: TLobbyUser;
const
  Space = #32; { do not localize }
begin
  Font := TFont.Create;
  try
    Font.Name := 'Tahoma'; { do not localize }
    Font.Size := 10;
    Font.Color := clBlack;
    Font.Style := [];
    sTimeStamp := FormatDateTime('(hh:nn)', Now); { do not localize }
    if (Length(ChatRichEdit.Text) > 0) then
      ChatRichEdit.AddFormatText(sLineBreak);
    ChatRichEdit.AddFormatText(sTimeStamp + Space, Font);
    case MessageType of
      mError:
        begin
          Font.Color := clRed;
          Font.Style := [fsBold];
          ChatRichEdit.AddFormatText('<Lobby>' + Space, Font);
        end;
      mSystem:
        begin
          Font.Style := [fsBold];
          ChatRichEdit.AddFormatText('<Lobby>' + Space, Font);
        end;
      mEnter:
        begin
          Font.Style := [fsBold];
          ChatRichEdit.AddFormatText(Language.GetValue('user_enter') + Space, Font); { do not localize }
        end;
      mExit:
        begin
          Font.Style := [fsBold];
          ChatRichEdit.AddFormatText(Language.GetValue('user_exit') + Space, Font); { do not localize }
        end;
      mUser:
        begin
          ChatRichEdit.AddFormatText(Sender + '>' + Space, Font); { do not localize }
        end;
    end;
    Font.Color := clBlack;
    Font.Style := [];
    if (MessageType = mUser) then
    begin
      if (Sender = User.Name) then
        U := User
      else
        U := LobbyUsers.Get(Sender);
      if Assigned(U) then
      begin
        if (Screen.Fonts.IndexOf(U.Font.Name) <> -1) then
          Font.Name := U.Font.Name;
        Font.Style := [U.Font.Style];
        Font.Style := Font.Style - [fsUnderline, fsStrikeOut];
        if U.Font.Size in [8..12] then
          Font.Size := U.Font.Size;
        Font.Color := U.Font.Color;
      end;
    end;
    ChatRichEdit.AddFormatText(Message, Font);
    PostMessage(ChatRichEdit.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  finally
    Font.Free;
  end;
end;

{ User has joined a channel }
procedure TMainForm.IdIRCJoin(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel);
var
  U: TLobbyUser;
  UserName: String;
begin
  if IsMainChannel(AChannel) then
  begin
    { Notify me and update users list }
    UserName := RemoveNickNameSuffix(AUser.Nick);
    AddChatMessage(UserName, mEnter);
    U := TLobbyUser.Create;
    U.Name := UserName;
    LobbyUsers.Add(U);
    { Send RATING system message }
    SendSystemMessage(smRating, [User.Rating]);
    { Send FONT system message }
    SendSystemMessage(smFont, [TIdEncoderMIME.EncodeString(User.Font.Name),
      Ord(User.Font.Style), User.Font.Size, User.Font.Color]);
  end;
end;

{ I have joined a channel }
procedure TMainForm.IdIRCJoined(Sender: TObject; AChannel: TIdIRCChannel);
begin
  if IsMainChannel(AChannel) then
  begin
    { Obtain hosted games }
    AddChatMessage(User.Name, mEnter);
    LobbyClient.GetHostedGames(User.Id, User.Token);
    if SplashForm.Visible then
      SplashForm.Close;
    PlayersTreeView.Items.AddChildObject(FirstNode, User.Name, User);
    FirstNode.Expand(False);
    { Send RATING system message }
    SendSystemMessage(smRating, [User.Rating]);
    { Send FONT system message }
    SendSystemMessage(smFont, [TIdEncoderMIME.EncodeString(User.Font.Name),
      Ord(User.Font.Style), User.Font.Size, User.Font.Color]);
    if (ServerSettings.WelcomeMessage <> '') then
      AddChatMessage(ServerSettings.WelcomeMessage, mSystem);
    {$IFDEF HAMACHI}
    if not IsHamachiRunning then
      LaunchHamachi(HamachiPath);
    {$ENDIF}
    ChatEdit.SetFocus;
  end;
end;

procedure TMainForm.IdIRCStateChange(Sender: TObject);
begin
  case IdIRC.State of
    csDisconnect: AddChatMessage(Language.GetValue('disconnecting')); { do not localize }
    csDisconnected: AddChatMessage(Language.GetValue('disconnected')); { do not localize }
    csConnecting: AddChatMessage(Language.GetValue('connecting')); { do not localize }
    csLoggingOn: AddChatMessage(Language.GetValue('logging_on')); { do not localize }
    csConnected: AddChatMessage(Language.GetValue('connected')); { do not localize }
  end;
end;

procedure TMainForm.IdIRCSystem(Sender: TObject; AUser: TIdIRCUser;
  ACmdCode: Integer; ACommand, AContent: String);
var
  CurrentNick: String;
begin
  { Check if our nick was not stripped }
  if (ACmdCode = 1) and (ACommand = 'WELCOME') then { do not localize }
  begin
    if (Pos(':', AContent) > 0) then { do not localize }
    begin
      CurrentNick := Trim(Copy(AContent, 1, Pos(':', AContent) - 1)); { do not localize }
      if (CurrentNick <> IdIRC.Nick) then
      begin
        AddChatMessage(Language.GetValueFmt('error', [Language.GetValue('nickname_stripped')]), mError); { do not localize }
        try
          IdIRC.Disconnect(True);
        except
          //
        end;
        Exit;
      end;
    end;
  end;
  { Wait for End of /MOTD command, than connect to a channel }
  if (ACmdCode = RPL_ENDOFMOTD) then
  begin
    if IdIRC.IsChannel(ServerSettings.IRCChannel) then
      IdIRC.Join(ServerSettings.IRCChannel);
  end;
end;

{ I have parted a channel }
procedure TMainForm.IdIRCParted(Sender: TObject; AChannel: TIdIRCChannel);
begin
  if IsMainChannel(AChannel) then
  begin
    { Clear users and games lists }
    AddChatMessage(User.Name, mExit);
    DisconnectUI(False);
  end;
end;

{ User has parted a channel }
procedure TMainForm.IdIRCPart(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel);
var
  U: TLobbyUser;
  UserName: String;
begin
  if IsMainChannel(AChannel) then
  begin
    { Notify me and update users list }
    UserName := RemoveNickNameSuffix(AUser.Nick);
    AddChatMessage(UserName, mExit);
    U := LobbyUsers.Get(UserName);
    if Assigned(U) then
      LobbyUsers.Remove(U);
  end;
end;

{ User has quitted IRC }
procedure TMainForm.IdIRCQuit(Sender: TObject; AUser: TIdIRCUser);
var
  U: TLobbyUser;
  UserName: String;
begin
  { Notify me and update users list }
  UserName := RemoveNickNameSuffix(AUser.Nick);
  AddChatMessage(UserName, mExit);
  U := LobbyUsers.Get(UserName);
  if Assigned(U) then
    LobbyUsers.Remove(U);
end;

{ Received a list of users in a channel }
procedure TMainForm.IdIRCNames(Sender: TObject; AUsers: TIdIRCUsers;
  AChannel: TIdIRCChannel);
var
  U: TLobbyUser;
  UserName: String;
  i: Integer;
begin
  if IsMainChannel(AChannel) then
  begin
    { Reload users list }
    LobbyUsers.Clear;
    for i := 0 to AUsers.Count - 1 do
    begin
      UserName := RemoveNickNameSuffix(IdIRC.Users.Items[i].Nick);
      if (UserName <> '') and (UserName <> User.Name) then
      begin
        U := TLobbyUser.Create;
        U.Name := UserName;
        LobbyUsers.Add(U);
      end;
    end;
  end;
end;

{ Received error message from server }
procedure TMainForm.IdIRCError(Sender: TObject; AUser: TIdIRCUser; ANumeric,
  AError: String);
var
  CommandNumber: Integer;
  ErrorMessage: String;
begin
  if SplashForm.Visible then
    SplashForm.Close;
  CommandNumber := StrToIntDef(ANumeric, -1);
  if (CommandNumber >= ERR_NONICKNAMEGIVEN) and (CommandNumber <= ERR_NICKCOLLISION) then
  begin
    if (Pos(':', AError) > 0) then { do not localize }
      ErrorMessage := Copy(AError, Pos(':', AError) + 1, Length(AError)) { do not localize }
    else
      ErrorMessage := AError;
    AddChatMessage(Language.GetValueFmt('error', [ErrorMessage]), mError); { do not localize }
  end else
  begin
    ErrorMessage := StringReplace(AError, USERNAME_SUFFIX, '', [rfReplaceAll]);
    AddChatMessage(Language.GetValueFmt('error', [ErrorMessage]), mError); { do not localize }
  end;
end;

{ Received a message }
procedure TMainForm.IdIRCMessage(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel; Content: String);
var
  GameId, Rating: Integer;
  UserName: String;
  FWInfo: TFlashWInfo;
  U: TLobbyUser;
  FontString: TStringList;
  FontStyle: Integer;
begin
  UserName := RemoveNickNameSuffix(AUser.Nick);
  if not IsMainChannel(AChannel) then
  begin
    if (IgnoreList.IndexOf(UserName) <> -1) then
      Exit;
    if User.IsInGame or (User.Status = usPlaying) then
      { ignore messages if I am in a game }
      Exit;
    with TMessageForm.Create(nil) do
    begin
      SetForm(UserName, Content);
      Show;
      with FWInfo do
      begin
        cbSize := SizeOF(TFlashWInfo);
        hwnd := Handle;
        dwFlags := FLASHW_TIMERNOFG or FLASHW_ALL;
        uCount := 10;
        dwTimeout := 0;
      end;
      FlashWindowEx(FWInfo);
    end;
    Exit;
  end;
  if (Content = SYS_UPDATE) then
  begin
    { UDPATE system message, update games list }
    LobbyClient.GetHostedGames(User.Id, User.Token)
  end else
  if (LeftStr(Content, Length(SYS_JOIN)) = SYS_JOIN) then
  begin
    { JOIN system message, get game id }
    GameId := StrToIntDef(Copy(Content, Length(SYS_JOIN) + 1, Length(Content)), 0);
    if (GameId = 0) then
      Exit;
    { Update games list }
    RefreshHostedGames(GameId, UserName, 0, True);
  end else
  if (LeftStr(Content, Length(SYS_LEAVE)) = SYS_LEAVE) then
  begin
    { LEAVE system message, get game id }
    GameId := StrToIntDef(Copy(Content, Length(SYS_LEAVE) + 1, Length(Content)), 0);
    if (GameId = 0) then
      Exit;
    { update games list }
    RefreshHostedGames(GameId, UserName, 0, False);
  end else
  if (LeftStr(Content, Length(SYS_PONG)) = SYS_PONG) then
    { do nothing }
  else
  if (LeftStr(Content, Length(SYS_RATING)) = SYS_RATING) then
  begin
    { RATING system message, get rating }
    Rating := StrToIntDef(Copy(Content, Length(SYS_RATING) + 1, Length(Content)), 0);
    if (Rating <> 0) then
    begin
      U := LobbyUsers.Get(UserName);
      if Assigned(U) then
      begin
        U.Rating := Rating;
        PlayersTreeView.Repaint;
      end;
    end;
  end else
  if (LeftStr(Content, Length(SYS_FONT)) = SYS_FONT) then
  begin
    { FONT system message, set font }
    U := LobbyUsers.Get(UserName);
    if Assigned(U) then
    begin
      FontString := TStringList.Create;
      try
        try
          FontString.Delimiter := ';';
          FontString.DelimitedText := Copy(Content, Length(SYS_FONT) + 1, Length(Content));
          if (FontString.Count > 3) then
          begin
            U.Font.Name := TIdDecoderMIME.DecodeString(FontString[0]);
            FontStyle := StrToIntDef(FontString[1], 2);
            if (FontStyle > 2) then
              FontStyle := 2;
            U.Font.Style := TFontStyle(FontStyle);
            U.Font.Size := StrToIntDef(FontString[2], 10);
            U.Font.Color := StrToIntDef(FontString[3], clBlack);
          end;
        except
          //
        end;
      finally
        FontString.Free;
      end;
    end;
  end else
    AddChatMessage(Content, mUser, UserName);
end;

procedure TMainForm.IdIRCPingPong(Sender: TObject);
begin
  LastPingPong := GetTickCount;
  if not TimeoutTimer.Enabled then
    TimeoutTimer.Enabled := True;
end;

procedure TMainForm.TimeoutTimerTimer(Sender: TObject);
begin
  if (GetTickCount - LastPingPong > PINGPONG_TIMEOUT) then
  begin
    try
      IdIRC.Say(ServerSettings.IRCChannel, SYS_PONG);
      IdIRC.Say(ServerSettings.IRCChannel, SYS_PONG);
      IdIRC.CheckForDisconnect;
      IdIRC.CheckForGracefulDisconnect;
      LastPingPong := GetTickCount;
    except
      //
    end;
  end;
end;

{ Refresh games list when join or leave message has been received }
procedure TMainForm.RefreshHostedGames(GameId: Integer; UserName: String;
  UserRating: Integer; Join: Boolean);
var
  ListItem: TListItem;
  G: THostedGame;
  B: TBubble;
  U: TLobbyUser;
  i: Integer;
begin
  ListItem := nil; B := nil;
  for i := 0 to GamesListView.Items.Count - 1 do
  begin
    ListItem := GamesListView.Items[i];
    B := ListItem.Data;
    if Assigned(B) and Assigned(B.Data) and (THostedGame(B.Data).Id = GameId) then
      Break;
    ListItem := nil;
    B := nil;
  end;
  if not Assigned(ListItem) or not Assigned(B) then
    Exit;

  G := B.Data;
  U := LobbyUsers.Get(UserName);
  if (Join) then
  begin
    { User has joined a game, increase # of players and add player to the list  }
    G.PlayerList.AddObject(UserName, Pointer(UserRating));
    if Assigned(U) then
      U.Status := usPlaying;
    if (UserName = User.Name) then
    begin
      { bol som to ja }
      B.Active := True;
    end;
  end else
  begin
    if (UserName = User.Name) then
      B.Active := False;
    { User has left a game, decrease # of players or remove the game if players = 0 }
    i := G.PlayerList.IndexOf(UserName);
    if (i = -1) then
      Exit;
    G.PlayerList.Delete(i);
    if Assigned(U) then
      U.Status := usLooking;
    if (G.PlayerList.Count = 0) then
    begin
      B.Data := nil;
      HostedGames.Remove(G);
    end else
    begin
      if (i = 0) then
      begin
        { host left }
        U := LobbyUsers.Get(G.PlayerList[0]);
        if Assigned(U) then
          G.HostPing := U.Ping;
      end;
    end;
  end;
  GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
end;

{ Received hosted games from server }
procedure TMainForm.LobbyClientGetHostedGames(AHostedGames: TObjectList);
var
  G: THostedGame;
  i, j: Integer;
  U: TLobbyUser;
begin
  { Reload games list }
  for i := 0 to Bubbles.Count - 1 do
    Bubbles[i].Data := nil;

  HostedGames.Free;
  HostedGames := AHostedGames;

  for i := HostedGames.Count - 1 downto 0 do
  begin
    G := HostedGames[i] as THostedGame;
    if not G.RoomId in [0..ROOMS - 1] then
    begin
      HostedGames.Delete(i);
      Continue;
    end;
    Bubbles[G.RoomId].Data := G;
    for j := 0 to G.PlayerList.Count - 1 do
    begin
      U := LobbyUsers.Get(G.PlayerList[j]);
      if Assigned(U) then
      begin
        U.RoomId := G.RoomId;
        U.Rating := Integer(G.PlayerList.Objects[j]);
        if (j = 0) then
          G.HostPing := U.Ping;
        case G.Status of
          gsWaiting: U.Status := usWaiting;
          gsJoinInProgress: U.Status := usPlaying;
          gsInProgress: U.Status := usPlaying;
        end;
      end;
    end;
  end;
  { Repaint bubbles }
  GamesListView.Invalidate;
  GamesTimer.Enabled := True;
end;

{ Received host response from server }
procedure TMainForm.LobbyClientHostGame(Result: Boolean; GameId: Integer);
var
  G: THostedGame;
  ListItem: TListItem;
  Bubble: TBubble;
begin
  if Result then
  begin
    User.IsInGame := True;
    { Send UPDATE system message and add game to game list}
    SendSystemMessage(smUpdate, []);
    User.Status := usPlaying;
    User.HostedGame.Id := GameId;
    User.RoomId := User.HostedGame.RoomId;
    G := THostedGame.Create;
    G.Assign(User.HostedGame);
    HostedGames.Add(G);
    { Update UI }
    if (User.RoomId >= 0) and (User.RoomId < GamesListView.Items.Count) then
    begin
      ListItem := GamesListView.Items[User.RoomId];
      Bubble := ListItem.Data;
      if Assigned(Bubble) then
      begin
        Bubble.Data := G;
        Bubble.Active := True;
        GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
      end;
    end;
  end else
  begin
    InfoDlg.InfoDlgType := idtFailedHosting; { TODO: reason: server update }
    InfoDlg.Show;
  end;
end;

{ Received join response from server }
procedure TMainForm.LobbyClientJoinGame(Result: Boolean; GameId: Integer);
begin
  if Result then
  begin
    User.IsInGame := True;
    { Send JOIN system message and update games list }
    SendSystemMessage(smJoin, [GameId]);
    User.Status := usPlaying;
    RefreshHostedGames(GameId, User.Name, User.Rating, True);
  end else
  begin
    InfoDlg.InfoDlgType := idtFailedJoining;
    InfoDlg.Show;
  end;
end;

{ Received leave response from server }
procedure TMainForm.LobbyClientLeaveGame(Result: Boolean; GameId: Integer);
begin
  if Result then
  begin
    User.IsInGame := False;
    User.Status := usLooking;
    { Send LEAVE system mesage and update games list }
    SendSystemMessage(smLeave, [GameId]);
    RefreshHostedGames(GameId, User.Name, User.Rating, False);
  end;
end;

{ Received logout response from server }
procedure TMainForm.LobbyClientLogoutUser(Result: Boolean);
begin
  if Result and User.IsInGame then
  begin
    { Send UPDATE system message }
    SendSystemMessage(smUpdate, []);
    User.IsInGame := False;
  end;
end;

{ Handle Lobby Client exceptions }
procedure TMainForm.LobbyClientRequestException(RequestType: TRequestType; Exception: Exception);
var
  MessageText: String;
begin
  case RequestType of
  {$IFDEF DEBUG}
    rtGameStats:
      begin
        try
          TLogger.GetInstance.SendMessage('LobbyClientRequestException: ' + Exception.Message); { do not localize }
        except
          //
        end;
      end;
  {$ENDIF}
    rtGetHostedGames:
      begin
        MessageText := Language.GetValue('error_hosted_games') + #13#10 + Exception.Message; { do not localize }
        AddChatMessage(MessageText, mError);
      end;
    rtGetRatings:
      begin
        TeamizeBtn.Enabled := True;
      end;
  end;
end;
{$IFDEF DEBUG}
procedure TMainForm.LobbyClientGameStats(const Response: String);
begin
  try
    TLogger.GetInstance.SendMessage('LobbyClientGameStats: ' + Response); { do not localize }
  except
    //
  end;
end;
{$ENDIF}
procedure TMainForm.LobbyClientGetRatings(Result: Boolean; var Players: TStringList);
var
  i, j: Integer;
  CanTeamize: Boolean;
begin
  TeamizeBtn.Enabled := True;
  try
    if not Result then
    begin
      MessageDlg(Language.GetValue('unable_to_get_ratings') + ' '
        + Language.GetValue('teamizer_manually'), mtError, [mbOK], 0); {do not localize}
      Exit;
    end;
    CanTeamize := True;
    Players.CaseSensitive := False;
    for i := 0 to Length(PEdit) - 1 do
    begin
      j := Players.IndexOf(PEdit[i].Text);
      if (j <> -1) then
        REdit[i].Text := IntToStr(Integer(Players.Objects[j]));
      if (PEdit[i].Text <> '') and (REdit[i].Text = '') then
        CanTeamize := False;
    end;
    if CanTeamize then
      DoTeamize
    else
      MessageDlg(Language.GetValue('unable_to_get_ratings') + ' '
        + Language.GetValue('teamizer_manually'), mtError, [mbOK], 0); {do not localize}
  finally
    Players.Free;
  end;
end;

procedure TMainForm.DoTeamize;
var
  i, l, r, idx: Integer;
  Teamizer: TTeamizer;
  Ratings: array of Integer;
  ByteSet: TByteSet;
  Players: TStringList;
  Rating: Integer;
begin
  Players := TStringList.Create;
  try
    for i := 0 to Length(PEdit) - 1 do
    begin
      if (PEdit[i].Text <> '') and (REdit[i].Text <> '') then
      begin
        try
          Rating := StrToInt(REdit[i].Text);
          Players.AddObject(PEdit[i].Text, Pointer(Rating));
        except
          Exit;
        end;
      end;
    end;
    if (Players.Count > 0) then
    begin
      SetLength(Ratings, Players.Count);
      try
        for i := 0 to Players.Count - 1 do
          Ratings[i] := Integer(Players.Objects[i]);
        Teamizer := TTeamizer.Create(Ratings);
        Teamizer.Teamize;
        ByteSet := Teamizer.Result;
        for i := 0 to Length(PEdit) - 1 do
        begin
          PEdit[i].Text := '';
          REdit[i].Text := '';
        end;
        l := 0; r := 1;
        for i := 0 to Players.Count - 1 do
        begin
          if i in ByteSet then
          begin
            idx := l; Inc(l, 2);
          end else
          begin
            idx := r; Inc(r, 2);
          end;
          PEdit[idx].Text := Players[i];
          REdit[idx].Text := IntToStr(Integer(Players.Objects[i]));
        end;
      finally
        SetLength(Ratings, 0);
      end;
    end;
  finally
    Players.Free;
  end;
end;

{ Triggered when DirectPlay application has created a session or
  has failed to create a session }
procedure TMainForm.DPlayHostSession(Sender: TObject; Result: Boolean; const guidInstance: TGUID);
begin
  InfoDlg.Close;
  User.IsStartingSession := False;
  if WSPatchUsed then
    WSPatchUsed := not SetAOCRegistry(OriginalPath);
  if not Result then
    MessageDlg(Language.GetValue('unable_host_session'), mtWarning, [mbOK], 0) { do not localize }
  else
  begin
    { Send host server request }
    User.HostedGame.SessionGuid := guidInstance;
    LobbyClient.HostGame(User.Id, User.Token, User.HostedGame);
  end;
end;

{ Triggered when DirectPlay application has successfully joined a session or
  has failed to connect to a session }
procedure TMainForm.DPlayJoinSession(Sender: TObject; Result: Boolean; const guidInstance: TGUID);
begin
  InfoDlg.Close;
  User.IsStartingSession := False;
  if WSPatchUsed then
    WSPatchUsed := not SetAOCRegistry(OriginalPath);
  if not Result then
    MessageDlg(Language.GetValue('unable_join_session'), mtWarning, [mbOK], 0) { do not localize }
  else
  begin
    { Send join server request }
    LobbyClient.JoinGame(User.Id, User.Token, User.HostedGame);
  end;
end;

{ Triggered when DirectPlay application has terminated }
procedure TMainForm.DPlayAppTerminated(Sender: TObject);
begin
  if WSPatchUsed then
    WSPatchUsed := not SetAOCRegistry(OriginalPath);
  { Send leave server request }
  LobbyClient.LeaveGame(User.Id, User.Token, User.HostedGame);
end;

procedure TMainForm.DPlayAge2x1Stats(Sender: TObject; const GameStats: TGameStats);
var
  strScenarioFileName: String;
  Indexes: Set of Byte;
  PS: TPlayerStats;
  i: Integer;
  {$IFDEF DEBUG}MStream: TMemoryStream;
  UTC: TSystemTime;
  StatsId: String;{$ENDIF}
begin
  { check if there is a cooping player in the game }
  Indexes := [];
  for i := 0 to 7 do
  begin
    PS := GameStats.PlayerStats[i];
    if (PS.Civilization = 0) then
      Continue;
    if PS.Index in Indexes then
    begin
      Indexes := [];
      Break;
    end;
    Indexes := Indexes + [PS.Index];
  end;
  if (Indexes <> []) and (GameStats.Complete = 1) and (GameStats.AllowCheats = 0) then
  begin
    strScenarioFileName := GameStats.ScenarioFileName;
    if (strScenarioFileName <> '') then
      Exit;
    LobbyClient.SendGameStats(User.Id, User.Token, User.HostedGame, GameStats);
    {$IFDEF DEBUG}
    MStream := TMemoryStream.Create;
    try
      try
        MStream.WriteBuffer(GameStats, SizeOf(TGameStats));
        GetSystemTime(UTC);
        StatsId := FormatDateTime('yyyy-mm-dd hh:nn:ss', SystemTimeToDateTime(UTC)); { do not localize }
        TLogger.GetInstance.SendMessage(Format('DPlayAge2x1Stats (%s)', [StatsId])); { do not localize }
        MailSender.SendMail(Format('DPlayAge2x1Stats (%s) (%s, %d)', [StatsId, User.Name, User.Id]), { do not localize }
          MStream, 'age2x1.stats'); { do not localize }
      except
        //
      end;
    finally
      MStream.Free;
    end;
    {$ENDIF}
  end;
end;

procedure TMainForm.HandleIRCThreadException(AThread: TIdThread; AException: Exception);
begin
  AThread.OnException := nil;
  DisconnectUI;
  { Logout from server (send UPDATE if required) }
  LobbyClient.LogoutUser(User.Id, User.Token);
  while LobbyClient.HasActiveThreads do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  { Leave channel and quit IRC }
  if (IdIRC.State = csConnected) and IdIRC.Connected then
    try
      IdIRC.Quit('');
    except
      //
    end;
  AddChatMessage(Language.GetValue('forced_disconnect')); { do not localize }
end;

procedure TMainForm.HandleIRCThreadTerminate(Sender: TObject);
begin
  if Assigned(IdIRC.IRCThread) then
    IdIRC.IRCThread.OnException := nil;
end;

procedure TMainForm.PlayersTreeViewCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
  User: TLobbyUser;
  sText: String;
  sWidth, y, PingIdx: Integer;
const
  OFFSET = 5;
begin
  DefaultDraw := False;
  NodeRect := Node.DisplayRect(False);

  with (Sender as TTreeView) do
  begin
    if cdsSelected in State then
      Canvas.Brush.Color := Color;

    case Node.Level of
      0:  begin
        { draw caption }
        Canvas.TextOut(NodeRect.Left + OFFSET, NodeRect.Top, Node.Text);

        { calculate width of Node.Count }
        if (Node = FirstNode) then
          { Count = Sum of all Node.Count }
          sText := IntToStr(MemPlusNode.Count + FriendsNode.Count +
                       LookingNode.Count + WaitingNode.Count +
                       PlayingNode.Count + 1) // = me
        else
          sText := IntToStr(Node.Count);
        sWidth := Canvas.TextWidth(sText);
        { draw Node.Count }
        Canvas.TextOut(NodeRect.Right - OFFSET - sWidth, NodeRect.Top, sText);
        { draw line under node }
        Canvas.Pen.Color := LINE_COLOR;
        Canvas.MoveTo(NodeRect.Left  + OFFSET, NodeRect.Bottom - 1);
        Canvas.LineTo(NodeRect.Right - OFFSET, NodeRect.Bottom - 1);
      end;

      1:  begin
        User := Node.Data;
        if Assigned (User) then
        begin
          case User.Status of
            usLooking: Canvas.Font.Color := LOOKING_COLOR;
            usWaiting: Canvas.Font.Color := WAITING_COLOR;
            usPlaying: Canvas.Font.Color := PLAYING_COLOR;
          end;
          case User.Ping of
            0:                                      PingIdx := - 1;  { unknown }
            1..PING_PUREGREEN_MAX:                  PingIdx := PING_PUREGREEN_IDX;
            PING_PUREGREEN_MAX + 1..PING_GREEN_MAX: PingIdx := PING_GREEN_IDX;
            PING_GREEN_MAX + 1..PING_YELLOW_MAX:    PingIdx := PING_YELLOW_IDX;
            else PingIdx := -1;
          end;
          { draw player's name }
          if (IgnoreList.IndexOf(User.Name) <> -1) then
            Canvas.Font.Style := [fsStrikeOut]
          else
            Canvas.Font.Style := [];
          if cdsHot	in State then
            Canvas.Font.Color := LINE_COLOR;  // Canvas.Brush.Color := LINE_COLOR;
          if (Node.Parent = MemPlusNode) then
            Canvas.TextOut(NodeRect.Left + OFFSET + Indent, NodeRect.Top, '+' + Node.Text) { do not localize }
          else
            Canvas.TextOut(NodeRect.Left + OFFSET + Indent, NodeRect.Top, Node.Text);
          { draw ping if not unknown }
          if (PingIdx <> -1) and Assigned(Images) then
          begin
            y := ((NodeRect.Bottom - NodeRect.Top) - Images.Height) div 2;
            ImageList_Draw(Images.Handle, PingIdx, Canvas.Handle,
                NodeRect.Left, NodeRect.Top + y, ILD_NORMAL);
          end;
          { draw rating }
          if (User.Rating <> 0) then  // alebo if room.rated
          begin
            { calculate width of rating text }
            sText := Format ('(%d)', [User.Rating]); { do not localize }
            sWidth := Canvas.TextWidth (sText);
            Canvas.TextOut(NodeRect.Right - OFFSET - sWidth, NodeRect.Top, sText);
          end;
        end;
      end;
    end;  { end case }
  end;
end;

procedure TMainForm.PlayersTreeViewContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Node: TTreeNode;
  P: TPoint;
begin
  Handled := True;
  { hide player info form }
  HintForm.IsVisible := False;
  with (Sender as TTreeView) do
    if Assigned(PopupMenu) then
    begin
      GetCursorPos(P);
      Node := GetNodeAt(MousePos.X, MousePos.Y);
      if Assigned(Node) then
      begin
        Node.Selected := True;
        Node.Focused := True;
        if (Node.Level = 1) and (Node.Text <> User.Name) then
          PopupMenu.Popup(P.X, P.Y);
      end;
    end;
end;

procedure TMainForm.PlayersTreeViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Node: TTreeNode;
  User: TLobbyUser;
  P: TPoint;
  B: TBubble;
  sPlayTime: String;
begin
  Node := PlayersTreeView.GetNodeAt(X, Y);
  if Assigned(Node) and (Node.Level = 1) then
  begin
    GetCursorPos(P);
    with HintForm do
    begin
      User := Node.Data;
      if Assigned(User) then
      begin
        if (Self.Left + Self.Width > P.X - 5 + Width) then
          Left := P.X - 5
        else
          Left := P.X - Width;
        if (Self.Top + Self.Height > P.Y + 20 + Height) then
          Top := P.Y + 20
        else
          Top := P.Y - 5 - Height;
        PlayerName := User.Name;
        PlayerPing := User.Ping;
        PlayerRating := User.Rating;
        sPlayTime := '';
        if (User.RoomId >= 0) and (User.RoomId < Bubbles.Count) then
        begin
          B := Bubbles[User.RoomId];
          if Assigned(B.Data) then
            sPlayTime := ', ' + PlayTimeToString(THostedGame(B.Data).DateTime); { do not localize }
        end;
        case User.Status of
          usLooking: PlayerStatus := LOOKING_STATUS;
          usWaiting: PlayerStatus := Format(WAITING_STATUS, [User.RoomId + 1]);
          usPlaying: PlayerStatus := Format(PLAYING_STATUS, [User.RoomId + 1, sPlayTime]);
        end;
        IsPlayer := True;
        IsVisible := True;
      end else
        IsVisible := False;
    end;  { with }
  end else
    HintForm.IsVisible := False;
end;

procedure TMainForm.PlayersTreeViewMouseLeave(Sender: TObject);
begin
  if HintForm.IsVisible then
    HintForm.IsVisible := False;
end;

{ GameListView }

procedure TMainForm.VSplitterMoved(Sender: TObject);
begin
  PlayersTreeView.Refresh;
end;

procedure TMainForm.SortPanelClick(Sender: TObject);
begin
  if (SortType = High(TSortType)) then
    SortType := Low(TSortType)
  else
    SortType := TSortType(Ord(SortType) + 1);
  case SortType of
    stNameUp, stNameDown: SortPanel.Caption :=  Language.GetValueFmt('sort_button', ['+', '-', '-']); { do not localize }
    stRatingUp, stRatingDown: SortPanel.Caption := Language.GetValueFmt('sort_button', ['-', '+', '-']); { do not localize }
    stPingUp, stPingDown: SortPanel.Caption := Language.GetValueFmt('sort_button', ['-', '-', '+']); { do not localize }
  end;
  SortPlayersTreeView(Sender, SortType);
end;

procedure TMainForm.Ignore1Click(Sender: TObject);
var
  UserName: String;
  i: Integer;
begin
  if Assigned(PlayersTreeView.Selected) then
  begin
    UserName := PlayersTreeView.Selected.Text;
    i := IgnoreList.IndexOf(UserName);
    if (i = -1) then
      IgnoreList.Add(UserName)
    else
      IgnoreList.Delete(i);
    PlayersTreeView.Repaint;
  end;
end;

procedure TMainForm.PlayerPopupMenuPopup(Sender: TObject);
var
  UserName: String;
begin
  if Assigned(PlayersTreeView.Selected) and Assigned(PlayersTreeView.Selected.Data) then
  begin
    UserName := TLobbyUser(PlayersTreeView.Selected.Data).Name;
    if UserName = User.Name then
      Exit;
    if (IgnoreList.IndexOf(UserName) = -1) then
      PlayerPopupMenu.Items[3].Caption := Language.GetValue('ignore_add')
    else
      PlayerPopupMenu.Items[3].Caption := Language.GetValue('ignore_remove');

    if (FriendsList.IndexOf(UserName) = -1) then
      PlayerPopupMenu.Items[2].Caption := Language.GetValue('friend_add')
    else
      PlayerPopupMenu.Items[2].Caption := Language.GetValue('friend_remove');
  end;
end;

procedure TMainForm.SortPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SortPanel.BevelInner := bvLowered;
  SortPanel.BevelOuter := bvLowered;
end;

procedure TMainForm.SortPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SortPanel.BevelInner := bvRaised;
  SortPanel.BevelOuter := bvRaised;
end;

procedure TMainForm.SortPlayersTreeView(Sender: TObject; SortType: TSortType);
var
  SortProcPtr: PFNTVCOMPARE;
  Direction: Integer;
begin
  SortProcPtr := nil;
  Direction := 0;
  case SortType of
    stNameUp: SortProcPtr := nil;
    stnameDown:
      begin
        SortProcPtr := nil;
        Direction := 1;
      end;
    stRatingUp: SortProcPtr := @RatingSort;
    stRatingDown:
      begin
        SortProcPtr := @RatingSort;
        Direction := 1;
      end;
    stPingUp: SortProcPtr := @LatencySort;
    stPingDown:
      begin
        SortProcPtr := @LatencySort;
        Direction := 1;
      end;
  end;
  if Assigned(SortProcPtr) then
  begin
    if Assigned(MemPlusNode) then
      MemPlusNode.CustomSort(@SortProcPtr, Direction);
    if Assigned(FriendsNode) then
      FriendsNode.CustomSort(@SortProcPtr, Direction);
    if Assigned(LookingNode) then
      LookingNode.CustomSort(@SortProcPtr, Direction);
    if Assigned(WaitingNode) then
      WaitingNode.CustomSort(@SortProcPtr, Direction);
    if Assigned(PlayingNode) then
      PlayingNode.CustomSort(@SortProcPtr, Direction);
  end else
  begin
    if Assigned(MemPlusNode) then
      MemPlusNode.AlphaSort(False);
    if Assigned(FriendsNode) then
      FriendsNode.AlphaSort(False);
    if Assigned(LookingNode) then
      LookingNode.AlphaSort(False);
    if Assigned(WaitingNode) then
      WaitingNode.AlphaSort(False);
    if Assigned(PlayingNode) then
      PlayingNode.AlphaSort(False);
  end;
  { TODO }
  MemPlusNode.Expand(False);
  FriendsNode.Expand(False);
  LookingNode.Expand(False);
  WaitingNode.Expand(False);
  PlayingNode.Expand(False);
end;

procedure TMainForm.PlayersTreeViewHorizontalScroll(Sender: TObject);
begin
  PlayersTreeView.Refresh;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if (Tag = 1) then
  begin
    PostMessage(Handle, WM_AFTER_SHOW, 0, 0);
    Exit;
  end;
  SplashForm := TSplashForm.Create(Self);
  try
    if (SplashForm.ShowModal = mrCancel) then
      Close
    else
      PostMessage(Handle, WM_AFTER_SHOW, 0, 0);
  finally
    SplashForm.Free;
  end;
end;

procedure TMainForm.WMAfterShow(var Msg: TMessage);
begin
  if ShowTips then
  begin
    with TTipsForm.Create(Self) do
      try
        ShowModal;
      finally
        Free;
      end;
  end;
end;

procedure TMainForm.LobbyUsersAddUser(Sender: TObject; User: TLobbyUser);
var
  ParentNode: TTreeNode;
begin
  ParentNode := nil;
  case User.Status of
    usLooking: ParentNode := LookingNode;
    usWaiting: ParentNode := WaitingNode;
    usPlaying: ParentNode := PlayingNode;
  end;
//  if (User.Name = Self.User.Name) then
//    ParentNode := FirstNode;
  if (FriendsList.IndexOf(User.Name) <> -1) then
    ParentNode := FriendsNode;
  PlayersTreeView.Items.AddChildObject(ParentNode, User.Name, User);
  SortPlayersTreeView(Sender, SortType);
end;

procedure TMainForm.LobbyUsersRemoveUser(Sender: TObject; User: TLobbyUser);
var
  Node: TTreeNode;
begin
  Node := nil;
  case User.Status of
    usLooking: Node := LookingNode.getFirstChild;
    usWaiting: Node := WaitingNode.getFirstChild;
    usPlaying: Node := PlayingNode.getFirstChild;
  end;
//  if (User.Name = Self.User.Name) then
//    Node := FirstNode;
  while Assigned(Node) do
  begin
    if Assigned(Node.Data) and (Node.Data = User) then
    begin
      Node.Data := nil;
      Node.Delete;
      Break;
    end;
    Node := Node.getNextSibling;
  end;
  SortPlayersTreeView(Sender, SortType);
end;

procedure TMainForm.LobbyUsersUserStatusChanged(Sender: TObject; OldStatus, NewStatus: TUserStatus);
var
  Node, NewParent: TTreeNode;
begin
  Node := nil; NewParent := nil;
  if ((Sender as TLobbyUser).Name = User.Name) then
  begin
    PlayersTreeView.Repaint;
    Exit;
  end;
  if (FriendsList.IndexOf((Sender as TLobbyUser).Name) <> -1) then
  begin
    PlayersTreeView.Repaint;
    Exit;
  end;
  case OldStatus of
    usLooking: Node := LookingNode.getFirstChild;
    usWaiting: Node := WaitingNode.getFirstChild;
    usPlaying: Node := PlayingNode.getFirstChild;
  end;
  case NewStatus of
    usLooking: NewParent := LookingNode;
    usWaiting: NewParent := WaitingNode;
    usPlaying: NewParent := PlayingNode;
  end;
  while Assigned(Node) do
  begin
    if Assigned(Node.Data) and (Node.Data = Sender) then
    begin
      Node.MoveTo(NewParent, naAddChild);
      Break;
    end;
    Node := Node.getNextSibling;
  end;
  SortPlayersTreeView(Sender, SortType);
end;

procedure TMainForm.LobbyUsersClear(Sender: TObject);
begin
  HintForm.IsVisible := False;
  MemPlusNode.DeleteChildren;
  FriendsNode.DeleteChildren;
  LookingNode.DeleteChildren;
  WaitingNode.DeleteChildren;
  PlayingNode.DeleteChildren;
end;

procedure TMainForm.PlayersTreeViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  Node := (Sender as TTreeView).GetNodeAt(X, Y);
  if not Assigned(Node) then
  begin
    PlayersTreeView.Selected := nil;
    Exit;
  end;
  { Check if TreeNode is MemPlus, Friends, Looking, Waiting or Playing Node }
  if (Node.Level = 0) and (Node <> FirstNode) then
  begin
    if Node.Expanded then
      Node.Collapse(False)
    else
      Node.Expand(False);
    Exit;
  end;
  Node.Selected := True;
  Node.Focused := True;
end;

procedure TMainForm.PlayersTreeViewCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
  PlayersTreeView.Invalidate;
end;

function TMainForm.IsMainChannel(AChannel: TIdIRCChannel): Boolean;
begin
  Result := Assigned(AChannel) and (AChannel.Name = ServerSettings.IRCChannel);
end;

procedure TMainForm.SendMessage1Click(Sender: TObject);
begin
  if Assigned(PlayersTreeView.Selected) then
  begin
    with TMessageForm.Create(nil) do
    begin
      SetForm(PlayersTreeView.Selected.Text);
      Show;
    end;
  end;
end;

procedure TMainForm.AddtoFriends1Click(Sender: TObject);
var
  UserName: String;
  U: TLobbyUser;
  ParentNode: TTreeNode;
  i: Integer;
begin
  ParentNode := nil;
  if Assigned(PlayersTreeView.Selected) then
  begin
    UserName := PlayersTreeView.Selected.Text;
    i := FriendsList.IndexOf(UserName);
    if (i = -1) then
    begin
      FriendsList.Add(UserName);
      PlayersTreeView.Selected.MoveTo(FriendsNode, naAddChild);
    end else
    begin
      U := PlayersTreeView.Selected.Data;
      if Assigned(U) then
      begin
        case U.Status of
          usLooking: ParentNode := LookingNode;
          usWaiting: ParentNode := WaitingNode;
          usPlaying: ParentNode := PlayingNode;
        end;
        FriendsList.Delete(i);
        PlayersTreeView.Selected.MoveTo(ParentNode, naAddChild);
        SortPlayersTreeView(Sender, SortType);
      end;
    end;
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SendMessage(const Receiver, Message: String);
begin
  if (IdIRC.State = csConnected) and IdIRC.Connected then
  begin
    try
      if (Receiver <> ServerSettings.IRCChannel) then
        IdIRC.Say(AddNickNameSuffix(Receiver), Message)
      else
        IdIRC.Say(ServerSettings.IRCChannel, Message);
    except
      //
    end;
  end;
end;

procedure TMainForm.SendSystemMessage(SystemMessageType: TSystemMessageType;
  const Args: array of const; const Receiver: String = '');
var
  Message: String;
begin
  case SystemMessageType of
    smUpdate: Message := SYS_UPDATE;
    smJoin: Message := SYS_JOIN + IntToStr(Args[0].VInteger);
    smLeave: Message := SYS_LEAVE + IntToStr(Args[0].VInteger);
    smRating: Message := SYS_RATING + IntToStr(Args[0].VInteger);
    smFont: Message := SYS_FONT + Args[0].VPChar + ';' + IntToStr(Args[1].VInteger) { do not localize }
       + ';' + IntToStr(Args[2].VInteger) + ';' + IntToStr(Args[3].VInteger); { do not localize }
  end;
  if (Receiver <> '') then
    SendMessage(Receiver, Message)
  else
    SendMessage(ServerSettings.IRCChannel, Message);
end;

procedure TMainForm.ChatEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Msg: String;
begin
  if (Key = VK_RETURN) then
  begin
    Msg := Trim(ChatEdit.Text);
    if (Length(Msg) > 0) and (IdIRC.State = csConnected) {and IdIRC.Connected} then
    begin
      try
        IdIRC.Say(ServerSettings.IRCChannel, Msg);
        AddChatMessage(ChatEdit.Text, mUser, User.Name);
        ChatEdit.Clear;
      except
        ChatEdit.Clear;
      end;
    end;
  end;
end;

procedure TMainForm.SendImageClick(Sender: TObject);
var
  Msg: String;
begin
  // if not disabled
  Msg := Trim(ChatEdit.Text);
  if (Length(Msg) > 0) and (IdIRC.State = csConnected) {and IdIRC.Connected} then
  begin
    try
      IdIRC.Say(ServerSettings.IRCChannel, Msg);
      AddChatMessage(ChatEdit.Text, mUser, User.Name);
      ChatEdit.Clear;
    except
      ChatEdit.Clear;
    end;
  end;
end;

procedure TMainForm.FontImageClick(Sender: TObject);
begin
  with TMessageOptions.Create(Self) do
  begin
    FontNameBox.FontName := User.Font.Name;
    if (FontNameBox.ItemIndex = -1) then
      FontNameBox.ItemIndex := 0;
    FontStyleBox.ItemIndex := Ord(User.Font.Style);
    FontColorBox.ColorValue := User.Font.Color;
    FontSizeBox.ItemIndex := User.Font.Size - 8;
    if not FontSizeBox.ItemIndex in [0..4] then
      FontSizeBox.ItemIndex := 0;
    if (ShowModal = mrOK) then
    begin
      User.Font.Name := FontNameBox.FontName;
      User.Font.Style := TFontStyle(FontStyleBox.ItemIndex);
      User.Font.Size := 8 + FontSizeBox.ItemIndex;
      User.Font.Color := FontColorBox.ColorValue;

      if (Screen.Fonts.IndexOf(User.Font.Name) <> -1) then
        ChatEdit.Font.Name := User.Font.Name;
      ChatEdit.Font.Style := [User.Font.Style] - [fsUnderline, fsStrikeOut];
      if User.Font.Size in [8..12] then
        ChatEdit.Font.Size := User.Font.Size;
      ChatEdit.Font.Color := User.Font.Color;

      SendSystemMessage(smFont, [TIdEncoderMIME.EncodeString(User.Font.Name),
        Ord(User.Font.Style), User.Font.Size, User.Font.Color]);
      ChatEdit.SetFocus;
    end;
  end;
end;

procedure TMainForm.VSplitterCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  if (NewSize < 150) or (ClientWidth - NewSize - VSplitter.Width < MainPanel.Constraints.MinWidth) then
    Accept := False;
end;

procedure TMainForm.GamesListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  ItemRect: TRect;
begin
  DefaultDraw := False;
  ItemRect := Item.DisplayRect(drIcon);
  if Assigned(Item.Data) then
    TBubble(Item.Data).Draw((Sender as TCustomListView).Canvas, ItemRect.Left, ItemRect.Top);
end;

procedure TMainForm.HostGame(ARoomId: Integer);
var
  lpGUID: TGUID;
  Pwd: String;
  i: Integer;
  Ptr: Pointer;
begin
  if User.IsInGame then
  begin
    InfoDlg.Tag := User.RoomId + 1;
    InfoDlg.InfoDlgType := idtAlreadyInGame;
    InfoDlg.Show;
    Exit;
  end;
  if not User.IsStartingSession and IdIRC.Connected then
  begin
    with TGameParamsForm.Create(Self) do
    try
      SetLanguage(Language);
      { Fill DPApplicationsComboBox with DirectPlay applications }
      for i := 0 to DPlay.DPApplications.Count - 1 do
        DPApplicationsComboBox.AddItem(DPlay.DPApplications[i], DPlay.DPApplications.Objects[i]);
      { Set to last used values }
      if (DPApplicationIndex = -1) and (DPlay.DPApplications.Count > 0) then
        DPApplicationIndex := 0;
      DPApplicationsComboBox.ItemIndex := DPApplicationIndex;
      TitleEdit.Text := GameTitle;
      if (TitleEdit.Text = '') then
        TitleEdit.Text := Format('%s''s Game', [User.Name]);
      DescRichEdit.Text := GameDescription;
      PwdEdit.Text := GamePassword;
      UpDown.Position := GameMaxPlayers;
      if (ShowModal = mrOK) then
      begin
        { Set values as last used }
        with DPApplicationsComboBox do
        begin
          if (ItemIndex <> -1) then
            lpGUID := PGUID(Items.Objects[ItemIndex])^
          else
            lpGUID := GUID_NULL;
          DPApplicationIndex := ItemIndex;
        end;
        GameTitle := TitleEdit.Text;
        GameDescription := DescRichEdit.Text;
        GamePassword := PwdEdit.Text;
        GameMaxPlayers := UpDown.Position;
        if IsEqualGUID(lpGUID, GUID_NULL) then
        begin
          MessageDlg(Language.GetValue('no_app_selected'), mtWarning, [mbOK], 0); { do not localize }
          Exit;
        end;
        Pwd := GamePassword;
        if ServerSettings.ClientJoins and (Pwd = '') then
          Pwd := SESSION_PWD;
        AgePresetData := PresetData;
        with User.HostedGame do
        begin
          Id := 0;
          IP := '';
          DateTime := Now;
          if (DPApplicationIndex <> -1) then
            Game := DPApplicationsComboBox.Items[DPApplicationIndex];
          Guid := lpGUID;
          Title := GameTitle;
          Description := GameDescription;
          Password := (GamePassword <> '');
          MaxPlayers := GameMaxPlayers;
          RoomId := ARoomId;
          HostPing := User.Ping;
          PlayerList.Clear;
          PlayerList.AddObject(User.Name, Pointer(User.Rating));
        end;
        User.IsStartingSession := True;
        if IsEqualGuid(AGE2X1_GUID, lpGUID) then
        begin
          if UseWidescreenPatch1.Checked then
            WSPatchUsed := SetAOCRegistry(WidescreenPatch);
          Ptr := @AgePresetData;
        end else
          Ptr := nil;
        if not DPlay.HostSession(lpGUID, 'S', User.Name, Pwd, GameMaxPlayers, Ptr) then { do not localize }
        begin
          User.IsStartingSession := False;
          if WSPatchUsed then
            WSPatchUsed := not SetAOCRegistry(OriginalPath);
          InfoDlg.InfoDlgType := idtFailedLaunching;
          InfoDlg.Show;
          Exit;
        end;
        InfoDlg.InfoDlgType := idtLaunchingGame;
        InfoDlg.Show;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TMainForm.JoinGame(G: THostedGame);
var
  Pwd: String;
begin
  if (G.Status = gsInProgress) or G.IsFull then
    Exit;
  if User.IsInGame then
  begin
    InfoDlg.Tag := User.RoomId + 1;
    InfoDlg.InfoDlgType := idtAlreadyInGame;
    InfoDlg.Show;
    Exit;
  end;
  if not User.IsStartingSession and IdIRC.Connected then
  begin
    { pripoj sa }
    Pwd := '';
    if G.Password then
    begin
      with TPasswordForm.Create(Self) do
        try
          case ShowModal of
            mrOK: Pwd := PwdEdit.Text;
            mrCancel: Exit;
          end;
        finally
          Free;
        end;
    end;
    if ServerSettings.ClientJoins and (Pwd = '') then
      Pwd := SESSION_PWD;
    User.HostedGame.Assign(G);
    User.IsStartingSession := True;
    if UseWidescreenPatch1.Checked and IsEqualGuid(AGE2X1_GUID, G.Guid) then
      WSPatchUsed := SetAOCRegistry(WidescreenPatch);
    if not DPlay.JoinSession(G.Guid, G.SessionGuid, G.IP, User.Name, Pwd) then
    begin
      User.IsStartingSession := False;
      if WSPatchUsed then
        WSPatchUsed := not SetAOCRegistry(OriginalPath);
      InfoDlg.InfoDlgType := idtFailedLaunching;
      InfoDlg.Show;
      Exit;
    end;
    InfoDlg.InfoDlgType := idtLaunchingGame;
    InfoDlg.Show;
  end;
end;

procedure TMainForm.GamesListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  Bubble: TBubble;
  ItemRect: TRect;
  P, CP: TPoint;
begin
  if not Selected then
    Exit;
  GetCursorPos(CP);
  P := GamesListView.ScreenToClient(CP);
  if Assigned(Item.Data) then
  begin
    Bubble := Item.Data;
    ItemRect := Item.DisplayRect(drIcon);
    { bolo trafene info? }
    if Bubble.InfoAtPos(P.X - ItemRect.Left, P.Y - ItemRect.Top) then
    begin
      Bubble.InfoState := isDown;
      InfoForm.Left := CP.X;
      InfoForm.Top := CP.Y;
      InfoForm.SetRoom(Bubble.Data, LobbyUsers, User);
      InfoForm.Show;
      Exit;
    end;
    { bola trafena bublina? }
    if Bubble.BubbleAtPos(P.X - ItemRect.Left, P.Y - ItemRect.Top) then
      Bubble.BubbleState := bsDown
  end;
end;

procedure TMainForm.GamesListViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ListItem, Item: TListItem;
  ItemRect: TRect;
  Bubble: TBubble;
  G: THostedGame;
begin
  ListItem := GamesListView.Selected;
  Item := GamesListView.GetItemAt(X, Y);
  if Assigned(ListItem) and Assigned(ListItem.Data) then
  begin
    Bubble := ListItem.Data;
    if Assigned(Item) and (Item = ListItem) then
    begin
     { I am still on the same item I came from? }
      Bubble.BubbleState := bsUp;//bsHover;
      Bubble.InfoState := isUp;//isHover;
    end else
    begin
      Bubble.BubbleState := bsUp;
      Bubble.InfoState := isUp;
    end;

    ItemRect := ListItem.DisplayRect(drIcon);
    if Bubble.BubbleAtPos(MousePos.X - ItemRect.Left, MousePos.Y - ItemRect.Top) then
    begin
      G := Bubble.Data;
      if Assigned(G) then
        { existuje hra }
        JoinGame(G)
      else
        { neexistuje hra }
        HostGame(Bubble.Id);
    end;
    GamesListView.Selected := nil;
    { ak je selektnuty, nejde uz znova preklikavat }
  end;
end;

procedure TMainForm.GamesListViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ListItem, Item: TListItem;
  Bubble: TBubble;
  ItemRect: TRect;
  i: Integer;
  Can: Boolean;
  P: TPoint;
begin
  if InfoForm.Visible then
  begin
    GetCursorPos(P);
    if (P.X < InfoForm.Left - 15) or (P.X > InfoForm.Left + InfoForm.Width + 15)
      or (P.Y < InfoForm.Top - 15) or (P.Y > InfoForm.Top + InfoForm.Height + 15) then
      InfoForm.Close;
  end;

  ListItem := GamesListView.GetItemAt(X, Y);
  if Assigned(ListItem) and Assigned(ListItem.Data) then
  begin
    Bubble := ListItem.Data;
    ItemRect := ListItem.DisplayRect(drIcon);
    Can := not Assigned(GamesListView.Selected) or (Assigned(GamesListView.Selected) and (GamesListView.Selected = ListItem));
    { hoverujem len selektnuty, alebo kazdy, ak nie je selektnuty ziadny }
    { Title }
    if Bubble.TitleAtPos(X - ItemRect.Left, Y - ItemRect.Top) then
    begin
      GetCursorPos(P);
      HintForm.Left := P.X - 5;
      HintForm.Top  := P.Y + 10;
      HintForm.PlayerName := THostedGame(Bubble.Data).Title;
      HintForm.IsPlayer := False;
      HintForm.IsVisible := True;
    end else
      HintForm.IsVisible := False;
    { Info }
    if Bubble.InfoAtPos(X - ItemRect.Left, Y - ItemRect.Top) and Can then
    begin
      if (Bubble.InfoState = isUp) then
      begin
        Bubble.InfoState := isHover;
        GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
      end;
    end else
    begin
      if (Bubble.InfoState = isHover) then
      begin
        Bubble.InfoState := isUp;
        GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
      end;
    end;
    { Bubble }
    if Bubble.BubbleAtPos(X - ItemRect.Left, Y - ItemRect.Top) and Can then
    begin
      if (Bubble.BubbleState = bsUp) then
      begin
        Bubble.BubbleState := bsHover;
        GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
      end;
    end else
    begin
      if (Bubble.BubbleState = bsHover) then
      begin
        Bubble.BubbleState := bsUp;
        GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
      end;
    end;
  end;
  { clear other items }
  for i := 0 to GamesListView.Items.Count - 1 do
  begin
    Item := GamesListView.Items[i];
    if (Item <> ListItem) and Assigned(Item.Data) then
    begin
      Bubble := Item.Data;
      if (Bubble.BubbleState = bsHover) or (Bubble.InfoState = isHover) then
      begin
        Bubble.BubbleState := bsUp;
        Bubble.InfoState := isUp;
        GamesListView.UpdateItems(Item.Index, Item.Index);
      end;
    end;
  end;
end;

procedure TMainForm.GamesListViewMouseLeave(Sender: TObject);
begin
  if HintForm.IsVisible then
    HintForm.IsVisible := False;
{ TODO }
//  if InfoForm.Visible then
//      InfoForm.Close;
end;

procedure TMainForm.GamesTimerTimer(Sender: TObject);
var
  ListItem: TListItem;
  G: THostedGame;
  Found: Boolean;
  i: Integer;
begin
  Found := False;
  for i := 0 to GamesListView.Items.Count - 1 do
  begin
    ListItem := GamesListView.Items[i];
    if Assigned(ListItem.Data) and Assigned(TBubble(ListItem.Data).Data) then
    begin
      G := TBubble(ListItem.Data).Data;
      if (G.Status = gsJoinInProgress) then
      begin
        Found := True;
        if (MinutesBetween(Now, G.DateTime) > JOIN_MINS) then
        begin
          G.Status := gsInProgress;
          GamesListView.UpdateItems(ListItem.Index, ListItem.Index);
        end;
      end;
    end;
  end;
  GamesTimer.Enabled := Found;
end;

procedure TMainForm.GamesListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ListItem: TListItem;
  Bubble: TBubble;
begin
  if mbRight in [Button] then
  begin
    ListItem := GamesListView.Selected;
    if Assigned(ListItem) and Assigned(ListItem.Data) then
    begin
      Bubble := ListItem.Data;
      Bubble.BubbleState := bsUp;
      GamesListView.Selected := nil;
    end;
  end;
  MousePos := Point(X, Y);
end;

procedure TMainForm.AboutRoom1Click(Sender: TObject);
begin
  with TAboutForm.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainForm.GamesToolBtnClick(Sender: TObject);
begin
  JvPageControl.ActivePage := GamesTab;
end;

procedure TMainForm.TeamizerToolBtnClick(Sender: TObject);
begin
  JvPageControl.ActivePage := TeamizerTab;
end;

procedure TMainForm.TeamizeBtnClick(Sender: TObject);
var
  Players: TStringList;
  i: Integer;
begin
  Players := TStringList.Create;
  try
    for i := 0 to Length(PEdit) - 1 do
      if (PEdit[i].Text <> '') and (REdit[i].Text = '') then
        Players.Add(PEdit[i].Text);
    if (Players.Count > 0) then
    begin
      TeamizeBtn.Enabled := False;
      LobbyClient.GetRatings(User.Id, User.Token, Players)
    end else
      DoTeamize;
  finally
    Players.Free;
  end;
end;

procedure TMainForm.Teamize1Click(Sender: TObject);
var
  ListItem: TListItem;
  Bubble: TBubble;
  G: THostedGame;
  i: Integer;
begin
  if (GamesListView.Tag = 0) then
    Exit;
  ListItem := Pointer(GamesListView.Tag);
  if not Assigned(ListItem) or not Assigned(ListItem.Data) then
    Exit;
  Bubble := ListItem.Data;
  if not Assigned(Bubble) or not Assigned(Bubble.Data) then
    Exit;
  G := Bubble.Data;
  for i := 0 to Length(PEdit) - 1 do
  begin
    REdit[i].Text := '';
    if (G.PlayerList.Count > i) then
      PEdit[i].Text := G.PlayerList[i]
    else
      PEdit[i].Text := '';
  end;
  JvPageControl.ActivePage := TeamizerTab;
end;

procedure TMainForm.GamesListViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  ListItem: TListItem;
  Bubble: TBubble;
begin
  GamesListView.Tag := 0;
  ListItem := GamesListView.GetItemAt(MousePos.X, MousePos.Y);
  if not Assigned(ListItem) then
  begin
    Handled := True;
    Exit;
  end;
  Bubble := ListItem.Data;
  if not Assigned(Bubble) or not Assigned(Bubble.Data) then
  begin
    Handled := True;
    Exit;
  end;
  GamesListView.Tag := Integer(Pointer(ListItem));
end;

procedure TMainForm.ChatOptions1Click(Sender: TObject);
begin
  FontImageClick(Sender);
end;

procedure TMainForm.ViewToolbar1Click(Sender: TObject);
begin
  ViewToolbar1.Checked := not ViewToolbar1.Checked;
  ToolBar.Visible := ViewToolbar1.Checked;
end;

procedure TMainForm.SortUsersbyLatency1Click(Sender: TObject);
begin
  if Sender = SortUsersbyLatency1 then
    SortType := Pred(stPingUp)
  else if Sender = SortUsersbyName1 then
    SortType := High(TSortType)
  else if Sender = SortUsersbyRating1 then
    SortType := Pred(stRatingUp);
  SortPanelClick(Sender);
end;

procedure TMainForm.UnignoreAll1Click(Sender: TObject);
begin
  if (IgnoreList.Count > 0) then
  begin
    IgnoreList.Clear;
    PlayersTreeView.Refresh;
  end;
end;

procedure TMainForm.QuickHostBrnClick(Sender: TObject);
var
  Bubble: TBubble;
  i: Integer;
begin
  for i := 0 to GamesListView.Items.Count - 1 do
  begin
    Bubble := GamesListView.Items[i].Data;
    if Assigned(Bubble) and not Assigned(Bubble.Data) then
    begin
      HostGame(Bubble.Id);
      Break;
    end;
  end;
end;

procedure TMainForm.QuickJoinBtnClick(Sender: TObject);
var
  Bubble: TBubble;
  G: THostedGame;
  i: Integer;
begin
  for i := 0 to GamesListView.Items.Count - 1 do
  begin
    Bubble := GamesListView.Items[i].Data;
    if Assigned(Bubble) and Assigned(Bubble.Data) then
    begin
      G := Bubble.Data;
      if (G.Status = gsJoinInProgress) then
      begin
        JoinGame(G);
        Break;
      end;
    end;
  end;
end;
{$IFDEF AGE4GREEKS}
procedure TMainForm.TeamSpeakClick(Sender: TObject);
var
  ResStream: TResourceStream;
  TSServer: String;
begin
  ResStream := TResourceStream.Create(hInstance, 'TS_SERVER', RT_RCDATA); { do not localize }
  try
    SetString(TSServer, nil, ResStream.Size);
    ResStream.Read(Pointer(TSServer)^, ResStream.Size);
    ShellExecute(0, 'open', PAnsiChar(Format(TSServer, [User.Name])), { do not localize }
      nil, nil, SW_SHOWNORMAL);
  finally
    ResStream.Free;
  end;
end;
{$ENDIF}
procedure TMainForm.BrowserToolBtnClick(Sender: TObject);
begin
  if (WebBrowser.Tag = 0) then
  begin
    WebBrowser.Navigate(ServerSettings.LobbyUrl);
    WebBrowser.Tag := 1;
  end;
  JvPageControl.ActivePage := BrowserTab;
end;

procedure TMainForm.EnableAllTips1Click(Sender: TObject);
var
  IniFile: TIniFile;
const
  GENERAL_S = 'General'; { do not localize }
begin
  if not ShowTips then
  begin
    IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
    try
      IniFile.WriteBool(GENERAL_S, 'ShowTips', True); { do not localize }
    finally
      IniFile.Free;
    end;
  end;
end;

procedure TMainForm.ClientOptions1Click(Sender: TObject);
var
  IniFile: TIniFile;
const
  GENERAL_S = 'General'; { do not localize }
begin
  with TClientOptions.Create(Self) do
  begin
    try
      WSPatchEdit.Text := WideScreenPatch;
      if (ShowModal = mrOK) then
      begin
        IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
        try
          WideScreenPatch := WSPatchEdit.Text;
          IniFile.WriteString(GENERAL_S, 'WSPatch', WideScreenPatch); { do not localize }
        finally
          IniFile.Free;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TMainForm.UseWidescreenPatch1Click(Sender: TObject);
begin
  if UseWidescreenPatch1.Checked then
  begin
    UseWidescreenPatch1.Checked := False;
    Exit;
  end;
  if (WidescreenPatch = '') then
  begin
    if (MessageDlg('Path to widescreen patch is not set, would you like to set it now?', mtWarning, [mbYes, mbNo], 0) = mrYes) then
      ClientOptions1Click(Sender);
  end;
  if (WidescreenPatch <> '') then
    UseWideScreenPatch1.Checked := True;
end;

procedure TMainForm.Profile1Click(Sender: TObject);
var
  UserName, Url: String;
  i: Integer;
begin
  if Assigned(PlayersTreeView.Selected) then
  begin
    UserName := PlayersTreeView.Selected.Text;
    { TODO, nedratovat to na player.php }
    i := LastDelimiter('/', ServerSettings.LobbyUrl);
    if (i > 0) then
    begin
      Url := Copy(ServerSettings.LobbyUrl, 1, i);
      Url := Format('%splayer.php?id=%s', [Url, UserName]);
    end else
      Url := ServerSettings.LobbyUrl;
    WebBrowser.Navigate(Url);
    WebBrowser.Tag := 1;
    BrowserToolBtn.Down := True;
    BrowserToolBtn.OnClick(BrowserToolBtn);
  end;
end;

end.

