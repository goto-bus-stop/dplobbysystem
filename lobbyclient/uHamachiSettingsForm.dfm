object HamachiSettingsForm: THamachiSettingsForm
  Left = 440
  Top = 253
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Hamachi Settings'
  ClientHeight = 219
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 345
    Height = 169
    Caption = ' Hamachi '
    TabOrder = 0
    object InfoLabel: TLabel
      Left = 16
      Top = 24
      Width = 321
      Height = 41
      AutoSize = False
      Caption = 'InfoLabel'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 16
      Top = 64
      Width = 123
      Height = 13
      Caption = 'Your Hamachi IP address:'
    end
    object Label3: TLabel
      Left = 16
      Top = 112
      Width = 219
      Height = 13
      Caption = 'Location of your installed Hamachi application:'
    end
    object PathBtn: TSpeedButton
      Left = 304
      Top = 126
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = PathBtnClick
    end
    object IPEdit: TEdit
      Left = 16
      Top = 80
      Width = 129
      Height = 21
      TabOrder = 0
    end
    object PathEdit: TEdit
      Left = 16
      Top = 128
      Width = 281
      Height = 21
      TabOrder = 1
    end
  end
  object OkBtn: TButton
    Left = 192
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 280
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
