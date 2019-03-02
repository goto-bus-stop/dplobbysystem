unit uAppDataModule;

interface

uses
  SysUtils, Classes, ImgList, Controls, Windows, Graphics;

type
  TDimension = record
    X, Y: Integer;
    Width: Integer;
    Height: Integer;
  end;

  TConfig = class(TObject)
    Room: TDimension;
    Bubble: TDimension;
    Latency: TDimension;
    Info: TDimension;
    Title: TPoint;
    Status: TPoint;
    Password: TDimension;
    CM: TPoint;
    GameLabel: TPoint;
    BubbleHSpacing: Integer;
    BubbleVSpacing: Integer;
  end;

  TAppDataModule = class(TDataModule)
    ToolImageList: TImageList;
    BubbleImageList: TImageList;
    ButtonImageList: TImageList;
    RoomImageList: TImageList;
    PingImageList: TImageList;
    InfoImageList: TImageList;
    DotImageList: TImageList;
    SendImageList: TImageList;
    EmoFontImageList: TImageList;
    EmotsImageList: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function LoadResources(const FileName: String): Boolean;
  public
    Age2Lobby: TBitmap;
    LogoBitmap: TBitmap;
    BannerBitmap: TBitmap;
    SplashBitmap: TBitmap;
    RoomBitmap: TBitmap;
    LockBitmap: TBitmap;
    ChatBitmap: TBitmap;
    C: TConfig;
  end;

var
  AppDataModule: TAppDataModule;

implementation

{$R *.dfm}

uses
  CommCtrl, uConsts;

function LoadConfig(hLib: THandle; var Text: String): Boolean;
var
  hResInfo: HRSRC;
  GlobalMemoryBlock: HGLOBAL;
  ResData: PChar;
  ResSize: Longword;
begin
  Result := False;
  if (hLib = 0) then
    Exit;
  hResInfo := FindResource(hLib, PChar(RN_CONFIG), PChar(RN_CONFIG));
  if (hResInfo = 0) then
    Exit;
  ResSize := SizeOfResource(hLib, hResInfo);
  if (ResSize = 0) then
    Exit;
  GlobalMemoryBlock := LoadResource(hLib, hResInfo);
  if (GlobalMemoryBlock = 0) then
    Exit;
  ResData := LockResource(GlobalMemoryBlock);
  if (ResData = nil) then
    Exit;
  SetString(Text, ResData, ResSize);
  Result := True;
end;

function TAppDataModule.LoadResources(const FileName: String): Boolean;
var
  hLib: THandle;
  ConfigList: TStringList;
  ConfigText: String;
  Mask: Cardinal;
