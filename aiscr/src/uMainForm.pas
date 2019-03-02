unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DPlay, Menus;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    HostGame1: TMenuItem;
    HostGame2: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    RestoreGame1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HostGame2Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure RestoreGame1Click(Sender: TObject);
  private
    DPlay: TDPlay;
    procedure HostGame;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uPresetDataForm, AOCUtils, ActiveX, XPMan;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DPlay := TDPlay.Create;
  if not DPlay.Initialize then
    MessageDlg('DirectPlay has not been initialized.', mtError, [mbOK], 0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DPlay.Free;
end;

procedure TMainForm.HostGame;
var
  ApplicationGUID: TGUID;
  SessionName: String;
  PlayerName: String;
  Password: String;
  MaxPlayers: Integer;
  AgePresetDataPtr: PAgePresetData;
begin
  with TPresetDataForm.Create(Self) do
    try
      if (ShowModal = mrOK) then
      begin
        ApplicationGUID := AGE2X1_GUID;
        SessionName := 'S';
        PlayerName := 'Player';
        Password := '';
        MaxPlayers := 8;
        AgePresetDataPtr := @AgePresetData;
        if not DPlay.HostSession(ApplicationGUID, SessionName, PlayerName,
          Password, MaxPlayers, AgePresetDataPtr) then
        begin
          MessageDlg('Game failed to launch.', mtError, [mbOK], 0);
          Exit;
        end;
      end;
    finally
      Free;
    end;
end;

procedure TMainForm.HostGame2Click(Sender: TObject);
begin
  HostGame;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.RestoreGame1Click(Sender: TObject);
var
  ApplicationGUID: TGUID;
  SessionName: String;
  PlayerName: String;
  Password: String;
  MaxPlayers: Integer;
  AgePresetData: TAgePresetData;
  AgePresetDataPtr: PAgePresetData;
  Restore: Boolean;
  SavedGame: String;
begin
  with TOpenDialog.Create(Self) do
    try
      Options := Options + [ofPathMustExist, ofFileMustExist];
      Filter := 'Multi-player Saved Game Files (*.msx)|*.msx';
      InitialDir := GetAOCSpecificPath('SaveGame\Multi');
      if Execute then
      begin
        SavedGame := ExtractFileName(FileName);

        ZeroMemory(@AgePresetData, SizeOf(TAgePresetData));
        AgePresetData.bGameType := 8;
        CopyMemory(@AgePresetData.sGameFilename, @SavedGame[1], Length(SavedGame));
        ApplicationGUID := AGE2X1_GUID;
        SessionName := 'S';
        PlayerName := 'Player';
        Password := '';
        MaxPlayers := 8;
        AgePresetDataPtr := @AgePresetData;
        Restore := True;

        if not DPlay.HostSession(ApplicationGUID, SessionName, PlayerName,
          Password, MaxPlayers, AgePresetDataPtr, Restore) then
        begin
          MessageDlg('Game failed to launch.', mtError, [mbOK], 0);
          Exit;
        end;
      end;
    finally
      Free;
    end;
end;

end.
