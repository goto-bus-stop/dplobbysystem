unit uSplashForm;

interface

uses
  Controls, StdCtrls, ExtCtrls, Classes, Forms;

type
  TSplashForm = class(TForm)
    CancelBtn: TButton;
    SplashText: TLabel;
    Bevel: TBevel;
    SplashImage: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uAppDataModule;

{$R *.dfm}

procedure TSplashForm.FormCreate(Sender: TObject);
begin
  BorderStyle := bsSingle;
  BorderIcons := [biSystemMenu];
  Position := poMainFormCenter;
  Caption := 'Connecting, please wait...';
  SplashText.Caption := 'Connecting to Game Zone, please wait a while...';
  SplashImage.Picture.Assign(AppDataModule.SplashBitmap);
end;

procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ModalResult := mrOK;
  Action := caFree;
end;

end.
