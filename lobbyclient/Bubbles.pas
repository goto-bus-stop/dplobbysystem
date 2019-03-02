unit Bubbles;

interface

uses
  Windows, Graphics, Contnrs;

type
  { TBubble class }

  TInfoState = (isUp, isHover, isDown);
  TBubbleState = (bsUp, bsHover, bsDown);
  TBubble = class(TObject)
  private
    FId: Integer;
    FData: Pointer;
    FSelected: Boolean;
    FActive: Boolean;
    FInfoState: TInfoState;
    FBubbleState: TBubbleState;
    FTitleWidth: Integer;
    FTitleHeight: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; X, Y: Integer);
    function AtPos(X, Y: Integer): Boolean;
    function BubbleAtPos(X, Y: Integer): Boolean;
    function InfoAtPos(X, Y: Integer): Boolean;
    function TitleAtPos(X, Y: Integer): Boolean;
    property Id: Integer read FId;
    property Data: Pointer read FData write FData;
    property Selected: Boolean read FSelected write FSelected;
    property Active: Boolean read FActive write FActive;
    property InfoState: TInfoState read FInfoState write FInfoState;
    property BubbleState: TBubbleState read FBubbleState write FBubbleState;
  end;

  { TBubbleList class }

  TBubbleList = class(TObject)
  private
    FItems: TObjectList;
    function GetItem(Index: Integer): TBubble;
    procedure SetItem(Index: Integer; ABubble: TBubble);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(ABubble: TBubble; AData: Pointer = nil): Integer;
    function GetAt(X, Y: Integer): TBubble;
    property Items[Index: Integer]: TBubble read GetItem write SetItem; default;
    property Count: Integer read GetCount;
  end;

implementation

uses
  uAppDataModule, CommCtrl, uConsts, SysUtils, uLobbyClient;

constructor TBubble.Create;
begin
  inherited Create;
  FId := 0;
  FData := nil;
  FSelected := False;
  FActive := False;
  FInfoState := isUp;
  FBubbleState := bsUp;
  FTitleWidth := 0;
  FTitleHeight := 0;
end;

destructor TBubble.Destroy;
begin
  FData := nil;
  inherited Destroy;
end;

function TBubble.AtPos(X, Y: Integer): Boolean;
begin
  with AppDataModule do
    Result := (X >= 0) and (X <= C.Room.Width) and (Y >= 0) and (Y <= C.Room.Height);
end;

function TBubble.BubbleAtPos(X, Y: Integer): Boolean;
begin
  with AppDataModule do
    Result := (X >= C.Bubble.X) and (X <= C.Bubble.X + C.Bubble.Width)
      and (Y >= C.Bubble.Y) and (Y <= C.Bubble.Y + C.Bubble.Height);
end;

function TBubble.InfoAtPos(X, Y: Integer): Boolean;
begin
  with AppDataModule do
    Result := (X >= C.Info.X) and (X <= C.Info.X + C.Info.Width)
      and (Y >= C.Info.Y) and (Y <= C.Info.Y + C.Info.Height);
end;

function TBubble.TitleAtPos(X, Y: Integer): Boolean;
var
  maxWidth: Integer;
  Title: String;
begin
  Result := False;
  if not Assigned(FData) then
    Exit;
  if (FTitleWidth = 0) or (FTitleHeight = 0) then
    Exit;
  with AppDataModule do
  begin
    Title := THostedGame(FData).Title;
    maxWidth := C.CM.X - (C.Title.X + 4);
    if (FTitleWidth <= maxWidth) then
      Exit;
    Result := (X >= C.Title.X) and (X <= C.Title.X + maxWidth)
      and (Y >= C.Title.Y) and (Y <= C.Title.Y + FTitleHeight);
  end;
end;

procedure TBubble.Draw(Canvas: TCanvas; X, Y: Integer);
var
  BubbleIndex: Integer;
  StatusString: String;
  PingIdx, InfoIdx: Integer;
  sWidth, sExtWidth, maxWidth: Integer;
  sText: String;
  G: THostedGame;
  i, x1, y1, cx, cy: Integer;
  Bitmap: TBitmap;
  Font: HFONT;
  FontHeight: Integer;
  PixelsPerInch: Integer;
