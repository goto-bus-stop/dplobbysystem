unit uTipsForm;

interface

uses
  StdCtrls, Controls, Classes, Forms;

type
  TTipsForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    HideCheckBox: TCheckBox;
    OKBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  IniFiles, Windows, SysUtils;

{$R *.dfm}

procedure TTipsForm.FormCreate(Sender: TObject);
begin
  BorderStyle := bsSingle;
  BorderIcons := [biSystemMenu];
  Position := poMainFormCenter;
  Caption := 'Zone Tips - Finding a Game';

  Label1.Caption := 'Quick tips to help you find a game with the players in this room.';
  Label2.Caption := 'All the players are listed on the right. Use the outside scroll bar to see all their names.';
  Label3.Caption := 'To chat with the players in this room, type your message and click Send.';
  Label4.Caption := 'To see additional games, use the inner scroll bar.';
  Label5.Caption := 'To play a game with others, click one of the Join buttons.';
  Label6.Caption := 'To start a new game, click the Host button and wait for others to join you.';
  Label7.Caption := 'See the Zone Help for more information.';

  HideCheckBox.Caption := 'Don''t tell me about this again';

  CreateWindow('STATIC', 'MyWnd', WS_CHILD or WS_VISIBLE or SS_BLACKRECT, 16 + 4, 48 + 4, 5, 5, Self.Handle, 0, 0, nil); { do not localize }
  CreateWindow('STATIC', 'MyWnd', WS_CHILD or WS_VISIBLE or SS_BLACKRECT, 16 + 4, 82 + 4, 5, 5, Self.Handle, 0, 0, nil); { do not localize }
  CreateWindow('STATIC', 'MyWnd', WS_CHILD or WS_VISIBLE or SS_BLACKRECT, 16 + 4, 104 + 4, 5, 5, Self.Handle, 0, 0, nil); { do not localize }
  CreateWindow('STATIC', 'MyWnd', WS_CHILD or WS_VISIBLE or SS_BLACKRECT, 16 + 4, 126 + 4, 5, 5, Self.Handle, 0, 0, nil); { do not localize }
  CreateWindow('STATIC', 'MyWnd', WS_CHILD or WS_VISIBLE or SS_BLACKRECT, 16 + 4, 148 + 4, 5, 5, Self.Handle, 0, 0, nil); { do not localize }
end;

procedure TTipsForm.OKBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TTipsForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile: TIniFile;
const
  GENERAL_S = 'General'; { do not localize }
begin
  if HideCheckBox.Checked then
  begin
    IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')); { do not localize }
    try
      IniFile.WriteBool(GENERAL_S, 'ShowTips', False); { do not localize }
    finally
      IniFile.Free;
    end;
  end;
end;

end.
