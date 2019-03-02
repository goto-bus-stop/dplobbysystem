unit uInformationDlg;

interface

uses
  Controls, StdCtrls, Classes, Forms;

type
  TInfoDlgType = (idtLaunchingGame, idtFailedLaunching, idtFailedHosting, idtFailedJoining, idtAlreadyInGame);
  TInfoDlg = class(TForm)
    TitleLabel: TLabel;
    MessageLabel: TLabel;
    Btn: TButton;
    procedure BtnClick(Sender: TObject);
  private
    FInfoDlgType: TInfoDlgType;
    procedure SetInfoDlgType(AInfoDlgType: TInfoDlgType);
  public
    property InfoDlgType: TInfoDlgType read FInfoDlgType write SetInfoDlgType;
  end;

var
  InfoDlg: TInfoDlg;

implementation

uses
  uMainForm;

{$R *.dfm}

procedure TInfoDlg.SetInfoDlgType(AInfoDlgType: TInfoDlgType);
begin
  with MainForm do
  begin
    case AInfoDlgType of
      idtLaunchingGame:
        begin
          TitleLabel.Caption := Language.GetValue('launching_game'); { do not localize }
          MessageLabel.Caption := Language.GetValue('launching_game_msg'); { do not localize }
          Btn.Caption := Language.GetValue('cancel'); { do not localize }
        end;
      idtFailedLaunching:
        begin
          TitleLabel.Caption := Language.GetValue('failed_launching'); { do not localize }
          MessageLabel.Caption := Language.GetValue('failed_launching_msg'); { do not localize }
          Btn.Caption := Language.GetValue('ok'); { do not localize }
        end;
      idtFailedHosting:
        begin
          TitleLabel.Caption := Language.GetValue('failed_hosting'); { do not localize }
          MessageLabel.Caption := Language.GetValue('failed_hosting_msg'); { do not localize }
          Btn.Caption := Language.GetValue('ok'); { do not localize }
        end;
      idtFailedJoining:
        begin
          TitleLabel.Caption := Language.GetValue('failed_joining'); { do not localize }
          MessageLabel.Caption := Language.GetValue('failed_joining_msg'); { do not localize }
          Btn.Caption := Language.GetValue('ok'); { do not localize }
        end;
      idtAlreadyInGame:
        begin
          TitleLabel.Caption := Language.GetValue('information'); { do not localize }
          MessageLabel.Caption := Language.GetValueFmt('already_in_game', [Self.Tag]); { do not localize }
          Btn.Caption := Language.GetValue('ok'); { do not localize }
        end;
    end;
  end;
end;

procedure TInfoDlg.BtnClick(Sender: TObject);
begin
  Close;
end;

end.
