{
  Part of a demo project for VIBinData.dll.

  MIT License: https://delphidabbler.mit-license.org/2022/
}

program ResRWDemo;

uses
  Vcl.Forms,
  FmResRWDemo in 'FmResRWDemo.pas' {ResRWDemoForm},
  IntfBinaryVerInfo in '..\..\Src\Exports\IntfBinaryVerInfo.pas',
  PJResFile in 'Vendor\PJResFile.pas',
  ULogger in '..\Shared\ULogger.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TResRWDemoForm, ResRWDemoForm);
  Application.Run;
end.
