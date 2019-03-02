object MessageForm: TMessageForm
  Left = 422
  Top = 336
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ZoneMessage'
  ClientHeight = 184
  ClientWidth = 356
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
  object BkgImage: TImage
    Left = 0
    Top = 0
    Width = 354
    Height = 180
  end
  object FromLabel: TLabel
    Left = 16
    Top = 12
    Width = 26
    Height = 13
    Caption = 'From:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object UsernameLabel: TLabel
    Left = 16
    Top = 28
    Width = 48
    Height = 13
    Caption = 'Username'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object SentLabel: TLabel
    Left = 128
    Top = 12
    Width = 69
    Height = 13
    Caption = 'Message sent:'
    Transparent = True
  end
  object MsgLabel: TLabel
    Left = 136
    Top = 28
    Width = 201
    Height = 41
    AutoSize = False
    Transparent = True
    WordWrap = True
  end
  object InfoLabel: TLabel
    Left = 128
    Top = 72
    Width = 120
    Height = 13
    Caption = 'Type your response here:'
    Transparent = True
  end
  object Label3: TLabel
    Left = 4
    Top = 53
    Width = 60
    Height = 13
    Caption = 'Add &Friend'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object MessageMemo: TMemo
    Left = 128
    Top = 88
    Width = 209
    Height = 49
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    MaxLength = 130
    ParentCtl3D = False
    TabOrder = 0
    WantReturns = False
    OnKeyDown = MessageMemoKeyDown
  end
  object JvPanel1: TJvPanel
    Left = 272
    Top = 148
    Width = 65
    Height = 18
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    FlatBorder = True
    FlatBorderColor = clBlack
    BevelOuter = bvNone
    BorderWidth = 1
    Color = 6449199
    TabOrder = 1
    object CloseLabel: TLabel
      Left = 1
      Top = 1
      Width = 63
      Height = 16
      Align = alClient
      Alignment = taCenter
      Caption = '&Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      OnClick = CloseLabelClick
    end
  end
  object JvPanel2: TJvPanel
    Left = 200
    Top = 148
    Width = 65
    Height = 18
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    FlatBorder = True
    FlatBorderColor = clBlack
    BevelOuter = bvNone
    BorderWidth = 1
    Color = 6449199
    TabOrder = 2
    object ReplyLabel: TLabel
      Left = 1
      Top = 1
      Width = 63
      Height = 16
      Align = alClient
      Alignment = taCenter
      Caption = '&Reply'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      OnClick = ReplyLabelClick
    end
  end
end
