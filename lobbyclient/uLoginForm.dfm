object LoginForm: TLoginForm
  Left = 372
  Top = 264
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Login User'
  ClientHeight = 203
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object WaitLabel: TLabel
    Left = 88
    Top = 8
    Width = 76
    Height = 13
    Caption = 'Please wait...'
    Visible = False
  end
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 63
    Height = 13
    Caption = 'Username:'
  end
  object Label2: TLabel
    Left = 40
    Top = 72
    Width = 59
    Height = 13
    Caption = 'Password:'
  end
  object Label3: TLabel
    Left = 40
    Top = 124
    Width = 105
    Height = 13
    Cursor = crHandPoint
    Caption = 'Create an account'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Label4: TLabel
    Left = 40
    Top = 164
    Width = 148
    Height = 13
    Cursor = crHandPoint
    Caption = 'Already have an account?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label4Click
  end
  object Edit1: TEdit
    Left = 40
    Top = 40
    Width = 185
    Height = 21
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Edit2: TEdit
    Left = 40
    Top = 88
    Width = 185
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = Edit2KeyDown
  end
  object Button: TButton
    Left = 152
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 2
    OnClick = LoginButtonClick
  end
end
