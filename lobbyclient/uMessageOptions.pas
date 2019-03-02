unit uMessageOptions;

interface

uses
  StdCtrls, JvColorCombo, JvExStdCtrls, JvCombobox, Controls, Classes, Forms;

type
  TMessageOptions = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FontStyleBox: TComboBox;
    Label3: TLabel;
    FontSizeBox: TComboBox;
    FontNameBox: TJvFontComboBox;
    FontColorBox: TJvColorComboBox;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    OkBtn: TButton;
    CancelBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
