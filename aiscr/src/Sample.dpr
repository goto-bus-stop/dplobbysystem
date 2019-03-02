program Sample;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uPresetDataForm in 'uPresetDataForm.pas' {PresetDataForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
