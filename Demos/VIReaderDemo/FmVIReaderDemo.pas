{
  Part of a demo project for VIBinData.dll.

  Copyright (c) 2022, Peter D Johnson (https://gravatar.com/delphidabbler).

  MIT License: https://delphidabbler.mit-license.org/2022-/
}

unit FmVIReaderDemo;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ActiveX,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls,

  // Interface to read/write version info objext in DLL
  IntfBinaryVerInfo,

  // Class for extracting version information resources from an executable file
  // or DLL. Provides a read-onle TStream inerface to the version information
  // data.
  UVerInfoFileStream,

  // Logger class
  ULogger;

type
  TVIReaderDemoForm = class(TForm)
    bvlDescription: TBevel;
    lblDescription: TLabel;
    btnOpenExeOrDLL: TButton;
    dlgExePath: TFileOpenDialog;
    memoView: TMemo;
    lblDesc: TLabel;
    lblExePath: TLabel;
    procedure btnOpenExeOrDLLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  strict private
    var
      fDLL: THandle;
      fVI: IVerInfoBinaryReader;
      fCreateFunc: TVerInfoBinaryCreateFunc;
      fLog: TLogger;
    procedure LoadVersionInfo(const FilePath: string);
    procedure DisplayVersionInfo;
    procedure Check(Res: HRESULT); inline;
    function FormatVersion(MS, LS: LongWord): string; overload; inline;
    function FormatVersion(V: LongWord): string; overload; inline;
  public
  end;

var
  VIReaderDemoForm: TVIReaderDemoForm;

implementation

{$R *.dfm}

procedure TVIReaderDemoForm.btnOpenExeOrDLLClick(Sender: TObject);
begin
  // Get file from user
  if not dlgExePath.Execute then
    Exit;
  lblExePath.Caption := dlgExePath.FileName;
  // Load and display version information
  LoadVersionInfo(dlgExePath.FileName);
  DisplayVersionInfo;
end;

procedure TVIReaderDemoForm.Check(Res: HRESULT);
begin
  // Check return value from methods that call into VIBinData.dll objects
  if Failed(Res) then
    raise Exception.Create('IVerInfoBinaryReader method call failed');
end;

procedure TVIReaderDemoForm.DisplayVersionInfo;
begin
  memoView.Lines.BeginUpdate;
  try
    memoView.Clear;
    // Get and display Fixed File Information
    var FFI: TVSFixedFileInfo;
    Check(fVI.GetFixedFileInfo(FFI));
    fLog.Log('FFI');
    fLog.Log('dwSignature', FFI.dwSignature, HexC);
    fLog.Log('dwStrucVersion', FFI.dwStrucVersion, HexC);
    fLog.Log('dwFileVersionMS', FFI.dwFileVersionMS, HexC);
    fLog.Log('dwFileVersionLS', FFI.dwFileVersionLS, HexC);
    fLog.Log('dwProductVersionMS', FFI.dwProductVersionMS, HexC);
    fLog.Log('dwProductVersionLS', FFI.dwProductVersionLS, HexC);
    fLog.Log('dwFileFlagsMask', FFI.dwFileFlagsMask, HexC);
    fLog.Log('dwFileFlags', FFI.dwFileFlags, HexC);
    fLog.Log('dwFileOS', FFI.dwFileOS, HexC);
    fLog.Log('dwFileType', FFI.dwFileType, HexC);
    fLog.Log('dwFileSubtype', FFI.dwFileSubtype, HexC);
    fLog.Log('dwFileDateMS', FFI.dwFileDateMS);
    fLog.Log('dwFileDateLS', FFI.dwFileDateLS);
    fLog.Log;

    // Display some FFI fields in a more human readable way
    fLog.Log('Interpretation of some FFI fields');
    fLog.Log('Structure version',  FormatVersion(FFI.dwStrucVersion));
    fLog.Log(
      'FileVersion',
      FormatVersion(FFI.dwFileVersionMS, FFI.dwFileVersionLS)
    );
    fLog.Log(
      'ProductVersion',
      FormatVersion(FFI.dwProductVersionMS, FFI.dwProductVersionLS)
    );
    fLog.Log;

    // Display translation(s)
    fLog.Log('Translations');
    var TransCount: Integer;
    Check(fVI.GetTranslationCount(TransCount));
    fLog.Log('Translation count', TransCount);
    for var Idx := 0 to Pred(TransCount) do
    begin
      var TransCode: TTranslationCode;
      Check(fVI.GetTranslation(Idx, TransCode));
      var TransStr: WideString;
      Check(fVI.GetTranslationAsString(Idx, TransStr));
      fLog.Log('Translation #', Idx);
      fLog.Log('Translation string', TransStr);
      fLog.Log('Translation code', TransCode.Code, HexC);
      fLog.Log('Translation language ID', TransCode.LanguageID, HexC);
      fLog.Log('Translation character set', TransCode.CharSet, HexC);
    end;
    fLog.Log;

    // Display string table(s)
    fLog.Log('String tables');
    var TblCount: Integer;
    Check(fVI.GetStringTableCount(TblCount));
    fLog.Log('String table count', TblCount);
    for var TblIdx := 0 to Pred(TblCount) do
    begin
      fLog.Log;
      var StrCount: Integer;
      Check(fVI.GetStringCount(TblIdx, StrCount));
      var TblTransStr: WideString;
      Check(fVI.GetStringTableTransString(TblIdx, TblTransStr));
      var TblTransCode: TTranslationCode;
      Check(fVI.GetStringTableTransCode(TblIdx, TblTransCode));
      fLog.Log('String table #', TblIdx);
      fLog.Log('String table tanslation string', TblTransStr);
      fLog.Log('String table translation code', TblTransCode.Code);
      fLog.Log('String table language ID', TblTransCode.LanguageID);
      fLog.Log('String table character set', TblTransCode.CharSet);
      fLog.Log('String count', StrCount);
      fLog.Log;
      // Display strings in a string table
      for var StrIdx := 0 to Pred(StrCount) do
      begin
        var StrName, StrValue: WideString;
        Check(fVI.GetStringName(TblIdx, StrIdx, StrName));
        Check(fVI.GetStringValue(TblIdx, StrIdx, StrValue));
        fLog.Log('String #', StrIdx);
        fLog.Log('String name=value', StrName + '=' + StrValue);
      end;
    end;
    fLog.Log;
  finally
    memoView.Lines.EndUpdate;
  end;
end;

function TVIReaderDemoForm.FormatVersion(MS, LS: LongWord): string;
begin
  // Format version information encoded in two 32 bit word values
  Result := FormatVersion(MS) + '.' + FormatVersion(LS);
end;

function TVIReaderDemoForm.FormatVersion(V: LongWord): string;
begin
  // Format version information encoded in a 32 bit word value
  Result := Format('%d.%d', [LongRec(V).Hi, LongRec(V).Lo]);
end;

procedure TVIReaderDemoForm.FormCreate(Sender: TObject);
begin
  // Load VIBinData.dll
  // This DLL should be compiled in the main project and the DLL should then be
  // copied into the same directory as this demo's .exe. file.
  fDLL := SafeLoadLibrary('VIBinData');
  if fDLL = 0 then
    raise Exception.Create('Can''t load VIBinData.dll');

  // Get instance of object from DLL that provides read-only access to 32 bit
  // version information
  // 1st load the CreateInstance function from the DLL
  fCreateFunc := GetProcAddress(fDLL, 'CreateInstance');
  if not Assigned(fCreateFunc) then
    raise Exception.Create('Can''t load "CreateInstance" function from DLL');
  // now create required 32 bit read only object
  if Failed(fCreateFunc(fVI)) then
    raise Exception.Create('Can''t instantiate required object in DLL');

  fLog := TLogger.Create(memoView, 32);
end;

procedure TVIReaderDemoForm.FormDestroy(Sender: TObject);
begin
  fLog.Free;
  // Ensure version info object freed before releasing the DLL
  fVI := nil;
  if fDLL <> 0 then
    FreeLibrary(fDLL);
end;

procedure TVIReaderDemoForm.LoadVersionInfo(const FilePath: string);
begin
  // Load version information from specified execuatable file / DLL
  // We read the version information from the specified file's resources using
  // TStream object. But IVerInfoBinaryReader reads data from an IStream, not a
  // TStream, so we use TStreamAdapter to get an IStream interface to the
  // TStream.
  var VIFS := TVerInfoFileStream.Create(FilePath);
  try
    var Stm: IStream := TStreamAdapter.Create(VIFS, soReference);
    fVI.ReadFromStream(Stm);
  finally
    VIFS.Free;
  end;
end;

end.
