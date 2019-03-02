unit uHintForm;

interface

uses
  Classes, Controls, StdCtrls, Forms, Messages;

type
  THintForm = class(TForm)
    PlayerNameLabel: TLabel;
    PingLabel: TLabel;
    RatingLabel: TLabel;
    StatusLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FIsPlayer: Boolean;
    FIsVisible: Boolean;
    procedure SetPlayerName(const AValue: String);
    procedure SetPlayerPing(const AValue: Integer);
    procedure SetPlayerRating(const AValue: Integer);
    procedure SetPlayerStatus(const AValue: String);
    procedure SetForm(const AValue: Boolean);
    procedure SetVisibility(const AValue: Boolean);
    function GetVisibility: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure GetMinMaxInfo(var Msg: TWMGETMINMAXINFO); message WM_GETMINMAXINFO;
  public
    property PlayerName: String write SetPlayerName;
    property PlayerPing: Integer write SetPlayerPing;
    property PlayerRating: Integer write SetPlayerRating;
    property PlayerStatus: String write SetPlayerStatus;
    property IsPlayer: Boolean read FIsPlayer write SetForm;
    property IsVisible: Boolean read GetVisibility write SetVisibility;
  end;

var
  HintForm: THintForm;

implementation

uses
  Windows, CommCtrl, uConsts, Graphics, SysUtils;

{$R *.dfm}

procedure THintForm.CreateParams(var Params: TCreateParams);
begin
  BorderStyle := bsNone;
  inherited CreateParams(Params);
  with Params do
    ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_TRANSPARENT;
end;

{ by default there is in Windows min width of form 112 / 118 pixels }
procedure THintForm.GetMinMaxInfo(var Msg: TWMGETMINMAXINFO);
begin
  with Msg.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := 0;  { min. Width }
    ptMinTrackSize.Y := 0;  { min. Height }
  end;
end;

procedure THintForm.FormCreate(Sender: TObject);
var
  Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Width - 0, Height - 0, 15, 15);
  SetWindowRgn(Handle, Rgn, True);
  AlphaBlendValue := 200;
  AlphaBlend := True;
  Color := clGreen;
  FIsPlayer := True;
  FIsVisible := False;
end;

procedure THintForm.SetForm(const AValue: Boolean);
begin
//  if (FIsPlayer = AValue) and (FIsPlayer) then
//    Exit;
  FIsPlayer := AValue;
  if FIsPlayer then
  begin
// tych 150 by malo byt width max z... ...+/- nejake pixely
    Constraints.MinWidth := 180;
    Width := PlayerNameLabel.Canvas.TextWidth(PlayerNameLabel.Caption) + 15;
    Height := 84;
  end else
  begin
    Constraints.MinWidth := 0;
    Width := PlayerNameLabel.Canvas.TextWidth(PlayerNameLabel.Caption) + 15;
    Height := PlayerNameLabel.Canvas.TextHeight(PlayerNameLabel.Caption) + 15;
  end;
end;

procedure THintForm.SetPlayerName(const AValue: String);
begin
  PlayerNameLabel.Caption := AValue;
end;

procedure THintForm.SetPlayerPing(const AValue: Integer);
begin
  if (AValue = 0) then
    PingLabel.Caption := 'Ping: unknown'
  else
    PingLabel.Caption := Format('Ping: %d ms', [AValue]);
end;

procedure THintForm.SetPlayerRating(const AValue: Integer);
begin
  RatingLabel.Caption := Format('Rating: %d', [AValue]);
end;

procedure THintForm.SetPlayerStatus(const AValue: String);
begin
  StatusLabel.Caption := Format('Status: %s', [AValue]);
end;

procedure THintForm.SetVisibility(const AValue: Boolean);
begin
  if (FIsVisible <> AValue) then
  begin
    FIsVisible := AValue;
    if FIsVisible then
      ShowWindow(Handle, SW_SHOWNOACTIVATE)
    else
      ShowWindow(Handle, SW_HIDE);
  end;
end;

function THintForm.GetVisibility: Boolean;
begin
  Result := FIsVisible;
end;

procedure THintForm.FormPaint(Sender: TObject);
begin
  with Canvas do
  begin
    Pen.Color:= LINE_COLOR;
    Pen.Width := 3;
    RoundRect(0, 0, ClientWidth - 1, ClientHeight - 1, 15, 15);
  end;
end;

procedure THintForm.FormResize(Sender: TObject);
var
  Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Width - 0, Height - 0, 10, 10);
  SetWindowRgn(Handle, Rgn, True);
end;

end.
