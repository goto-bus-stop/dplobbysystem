object ClientOptions: TClientOptions
  Left = 392
  Top = 221
  Width = 427
  Height = 256
  Caption = 'Client Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 377
    Height = 145
    Caption = ' Client Options '
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 91
      Height = 13
      Caption = 'Widescreen Patch:'
    end
    object DlgBtn: TSpeedButton
      Left = 336
      Top = 38
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = DlgBtnClick
    end
    object WSPatchEdit: TEdit
      Left = 24
      Top = 40
      Width = 305
      Height = 21
      TabOrder = 0
    end
  end
  object OkBtn: TButton
    Left = 232
    Top = 176
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 320
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
