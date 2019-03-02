object PresetDataForm: TPresetDataForm
  Left = 470
  Top = 265
  Width = 521
  Height = 406
  Caption = 'Game Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 489
    Height = 321
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Game Settings'
      object FNLabel: TLabel
        Left = 272
        Top = 16
        Width = 45
        Height = 13
        Caption = 'Filename:'
        Enabled = False
      end
      object FNBtn: TSpeedButton
        Left = 440
        Top = 30
        Width = 23
        Height = 22
        Caption = '...'
        Enabled = False
        OnClick = FNBtnClick
      end
      object CB1: TCheckBox
        Left = 16
        Top = 18
        Width = 97
        Height = 17
        Caption = 'Game'
        TabOrder = 0
      end
      object CB2: TCheckBox
        Left = 16
        Top = 42
        Width = 97
        Height = 17
        Caption = 'Map Style'
        TabOrder = 1
      end
      object CB3: TCheckBox
        Left = 16
        Top = 66
        Width = 97
        Height = 17
        Caption = 'Size'
        TabOrder = 2
      end
      object CB4: TCheckBox
        Left = 16
        Top = 90
        Width = 97
        Height = 17
        Caption = 'Difficulty'
        TabOrder = 3
      end
      object CB5: TCheckBox
        Left = 16
        Top = 114
        Width = 97
        Height = 17
        Caption = 'Resources'
        TabOrder = 4
      end
      object CB6: TCheckBox
        Left = 16
        Top = 138
        Width = 97
        Height = 17
        Caption = 'Population'
        TabOrder = 5
      end
      object CB7: TCheckBox
        Left = 16
        Top = 162
        Width = 97
        Height = 17
        Caption = 'Game Speed'
        TabOrder = 6
      end
      object CB8: TCheckBox
        Left = 16
        Top = 186
        Width = 97
        Height = 17
        Caption = 'Reveal Map'
        TabOrder = 7
      end
      object CB9: TCheckBox
        Left = 16
        Top = 210
        Width = 97
        Height = 17
        Caption = 'Starting Age'
        TabOrder = 8
      end
      object CB10: TCheckBox
        Left = 16
        Top = 234
        Width = 97
        Height = 17
        Caption = 'Victory'
        TabOrder = 9
      end
      object CBX10: TComboBox
        Left = 104
        Top = 232
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 10
        Text = 'Standard'
        Items.Strings = (
          'Standard'
          'Conquest'
          'Time Limit'
          'Score'
          'Last Man Standing')
      end
      object CBX9: TComboBox
        Left = 104
        Top = 208
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 11
        Text = 'Standard'
        Items.Strings = (
          'Standard'
          'Dark Age'
          'Feudal Age'
          'Castle Age'
          'Imperial Age'
          'Post-Imperial Age')
      end
      object CBX8: TComboBox
        Left = 104
        Top = 184
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 12
        Text = 'Normal'
        Items.Strings = (
          'Normal'
          'Explored'
          'All Visible')
      end
      object CBX7: TComboBox
        Left = 104
        Top = 160
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 13
        Text = 'Slow'
        Items.Strings = (
          'Slow'
          'Normal'
          'Fast')
      end
      object CBX6: TComboBox
        Left = 104
        Top = 136
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 14
        Text = '25'
        Items.Strings = (
          '25'
          '50'
          '75'
          '100'
          '125'
          '150'
          '175'
          '200')
      end
      object CBX5: TComboBox
        Left = 104
        Top = 112
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 15
        Text = 'Standard'
        Items.Strings = (
          'Standard'
          'Low'
          'Medium'
          'High')
      end
      object CBX4: TComboBox
        Left = 104
        Top = 88
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 16
        Text = 'Easiest'
        Items.Strings = (
          'Easiest'
          'Standard'
          'Moderate'
          'Hard'
          'Hardest')
      end
      object CBX3: TComboBox
        Left = 104
        Top = 64
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 17
        Text = 'Tiny (2 players)'
        Items.Strings = (
          'Tiny (2 players)'
          'Small (3 players)'
          'Medium (4 players)'
          'Normal (6 players)'
          'Large (8 players)'
          'Giant')
      end
      object CBX2: TComboBox
        Left = 104
        Top = 40
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 18
        Text = 'Standard'
        Items.Strings = (
          'Standard'
          'Real World'
          'Custom')
      end
      object CBX1: TComboBox
        Left = 104
        Top = 16
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 19
        Text = 'Random Map'
        Items.Strings = (
          'Random Map'
          'Regicide'
          'Death Match'
          'Scenario'
          'King of the Hill'
          'Wonder Race'
          'Defent the Wonder'
          'Turbo Random Map')
      end
      object CB11: TCheckBox
        Left = 32
        Top = 258
        Width = 97
        Height = 17
        Caption = 'Time / Score'
        TabOrder = 20
      end
      object CBX11: TComboBox
        Left = 120
        Top = 256
        Width = 129
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 21
      end
      object OptionsGroupBox: TJvGroupBox
        Left = 272
        Top = 72
        Width = 193
        Height = 201
        Caption = 'Lock Options'
        TabOrder = 22
        Checkable = True
        Checked = False
        PropagateEnable = True
        OnCheckBoxClick = OptionsGroupBoxCheckBoxClick
        object TTCB: TCheckBox
          Left = 16
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Team Together'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 1
        end
        object ATCB: TCheckBox
          Left = 16
          Top = 48
          Width = 97
          Height = 17
          Caption = 'All Techs'
          Enabled = False
          TabOrder = 2
        end
        object ACCB: TCheckBox
          Left = 16
          Top = 72
          Width = 97
          Height = 17
          Caption = 'Allow Cheats'
          Enabled = False
          TabOrder = 3
        end
        object LTCB: TCheckBox
          Left = 16
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Lock Teams'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 4
        end
        object LSCB: TCheckBox
          Left = 16
          Top = 128
          Width = 97
          Height = 17
          Caption = 'Lock Speed'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 5
        end
        object RGCB: TCheckBox
          Left = 16
          Top = 152
          Width = 97
          Height = 17
          Caption = 'Record Game'
          Enabled = False
          TabOrder = 6
        end
      end
      object FNEdit: TEdit
        Left = 272
        Top = 32
        Width = 161
        Height = 21
        Enabled = False
        TabOrder = 23
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Available Maps && Civs'
      ImageIndex = 2
      object MapsListBox: TCheckListBox
        Left = 16
        Top = 40
        Width = 201
        Height = 241
        ItemHeight = 13
        Items.Strings = (
          'Arabia'
          'Archipelago'
          'Baltic'
          'Black Forest'
          'Coastal'
          'Continental'
          'Crater Lake'
          'Fortress'
          'Gold Rush'
          'Highland'
          'Islands'
          'Mediterranean'
          'Migration'
          'Rivers'
          'Team Islands'
          'Scandinavia'
          'Mongolia'
          'Yucatan'
          'SaltMarsh'
          'Arena'
          'Oasis'
          'Ghost Lake'
          'Nomad'
          'Iberia'
          'Britain'
          'Mideast'
          'Texas'
          'Italy'
          'Central America'
          'France'
          'Norse Lands'
          'Sea of Japan (East Sea)'
          'Byzantinum'
          'Custom'
          'Random Land Map'
          'Full Random'
          'Custom, Full Random'
          'Blind Random')
        TabOrder = 0
      end
      object MapsCB: TCheckBox
        Left = 16
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Lock Maps'
        TabOrder = 1
        OnClick = MapsCBClick
      end
      object CivsCB: TCheckBox
        Left = 240
        Top = 16
        Width = 105
        Height = 17
        Caption = 'Lock Civilizations'
        TabOrder = 2
        OnClick = CivsCBClick
      end
      object CivsListBox: TCheckListBox
        Left = 240
        Top = 40
        Width = 201
        Height = 241
        ItemHeight = 13
        Items.Strings = (
          'Britons'
          'Franks'
          'Goths'
          'Teutons'
          'Japanese'
          'Chinese'
          'Byzantines'
          'Persians'
          'Saracens'
          'Turks'
          'Vikings'
          'Mongols'
          'Celts'
          'Spanish'
          'Aztecs'
          'Mayans'
          'Huns'
          'Koreans'
          'Random')
        TabOrder = 3
      end
    end
  end
  object OkBtn: TButton
    Left = 336
    Top = 336
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 424
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
