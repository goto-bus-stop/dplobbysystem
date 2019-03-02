object TipsForm: TTipsForm
  Left = 432
  Top = 300
  Width = 420
  Height = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 32
    Top = 48
    Width = 361
    Height = 33
    AutoSize = False
    Caption = 'Label2'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 32
    Top = 82
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 32
    Top = 104
    Width = 32
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 32
    Top = 126
    Width = 32
    Height = 13
    Caption = 'Label5'
  end
  object Label6: TLabel
    Left = 32
    Top = 148
    Width = 32
    Height = 13
    Caption = 'Label6'
  end
  object Label7: TLabel
    Left = 16
    Top = 188
    Width = 32
    Height = 13
    Caption = 'Label7'
  end
  object HideCheckBox: TCheckBox
    Left = 16
    Top = 228
    Width = 193
    Height = 17
    Caption = 'Don'#39't tell me about this again'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 312
    Top = 224
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKBtnClick
  end
end
