object InfoDlg: TInfoDlg
  Left = 510
  Top = 248
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 142
  ClientWidth = 251
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TitleLabel: TLabel
    Left = 0
    Top = 24
    Width = 249
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Launching Game'
  end
  object MessageLabel: TLabel
    Left = 0
    Top = 64
    Width = 249
    Height = 41
    Alignment = taCenter
    AutoSize = False
    Caption = 'Message'
    WordWrap = True
  end
  object Btn: TButton
    Left = 88
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = BtnClick
  end
end
