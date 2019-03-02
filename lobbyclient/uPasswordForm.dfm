object PasswordForm: TPasswordForm
  Left = 352
  Top = 224
  BorderStyle = bsDialog
  Caption = 'Private Game'
  ClientHeight = 88
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TextLabel: TLabel
    Left = 16
    Top = 16
    Width = 47
    Height = 13
    Caption = 'TextLabel'
  end
  object PwdEdit: TEdit
    Left = 16
    Top = 56
    Width = 161
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyDown = PwdEditKeyDown
  end
  object OKBtn: TButton
    Left = 208
    Top = 16
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 208
    Top = 48
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
