unit MyJvListView;

interface

uses
  JvListView, Types, ComCtrls;

type
  TMyJvListView = class(TJvListView)
  protected
    function CustomDraw(const ARect: TRect; Stage: TCustomDrawStage): Boolean; override;
  end;

procedure Register;

implementation

uses
  Windows, Graphics, CommCtrl, Classes,
  SysUtils;

function BitBlt(DestCanvas: TCanvas; X, Y, Width, Height: Integer; SrcCanvas: TCanvas;
  XSrc, YSrc: Integer; WinRop: Cardinal; IgnoreMask: Boolean = True): LongBool;
begin
  // NB! IgnoreMask is not supported in VCL!
  Result := Windows.BitBlt(DestCanvas.Handle, X, Y, Width, Height, SrcCanvas.Handle,
    XSrc, YSrc, WinRop);
end;

function TMyJvListView.CustomDraw(const ARect: TRect; Stage: TCustomDrawStage): Boolean;
var
  BmpYPos: Integer; // Y position for bitmap
  ItemRect: TRect; // List item bounds rectangle
  TopOffset: Integer; // Y pos where bmp drawing starts
  Bmp: TBitmap;

  function GetHeaderHeight: Integer;
  var
    Header: HWND; // header window handle
    Pl: TWindowPlacement; // header window placement
  begin
    // Get header window
    Header := SendMessage(Handle, LVM_GETHEADER, 0, 0);
    // Get header window placement
    FillChar(Pl, SizeOf(Pl), 0);
    Pl.length := SizeOf(Pl);
    GetWindowPlacement(Header, @Pl);
    // Calculate header window height
    Result := Pl.rcNormalPosition.Bottom - Pl.rcNormalPosition.Top;
  end;

begin
  Result := inherited CustomDraw(ARect, Stage);
  if Result and (Stage = cdPrePaint) and (Picture <> nil) and (Picture.Graphic <> nil) and not
    Picture.Graphic.Empty and (Picture.Graphic.Width > 0) and (Picture.Graphic.Height > 0) then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.Width := ClientWidth;
      Bmp.Height := ClientHeight;
      Bmp.Canvas.Brush.Color := Self.Color;
      Bmp.Canvas.FillRect(ClientRect);

      // Get top offset where drawing starts
      if (Items.Count > 0) then
      begin
        ListView_GetItemRect(Handle, 0, ItemRect, LVIR_BOUNDS);
        TopOffset := ListView_GetTopIndex(Handle) * (ItemRect.Bottom - ItemRect.Top);
      end else
        TopOffset := 0;
      if ViewStyle = TJvViewStyle(vsReport) then
        BmpYPos := ARect.Top - TopOffset + GetHeaderHeight
      else
        BmpYPos := 0;

      // draw image across width of display
      Bmp.Canvas.Draw(ARect.Left, BmpYPos, Picture.Graphic);

      BitBlt(Canvas, 0, 0, ClientWidth, ClientHeight, Bmp.Canvas, 0, 0, SRCCOPY);
      // Ensure that the items are drawn transparently
      SetBkMode(Canvas.Handle, TRANSPARENT);
      ListView_SetTextBkColor(Handle, CLR_NONE);
      ListView_SetBKColor(Handle, CLR_NONE);
    finally
      Bmp.Free;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TMyJvListView]);
end;

end.
