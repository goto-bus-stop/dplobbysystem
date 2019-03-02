unit uInfoForm;

interface

uses
  ComCtrls, JvExComCtrls, JvComCtrls, StdCtrls, Classes, Controls,
  ExtCtrls, Forms, uLobbyClient, LobbyClasses, Messages;

type
  TInfoForm = class(TForm)
    MainPanel: TPanel;
    TopPanel: TPanel;
    PlayersTreeView: TJvTreeView;
    DescRichEdit: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure PlayersTreeViewCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    HostNode, PlayersNode: TTreeNode;
    HostedGame: THostedGame;
    RoomUsers: TLobbyUsers;
    procedure RoomUsersAddUser(Sender: TObject; User: TLobbyUser);
    procedure RoomUsersClear(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure GetMinMaxInfo(var Msg: TWMGETMINMAXINFO); message WM_GETMINMAXINFO;
  public
    procedure SetRoom(AHostedGame: THostedGame; ALobbyUsers: TLobbyUsers; User: TLobbyUser);
  end;

var
  InfoForm: TInfoForm;

implementation

uses
  Windows, CommCtrl, SysUtils, uAppDataModule, uConsts;

{$R *.dfm}

const
  pxINDENT = 5;

procedure TInfoForm.CreateParams(var Params: TCreateParams);
begin
  BorderStyle := bsNone;
  inherited CreateParams(Params);
  with Params do
    ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_TRANSPARENT;
end;

procedure TInfoForm.GetMinMaxInfo(var Msg: TWMGETMINMAXINFO);
begin
  with Msg.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := 0;  { min. Width }
    ptMinTrackSize.Y := 0;  { min. Height }
  end;
end;

procedure TInfoForm.FormCreate(Sender: TObject);
begin
  HostedGame := THostedGame.Create;
  RoomUsers := TLobbyUsers.Create;
  RoomUsers.OnAddUser := RoomUsersAddUser;
  RoomUsers.OnClear := RoomUsersClear;
  PlayersTreeView.Images := AppDataModule.PingImageList;
  HostNode := PlayersTreeView.Items.Add(nil, HOST_CAP);
  PlayersNode := PlayersTreeView.Items.Add(nil, PLAYERS_CAP);
end;

procedure TInfoForm.FormDestroy(Sender: TObject);
begin
  HostedGame.Free;
  RoomUsers.Free;
end;

procedure TInfoForm.PlayersTreeViewCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
  User: TLobbyUser;
  sText: String;
  sWidth, y, PingIdx: Integer;
begin
  DefaultDraw := False;
  NodeRect := Node.DisplayRect(False);

  with (Sender as TTreeView) do
  begin
    if cdsSelected in State then
      Canvas.Brush.Color := Color;

    case Node.Level of
      0:  begin
        { draw caption }
        Canvas.TextOut(NodeRect.Left + pxINDENT, NodeRect.Top, Node.Text);
        { draw line under node }
        Canvas.Pen.Color := LINE_COLOR;
        Canvas.MoveTo(NodeRect.Left  + pxINDENT, NodeRect.Bottom - 1);
        Canvas.LineTo(NodeRect.Right - pxINDENT, NodeRect.Bottom - 1);
      end;

      1:  begin
        User := Node.Data;
        if Assigned (User) then
        begin
          case User.Status of
            usLooking: Canvas.Font.Color := LOOKING_COLOR;
            usWaiting: Canvas.Font.Color := WAITING_COLOR;
            usPlaying: Canvas.Font.Color := PLAYING_COLOR;
          end;
          case User.Ping of
            0:                                       PingIdx := - 1;  { unknown }
            1..PING_PUREGREEN_MAX:                   PingIdx := PING_PUREGREEN_IDX;
            PING_PUREGREEN_MAX + 1..PING_GREEN_MAX:  PingIdx := PING_GREEN_IDX;
            PING_GREEN_MAX + 1..PING_YELLOW_MAX:     PingIdx := PING_YELLOW_IDX;
            else PingIdx := PING_RED_IDX;
          end;
          { draw player's name }
          if cdsHot	in State then
            Canvas.Font.Color := LINE_COLOR;
//          if (IgnoreList.IndexOf (Pointer (PUI^.ID)) <> -1) then
//            Canvas.Font.Style := [fsStrikeOut];
          Canvas.TextOut(NodeRect.Left + pxINDENT + Indent, NodeRect.Top, Node.Text);
          { draw ping if not unknown }
          if (PingIdx <> -1) and Assigned(Images) then
          begin
            y := ((NodeRect.Bottom - NodeRect.Top) - Images.Height) div 2;
            ImageList_Draw(Images.Handle, PingIdx, Canvas.Handle,
                NodeRect.Left, NodeRect.Top + y, ILD_NORMAL);
          end;
          { draw rating }
          if (User.Rating <> 0) then  // alebo if room.rated
          begin
            { calculate width of rating text }
            sText := Format('(%d)', [User.Rating]); { do not localize }
            sWidth := Canvas.TextWidth(sText);
            Canvas.TextOut(NodeRect.Right - pxINDENT - sWidth, NodeRect.Top, sText);
          end;
        end;
      end;
    end; { end case }
  end;
end;

procedure TInfoForm.SetRoom(AHostedGame: THostedGame; ALobbyUsers: TLobbyUsers; User: TLobbyUser);
var
  RU, U: TLobbyUser;
  i: Integer;
begin
  PlayersTreeView.Items.BeginUpdate;
  RoomUsers.Clear;
  HostedGame.Assign(AHostedGame);
  for i := 0 to HostedGame.PlayerList.Count - 1 do
  begin
    U := ALobbyUsers.Get(HostedGame.PlayerList[i]);
    RU := TLobbyUser.Create;
    if Assigned(U) then
      RU.Assign(U)
    else
    if (User.Name = HostedGame.PlayerList[i]) then
      RU.Assign(User)
    else
    begin
      RU.Name := HostedGame.PlayerList[i];
      RU.Status := usPlaying;
      RU.Rating := 0;
      RU.Ping := 0;
    end;
    RoomUsers.Add(RU);
  end;
  HostNode.Expand(False);
  PlayersNode.AlphaSort(False);
  PlayersNode.Expand(False);
  PlayersTreeView.Items.EndUpdate;
end;

procedure TInfoForm.RoomUsersAddUser(Sender: TObject; User: TLobbyUser);
var
  ParentNode: TTreeNode;
begin
  if (HostedGame.PlayerList.Count > 0) then
  begin
    if (User.Name = HostedGame.PlayerList[0]) then
      ParentNode := HostNode
    else
      ParentNode := PlayersNode;
    PlayersTreeView.Items.AddChildObject(ParentNode, User.Name, User);
  end;
end;

procedure TInfoForm.RoomUsersClear(Sender: TObject);
begin
  HostNode.DeleteChildren;
  PlayersNode.DeleteChildren;
end;

procedure TInfoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RoomUsers.Clear;
end;

procedure TInfoForm.FormHide(Sender: TObject);
begin
  RoomUsers.Clear;
end;

procedure TInfoForm.FormShow(Sender: TObject);
begin
  DescRichEdit.Text := HostedGame.Description;
end;

end.
