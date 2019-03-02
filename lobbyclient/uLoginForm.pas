unit uLoginForm;

interface

uses
  StdCtrls, Controls, Classes, Forms, SysUtils, uLobbyClient, Language;

type
  TLoginForm = class(TForm)
    WaitLabel: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Button: TButton;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure RegisterButtonClick(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label4Click(Sender: TObject);
  private
    FIsRegisterForm: Boolean;
    LobbyClient: TLobbyClient;
    Language: TLanguage;
    procedure ChangeToRegisterForm;
    procedure ChangeToLoginForm;
    procedure LobbyClientRegisterUser(const Username, Email: String;
      ResponseCode: Integer; const ResponseText, ServerVersion: String);
    procedure LobbyClientLoginUser(const Username, Password: String; UserId: Integer;
      const Token: String; Rating: Integer; const ServerVersion: String; const ServerSettings: TServerSettings);
    procedure LobbyClientRequestException(RequestType: TRequestType; Exception: Exception);
  public
    class function Execute: Boolean;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, Dialogs, Graphics, Windows, VistaAltFixUnit{$IFDEF HAMACHI}, uHamachiSettingsForm{$ENDIF},
  ShellApi;

resourcestring
  c_no_language = 'Unable to load language file.'; { do not localize }

class function TLoginForm.Execute: Boolean;
begin
  with TLoginForm.Create(nil) do
    try
      Result := (ShowModal = mrOK);
    finally
      Free;
    end;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
  Username, Password, LangFile: String;
const
  GENERAL_S = 'General'; { do not localize }
  IRC_S = 'IRC'; { do not localize }
begin
  TVistaAltFix.Create(Self);
  LobbyClient := TLobbyClient.Create;
  LobbyClient.OnRegisterUser := LobbyClientRegisterUser;
  LobbyClient.OnLoginUser := LobbyClientLoginUser;
  LobbyClient.OnRequestException := LobbyClientRequestException;
  FIsRegisterForm := False;
  Username := '';
  Password := '';
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
  try
    Username := IniFile.ReadString(GENERAL_S, 'Username', ''); { do not localize }
    Password := IniFile.ReadString(GENERAL_S, 'Password', ''); { do not localize }
    LobbyClient.LobbyServerUrl := IniFile.ReadString(GENERAL_S, 'LobbyServer', ''); { do not localize }
    LangFile := IniFile.ReadString(GENERAL_S, 'Language', 'english.lng'); { do not localize }
  finally
    IniFile.Free;
  end;

  Language := TLanguage.Create;
  try
    Language.LoadFromFile(LangFile);
  except
    MessageDlg(c_no_language, mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  FIsRegisterForm := (Username = '');
  if not FIsRegisterForm then
  begin
    ChangeToLoginForm;
    Edit1.Text := Username;
    Edit2.Text := Password;
  end else
    ChangeToRegisterForm;
end;

procedure TLoginForm.FormDestroy(Sender: TObject);
begin
  while LobbyClient.HasActiveThreads do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  LobbyClient.Free;
  Language.Free;
end;

procedure TLoginForm.RegisterButtonClick(Sender: TObject);
{$IFDEF HAMACHI}
const
  HAMACHI_S = 'Hamachi'; { do not localize }
var
  IniFile: TIniFile;
{$ENDIF}
begin
  if (Edit1.Text = '') or (Edit2.Text = '') then
  begin
    MessageDlg(Language.GetValue('no_username_or_password'), mtError, [mbOK], 0); { do not localize }
    Edit1.SetFocus;
    Exit;
  end;
  {$IFDEF HAMACHI}
  with THamachiSettingsForm.Create(Self) do
    try
      if (ShowModal = mrOK) then
      begin
        IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
        try
          try
            IniFile.WriteString(HAMACHI_S, 'Path', PathEdit.Text); { do not localize }
          except
            //
          end;
        finally
          IniFile.Free;
        end;
        LobbyClient.RegisterUser(Edit1.Text, Edit2.Text, IPEdit.Text);
        Button.Enabled := False;
        WaitLabel.Visible := True;
      end;
    finally
      Free;
    end;
  {$ELSE}
  LobbyClient.RegisterUser(Edit1.Text, Edit2.Text);
  Button.Enabled := False;
  WaitLabel.Visible := True;
  {$ENDIF}
end;

procedure TLoginForm.LoginButtonClick(Sender: TObject);
begin
  if (Edit1.Text = '') or (Edit2.Text = '') then
  begin
    MessageDlg(Language.GetValue('no_username_or_password'), mtError, [mbOK], 0); { do not localize }
    Edit1.SetFocus;
    Exit;
  end;
  LobbyClient.LoginUser(Edit1.Text, Edit2.Text);
  Button.Enabled := False;
  WaitLabel.Visible := True;
end;

procedure TLoginForm.LobbyClientRegisterUser(const Username, Email: String;
  ResponseCode: Integer; const ResponseText, ServerVersion: String);
var
  MsgDlgType: TMsgDlgType;
begin
  Button.Enabled := True;
  WaitLabel.Visible := False;
  if (ResponseCode = 0) and (ServerVersion <> LobbyClient.Version) then
  begin
    if (MessageDlg(Language.GetValue('lobbyserver_updated'), mtWarning, [mbOK, mbCancel], 0) = mrOK) then { do not localize }
      ShellExecute(0, 'open', PAnsiChar(ResponseText), nil, nil, SW_SHOWNORMAL); { do not localize }
    Exit;
  end;
  if (ResponseCode = 0) then
    MsgDlgType := mtWarning
  else
    MsgDlgType := mtInformation;
  if (MessageDlg(ResponseText, MsgDlgType, [mbOK], 0) = mrOK) then
  begin
    if (ResponseCode <> 0) then
      ChangeToLoginForm;
  end;
end;

procedure TLoginForm.LobbyClientLoginUser(const Username, Password: String; UserId: Integer;
  const Token: String; Rating: Integer; const ServerVersion: String; const ServerSettings: TServerSettings);
var
  IniFile: TIniFile;
const
  GENERAL_S = 'General'; { do not localize }
  IRC_S = 'IRC'; { do not localize }
begin
  Button.Enabled := True;
  WaitLabel.Visible := False;
  if (UserId = 0) and (ServerVersion <> LobbyClient.Version) then
  begin
    if (MessageDlg(Language.GetValue('lobbyserver_updated'), mtWarning, [mbOK, mbCancel], 0) = mrOK) then { do not localize }
      ShellExecute(0, 'open', PAnsiChar(Token), nil, nil, SW_SHOWNORMAL); { do not localize }
    Exit;
  end;
  if (UserId = 0) then
  begin
    MessageDlg(Token, mtError, [mbOK], 0);
    Exit;
  end;
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
  try
    try
      with IniFile, ServerSettings do
      begin
        WriteString(GENERAL_S, 'Username', Username); { do not localize }
        WriteString(GENERAL_S, 'Password', Password); { do not localize }
        WriteInteger(GENERAL_S, 'Id', UserId); { do not localize }
        WriteString(GENERAL_S, 'Token', Token); { do not localize }
        WriteInteger(GENERAL_S, 'R', Rating); { do not localize }
        WriteString(IRC_S, 'Server', IRCServer); { do not localize }
        WriteInteger(IRC_S, 'Port', IRCPort); { do not localize }
        WriteString(IRC_S, 'Channel', IRCChannel); { do not localize }
        WriteBool(GENERAL_S, 'ClientJoins', ClientJoins); { do not localize }
        WriteString(GENERAL_S, 'WMessage', WelcomeMessage); { do not localize }
        WriteString(GENERAL_S, 'LobbyUrl', LobbyUrl); { do not localize }
      end;
    except
      // silently discard exceptions
    end;
  finally
    IniFile.Free;
  end;
  ModalResult := mrOK;
end;

procedure TLoginForm.ChangeToRegisterForm;
begin
  FIsRegisterForm := True;
  Edit1.Text := '';
  Edit2.Text := '';
  Caption := Language.GetValue('register_user'); { do not localize }
  Label1.Caption := Language.GetValue('username') + ':'; { do not localize }
  Label2.Caption := Language.GetValue('email') + ':'; { do not localize }
  Edit2.PasswordChar := #0; { do not localize }
  Button.Caption := Language.GetValue('register'); { do not localize }
  Button.OnClick := RegisterButtonClick;
  with Label3 do
  begin
    Font.Color := clWindowText;
    Font.Style := [];
    Cursor := crDefault;
    Caption :=  StringReplace(Language.GetValue('register_note'), '\n', #13#10, [rfReplaceAll]); { do not localize }
  end;
  Label4.Visible := True;
end;

procedure TLoginForm.ChangeToLoginForm;
begin
  FIsRegisterForm := False;
  Caption := Language.GetValue('login_user'); { do not localize }
  Label1.Caption := Language.GetValue('username') + ':'; { do not localize }
  Label2.Caption := Language.GetValue('password') + ':'; { do not localize }
  Edit2.Text := '';
  Edit2.PasswordChar := '*'; { do not localize }
  Button.Caption := Language.GetValue('login'); { do not localize }
  Button.OnClick := LoginButtonClick;
  with Label3 do
  begin
    Font.Color := clBlue;
    Font.Style := [fsUnderline];
    Cursor := crHandPoint;
    Caption := Language.GetValue('create_account'); { do not localize }
  end;
  Label4.Visible := False;
end;

procedure TLoginForm.LobbyClientRequestException(RequestType: TRequestType; Exception: Exception);
begin
  case RequestType of
    rtRegisterUser, rtLoginUser:
      begin
        MessageDlg(Exception.Message, mtError, [mbOK], 0);
        Button.Enabled := True;
        WaitLabel.Visible := False;
      end;
  end;
end;

procedure TLoginForm.Label3Click(Sender: TObject);
begin
  if not FIsRegisterForm then
    ChangeToRegisterForm;
end;

procedure TLoginForm.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    Button.OnClick(Sender)
  else if (Key = VK_ESCAPE) then
    Close;
end;

procedure TLoginForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Edit2.Text <> '') then
    Button.OnClick(Sender)
  else if (Key = VK_ESCAPE) then
    Close;
end;

procedure TLoginForm.Label4Click(Sender: TObject);
begin
  ChangeToLoginForm;
end;

end.
