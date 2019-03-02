unit uMessageForm;

interface

uses
  Controls, ExtCtrls, JvExExtCtrls, JvExtComponent, JvPanel,
  StdCtrls, Classes, Forms;

type
  TMessageForm = class(TForm)
    BkgImage: TImage;
    FromLabel: TLabel;
    UsernameLabel: TLabel;
    SentLabel: TLabel;
    MsgLabel: TLabel;
    MessageMemo: TMemo;
    InfoLabel: TLabel;
    Label3: TLabel;
    JvPanel1: TJvPanel;
    JvPanel2: TJvPanel;
    ReplyLabel: TLabel;
    CloseLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CloseLabelClick(Sender: TObject);
    procedure ReplyLabelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MessageMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure SetForm(const AUsername: String; const AMessage: String = '');
  end;

implementation

uses
  uAppDataModule, uMainForm, LobbyClasses, Windows, Dialogs;

{$R *.dfm}

procedure TMessageForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TMessageForm.FormCreate(Sender: TObject);
begin
  BkgImage.Picture.Assign(AppDataModule.ChatBitmap);
  ClientWidth := BkgImage.Width;
  ClientHeight := BkgImage.Height;
end;

procedure TMessageForm.CloseLabelClick(Sender: TObject);
begin
  Close;
end;

procedure TMessageForm.SetForm(const AUsername: String; const AMessage: String = '');
begin
  if (AMessage = '') then
  begin
    FromLabel.Caption := 'To:';
    ReplyLabel.Caption := '&Send';
    SentLabel.Visible := False;
    InfoLabel.Caption := 'Type your message here:';
  end else
  begin
    FromLabel.Caption := 'From:';
    ReplyLabel.Caption := '&Reply';
    SentLabel.Visible := True;
    InfoLabel.Caption := 'Type your response here:';
  end;
  MsgLabel.Caption := AMessage;
  UsernameLabel.Caption := AUsername;
end;

procedure TMessageForm.ReplyLabelClick(Sender: TObject);
var
  U: TLobbyUser;
  UserName: String;
begin
  with MainForm do
  begin
    UserName := UsernameLabel.Caption;
    U := LobbyUsers.Get(UserName);
    if (MessageMemo.Text <> '') and Assigned(U) then
    begin
      if (U.Status = usPlaying) then
        MessageDlg('User is in a game, message won''t be delivered.', mtInformation, [mbOK], 0)
      else
        SendMessage(UserName, MessageMemo.Text);
    end;
  end;
  Close;
end;

procedure TMessageForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMessageForm.MessageMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    ReplyLabelClick(Sender);
end;

end.