begin
  if not Assigned(Canvas) then
    Exit;

  Bitmap := TBitmap.Create;
  try
    with AppDataModule do
    begin
      with Bitmap, Bitmap.Canvas do
      begin
        Width := C.Room.Width;
        Height := C.Room.Height;
        Brush.Color := clFuchsia;
        FloodFill(0, 0, clNone, fsBorder);
        TransparentColor := clFuchsia;
        Transparent := True;
        Brush.Style := bsClear;
        Font.Name := 'Tahoma'; { do not localize }
        Font.Color := clWhite;
        Font.Style := [fsBold];
        Font.Size := 10;
      end;

      { draw item's surrounding }
      if FSelected or FActive then
        ImageList_Draw(RoomImageList.Handle, ROOM_ON_IDX, Bitmap.Canvas.Handle, 0, 0, ILD_NORMAL)
      else
        ImageList_Draw(RoomImageList.Handle, ROOM_OFF_IDX, Bitmap.Canvas.Handle, 0, 0, ILD_NORMAL);

      case FBubbleState of
        bsUp: BubbleIndex := HOST_OFF_IDX;
        bsHover: BubbleIndex := HOST_ON_IDX;
        bsDown: BubbleIndex := HOST_DOWN_IDX;
        else BubbleIndex := HOST_OFF_IDX;
      end;

      G := FData;
      if not Assigned(G) then
      begin
        { draw Game i }
        Bitmap.Canvas.TextOut(C.GameLabel.X, C.GameLabel.Y, Format(GAME_ID, [FId + 1]));
        { draw bubble }
        ImageList_Draw(BubbleImageList.Handle, BubbleIndex, Bitmap.Canvas.Handle,
            C.Bubble.X, C.Bubble.Y, ILD_NORMAL);
        Canvas.Draw(X, Y, Bitmap);
        Exit;
      end;

      StatusString := '';
      case G.Status of
        gsWaiting:
          begin
            StatusString := WAITING_FOR_PLAYERS;
            if (G.PlayerList.Count = G.MaxPlayers) then
              BubbleIndex := JOIN_DISABLED_IDX
            else
              case FBubbleState of
                bsUp: BubbleIndex := JOIN_OFF_IDX;
                bsHover: BubbleIndex := JOIN_ON_IDX;
                bsDown: BubbleIndex := JOIN_DOWN_IDX;
              end;
              if FActive and (FBubbleState = bsUp) then
                BubbleIndex := JOIN_ON_IDX;
          end;
        gsJoinInProgress:
          begin
            StatusString := JOIN_IN_PROGRESS;
            if (G.PlayerList.Count = G.MaxPlayers) then
              BubbleIndex := JOIN_DISABLED_IDX
            else
            begin
              case FBubbleState of
                bsUp: BubbleIndex := JOIN_OFF_IDX;
                bsHover: BubbleIndex := JOIN_ON_IDX;
                bsDown: BubbleIndex := JOIN_DOWN_IDX;
              end;
              if FActive and (FBubbleState = bsUp) then
                BubbleIndex := JOIN_ON_IDX;
            end;
          end;
        gsInProgress:
          begin
            StatusString := GAME_IN_PROGRESS;
            BubbleIndex := JOIN_DISABLED_IDX;
          end;
      end; { end case }

      { draw Game i }
      Bitmap.Canvas.TextOut(C.GameLabel.X, C.GameLabel.Y, Format(GAME_ID, [FId + 1]));

      { draw bubble }
      ImageList_Draw(BubbleImageList.Handle, BubbleIndex, Bitmap.Canvas.Handle,
          C.Bubble.X, C.Bubble.Y, ILD_NORMAL);
      if FActive then
        ImageList_Draw(BubbleImageList.Handle, JOIN_DISABLED_IDX, Bitmap.Canvas.Handle,
            C.Bubble.X, C.Bubble.Y, ILD_NORMAL);

      { draw info button }
      case FInfoState of
        isUp: InfoIdx := INFO_OFF_IDX;
        isHover: InfoIdx := INFO_ON_IDX;
        isDown: InfoIdx := INFO_DOWN_IDX;
        else InfoIdx := INFO_OFF_IDX;
      end;
      ImageList_Draw(InfoImageList.Handle, InfoIdx, Bitmap.Canvas.Handle,
        C.Info.X, C.Info.Y, ILD_NORMAL);

      { draw ping }
      case G.HostPing of
        0:                                      PingIdx := - 1;  { unknown }
        1..PING_PUREGREEN_MAX:                  PingIdx := PING_PUREGREEN_IDX;
        PING_PUREGREEN_MAX + 1..PING_GREEN_MAX: PingIdx := PING_GREEN_IDX;
        PING_GREEN_MAX + 1..PING_YELLOW_MAX:    PingIdx := PING_YELLOW_IDX;
        else PingIdx := -1;
      end;
      if (PingIdx <> -1) then
        ImageList_Draw(PingImageList.Handle, PingIdx, Bitmap.Canvas.Handle,
          C.Latency.X, C.Latency.Y, ILD_NORMAL);

      if G.Password then
        Bitmap.Canvas.Draw(C.Password.X, C.Password.Y, LockBitmap);

      { draw curr players / max players }
      Bitmap.Canvas.Font.Style := [];
      Bitmap.Canvas.Font.Size := 10;
      Bitmap.Canvas.TextOut(C.CM.X, C.CM.Y, Format('%d/%d', [G.PlayerList.Count, G.MaxPlayers]));

      { draw dots }   //         (360 / 16) = 22 {16 max kruzkov}
      cx := (C.Bubble.X) + (C.Bubble.Width div 2);
      cy := ((C.Room.Height) - C.Bubble.Height) + (C.Bubble.Height div 2) - 9;
      for i := 0 to G.MaxPlayers - 1 do
      begin
        { polomer 32 }
        x1 := cx + Round(32 * cos((i * 22 -90) * (PI / 180)));
        y1 := cy + Round(32 * sin((i * 22 -90) * (PI / 180)));
        if (i < G.PlayerList.Count) then
          ImageList_Draw(DotImageList.Handle, 0, Bitmap.Canvas.Handle, x1, y1, ILD_NORMAL)
        else
          ImageList_Draw(DotImageList.Handle, 1, Bitmap.Canvas.Handle, x1, y1, ILD_NORMAL);
      end;

      { draw Game's title }
      sText := G.Title;
      sWidth := Bitmap.Canvas.TextWidth(G.Title);
      maxWidth := C.CM.X - (C.Title.X + 4);
      FTitleWidth := sWidth;
      FTitleHeight := Bitmap.Canvas.TextHeight(G.Title);
      if (sWidth > maxWidth) then
      begin
        sExtWidth := Bitmap.Canvas.TextWidth('...'); { do not localize }
        while (sWidth + sExtWidth > maxWidth) do
        begin
          SetLength(sText, Length(sText) - 1);
          sWidth := Bitmap.Canvas.TextWidth(sText);
        end;
        sText := sText + '...'; { do not localize }
      end;
      Bitmap.Canvas.TextOut(C.Title.X, C.Title.Y, sText);
      Canvas.Draw(X, Y, Bitmap);

      { draw game's status }
      Bitmap.Canvas.Font.Size := 10;
      sWidth := Bitmap.Canvas.TextWidth(StatusString);
      { We draw on primary canvas, reason: antialiased fonts }
      { We don't use canvas's font, known issues, Mantis 3932, JvListView.pas }
      PixelsPerInch := GetDeviceCaps(GetDC(0), LOGPIXELSY);
      FontHeight := -MulDiv(8, PixelsPerInch, 72);
      Font := CreateFont(FontHeight, 0, 0, 0, FW_BOLD, 0, 0, 0, GetDefFontCharSet,
        OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY, DEFAULT_PITCH, 'Tahoma'); { do not localize }
      SelectObject(Canvas.handle, Font);
      SetTextColor(Canvas.Handle, RGB(0, 0, 0));
      Canvas.TextOut(X + C.Status.X + 1 + (C.Room.Width - sWidth) div 2, Y + C.Status.Y + 1, StatusString);
      SetTextColor(Canvas.Handle, RGB(255, 255, 255));
      Canvas.TextOut(X + C.Status.X + (C.Room.Width - sWidth) div 2, Y + C.Status.Y, StatusString);
      DeleteObject(Font);
    end;
  finally
    Bitmap.Free
  end;
end;

{ TBubbleList }

constructor TBubbleList.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
end;

destructor TBubbleList.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TBubbleList.GetItem(Index: Integer): TBubble;
begin
  Result := FItems[Index] as TBubble;
end;

procedure TBubbleList.SetItem(Index: Integer; ABubble: TBubble);
begin
  FItems[Index] := ABubble;
end;

function TBubbleList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBubbleList.Add(ABubble: TBubble; AData: Pointer = nil): Integer;
begin
  ABubble.FId := Count;
  ABubble.Data := AData;
  Result := FItems.Add(ABubble);
end;

function TBubbleList.GetAt(X, Y: Integer): TBubble;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FItems.Count - 1 do
  begin
    Result := Items[i];
    if Result.AtPos(X, Y) then
      Break;
    Result := nil;
  end;
end;

end.

