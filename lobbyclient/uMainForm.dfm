object MainForm: TMainForm
  Left = 277
  Top = 128
  Width = 811
  Height = 568
  Caption = 'Lobby Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object VSplitter: TSplitter
    Left = 604
    Top = 112
    Width = 6
    Height = 398
    Align = alRight
    OnCanResize = VSplitterCanResize
    OnMoved = VSplitterMoved
  end
  object RightPanel: TPanel
    Left = 610
    Top = 112
    Width = 185
    Height = 398
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    object PlayersTreeView: TJvTreeView
      Left = 0
      Top = 25
      Width = 185
      Height = 373
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBlack
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HotTrack = True
      Indent = 15
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = PlayerPopupMenu
      ReadOnly = True
      ShowButtons = False
      ShowHint = False
      ShowLines = False
      ShowRoot = False
      TabOrder = 0
      OnCollapsed = PlayersTreeViewCollapsed
      OnContextPopup = PlayersTreeViewContextPopup
      OnCustomDrawItem = PlayersTreeViewCustomDrawItem
      OnExpanded = PlayersTreeViewCollapsed
      OnMouseMove = PlayersTreeViewMouseMove
      OnMouseUp = PlayersTreeViewMouseUp
      LineColor = 13160660
      OnHorizontalScroll = PlayersTreeViewHorizontalScroll
      OnMouseLeave = PlayersTreeViewMouseLeave
    end
    object SortPanel: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 25
      Align = alTop
      BevelInner = bvRaised
      Caption = '+ Name / - Rating / - Ping'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = SortPanelClick
      OnMouseDown = SortPanelMouseDown
      OnMouseUp = SortPanelMouseUp
    end
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 795
    Height = 28
    ButtonHeight = 19
    ButtonWidth = 65
    EdgeBorders = [ebTop, ebBottom]
    Flat = True
    List = True
    ShowCaptions = True
    TabOrder = 0
    object QuickHostBrn: TToolButton
      Left = 0
      Top = 0
      Caption = 'Quick Host'
      ImageIndex = 0
      OnClick = QuickHostBrnClick
    end
    object QuickJoinBtn: TToolButton
      Left = 65
      Top = 0
      Caption = 'Quick Join'
      ImageIndex = 1
      OnClick = QuickJoinBtnClick
    end
    object SeparatorBtn: TToolButton
      Left = 130
      Top = 0
      Width = 8
      Caption = 'SeparatorBtn'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object TableViewBtn: TToolButton
      Left = 138
      Top = 0
      Caption = 'Table View'
      Down = True
      Grouped = True
      ImageIndex = 2
      Style = tbsCheck
    end
    object ListViewBtn: TToolButton
      Left = 203
      Top = 0
      Caption = 'List View'
      Enabled = False
      Grouped = True
      ImageIndex = 3
      Style = tbsCheck
    end
    object ToolButton1: TToolButton
      Left = 268
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object GamesToolBtn: TToolButton
      Left = 276
      Top = 0
      AutoSize = True
      Caption = 'Games'
      Down = True
      Grouped = True
      Style = tbsCheck
      OnClick = GamesToolBtnClick
    end
    object TeamizerToolBtn: TToolButton
      Left = 320
      Top = 0
      AutoSize = True
      Caption = 'Teamizer'
      Grouped = True
      Style = tbsCheck
      OnClick = TeamizerToolBtnClick
    end
    object BrowserToolBtn: TToolButton
      Left = 374
      Top = 0
      AutoSize = True
      Caption = 'Browser'
      Grouped = True
      Style = tbsCheck
      OnClick = BrowserToolBtnClick
    end
  end
  object MainPanel: TPanel
    Left = 0
    Top = 112
    Width = 604
    Height = 398
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object HSplitter: TSplitter
      Left = 0
      Top = 181
      Width = 604
      Height = 6
      Cursor = crVSplit
      Align = alBottom
    end
    object BottomPanel: TJvPanel
      Left = 0
      Top = 187
      Width = 604
      Height = 211
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      FlatBorder = True
      FlatBorderColor = 10066278
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 4
      TabOrder = 0
      object ChatSplitter: TSplitter
        Left = 4
        Top = 162
        Width = 596
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        Color = 10066278
        ParentColor = False
      end
      object ChatPanel: TPanel
        Left = 4
        Top = 166
        Width = 596
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object EmotImage: TJvImage
          Left = 49
          Top = 0
          Width = 49
          Height = 41
          Align = alLeft
        end
        object SendImage: TJvImage
          Left = 553
          Top = 0
          Width = 43
          Height = 41
          Align = alRight
          OnClick = SendImageClick
        end
        object FontImage: TJvImage
          Left = 0
          Top = 0
          Width = 49
          Height = 41
          Align = alLeft
          OnClick = FontImageClick
        end
        object ChatEdit: TEdit
          Left = 128
          Top = 16
          Width = 121
          Height = 21
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnKeyDown = ChatEditKeyDown
        end
      end
      object ChatRichEdit: TJvRichEdit
        Left = 4
        Top = 4
        Width = 596
        Height = 158
        Align = alClient
        ClipboardCommands = [caCopy, caCut, caPaste, caClear]
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object JvPageControl: TJvPageControl
      Left = 0
      Top = 0
      Width = 604
      Height = 181
      ActivePage = GamesTab
      Align = alClient
      TabOrder = 1
      TabPosition = tpBottom
      ClientBorderWidth = 0
      ParentColor = False
      Color = clBtnFace
      object GamesTab: TTabSheet
        object GamesListView: TMyJvListView
          Left = 0
          Top = 0
          Width = 604
          Height = 163
          Align = alClient
          Columns = <>
          IconOptions.AutoArrange = True
          PopupMenu = GamesPopupMenu
          TabOrder = 0
          OnContextPopup = GamesListViewContextPopup
          OnCustomDrawItem = GamesListViewCustomDrawItem
          OnMouseDown = GamesListViewMouseDown
          OnMouseMove = GamesListViewMouseMove
          OnMouseUp = GamesListViewMouseUp
          OnSelectItem = GamesListViewSelectItem
          AutoSelect = False
          Groups = <>
          OnMouseLeave = GamesListViewMouseLeave
          ExtendedColumns = <>
        end
      end
      object TeamizerTab: TTabSheet
        ImageIndex = 1
        object TeamizeInfoLabel: TLabel
          Left = 432
          Top = 16
          Width = 161
          Height = 121
          AutoSize = False
          Caption = 'TeamizeInfo'
          WordWrap = True
        end
        object PlayersGroupBox: TGroupBox
          Left = 16
          Top = 8
          Width = 401
          Height = 135
          Caption = ' Players '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object P5Edit: TEdit
            Left = 16
            Top = 72
            Width = 121
            Height = 21
            TabOrder = 2
          end
          object P1Edit: TEdit
            Left = 16
            Top = 24
            Width = 121
            Height = 21
            TabOrder = 0
          end
          object P3Edit: TEdit
            Left = 16
            Top = 48
            Width = 121
            Height = 21
            TabOrder = 1
          end
          object P7Edit: TEdit
            Left = 16
            Top = 96
            Width = 121
            Height = 21
            TabOrder = 3
          end
          object P2Edit: TEdit
            Left = 216
            Top = 24
            Width = 121
            Height = 21
            TabOrder = 4
          end
          object P4Edit: TEdit
            Left = 216
            Top = 48
            Width = 121
            Height = 21
            TabOrder = 5
          end
          object P6Edit: TEdit
            Left = 216
            Top = 72
            Width = 121
            Height = 21
            TabOrder = 6
          end
          object P8Edit: TEdit
            Left = 216
            Top = 96
            Width = 121
            Height = 21
            TabOrder = 7
          end
          object R1Edit: TEdit
            Left = 144
            Top = 24
            Width = 41
            Height = 21
            TabOrder = 8
          end
          object R3Edit: TEdit
            Left = 144
            Top = 48
            Width = 41
            Height = 21
            TabOrder = 9
          end
          object R5Edit: TEdit
            Left = 144
            Top = 72
            Width = 41
            Height = 21
            TabOrder = 10
          end
          object R7Edit: TEdit
            Left = 144
            Top = 96
            Width = 41
            Height = 21
            TabOrder = 11
          end
          object R2Edit: TEdit
            Left = 344
            Top = 24
            Width = 41
            Height = 21
            TabOrder = 12
          end
          object R4Edit: TEdit
            Left = 344
            Top = 48
            Width = 41
            Height = 21
            TabOrder = 13
          end
          object R6Edit: TEdit
            Left = 344
            Top = 72
            Width = 41
            Height = 21
            TabOrder = 14
          end
          object R8Edit: TEdit
            Left = 344
            Top = 96
            Width = 41
            Height = 21
            TabOrder = 15
          end
        end
        object TeamizeBtn: TButton
          Left = 344
          Top = 154
          Width = 75
          Height = 25
          Caption = 'Teamize'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = TeamizeBtnClick
        end
      end
      object BrowserTab: TTabSheet
        ImageIndex = 2
        object WebBrowser: TWebBrowser
          Left = 0
          Top = 0
          Width = 591
          Height = 163
          Align = alClient
          TabOrder = 0
          ControlData = {
            4C000000153D0000D91000000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126200000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
  end
  object TopPanel: TPanel
    Left = 0
    Top = 28
    Width = 795
    Height = 84
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 2
    object BannerImage: TImage
      Left = 285
      Top = 0
      Width = 510
      Height = 84
      Align = alRight
      AutoSize = True
    end
    object LogoImage: TImage
      Left = 0
      Top = 0
      Width = 120
      Height = 84
      Align = alLeft
      AutoSize = True
    end
  end
  object MainMenu: TMainMenu
    Left = 632
    Top = 144
    object Room1: TMenuItem
      Caption = '&Room'
      object QuickHost1: TMenuItem
        Caption = 'Quick &Host...'
      end
      object QuickJoin1: TMenuItem
        Caption = 'Quick &Join...'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object UnignoreAll1: TMenuItem
        Caption = '&Unignore All'
        OnClick = UnignoreAll1Click
      end
      object EnableAllTips1: TMenuItem
        Caption = 'Enable All &Tips'
        OnClick = EnableAllTips1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object ChatOptions1: TMenuItem
        Caption = '&Chat Options...'
        OnClick = ChatOptions1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object ViewToolbar1: TMenuItem
        Caption = '&View Toolbar'
        Checked = True
        OnClick = ViewToolbar1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object TableView1: TMenuItem
        Caption = '&Table View'
        Checked = True
        Enabled = False
      end
      object ListView1: TMenuItem
        Caption = '&List View'
        Enabled = False
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object SortUsersbyLatency1: TMenuItem
        Caption = 'Sort Users by L&atency'
        OnClick = SortUsersbyLatency1Click
      end
      object SortUsersbyName1: TMenuItem
        Caption = 'Sort Users by &Name'
        OnClick = SortUsersbyLatency1Click
      end
      object SortUsersbyRating1: TMenuItem
        Caption = 'Sort Users by &Rating'
        OnClick = SortUsersbyLatency1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object ClientOptions1: TMenuItem
        Caption = 'Client Options...'
        OnClick = ClientOptions1Click
      end
      object UseWidescreenPatch1: TMenuItem
        Caption = 'Use Widescreen Patch'
        OnClick = UseWidescreenPatch1Click
      end
    end
    object Zone1: TMenuItem
      Caption = 'Zone'
      object SendZoneMessage1: TMenuItem
        Caption = 'Send &Zone Message...'
        Enabled = False
      end
      object ViewProfiles1: TMenuItem
        Caption = 'View &Profiles...'
        Enabled = False
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object GameHelp1: TMenuItem
        Caption = 'Game &Help...'
        Enabled = False
        ShortCut = 112
      end
      object ZoneSupport1: TMenuItem
        Caption = '&Zone Support...'
        Enabled = False
      end
      object CodeofConduct1: TMenuItem
        Caption = '&Code of Conduct...'
        Enabled = False
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object AboutRoom1: TMenuItem
        Caption = '&About Room...'
        OnClick = AboutRoom1Click
      end
    end
  end
  object PlayerPopupMenu: TPopupMenu
    AutoPopup = False
    OnPopup = PlayerPopupMenuPopup
    Left = 664
    Top = 145
    object Profile1: TMenuItem
      Caption = '&Profile'
      OnClick = Profile1Click
    end
    object SendMessage1: TMenuItem
      Caption = '&Send Message'
      OnClick = SendMessage1Click
    end
    object AddtoFriends1: TMenuItem
      Caption = 'Add to &Friends'
      OnClick = AddtoFriends1Click
    end
    object Ignore1: TMenuItem
      Caption = '&Ignore'
      OnClick = Ignore1Click
    end
  end
  object IdIRC: TIdIRC
    MaxLineAction = maException
    ReadTimeout = 0
    Nick = 'Nick'
    AltNick = 'OtherNick'
    Username = 'username'
    RealName = 'Real name'
    Replies.Version = 'TIdIRC 1.061 by Steve Williams'
    Replies.ClientInfo = 
      'TIdIRC 1.061 by Steve Williams Non-visual component for 32-bit D' +
      'elphi.'
    UserMode = []
    OnMessage = IdIRCMessage
    OnJoin = IdIRCJoin
    OnJoined = IdIRCJoined
    OnPart = IdIRCPart
    OnParted = IdIRCParted
    OnQuit = IdIRCQuit
    OnNames = IdIRCNames
    OnPingPong = IdIRCPingPong
    OnError = IdIRCError
    OnSystem = IdIRCSystem
    OnStateChange = IdIRCStateChange
    Left = 128
    Top = 32
  end
  object TimeoutTimer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = TimeoutTimerTimer
    Left = 160
    Top = 32
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 12
    MaxFontSize = 8
    Options = [fdForceFontExist, fdLimitSize]
    Left = 192
    Top = 32
  end
  object GamesTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = GamesTimerTimer
    Left = 224
    Top = 32
  end
  object GamesPopupMenu: TPopupMenu
    Left = 256
    Top = 36
    object Teamize1: TMenuItem
      Caption = 'Teamize'
      OnClick = Teamize1Click
    end
  end
end
