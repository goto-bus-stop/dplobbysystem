object SplashForm: TSplashForm
  Left = 397
  Top = 298
  Width = 362
  Height = 313
  Caption = 'SplashForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SplashText: TLabel
    Left = 16
    Top = 232
    Width = 56
    Height = 13
    Caption = 'Splash Text'
  end
  object Bevel: TBevel
    Left = 16
    Top = 16
    Width = 325
    Height = 205
    Shape = bsFrame
  end
  object SplashImage: TImage
    Left = 18
    Top = 18
    Width = 320
    Height = 200
    AutoSize = True
  end
  object CancelBtn: TButton
    Left = 266
    Top = 248
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
end
