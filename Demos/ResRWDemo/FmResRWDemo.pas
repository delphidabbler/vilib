{
  Part of a demo project for VIBinData.dll.

  Copyright (c) 2022, Peter D Johnson (https://gravatar.com/delphidabbler).

  MIT License: https://delphidabbler.mit-license.org/2022-/
}

unit FmResRWDemo;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Mask,

  // Unit for reading / writing 32 bit resorces files from
  // https://github.com/ddablib/resfiles
  PJResFile,

  // Logger class
  ULogger,

  // Interface to read/write version info objext in DLL
  IntfBinaryVerInfo;

type
  TResRWDemoForm = class(TForm)
    lblDescription: TLabel;
    bvlDescription: TBevel;
    btnView: TButton;
    memoView: TMemo;
    btnOpen: TButton;
    btnSave: TButton;
    btnViewRaw: TButton;
    btnViewResFile: TButton;
    btnAddTranslation: TButton;
    leCharSet: TLabeledEdit;
    leLanguageID: TLabeledEdit;
    leStringName: TLabeledEdit;
    leStringValue: TLabeledEdit;
    btnDeleteTrans: TButton;
    btnIndexOfTrans: TButton;
    leTransIdx: TLabeledEdit;
    leStrTableIdx: TLabeledEdit;
    btnAddStrTable: TButton;
    btnIndexOfStrTable: TButton;
    btnDeleteStrTable: TButton;
    btnAddOrUpdateString: TButton;
    btnDeleteString: TButton;
    btnSetFFI: TButton;
    btnIndexOfString: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnViewRawClick(Sender: TObject);
    procedure btnViewResFileClick(Sender: TObject);
    procedure HexEditKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddTranslationClick(Sender: TObject);
    procedure btnDeleteTransClick(Sender: TObject);
    procedure btnIndexOfTransClick(Sender: TObject);
    procedure btnAddStrTableClick(Sender: TObject);
    procedure btnIndexOfStrTableClick(Sender: TObject);
    procedure btnDeleteStrTableClick(Sender: TObject);
    procedure btnAddOrUpdateStringClick(Sender: TObject);
    procedure btnDeleteStringClick(Sender: TObject);
    procedure btnSetFFIClick(Sender: TObject);
    procedure btnIndexOfStringClick(Sender: TObject);
  strict private
    const
      ResFileName = 'TestVI.res';
    var
      fDLL: THandle;
      // Defining fVI as IVerInfoBinary2 instead of IVerInfoBinary so we can use
      // IVerInfoBinary2.IndexOfString in the
      // TResRWDemoForm.btnIndexOfStringClick method below. All other methods f
      // IVerInfoBinary2 ar also in IVerInfoBinary
      fVI: IVerInfoBinary2;
      fCreateFunc: TVerInfoBinaryCreateFunc;
      fLog: TLogger;
    function ResFilePath: string;
    procedure Check(Res: HRESULT); inline;
    procedure ReadVIFromResourceFile;
    procedure WriteVIToResourceFile;
    function VIAsBytes: TArray<Byte>;
  public

  end;

var
  ResRWDemoForm: TResRWDemoForm;

implementation

uses
  System.IOUtils;

{$R *.dfm}

procedure TResRWDemoForm.btnAddOrUpdateStringClick(Sender: TObject);
begin
  var Name := Trim(leStringName.Text);
  var Value := leStringValue.Text;
  var TblIdx := StrToInt(leStrTableIdx.Text);
  if Name = '' then
    raise Exception.Create('String name required');
  var StrIdx: Integer;
  Check(fVI.SetOrAddString(TblIdx, Name, Value, StrIdx));
  fLog.Log(
    '### Added or updated string named "%s" to string table %d at index %d',
    [Name, TblIdx, StrIdx]
  );
  fLog.Log;
end;

procedure TResRWDemoForm.btnAddStrTableClick(Sender: TObject);
begin
  var NewIdx: Integer;
  var Code: TTranslationCode;
  Code.CharSet := StrToIntDef('$' + leCharSet.Text, $FFFF);
  Code.LanguageID := StrToIntDef('$' + leLanguageID.Text, $FFFF);
  Check(fVI.AddStringTableByCode(Code, NewIdx));
  fLog.Log('### Added string table %.8x at index %d', [Code.Code, NewIdx]);
  fLog.Log;
end;

procedure TResRWDemoForm.btnAddTranslationClick(Sender: TObject);
begin
  var NewIdx: Integer;
  var Code: TTranslationCode;
  Code.CharSet := StrToIntDef('$' + leCharSet.Text, $FFFF);
  Code.LanguageID := StrToIntDef('$' + leLanguageID.Text, $FFFF);
  Check(fVI.AddTranslation(Code, NewIdx));
  fLog.Log('### Added translation %.8x at index %d', [Code.Code, NewIdx]);
  fLog.Log;
end;

procedure TResRWDemoForm.btnDeleteStringClick(Sender: TObject);
begin
  var Name := Trim(leStringName.Text);
  var TblIdx := StrToInt(leStrTableIdx.Text);
  if Name = '' then
    raise Exception.Create('String name required');
  Check(fVI.DeleteStringByName(TblIdx, Name));
  fLog.Log(
    '### Deleted string named "%s" from string table %d', [Name, TblIdx]
  );
  fLog.Log;
end;

procedure TResRWDemoForm.btnDeleteStrTableClick(Sender: TObject);
begin
  var DelIdx: Integer := StrToInt(leStrTableIdx.Text);
  Check(fVI.DeleteStringTable(DelIdx));
  fLog.Log('### Deleted string table at index %d', [DelIdx]);
  fLog.Log;
end;

procedure TResRWDemoForm.btnDeleteTransClick(Sender: TObject);
begin
  var DelIdx: Integer := StrToInt(leTransIdx.Text);
  Check(fVI.DeleteTranslation(DelIdx));
  fLog.Log('### Deleted translation at index %d', [DelIdx]);
  fLog.Log;
end;

procedure TResRWDemoForm.btnIndexOfStringClick(Sender: TObject);
begin
  var StrTableIdx := StrToInt(leStrTableIdx.Text);
  var StrName := Trim(leStringName.Text);
  var Idx: Integer;
  // NOTE: Here we call the IndexOfString method which is defined in
  // IVerInfoBinary2, not IVerInfoBinary. We can make a direct call on fVI here
  // because it has type IVerInfoBinary2. However if fVI had been given type
  // IVerInfoBinary instead the following call would have to be written as
  //   (fVI as IVerInfoBinary2).IndexOfString(StrTableIdx, StrName, Idx)
  Check(fVI.IndexOfString(StrTableIdx, StrName, Idx));
  fLog.Log(
    '### Index of string "%s" in string table %d is %d',
    [StrName, StrTableIdx, Idx]
  );
  fLog.Log;
end;

procedure TResRWDemoForm.btnIndexOfStrTableClick(Sender: TObject);
begin
  var Idx: Integer;
  var Code: TTranslationCode;
  Code.CharSet := StrToIntDef('$' + leCharSet.Text, $FFFF);
  Code.LanguageID := StrToIntDef('$' + leLanguageID.Text, $FFFF);
  Check(fVI.IndexOfStringTableByCode(Code, Idx));
  fLog.Log('### Index of string table %.8x = %d', [Code.Code, Idx]);
  fLog.Log;
end;

procedure TResRWDemoForm.btnIndexOfTransClick(Sender: TObject);
begin
  var Idx: Integer;
  var Code: TTranslationCode;
  Code.CharSet := StrToIntDef('$' + leCharSet.Text, $FFFF);
  Code.LanguageID := StrToIntDef('$' + leLanguageID.Text, $FFFF);
  Check(fVI.IndexOfTranslation(Code, Idx));
  fLog.Log('### Index of translation %.8x = %d', [Code.Code, Idx]);
  fLog.Log;
end;

procedure TResRWDemoForm.btnOpenClick(Sender: TObject);
begin
  if TFile.Exists(ResFilePath) then
    ReadVIFromResourceFile
  else
    // File doesn't exist: just free current version info (i.e. create new file)
    fVI.Clear;
end;

procedure TResRWDemoForm.btnSaveClick(Sender: TObject);
begin
  WriteVIToResourceFile;
end;

procedure TResRWDemoForm.btnSetFFIClick(Sender: TObject);
begin
  // Set Fixed File Information to some arbitrary values
  // We're not allowing user to enter these values, just because there would
  // be many too any buttons!!
  var FFI: TVSFixedFileInfo;
  FFI.dwSignature := 0;     // will be overwritten with fixed signature
  FFI.dwStrucVersion := 0;  // will be overwritten with value meaning v1.0
  FFI.dwFileVersionMS := $00020004;
  FFI.dwFileVersionLS := $00060A76;     // file version 2.4.6.2678
  FFI.dwProductVersionMS := $07E60006;
  FFI.dwProductVersionLS := $00000000;  // product version 2022.6.0.0
  FFI.dwFileFlagsMask := VS_FF_PRIVATEBUILD or VS_FF_SPECIALBUILD;
  FFI.dwFileFlags := VS_FF_SPECIALBUILD;
  FFI.dwFileOS := VOS__WINDOWS32;
  FFI.dwFileType := VFT_APP;
  FFI.dwFileSubtype := 0;     // sub-type N/a for file type VFT_APP
  FFI.dwFileDateMS := 0;
  FFI.dwFileDateLS := 0;      // no date
  // Set the FFI
  Check(fVI.SetFixedFileInfo(FFI));
end;

procedure TResRWDemoForm.btnViewClick(Sender: TObject);
begin
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
end;

procedure TResRWDemoForm.btnViewRawClick(Sender: TObject);
begin
  fLog.Log('Version Information Raw Data');
  fLog.HexDump(VIAsBytes);
  fLog.Log;
end;

procedure TResRWDemoForm.btnViewResFileClick(Sender: TObject);
begin
  if TFile.Exists(ResFilePath) then
  begin
    fLog.Log('Resource file content');
    fLog.HexDump(TFile.ReadAllBytes(ResFilePath));
  end
  else
    fLog.Log('Resource file does not exist');
  fLog.Log;
end;

procedure TResRWDemoForm.Check(Res: HRESULT);
begin
  if Failed(Res) then
    raise Exception.Create('IVerInfoBinary method call failed');
end;

procedure TResRWDemoForm.FormCreate(Sender: TObject);
begin
  // Load VIBinData.dll
  // This DLL should be compiled in the main project and the DLL should then be
  // copied into the same directory as this demo's .exe. file.
  fDLL := SafeLoadLibrary('VIBinData');
  if fDLL = 0 then
    raise Exception.Create('Can''t load VIBinData.dll');

  // Get instance of object from DLL that can be used to read/write 32 bit
  // version information
  // 1st load the CreateInstance function from the DLL
  fCreateFunc := GetProcAddress(fDLL, 'CreateInstance');
  if not Assigned(fCreateFunc) then
    raise Exception.Create('Can''t load "CreateInstance" function from DLL');
  // now create required 32 bit R/W object
  // -- this same call to CreateInstance (via fCreateFunc) can be for objects
  //    that support IVerInfoBinary or, as in this case, IVerInfoBinary2.
  if Failed(fCreateFunc(CLSID_VerInfoBinaryW, fVI)) then
    raise Exception.Create('Can''t instantiate required object in DLL');

  fLog := TLogger.Create(memoView, 32);
end;

procedure TResRWDemoForm.FormDestroy(Sender: TObject);
begin
  fLog.Free;
  // Ensure version info object freed before releasing the DLL
  fVI := nil;
  if fDLL <> 0 then
    FreeLibrary(fDLL);
end;

procedure TResRWDemoForm.HexEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['1'..'9', '0', 'a'..'f', 'A'..'F', #8]) then
    Key := #0;
end;

procedure TResRWDemoForm.ReadVIFromResourceFile;
begin
  // PRECONDITION: Resource file must exist
  // Create a resource file object and load resource file into it
  var ResFile := TPJResourceFile.Create;
  try
    ResFile.LoadFromFile(ResFilePath);
    // Find RT_VERSION resource, if present
    var VIEntry := ResFile.FindEntry(RT_VERSION, MakeIntResource(1));
    if Assigned(VIEntry) then
    begin
      // Found resource entry: load data from resource entry into version
      // information object fVI.
      // NOTE: fVI reads data from an IStream while TPJResourceEntry exposes its
      // data as a TStream, so we use TStreamAdapter to convert between the two
      // stream types.
      var DataStreamAdapter: IStream := TStreamAdapter.Create(VIEntry.Data);
      Check(fVI.ReadFromStream(DataStreamAdapter));
    end
    else
      // Version information reosource not found: clear existing VI data
      fVI.Clear;
  finally
    ResFile.Free;
  end;
end;

function TResRWDemoForm.ResFilePath: string;
begin
  // Resource file is located in the same directory as the demo executable
  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), ResFileName);
