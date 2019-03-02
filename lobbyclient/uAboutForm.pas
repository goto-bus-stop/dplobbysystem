unit uAboutForm;

interface

uses
  Controls, StdCtrls, Classes, ExtCtrls, Forms;

type
  TAboutForm = class(TForm)
    IcoImage: TImage;
    AppLabel: TLabel;
    AboutLabel: TLabel;
    OKBtn: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  SysUtils;

{$R *.dfm}

const
  VERSION = '2.01'; { do not localize }
  AUTHOR = 'biegleux'; { do not localize }
  AUTHOR_EMAIL = 'biegleux@gmail.com'; { do not localize }

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Caption := 'About ' + Application.Title;
  AppLabel.Caption := Application.Title + ' ' + VERSION;
  AboutLabel.Caption := Format('Author: %s <%s>', [AUTHOR, AUTHOR_EMAIL]);
  IcoImage.Picture.Icon.Assign(Application.Icon);
end;

end.
