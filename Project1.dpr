program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  Unit2 in 'Unit2.pas' {Form2},
  UfrmSettings in 'UfrmSettings.pas' {frmSettings},
  UMyStringUtils in 'UMyStringUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SND Release Packer 2.1';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
