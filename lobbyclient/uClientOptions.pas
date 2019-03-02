unit uClientOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TClientOptions = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    WSPatchEdit: TEdit;
    DlgBtn: TSpeedButton;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure DlgBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TClientOptions.DlgBtnClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
    try
      Options := Options + [ofPathMustExist, ofFileMustExist];
      Filter := 'AOC Widescreen Patch (*.exe)|*.exe';
      if Execute then
        WSPatchEdit.Text := FileName;
    finally
      Free;
    end;
end;

end.
