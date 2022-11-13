{
  Part of a demo project for VIBinData.dll.

  Copyright (c) 2022, Peter D Johnson (https://delphidabbler.com).

  MIT License: https://delphidabbler.mit-license.org/2022-/
}

program VIReaderDemo;

uses
  Vcl.Forms,
  FmVIReaderDemo in 'FmVIReaderDemo.pas' {VIReaderDemoForm},
  IntfBinaryVerInfo in '..\..\Src\Exports\IntfBinaryVerInfo.pas',
  ULogger in '..\Shared\ULogger.pas',
  UVerInfoFileStream in 'UVerInfoFileStream.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TVIReaderDemoForm, VIReaderDemoForm);
  Application.Run;
end.
