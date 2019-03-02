object AboutForm: TAboutForm
  Left = 421
  Top = 304
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 114
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IcoImage: TImage
    Left = 24
    Top = 24
    Width = 32
    Height = 32
  end
  object AppLabel: TLabel
    Left = 72
    Top = 24
    Width = 80
    Height = 13
    Caption = 'Lobby Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AboutLabel: TLabel
    Left = 72
    Top = 40
    Width = 38
    Height = 13
    Caption = 'Author'
  end
  object OKBtn: TButton
    Left = 136
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
end
