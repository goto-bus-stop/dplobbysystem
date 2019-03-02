unit uPresetDataForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst, JvExStdCtrls, JvGroupBox, Buttons,
  DPlay;

type
  TPresetDataForm = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MapsListBox: TCheckListBox;
    CB1: TCheckBox;
    CB2: TCheckBox;
    CB3: TCheckBox;
    CB4: TCheckBox;
    CB5: TCheckBox;
    CB6: TCheckBox;
    CB7: TCheckBox;
    CB8: TCheckBox;
    CB9: TCheckBox;
    CB10: TCheckBox;
    CBX10: TComboBox;
    CBX9: TComboBox;
    CBX8: TComboBox;
    CBX7: TComboBox;
    CBX6: TComboBox;
    CBX5: TComboBox;
    CBX4: TComboBox;
    CBX3: TComboBox;
    CBX2: TComboBox;
    CBX1: TComboBox;
    CB11: TCheckBox;
    CBX11: TComboBox;
    MapsCB: TCheckBox;
    CivsCB: TCheckBox;
    CivsListBox: TCheckListBox;
    OptionsGroupBox: TJvGroupBox;
    TTCB: TCheckBox;
    ATCB: TCheckBox;
    ACCB: TCheckBox;
    LTCB: TCheckBox;
    FNLabel: TLabel;
    FNEdit: TEdit;
    FNBtn: TSpeedButton;
    LSCB: TCheckBox;
    RGCB: TCheckBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MapsCBClick(Sender: TObject);
    procedure CivsCBClick(Sender: TObject);
    procedure OptionsGroupBoxCheckBoxClick(Sender: TObject);
    procedure FNBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    FileName: String;
    Times: TStringList;
    Scores: TStringList;
    CheckBox: array[0..10] of TCheckBox;
    ComboBox: array[0..10] of TComboBox;
    procedure CheckBoxClick(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
  public
    AgePresetData: TAgePresetData;
  end;

implementation

uses
  uConsts, AOCUtils;

{$R *.dfm}

procedure TPresetDataForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  ZeroMemory(@AgePresetData, SizeOf(TAgePresetData));
  CheckBox[0] := CB1; ComboBox[0] := CBX1;
  CheckBox[1] := CB2; ComboBox[1] := CBX2;
  CheckBox[2] := CB3; ComboBox[2] := CBX3;
  CheckBox[3] := CB4; ComboBox[3] := CBX4;
  CheckBox[4] := CB5; ComboBox[4] := CBX5;
  CheckBox[5] := CB6; ComboBox[5] := CBX6;
  CheckBox[6] := CB7; ComboBox[6] := CBX7;
  CheckBox[7] := CB8; ComboBox[7] := CBX8;
  CheckBox[8] := CB9; ComboBox[8] := CBX9;
  CheckBox[9] := CB10; ComboBox[9] := CBX10;
  CheckBox[10] := CB11; ComboBox[10] := CBX11;
  for i := 0 to 10 do
  begin
    CheckBox[i].Tag := i;
    CheckBox[i].Checked := False;
    CheckBox[i].OnClick := CheckBoxClick;
    ComboBox[i].Tag := i;
    ComboBox[i].Enabled := False;
    ComboBox[i].OnChange := ComboBoxChange;
  end;
  CB11.Enabled := False;
  CBX11.Enabled := False;
  for i := 0 to MapsListBox.Items.Count - 1 do
    MapsListBox.Checked[i] := True;
  for i := 0 to CivsListBox.Items.Count - 1 do
    CivsListBox.Checked[i] := True;
  MapsCB.Checked := False;
  CivsCB.Checked := False;
  MapsListBox.Enabled := False;
  CivsListBox.Enabled := False;
  MapsListBox.ItemEnabled[mCustom] := False;

  Times := TStringList.Create;
  Scores := TStringList.Create;
  Times.AddObject('1,500 years (2:00 hr)', Pointer(1500));
  Times.AddObject('1,300 years (1:45 hr)', Pointer(1300));
  Times.AddObject('1,100 years (1:30 hr)', Pointer(1100));
  Times.AddObject('900 years (1:15 hr)', Pointer(900));
  Times.AddObject('700 years (60 min)', Pointer(700));
  Times.AddObject('500 years (40 min)', Pointer(500));
  Times.AddObject('300 years (25 min)', Pointer(300));
  for i := 4 to 14 do
    Scores.AddObject(IntToStr(i*1000), Pointer(i*1000));
end;

procedure TPresetDataForm.FormDestroy(Sender: TObject);
begin
  Times.Free;
  Scores.Free;
end;

procedure TPresetDataForm.CheckBoxClick(Sender: TObject);
var
  CB: TCheckBox;
  i: Integer;
begin
  if not (Sender is TCheckBox) then
    Exit;
  CB := (Sender as TCheckBox);
  if (CB.Tag < 0) or (CB.Tag > 10) then
    Exit;
  ComboBox[CB.Tag].Enabled := CB.Checked;
  case CB.Tag of
    0:  begin
          { Game }
          if not CB.Checked then
          begin
            CB2.Enabled := True;
            CB3.Enabled := True;
            CBX2.Enabled := CB2.Checked;
            CBX3.Enabled := CB3.Checked;
            FNLabel.Enabled := CB2.Enabled and CB2.Checked and (CBX2.ItemIndex = msCustom);
            FNEdit.Enabled := CB2.Enabled and CB2.Checked and (CBX2.ItemIndex = msCustom);
            FNBtn.Enabled := CB2.Enabled and CB2.Checked and (CBX2.ItemIndex = msCustom);
            MapsCB.Enabled := True;
            MapsListBox.Enabled := MapsCB.Checked;
          end else
            ComboBoxChange(ComboBox[CB.Tag]);
        end;
    1:  begin
          { Map Style }
          if not CB.Checked then
          begin
            FNLabel.Enabled := False;
            FNEdit.Enabled := False;
            FNBtn.Enabled := False;
            MapsCB.Enabled := True;
            MapsListBox.Enabled := MapsCB.Checked;
            for i := 0 to MapsListBox.Items.Count - 1 do
              MapsListBox.ItemEnabled[i] := True;
            MapsListBox.ItemEnabled[mCustom] := False;
          end else
            ComboBoxChange(ComboBox[CB.Tag]);
        end;
    9:  begin
          { Victory }
          if not CB.Checked then
          begin
            CheckBox[10].Enabled := False;
            ComboBox[10].Enabled := False;
          end else
          begin
            if (ComboBox[9].ItemIndex in [vTimeLimit..vScore]) then
            begin
              CheckBox[10].Enabled := True;
              ComboBox[10].Enabled := CheckBox[10].Checked;
            end;
          end;
        end;
  end;
end;

procedure TPresetDataForm.ComboBoxChange(Sender: TObject);
var
  CB: TComboBox;
  IsSelectedCustom: Boolean;
  i: Integer;
begin
  if not (Sender is TComboBox) then
    Exit;
  CB := (Sender as TComboBox);
  case CB.Tag of
    0:  begin
          { Game }
          { Disable Map Style and Size for scenario }
          CB2.Enabled := (CB.ItemIndex <> gtScenario);
          CB3.Enabled := (CB.ItemIndex <> gtScenario);
          CBX2.Enabled := CB2.Checked and (CB.ItemIndex <> gtScenario);
          CBX3.Enabled := CB3.Checked and (CB.ItemIndex <> gtScenario);
          IsSelectedCustom := CB2.Enabled and CB2.Checked and (CBX2.ItemIndex = msCustom);
          FNLabel.Enabled := (CB.ItemIndex = gtScenario) or IsSelectedCustom;
          FNEdit.Enabled := (CB.ItemIndex = gtScenario) or IsSelectedCustom;
          FNBtn.Enabled := (CB.ItemIndex = gtScenario) or IsSelectedCustom;
          MapsCB.Enabled := (CB.ItemIndex <> gtScenario);
          MapsListBox.Enabled := MapsCB.Enabled and MapsCB.Checked;
        end;
    1:  begin
          { Map Style }
          FNLabel.Enabled := (CB.ItemIndex = msCustom);
          FNEdit.Enabled := (CB.ItemIndex = msCustom);
          FNBtn.Enabled := (CB.ItemIndex = msCustom);
          case CB.ItemIndex of
            0:  begin
                  { Standard }
                  for i := 0 to MapsListBox.Items.Count - 1 do
                      MapsListBox.ItemEnabled[i] := (i in [mArabia..mNomad,
                        mRandomLandMap, mFullRandom, mBlindRandom]);
                end;
            1:  begin
                  { Real World }
                  for i := 0 to MapsListBox.Items.Count - 1 do
                      MapsListBox.ItemEnabled[i] := (i in [mIberia..mByzantinum, mCustomFullRandom]);
                end;
            2:  begin
                  { Custom }
                  for i := 0 to MapsListBox.Items.Count - 1 do
                      MapsListBox.ItemEnabled[i] := False;
                end;
          end;
          MapsCB.Enabled := (CB.ItemIndex <> msCustom);
          MapsListBox.Enabled := MapsCB.Checked and (CB.ItemIndex <> msCustom);
        end;
    9:  begin
          { Victory }
          if (CB.ItemIndex in [vTimeLimit..vScore]) then
          begin
            CB11.Enabled := True;
            if (CB.ItemIndex = vTimeLimit) then
            begin
              CB11.Caption := 'Time';
              CBX11.Items.Assign(Times);
            end else
            begin
              CB11.Caption := 'Score';
              CBX11.Items.Assign(Scores);
            end;
            if (CBX11.ItemIndex = -1) then
              CBX11.ItemIndex := 0;
          end else
          begin
            CB11.Enabled := False;
            CB11.Caption := 'Time / Score';
          end;
        end;
  end;
end;

procedure TPresetDataForm.MapsCBClick(Sender: TObject);
begin
  MapsListBox.Enabled := MapsCB.Checked;
end;

procedure TPresetDataForm.CivsCBClick(Sender: TObject);
begin
  CivsListBox.Enabled := CivsCB.Checked;
end;

procedure TPresetDataForm.OptionsGroupBoxCheckBoxClick(Sender: TObject);
begin
  if OptionsGroupBox.Checked then
    ACCB.Enabled := False;
end;

procedure TPresetDataForm.FNBtnClick(Sender: TObject);
begin
  if (CB1.Checked and (CBX1.ItemIndex = gtScenario)) or (CB2.Checked and (CBX2.ItemIndex = msCustom)) then
  begin
    with TOpenDialog.Create(Self) do
      try
        Options := Options + [ofPathMustExist, ofFileMustExist];
        if CB1.Checked and (CBX1.ItemIndex = gtScenario) then
        begin
          Filter := 'Scenario Files (*.scx)|*.scx';
          InitialDir := GetAOCSpecificPath('Scenario');
        end else
        begin
          Filter := 'Custom Map Files (*.rms)|*.rms';
          InitialDir := GetAOCSpecificPath('Random');
        end;
        if Execute then
        begin
          Self.FileName := ChangeFileExt(ExtractFileName(FileName), '');
          FNEdit.Text := ChangeFileExt(ExtractFileName(FileName), '');
        end;
      finally
        Free;
      end;
  end;
end;

procedure TPresetDataForm.OkBtnClick(Sender: TObject);
var
  i: Integer;
begin
  if CB1.Checked then
  begin
    AgePresetData.bLockGameType := 1;
    AgePresetData.bGameType := CBX1.ItemIndex;
    if (AgePresetData.bGameType = gtScenario) then
      begin
        CopyMemory(@AgePresetData.sGameFilename, @FileName[1], Length(FileName));
      end;
  end;
  if CB2.Checked then
  begin
    case CBX2.ItemIndex of
      msStandard:
        begin
          if MapsCB.Checked then
          begin
            for i := 0 to MapsListBox.Items.Count - 1 do
            begin
              if MapsListBox.ItemEnabled[i] and MapsListBox.Checked[i] then
                AgePresetData.bMapTypeAvail[i] := 1;
            end;
          end else
          begin
            for i := mArabia to mNomad do
              AgePresetData.bMapTypeAvail[i] := 1;
            AgePresetData.bMapTypeAvail[mRandomLandMap] := 1;
            AgePresetData.bMapTypeAvail[mFullRandom] := 1;
            AgePresetData.bMapTypeAvail[mBlindRandom] := 1;
          end;
        end;
      msRealWorld:
        begin
          if MapsCB.Checked then
          begin
            for i := 0 to MapsListBox.Items.Count - 1 do
            begin
              if MapsListBox.ItemEnabled[i] and MapsListBox.Checked[i] then
                AgePresetData.bMapTypeAvail[i] := 1;
            end;
          end else
          begin
            for i := mIberia to mByzantinum do
              AgePresetData.bMapTypeAvail[i] := 1;
            AgePresetData.bMapTypeAvail[mCustomFullRandom] := 1;
          end;
        end;
      msCustom:
        begin
          AgePresetData.bMapTypeAvail[mCustom] := 1;
          CopyMemory(@AgePresetData.sGameFilename, @FileName[1], Length(FileName));
        end;
    end;
    AgePresetData.bLockMapTypeAvail := 1;
  end;
  if CB3.Checked then
  begin
    AgePresetData.bLockMapSize := 1;
    AgePresetData.bMapSize := CBX3.ItemIndex;
  end;
  if CB4.Checked then
  begin
    AgePresetData.bLockDifficulty := 1;
    AgePresetData.bDifficulty := CBX4.ItemIndex;
  end;
  if CB5.Checked then
  begin
    AgePresetData.bLockResources := 1;
    AgePresetData.bResources := CBX5.ItemIndex;
  end;
  if CB6.Checked then
  begin
    AgePresetData.bLockPopulation := 1;
    AgePresetData.dPopulation := CBX6.ItemIndex;
  end;
  if CB7.Checked then
  begin
    AgePresetData.bLockGameSpeed := 1;
    AgePresetData.bGameSpeed := CBX7.ItemIndex;
  end;
  if CB8.Checked then
  begin
    AgePresetData.bLockRevealMap := 1;
    AgePresetData.bRevealMap := CBX8.ItemIndex;
  end;
  if CB9.Checked then
  begin
    AgePresetData.bLockStartingAge := 1;
    AgePresetData.bStartingAge := CBX9.ItemIndex;
  end;
  if CB10.Checked then
  begin
    AgePresetData.bLockVictory := 1;
    AgePresetData.bVictory := CBX10.ItemIndex;
    if (AgePresetData.bVictory in [2..3]) and CB11.Checked then
    begin
      AgePresetData.dTimeScore := Integer(CBX11.Items.Objects[CBX11.ItemIndex]);
      if (AgePresetData.bVictory = 2) then
        AgePresetData.dTimeScore := AgePresetData.dTimeScore * 10;
      AgePresetData.bLockTimeScore := 1;
    end;
  end;
  if OptionsGroupBox.Checked then
  begin
    AgePresetData.bLockTeamTogether := 1;
    AgePresetData.bTeamTogether := Ord(TTCB.Checked);
    AgePresetData.bLockAllTechs := 1;
    AgePresetData.bAllTechs := Ord(ATCB.Checked);
    AgePresetData.bLockLockTeams := 1;
    AgePresetData.bLockTeams := Ord(LTCB.Checked);
    AgePresetData.bLockLockSpeed := 1;
    AgePresetData.bLockSpeed := Ord(LSCB.Checked);
    AgePresetData.bLockRecordGame := 1;
    AgePresetData.bRecordGame := Ord(RGCB.Checked);
  end;
  if CivsCB.Checked then
  begin
    for i := 0 to CivsListBox.Items.Count - 1 do
      AgePresetData.bCivAvail[i+1] := Ord(CivsListBox.Checked[i]);
    AgePresetData.bLockCivAvail := 1;
  end;
end;

end.
