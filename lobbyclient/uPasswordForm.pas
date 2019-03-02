unit uPasswordForm;

interface

uses
  StdCtrls, Controls, Classes, Forms;

type
  TPasswordForm = class(TForm)
    TextLabel: TLabel;
    PwdEdit: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure PwdEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Windows;

{$R *.dfm}

procedure TPasswordForm.PwdEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    Self.ModalResult := OkBtn.ModalResult;
end;

procedure TPasswordForm.FormShow(Sender: TObject);
begin
  PwdEdit.SetFocus;
end;

procedure TPasswordForm.FormCreate(Sender: TObject);
begin
  TextLabel.Caption := 'Please enter the password for this' + #13#10 + 'private game:';
end;

end.
