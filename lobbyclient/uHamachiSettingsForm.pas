unit uHamachiSettingsForm;

interface

uses
  StdCtrls, Buttons, Controls, Classes, Forms;

type
  THamachiSettingsForm = class(TForm)
    GroupBox1: TGroupBox;
    InfoLabel: TLabel;
    Label2: TLabel;
    IPEdit: TEdit;
    Label3: TLabel;
    PathEdit: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    PathBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure PathBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Dialogs, Hamachi;

{$R *.dfm}

procedure THamachiSettingsForm.FormCreate(Sender: TObject);
begin
  InfoLabel.Caption := 'In order for client to work correctly and to finish'
    + ' registration process, please provide your hamachi details.';
  IPEdit.Text := GetHamachiIP;
  PathEdit.Text := GetHamachiPath;
end;

procedure THamachiSettingsForm.PathBtnClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
    try
      Options := Options + [ofPathMustExist, ofFileMustExist];
      InitialDir := GetProgramFilesPath;
      Filter := 'Hamachi Application (*.exe)|*.exe';
      if Execute then
        PathEdit.Text := FileName;
    finally
      Free;
    end;
end;

procedure THamachiSettingsForm.OkBtnClick(Sender: TObject);
begin
  if (IPEdit.Text = '') or (PathEdit.Text = '') then
  begin
    MessageDlg('Hamachi IP address or Path to Hamachi application has not been entered.', mtWarning, [mbOK], 0);
    ModalResult := mrNone;
  end;
end;

end.
