unit uGameParamsForm;

interface

uses
  Controls, StdCtrls, ComCtrls, Classes, Forms, Language, DPlay;

type
  TGameParamsForm = class(TForm)
    TitleEdit: TEdit;
    TitleLabel: TLabel;
    DescLabel: TLabel;
    MaxPlayersLabel: TLabel;
    MPEdit: TEdit;
    UpDown: TUpDown;
    PrivateCheckBox: TCheckBox;
    PwdLabel: TLabel;
    PwdEdit: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    DescRichEdit: TRichEdit;
    BlockCheckBox: TCheckBox;
    DPApplicationsComboBox: TComboBox;
    Label1: TLabel;
    OptionsBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure PrivateCheckBoxClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OptionsBtnClick(Sender: TObject);
    procedure DPApplicationsComboBoxChange(Sender: TObject);
  private
    AlertMsg0, AlertMsg1, AlertMsg2: String;
  protected
    { Protected declarations }
  public
    PresetData: TAgePresetData;
    procedure SetLanguage(const Language: TLanguage);
  end;

var
  GameParamsForm: TGameParamsForm;

implementation

uses
  Windows, Dialogs, SysUtils, uPresetDataForm;

{$R *.dfm}

procedure TGameParamsForm.FormCreate(Sender: TObject);
begin
  AlertMsg0 := '';
  AlertMsg1 := '';
  AlertMsg2 := '';
  ZeroMemory(@PresetData, SizeOf(TAgePresetData));
end;

procedure TGameParamsForm.FormShow(Sender: TObject);
begin
  TitleEdit.SetFocus;
  PrivateCheckBox.Checked := (PwdEdit.Text <> '');
  PwdEdit.Enabled := PrivateCheckBox.Checked;
  PwdLabel.Enabled := PrivateCheckBox.Checked;
  DPApplicationsComboBoxChange(Sender);
end;

procedure TGameParamsForm.PrivateCheckBoxClick(Sender: TObject);
begin
  PwdEdit.Enabled := PrivateCheckBox.Checked;
  PwdLabel.Enabled := PrivateCheckBox.Checked;
  if PrivateCheckBox.Checked then
    PwdEdit.SetFocus
  else
    PwdEdit.Text := '';
end;

procedure TGameParamsForm.OKBtnClick(Sender: TObject);
begin
  if (DPApplicationsComboBox.ItemIndex = -1) then
  begin
    MessageDlg(AlertMsg2, mtWarning, [mbOK], 0);
    ModalResult := mrNone;
    Exit;
  end;
  TitleEdit.Text := Trim(TitleEdit.Text);
  DescRichEdit.Text := Trim(DescRichEdit.Text);

  if (TitleEdit.Text = '') then
  begin
    MessageDlg(AlertMsg0, mtWarning, [mbOK], 0);
    TitleEdit.SetFocus;
    ModalResult := mrNone;
  end else
  if (DescRichEdit.Text = '') then
  begin
    DescRichEdit.SetFocus;
    MessageDlg(AlertMsg1, mtWarning, [mbOK], 0);
    ModalResult := mrNone;
  end;
end;

procedure TGameParamsForm.SetLanguage(const Language: TLanguage);
begin
  AlertMsg0 := Language.GetValue('empty_title'); { do not localize }
  AlertMsg1 := Language.GetValue('empty_description'); { do not localize }
  AlertMsg2 := Language.GetValue('no_app_selected'); { do not localize }
end;

procedure TGameParamsForm.OptionsBtnClick(Sender: TObject);
begin
  with TPresetDataForm.Create(Self) do
    try
      if (ShowModal = mrOK) then
        PresetData := AgePresetData;
    finally
      Free;
    end;
end;

procedure TGameParamsForm.DPApplicationsComboBoxChange(Sender: TObject);
var
  lpGUID: TGUID;
begin
  with DPApplicationsComboBox do
  begin
    if (ItemIndex <> -1) then
    begin
      lpGUID := PGUID(Items.Objects[ItemIndex])^;
      OptionsBtn.Enabled := IsEqualGuid(lpGUID, AGE2X1_GUID);
    end else
      OptionsBtn.Enabled := False;
  end;
end;

end.
