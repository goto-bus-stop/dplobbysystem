object GameParamsForm: TGameParamsForm
  Left = 369
  Top = 278
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Game Parameters'
  ClientHeight = 254
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TitleLabel: TLabel
    Left = 20
    Top = 50
    Width = 62
    Height = 13
    Caption = '&Game Name:'
  end
  object DescLabel: TLabel
    Left = 20
    Top = 82
    Width = 85
    Height = 13
    Caption = 'Game &description:'
  end
  object MaxPlayersLabel: TLabel
    Left = 20
    Top = 168
    Width = 84
    Height = 13
    Caption = '&Maximum Players:'
  end
  object PwdLabel: TLabel
    Left = 20
    Top = 220
    Width = 49
    Height = 13
    Caption = 'Pass&word:'
  end
  object Label1: TLabel
    Left = 20
    Top = 18
    Width = 31
    Height = 13
    Caption = '&Game:'
  end
  object TitleEdit: TEdit
    Left = 91
    Top = 48
    Width = 206
    Height = 21
    MaxLength = 100
    TabOrder = 0
  end
  object MPEdit: TEdit
    Left = 115
    Top = 164
    Width = 30
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = '8'
  end
  object UpDown: TUpDown
    Left = 145
    Top = 164
    Width = 16
    Height = 21
    Associate = MPEdit
    Min = 2
    Max = 8
    Position = 8
    TabOrder = 3
  end
  object PrivateCheckBox: TCheckBox
    Left = 20
    Top = 196
    Width = 97
    Height = 17
    Caption = '&Private game'
    TabOrder = 4
    OnClick = PrivateCheckBoxClick
  end
  object PwdEdit: TEdit
    Left = 75
    Top = 216
    Width = 222
    Height = 21
    PasswordChar = '*'
    TabOrder = 5
  end
  object OKBtn: TButton
    Left = 320
    Top = 16
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 6
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 320
    Top = 48
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object DescRichEdit: TRichEdit
    Left = 20
    Top = 100
    Width = 277
    Height = 51
    MaxLength = 300
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object BlockCheckBox: TCheckBox
    Left = 192
    Top = 168
    Width = 113
    Height = 17
    Caption = 'Block quick joiners'
    Enabled = False
    TabOrder = 8
  end
  object DPApplicationsComboBox: TComboBox
    Left = 64
    Top = 16
    Width = 233
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 9
    OnChange = DPApplicationsComboBoxChange
  end
  object OptionsBtn: TButton
    Left = 312
    Top = 216
    Width = 83
    Height = 25
    Caption = 'Game Options'
    TabOrder = 10
    OnClick = OptionsBtnClick
  end
end