end;

function TResRWDemoForm.VIAsBytes: TArray<Byte>;
begin
  // Copy raw data from version information object into a byte array
  // The only way to get raw data out of the version info object is to copy it
  // to a stream and then to copy the stream to the required byte array.
  // Create a memory stream to recieve the data
  var DataStream := TMemoryStream.Create;
  try
    // Adapt the memory stream into an IStream that version info object can save
    // into. The saved data gets written to the wrapped memory stream
    var DataAdapter: IStream := TStreamAdapter.Create(DataStream);
    Check(fVI.WriteToStream(DataAdapter));
    // Reset the memory stream to the start
    DataStream.Position := 0;
    // Set the size of the byte array to same as memory stream
    SetLength(Result, DataStream.Size);
    // Copy data from memory stream into byte array
    DataStream.ReadBuffer(Result, Length(Result));
  finally
    DataStream.Free;
  end;
end;

procedure TResRWDemoForm.WriteVIToResourceFile;
begin
  // Create a resource file object and add an empty version info resource to it
  var ResFile := TPJResourceFile.Create;
  try
    // Version info resources have type RT_VERSION and *always* have ID of 1
    var VIEntry := ResFile.AddEntry(RT_VERSION, MakeIntResource(1));
    // TPJResourceEntry exposes its data as a TStream, bit the version
    // information object writes to an IStream. So we use TStreamAdapter to
    // convert between the two types.
    var DataStreamAdapter: IStream := TStreamAdapter.Create(VIEntry.Data);
    Check(fVI.WriteToStream(DataStreamAdapter));
    // Save resource file containing a single RT_VERSION resource.
    // Note that it is possible to replace an existing resource and have more
    // than one different resource in a resource file, but that's beyond the
    // scope of this demo: see https://github.com/ddablib/resfile for more info.
    ResFile.SaveToFile(ResFilePath);
  finally
    ResFile.Free;
  end;
end;

end.

