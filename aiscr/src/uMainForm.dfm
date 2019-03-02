object MainForm: TMainForm
  Left = 192
  Top = 211
  Width = 299
  Height = 216
  Caption = 'Sample'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu: TMainMenu
    Left = 48
    Top = 32
    object HostGame1: TMenuItem
      Caption = '&Actions'
      object HostGame2: TMenuItem
        Caption = '&Host Game'
        OnClick = HostGame2Click
      end
      object RestoreGame1: TMenuItem
        Caption = '&Restore Game...'
        OnClick = RestoreGame1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
  end
end
