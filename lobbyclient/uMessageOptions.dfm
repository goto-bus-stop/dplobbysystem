object MessageOptions: TMessageOptions
  Left = 192
  Top = 181
  ActiveControl = FontNameBox
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Message Options'
  ClientHeight = 219
  ClientWidth = 458
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
    Width = 425
    Height = 153
    Caption = ' Font '
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 24
      Height = 13
      Caption = 'Font:'
    end
    object Label2: TLabel
      Left = 232
      Top = 24
      Width = 48
      Height = 13
      Caption = 'Font style:'
    end
    object Label3: TLabel
      Left = 352
      Top = 24
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
    object Label4: TLabel
      Left = 24
      Top = 72
      Width = 27
      Height = 13
      Caption = 'Color:'
    end
    object FontStyleBox: TComboBox
      Left = 232
      Top = 40
      Width = 105
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
      Items.Strings = (
        'Bold'
        'Italic'
        'Regular')
    end
    object FontSizeBox: TComboBox
      Left = 352
      Top = 40
      Width = 49
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 1
      Items.Strings = (
        '8'
        '9'
        '10'
        '11'
        '12')
    end
    object FontNameBox: TJvFontComboBox
      Left = 24
      Top = 40
      Width = 193
      Height = 22
      DroppedDownWidth = 193
      MaxMRUCount = 0
      FontName = 'MS Sans Serif'
      ItemIndex = 8
      Options = [foPreviewFont]
      Sorted = False
      TabOrder = 2
      SampleText = 'AaBbYyZz'
    end
    object FontColorBox: TJvColorComboBox
      Left = 24
      Top = 88
      Width = 105
      Height = 22
      ColorNameMap.Strings = (
        'clBlack=Black'
        'clMaroon=Maroon'
        'clGreen=Green'
        'clOlive=Olive green'
        'clNavy=Navy blue'
        'clPurple=Purple'
        'clTeal=Teal'
        'clGray=Gray'
        'clSilver=Silver'
        'clRed=Red'
        'clLime=Lime'
        'clYellow=Yellow'
        'clBlue=Blue'
        'clFuchsia=Fuchsia'
        'clAqua=Aqua'
        'clWhite=White'
        'clMoneyGreen=Money green'
        'clSkyBlue=Sky blue'
        'clCream=Cream'
        'clMedGray=Medium gray'
        'clScrollBar=Scrollbar'
        'clBackground=Desktop background'
        'clActiveCaption=Active window title bar'
        'clInactiveCaption=Inactive window title bar'
        'clMenu=Menu background'
        'clWindow=Window background'
        'clWindowFrame=Window frame'
        'clMenuText=Menu text'
        'clWindowText=Window text'
        'clCaptionText=Active window title bar text'
        'clActiveBorder=Active window border'
        'clInactiveBorder=Inactive window border'
        'clAppWorkSpace=Application workspace'
        'clHighlight=Selection background'
        'clHighlightText=Selection text'
        'clBtnFace=Button face'
        'clBtnShadow=Button shadow'
        'clGrayText=Dimmed text'
        'clBtnText=Button text'
        'clInactiveCaptionText=Inactive window title bar text'
        'clBtnHighlight=Button highlight'
        'cl3DDkShadow=Dark shadow 3D elements'
        'cl3DLight=Highlight 3D elements'
        'clInfoText=Tooltip text'
        'clInfoBk=Tooltip background'
        'clGradientActiveCaption=Gradient Active Caption'
        'clGradientInactiveCaption=Gradient Inactive Caption'
        'clHotLight=Hot Light'
        'clMenuBar=Menu Bar'
        'clMenuHighlight=Menu Highlight')
      ColorDialogText = 'Custom...'
      DroppedDownWidth = 105
      NewColorText = 'Custom'
      TabOrder = 3
    end
    object CheckBox1: TCheckBox
      Left = 24
      Top = 120
      Width = 193
      Height = 17
      Caption = 'Make all chat text look like this'
      Enabled = False
      TabOrder = 4
    end
  end
  object OkBtn: TButton
    Left = 280
    Top = 184
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 368
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
