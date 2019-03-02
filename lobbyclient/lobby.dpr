program lobby;

{$IFDEF AGE4GREEKS}
  {$IFDEF DEBUG}
    {$R 'age4greeksdebug.res' 'age4greeksdebug.rc'}
  {$ELSE}
    {$R 'age4greeks.res' 'age4greeks.rc'}
  {$ENDIF}
{$ENDIF}

uses
  Forms,
  Windows,
  Dialogs,
  uMainForm in 'uMainForm.pas' {MainForm},
  uInfoForm in 'uInfoForm.pas' {InfoForm},
  uHintForm in 'uHintForm.pas' {HintForm},
  uSplashForm in 'uSplashForm.pas' {SplashForm},
  uConsts in 'uConsts.pas',
  uGameParamsForm in 'uGameParamsForm.pas' {GameParamsForm},
  uPasswordForm in 'uPasswordForm.pas' {PasswordForm},
  Bubbles in 'Bubbles.pas',
  uLoginForm in 'uLoginForm.pas' {LoginForm},
  uAppDataModule in 'uAppDataModule.pas' {AppDataModule: TDataModule},
  uTipsForm in 'uTipsForm.pas' {TipsForm},
  LobbyClasses in 'LobbyClasses.pas',
  uMessageForm in 'uMessageForm.pas' {MessageForm},
  uInformationDlg in 'uInformationDlg.pas' {InfoDlg},
  uMessageOptions in 'uMessageOptions.pas' {MessageOptions},
  uAboutForm in 'uAboutForm.pas' {AboutForm},
  {$IFDEF HAMACHI}
  uHamachiSettingsForm in 'uHamachiSettingsForm.pas' {HamachiSettingsForm},
  {$ENDIF}
  uClientOptions in 'uClientOptions.pas' {ClientOptions},
  uPresetDataForm in 'uPresetDataForm.pas' {PresetDataForm};

{$R *.res}

var
  Mutex: THandle;

begin
  Mutex := CreateMutex(nil, True, '{C2D49FE5-89B6-407B-B7B7-0986ACCC5319}'); { do not localize }
  if (Mutex = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    MessageDlg('Another instance of the application is already running.', mtInformation, [mbOK], 0);
    Exit;
  end;

  Application.Title := 'Lobby Client'; { do not localize }
  if TLoginForm.Execute then
  begin
    Application.Initialize;
    Application.CreateForm(TAppDataModule, AppDataModule);
    Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TInfoForm, InfoForm);
    Application.CreateForm(THintForm, HintForm);
    Application.CreateForm(TGameParamsForm, GameParamsForm);
    Application.CreateForm(TInfoForm, InfoForm);
    Application.CreateForm(TInfoDlg, InfoDlg);
    Application.Run;
  end;
  if (Mutex <> 0) then
    CloseHandle(Mutex);
end.