begin
  Result := False;
  hLib := LoadLibrary(PChar(RESOURCES_FILE));
  if (hLib = 0) then
    Exit;  { Coudn''t load resources }

  { loading config }
  if not LoadConfig(hLib, ConfigText) then
    Exit;
  Result := True;
  ConfigList := TStringList.Create;
  try
    try
      ConfigList.Text := ConfigText;
      with BubbleImageList do
      begin
        Width  := StrToInt(ConfigList.Values['bubble.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['bubble.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_BUBBLE, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
        C.Bubble.Width := Width;
        C.Bubble.Height := Height;
      end;
      with ButtonImageList do
      begin
        Width  := StrToInt(ConfigList.Values['button.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['button.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_BUTTON, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      with InfoImageList do
      begin
        Width  := StrToInt(ConfigList.Values['info.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['info.height']); { do not localize }
        if (StrToInt(ConfigList.Values['info.transparent']) <> 0) then { do not localize }
          Mask := CLR_DEFAULT
        else
          Mask := CLR_NONE;
        Handle := ImageList_LoadImage(hLib, RN_INFO, Width, AllocBy, Mask,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
        C.Info.Width := Width;
        C.Info.Height := Height;
      end;
      with PingImageList do
      begin
        Width  := StrToInt(ConfigList.Values['latency.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['latency.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_LATENCY, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      with RoomImageList do
      begin
        Width  := StrToInt(ConfigList.Values['room.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['room.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_ROOM, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
        C.Room.Width := Width;
        C.Room.Height := Height;
      end;
      with ToolImageList do
      begin
        Width  := StrToInt(ConfigList.Values['tool.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['tool.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_TOOL, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      with DotImageList do
      begin
        Width  := StrToInt(ConfigList.Values['dot.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['dot.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_DOT, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      with SendImageList do
      begin
        Width  := StrToInt(ConfigList.Values['send.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['send.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_SEND, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      with EmoFontImageList do
      begin
        Width  := StrToInt(ConfigList.Values['emofont.width']); { do not localize }
        Height := StrToInt(ConfigList.Values['emofont.height']); { do not localize }
        Handle := ImageList_LoadImage(hLib, RN_EMOFONT, Width, AllocBy, {CLR_DEFAULT}CLR_NONE,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      {
      with EmotsImageList do
      begin
        Width  := StrToInt(ConfigList.Values['dot.width']);
        Height := StrToInt(ConfigList.Values['dot.height']);
        Handle := ImageList_LoadImage(hLib, RN_DOT, Width, AllocBy, CLR_DEFAULT,
          IMAGE_BITMAP, LR_CREATEDIBSECTION);
        Result := Result and (Handle <> 0);
      end;
      }
      C.Bubble.X   := StrToInt(ConfigList.Values['bubble.x']); { do not localize }
      C.Bubble.Y   := StrToInt(ConfigList.Values['bubble.y']); { do not localize }
      C.Latency.X  := StrToInt(ConfigList.Values['latency.x']); { do not localize }
      C.Latency.Y  := StrToInt(ConfigList.Values['latency.y']); { do not localize }
      C.Info.X     := StrToInt(ConfigList.Values['info.x']); { do not localize }
      C.Info.Y     := StrToInt(ConfigList.Values['info.y']); { do not localize }
      C.Title.X    := StrToInt(ConfigList.Values['title.x']); { do not localize }
      C.Title.Y    := StrToInt(ConfigList.Values['title.y']); { do not localize }
      C.Status.X   := StrToInt(ConfigList.Values['status.x']); { do not localize }
      C.Status.Y   := StrToInt(ConfigList.Values['status.y']); { do not localize }
      C.Password.X := StrToInt(ConfigList.Values['password.x']); { do not localize }
      C.Password.Y := StrToInt(ConfigList.Values['password.y']); { do not localize }
      C.CM.X       := StrToInt(ConfigList.Values['cm.x']); { do not localize }
      C.CM.Y       := StrToInt(ConfigList.Values['cm.y']); { do not localize }
      C.GameLabel.X  := StrToInt(ConfigList.Values['label.x']); { do not localize }
      C.GameLabel.Y  := StrToInt(ConfigList.Values['label.y']); { do not localize }
      C.BubbleHSpacing := StrToInt(ConfigList.Values['bubble.hspacing']); { do not localize }
      C.BubbleVSpacing := StrToInt(ConfigList.Values['bubble.vspacing']); { do not localize }

      Age2Lobby.LoadFromResourceName(hLib, RN_AGE2XLOBBY);
      LogoBitmap.LoadFromResourceName(hLib, RN_LOGO);
      BannerBitmap.LoadFromResourceName(hLib, RN_BANNER);
      SplashBitmap.LoadFromResourceName(hLib, RN_SPLASH);
      RoomBitmap.LoadFromResourceName(hLib, RN_ROOMBKG);
      LockBitmap.LoadFromResourceName(hLib, RN_LOCK);
      LockBitmap.TransparentColor := clFuchsia;
      LockBitmap.Transparent := True;
      ChatBitmap.LoadFromResourceName(hLib, RN_CHAT);
    except
      Result := False;
      Exit;
    end;
  finally
    ConfigList.Free;
    FreeLibrary(hLib);
  end;
end;

procedure TAppDataModule.DataModuleCreate(Sender: TObject);
begin
  Age2Lobby := TBitmap.Create;
  LogoBitmap := TBitmap.Create;
  BannerBitmap := TBitmap.Create;
  SplashBitmap := TBitmap.Create;
  RoomBitmap := TBitmap.Create;
  LockBitmap := TBitmap.Create;
  ChatBitmap := TBitmap.Create;
  C := TConfig.Create;
  if not LoadResources(ExtractFilePath(ParamStr(0) + RESOURCES_FILE)) then
    Halt;
end;

procedure TAppDataModule.DataModuleDestroy(Sender: TObject);
begin
  Age2Lobby.Free;
  LogoBitmap.Free;
  BannerBitmap.Free;
  SplashBitmap.Free;
  RoomBitmap.Free;
  LockBitmap.Free;
  ChatBitmap.Free;
  C.Free;
end;

end.
