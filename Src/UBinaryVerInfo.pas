{
  Provides definition of class implementing of IVerInfoBinary and
  IVerInfoBinaryReader interfaces that are exported from DLL. Also exports
  function used to create objects supported by the DLL.
}


{
 * ***** BEGIN LICENSE BLOCK *****
 *
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is UBinaryVerInfo.pas
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2002-2004 Peter
 * Johnson. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK *****
}


unit UBinaryVerInfo;

interface

uses
  // Project
  IntfBinaryVerInfo;

function CreateInstance(const CLSID: TGUID; out Obj): HResult; stdcall;
  {If the library supports the object CLSID then an instance of the required
  object is created. A reference to the object is stored in Obj and S_OK is
  returned. If the library does not support CLSID then Obj is set to nil and
  E_NOTIMPL is returned. If there is an error in creating the object Obj is set
  to nil and E_FAIL is returned}

implementation

uses
  // Delphi
  SysUtils, Windows, ActiveX,
  // Project
  UVerInfoData;

type

  TVerInfoBinary = class;

  {
  TVerInfoBinary:
    Class that implements the IVerInfoBinary and IVerInfoBinaryReader interface
    exported from the DLL.

    Inheritance: TVerInfoBinary -> [TInterfacedObject] -> [TObject]
  }
  TVerInfoBinary = class(TInterfacedObject,
    IUnknown, IVerInfoBinaryReader, IVerInfoBinary)
  private
    fVIData: TVerInfoData;
      {Version information data object used to access and manipulate the binary
      data}
    fLastError: WideString;
      {The last error message}
    procedure Error(const FmtStr: string; const Args: array of const);
      {Raises an EVerInfoBinary exception with a message made up from the given
      format string and argumements}
    function Success: HResult;
      {Sets a successful result: returns S_OK and clears the last error message}
    function HandleException(const E: Exception): HResult;
      {Handles the exception passed as a parameter by returning E_FAIL and
      stores the exception's message for use by LastErrorMessage}
  protected
    { IVerInfoBinary / IVerInfoBinaryReader }
    function GetFixedFileInfo(out Value: TVSFixedFileInfo): HResult; stdcall;
      {Fetches the version information's fixed file information record and
      passes it out in Value}
    function GetFixedFileInfoArray(out Value: TFixedFileInfoArray): HResult;
      stdcall;
      {Fetches the version information's fixed file information record
      interpreted as an array and passes it out in Value}
    function GetFixedFileInfoItem(const Offset: TFixedFileInfoOffset;
      out Value: DWORD): HResult; stdcall;
      {Fetches the given element from the version information's fixed file
      information and passes in out in Value}
    function SetFixedFileInfo(const Value: TVSFixedFileInfo): HResult; stdcall;
      {Sets fixed file information record in version information to given value}
    function SetFixedFileInfoArray(const Value: TFixedFileInfoArray): HResult;
      stdcall;
      {Sets fixed file information in version information to information
      contained in given array}
    function SetFixedFileInfoItem(const Offset: TFixedFileInfoOffset;
      const Value: DWORD): HResult; stdcall;
      {Sets the given element of fixed file info to the given value}
    function GetTranslationCount(out Count: Integer): HResult; stdcall;
      {Sets Count to the number of translations in the version information}
    function GetTranslation(const Index: Integer;
      out Value: TTranslationCode): HResult; stdcall;
      {Sets Value to the code of the translation at the given index. It is an
      error if the translation index is out of bounds}
    function GetTranslationAsString(const Index: Integer;
      out Value: WideString): HResult; stdcall;
      {Sets Value to the translation string of the translation at the given
      index. It is an error if the translation index is out of bounds}
    function SetTranslation(const Index: Integer;
      const Value: TTranslationCode): HResult; stdcall;
      {Sets the translation at the given index to the given code. It is an error
      if the translation index is out of bounds}
    function AddTranslation(const Value: TTranslationCode;
      out NewIndex: Integer): HResult; stdcall;
      {Adds a new translation identified by the given code. NewIndex is set to
      the index of the new translation or -1 on error}
    function DeleteTranslation(const Index: Integer): HResult; stdcall;
      {Deletes the translation at the given index. It is an error of the
      translation index is out of bounds}
    function IndexOfTranslation(const Value: TTranslationCode;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the translation with the given code in the
      version info, or -1 if there is no such translation}
    function GetStringTableCount(out Count: Integer): HResult; stdcall;
      {Return the number of string tables in the version information in Count}
    function GetStringTableTransString(const Index: Integer;
      out TransStr: WideString): HResult; stdcall;
      {Sets TransCode to the translation string associated with the string table
      at the given index. It is an error if the table index is out of bounds}
    function GetStringTableTransCode(const Index: Integer;
      out TransCode: TTranslationCode): HResult; stdcall;
      {Returns the translation code associated with the string table at the
      given index in TransCode. It is an error if the table index is out of
      bounds}
    function AddStringTable(const TransStr: WideString;
      out NewIndex: Integer): HResult; stdcall;
      {Adds a new string table indentified by the given translation string.
      NewIndex is set to the index of the new string table or -1 if an error
      occurs}
    function AddStringTableByCode(const TransCode: TTranslationCode;
      out NewIndex: Integer): HResult; stdcall;
      {Adds a new string table indentified by the given translation code.
      NewIndex is set to the index of the new string table or -1 if an error
      occurs}
    function DeleteStringTable(const Index: Integer): HResult; stdcall;
      {Deletes the string table at the given index and all the string items that
      belong to the table. It is an error if the string table index is out of
      bounds}
    function IndexOfStringTable(const TransStr: WideString;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the the string table identified by the the
      given translation string, or -1 if no such string table}
    function IndexOfStringTableByCode(const Code: TTranslationCode;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the string table identified by a translation
      string made up from the given translation code, or -1 if no such string
      table}
    function GetStringCount(const TableIdx: Integer;
      out Count: Integer): HResult; stdcall;
      {Returns the number of string items in the given string table in Count. It
      is an error if the string table index is out of bounds}
    function GetStringName(const TableIdx, StringIdx: Integer;
      out Name: WideString): HResult; stdcall;
      {Returns the name of the string item at the given index in the string
      table with the given string table index in Name. It is an error if either
      index is out of bounds}
    function GetStringValue(const TableIdx, StringIdx: Integer;
      out Value: WideString): HResult; stdcall;
      {Sets Value to the string item at the given index in the string table. It
      is an error if either index is out of bounds}
    function GetStringValueByName(const TableIdx: Integer;
      const Name: WideString; out Value: WideString): HResult; stdcall;
      {Sets Value to the string item with the given name in the string table
      with the given string table index in Value. It is an error if there is no
      string item with the given name in the table or if the table index is out
      of bounds}
    function SetString(const TableIdx, StringIdx: Integer;
      const Value: WideString): HResult; stdcall;
      {Sets the string value at the given index in the string table at the given
      table index. It is an error if either index is out of bounds}
    function SetStringByName(const TableIdx: Integer;
      const Name, Value: WideString): HResult; stdcall;
      {Sets the value of the string with the given name in the the string table
      with the given index. It is an error if the string table index is out of
      range or if a string with the given name does not exist}
    function AddString(const TableIdx: Integer;
      const Name, Value: WideString; out StrIdx: Integer): HResult; stdcall;
      {Adds a new string with given name and value to the string table with the
      given index. StrIdx is set to the the index of the new string within the
      string table or -1 on error. It is an error if the string table index is
      out of bounds or if the table already contains a string with the given
      name}
    function SetOrAddString(const TableIdx: Integer;
      const Name, Value: WideString; out StrIndex: Integer): HResult; stdcall;
      {Set the string information item with the given name in the string table
      with the given index to the given value. If a string info item with the
      given name aleady exists then its value is overwritten, otherwise name
      item with the required name and value is created. StrIndex is set to the
      index of the string info item that is updated. It is an error if the
      string table index is out of bounds}
    function DeleteString(const TableIdx, StringIdx: Integer): HResult; stdcall;
      {Deletes the string information item at the given index in the string
      table which has the given table index. It is an error if either index is
      out of bounds}
    function DeleteStringByName(const TableIdx: Integer;
      const Name: WideString): HResult; stdcall;
      {Deletes the string information item with the given name from the string
      table which has the given table index. It is an error if no string item
      with the given name exists in the string table or the string table index
      is out of bounds}
    function Clear: HResult; stdcall;
      {Clears the version information data}
    function Assign(const Source: IVerInfoBinaryReader): HResult; stdcall;
      {Assigns contents of given object to this object}
    function ReadFromStream(const Stm: IStream): HResult; stdcall;
      {Reads binary version information from given stream}
    function WriteToStream(const Stm: IStream): HResult; stdcall;
      {Writes the binary version information to the given stream}
    function LastErrorMsg: WideString; stdcall;
      {Returns error message generated from last operation, or '' if last
      operation was a success}
  public
    constructor Create(VerResType: TVerResType);
      {Class constructor: creates a new version information data object that
      interprets and updates version information data}
    destructor Destroy; override;
      {Class destructor: frees owned version info data object}
  end;

  {
  EVerInfoBinary:
    Private class of exception raised by TVerInfoBinary.

    Inheritance: EVerInfoBinary -> [Exception] -> [TObject]
  }
  EVerInfoBinary = class(Exception);

  {
  TFixedFileInfoAccessor:
    "Union" that allows fixed file version information to be accessed either as
    a standard record or as an array of DWORD elements. This is used to enable
    fixed file information read from binary data to be returned to user as an
    array.
  }
  TFixedFileInfoAccessor = packed record
    case Integer of
      1: (Elements: TFixedFileInfoArray);   // array of fixed file info
      2: (Orig: TVSFixedFileInfo);          // standard record
  end;

resourcestring
  // Error messages
  sBadStrName = 'There is no string named "%0:s" in translation %1:d';


function CreateInstance(const CLSID: TGUID; out Obj): HResult; stdcall;
  {If the library supports the object CLSID then an instance of the required
  object is created. A reference to the object is stored in Obj and S_OK is
  returned. If the library does not support CLSID then Obj is set to nil and
  E_NOTIMPL is returned. If there is an error in creating the object Obj is set
  to nil and E_FAIL is returned}
begin
  try
    // Assume success
    Result := S_OK;
    // Check for supported objects, creating objects of required type
    if IsEqualIID(CLSID, CLSID_VerInfoBinaryA) then
      // requested IVerInfoBinary for 16 bit version info data
      IVerInfoBinary(Obj) := TVerInfoBinary.Create(vrtAnsi)
        as IVerInfoBinary
    else if IsEqualIID(CLSID, CLSID_VerInfoBinaryW) then
      // requested IVerInfoBinary for 32 bit version info data
      IVerInfoBinary(Obj) := TVerInfoBinary.Create(vrtUnicode)
        as IVerInfoBinary
    else if IsEqualIID(CLSID, CLSID_VerInfoBinaryReaderA) then
      // requested IVerInfoBinaryReader for 16 bit version info data
      IVerInfoBinaryReader(Obj) := TVerInfoBinary.Create(vrtAnsi)
        as IVerInfoBinaryReader
    else if IsEqualIID(CLSID, CLSID_VerInfoBinaryReaderW) then
      // requested IVerInfoBinaryReader for 32 bit version info data
      IVerInfoBinaryReader(Obj) := TVerInfoBinary.Create(vrtUnicode)
        as IVerInfoBinaryReader
    else
    begin
      // Unsupported object: set object nil and set error code
      Pointer(Obj) := nil;
      Result := E_NOTIMPL;
    end;
  except
    // Something went wrong: set object to nil and set error code
    Pointer(Obj) := nil;
    Result := E_FAIL;
  end;
end;

{ TVerInfoBinary }

function TVerInfoBinary.AddString(const TableIdx: Integer; const Name,
  Value: WideString; out StrIdx: Integer): HResult;
  {Adds a new string with given name and value to the string table with the
  given index. StrIdx is set to the the index of the new string within the
  string table or -1 on error. It is an error if the string table index is out
  of bounds or if the table already contains a string with the given name}
begin
  // Set error value of string index
  StrIdx := -1;
  try
    // Try to add string and record its index
    StrIdx := fVIData.AddString(TableIdx, Name, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.AddStringTable(const TransStr: WideString;
  out NewIndex: Integer): HResult;
  {Adds a new string table indentified by the given translation string. NewIndex
  is set to the index of the new string table or -1 if an error occurs}
begin
  // Set error value of string table index
  NewIndex := -1;
  try
    // Try to add new string table and record its index
    NewIndex := fVIData.AddStringTable(TransStr);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.AddStringTableByCode(
  const TransCode: TTranslationCode; out NewIndex: Integer): HResult;
  {Adds a new string table indentified by the given translation code. NewIndex
  is set to the index of the new string table or -1 if an error occurs}
begin
  Result := AddStringTable(
    TransToString(TransCode.LanguageID, TransCode.CharSet),
    NewIndex
  );
end;

function TVerInfoBinary.AddTranslation(const Value: TTranslationCode;
  out NewIndex: Integer): HResult;
  {Adds a new translation identified by the given code. NewIndex is set to the
  index of the new translation or -1 on error}
begin
  // Set error translation index value
  NewIndex := -1;
  try
    // Try of add new translation and record its index
    NewIndex := fVIData.AddTranslation(Value.LanguageID, Value.CharSet);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.Assign(const Source: IVerInfoBinaryReader): HResult;
  {Assigns contents of given object to this object}
begin
  try
    // Assign using source's object reference
    fVIData.Assign((Source as TVerInfoBinary).fVIData);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.Clear: HResult;
  {Clears the version information data}
begin
  try
    fVIData.Reset;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

constructor TVerInfoBinary.Create(VerResType: TVerResType);
  {Class constructor: creates a new version information data object that
  interprets and updates version information data}
begin
  inherited Create;
  fVIData := TVerInfoData.Create(VerResType);
end;

function TVerInfoBinary.DeleteString(const TableIdx,
  StringIdx: Integer): HResult;
  {Deletes the string information item at the given index in the string table
  which has the given table index. It is an error if either index is out of
  bounds}
begin
  try
    fVIData.DeleteString(TableIdx, StringIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.DeleteStringByName(const TableIdx: Integer;
  const Name: WideString): HResult;
  {Deletes the string information item with the given name from the string table
  which has the given table index. It is an error if no string item with the
  given name exists in the string table or the string table index is out of
  bounds}
var
  StrIdx: Integer;  // index of string item with given name in string table
begin
  try
    // Get index of string item in table and check it exists
    StrIdx := fVIData.IndexOfString(TableIdx, Name);
    if StrIdx = -1 then
      Error(sBadStrName, [Name, TableIdx]);
    // Delete the string item
    fVIData.DeleteString(TableIdx, StrIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.DeleteStringTable(
  const Index: Integer): HResult;
  {Deletes the string table at the given index and all the string items that
  belong to the table. It is an error if the string table index is out of
  bounds}
begin
  try
    fVIData.DeleteStringTable(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.DeleteTranslation(
  const Index: Integer): HResult;
  {Deletes the translation at the given index. It is an error of the translation
  index is out of bounds}
begin
  try
    fVIData.DeleteTranslation(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

destructor TVerInfoBinary.Destroy;
  {Class destructor: frees owned version info data object}
begin
  fVIData.Free;
  inherited;
end;

procedure TVerInfoBinary.Error(const FmtStr: string;
  const Args: array of const);
  {Raises an EVerInfoBinary exception with a message made up from the given
  format string and argumements}
begin
  raise EVerInfoBinary.CreateFmt(FmtStr, Args);
end;

function TVerInfoBinary.GetFixedFileInfo(
  out Value: TVSFixedFileInfo): HResult;
  {Fetches the version information's fixed file information record and passes it
  out in Value}
begin
  // Set empty record in case of error
  FillChar(Value, SizeOf(Value), 0);
  try
    // Get the fixed file info record
    Value := fVIData.GetFixedFileInfo;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetFixedFileInfoArray(
  out Value: TFixedFileInfoArray): HResult;
  {Fetches the version information's fixed file information record interpreted
  as an array and passes it out in Value}
var
  FFIAccess: TFixedFileInfoAccessor;  // record to interpret data as array
begin
  Assert(SizeOf(TFixedFileInfoArray) = SizeOf(TVSFixedFileInfo));
  // Get fixed file info record as store in "union"
  Result := GetFixedFileInfo(FFIAccess.Orig);
  // Return the data interpreted as an array
  Value := FFIAccess.Elements;
end;

function TVerInfoBinary.GetFixedFileInfoItem(
  const Offset: TFixedFileInfoOffset; out Value: DWORD): HResult;
  {Fetches the given element from the version information's fixed file
  information and passes in out in Value}
var
  FFIArray: TFixedFileInfoArray;  // array of fixed file info data
begin
  // Get array of fixed file info data
  Result := GetFixedFileInfoArray(FFIArray);
  // Return the element at the required offset
  Value := FFIArray[Offset];
end;

function TVerInfoBinary.GetStringCount(const TableIdx: Integer;
  out Count: Integer): HResult;
  {Returns the number of string items in the given string table in Count. It is
  an error if the string table index is out of bounds}
begin
  // Set count to zero in case of error
  Count := 0;
  try
    // Try to get the count
    Count := fVIData.GetStringCount(TableIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringName(const TableIdx,
  StringIdx: Integer; out Name: WideString): HResult;
  {Returns the name of the string item at the given index in the string table
  with the given string table index in Name. It is an error if either index is
  out of bounds}
begin
  // Set name to empty string in case of error
  Name := '';
  try
    // Try to get the name
    Name := fVIData.GetStringName(TableIdx, StringIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringTableCount(
  out Count: Integer): HResult;
  {Return the number of string tables in the version information in Count}
begin
  // Set count to 0 in case of error
  Count := 0;
  try
    // Try to get number of string tables
    Count := fVIData.GetStringTableCount;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringTableTransCode(const Index: Integer;
  out TransCode: TTranslationCode): HResult;
  {Returns the translation code associated with the string table at the given
  index in TransCode. It is an error if the table index is out of bounds}

  // ---------------------------------------------------------------------------
  function StrToTransCode(const Str: string): TTranslationCode;
    {Converts a translation string to a translation code}
  begin
    Result.LanguageID := StrToInt('$' + Copy(Str, 1, 4));
    Result.CharSet := StrToInt('$' + Copy(Str, 5, 4));
  end;
  // ---------------------------------------------------------------------------

begin
  // Set translation code to 0 in case of error
  TransCode.Code := 0;
  try
    // Attempt to get the transaltion code
    TransCode := StrToTransCode(fVIData.GetStringTableTransStr(Index));
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringTableTransString(
  const Index: Integer; out TransStr: WideString): HResult;
  {Sets TransCode to the translation string associated with the string table at
  the given index. It is an error if the table index is out of bounds}
begin
  // Set a default 'nul' translation code in case of error
  TransStr := '00000000';
  try
    // Attempt to get the translation string
    TransStr := fVIData.GetStringTableTransStr(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringValue(const TableIdx,
  StringIdx: Integer; out Value: WideString): HResult;
  {Sets Value to the string item at the given index in the string table. It is
  an error if either index is out of bounds}
begin
  // Set empty value in case of error
  Value := '';
  try
    // Try to get the string item value
    Value := fVIData.GetStringValue(TableIdx, StringIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringValueByName(const TableIdx: Integer;
  const Name: WideString; out Value: WideString): HResult;
  {Sets Value to the string item with the given name in the string table with
  the given string table index in Value. It is an error if there is no string
  item with the given name in the table or if the table index is out of bounds}
var
  StringIdx: Integer; // index of string item with given name in table
begin
  // Set nul value in case of error
  Value := '';
  try
    // Get index of string item with given name & check it exists
    StringIdx := fVIData.IndexOfString(TableIdx, Name);
    if StringIdx = -1 then
      Error(sBadStrName, [Name, TableIdx]);
    // Try to get value of string at required index
    Value := fVIData.GetStringValue(TableIdx, StringIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetTranslation(const Index: Integer;
  out Value: TTranslationCode): HResult;
  {Sets Value to the code of the translation at the given index. It is an error
  if the translation index is out of bounds}
begin
  // Sets a zero translation code in case of error
  Value.Code := 0;
  try
    // Try to set the translation code from the language id and character set
    Value.LanguageID := fVIData.GetLanguageID(Index);
    Value.CharSet := fVIData.GetCharSet(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetTranslationAsString(const Index: Integer;
  out Value: WideString): HResult;
  {Sets Value to the translation string of the translation at the given index.
  It is an error if the translation index is out of bounds}
begin
  // Set a zero translation string in case of error
  Value := '00000000';
  try
    // Try to get the translation string
    Value := fVIData.GetTranslationString(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetTranslationCount(
  out Count: Integer): HResult;
  {Sets Count to the number of translations in the version information}
begin
  // Set count to zero in case of error
  Count := 0;
  try
    // Try to get the number of translations
    Count := fVIData.GetTranslationCount;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.HandleException(const E: Exception): HResult;
  {Handles the exception passed as a parameter by returning E_FAIL and stores
  the exception's message for use by LastErrorMessage}
begin
  Result := E_FAIL;
  fLastError := E.Message;
end;

function TVerInfoBinary.IndexOfStringTable(const TransStr: WideString;
  out Index: Integer): HResult;
  {Sets Index to the index of the the string table identified by the the given
  translation string, or -1 if no such string table}
begin
  // Set index to -1 in case of error
  Index := -1;
  try
    // Try to get the index
    Index := fVIData.IndexOfStringTable(TransStr);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.IndexOfStringTableByCode(
  const Code: TTranslationCode; out Index: Integer): HResult;
  {Sets Index to the index of the string table identified by a translation
  string made up from the given translation code, or -1 if no such string table}
var
  TransStr: string; // the translation string to look up
begin
  // Make translation string from laguage id and code
  TransStr := TransToString(Code.LanguageID, Code.CharSet);
  // Find the index of the string table
  Result := IndexOfStringTable(TransStr, Index);
end;

function TVerInfoBinary.IndexOfTranslation(
  const Value: TTranslationCode; out Index: Integer): HResult;
  {Sets Index to the index of the translation with the given code in the version
  info, or -1 if there is no such translation}
begin
  // Set index to -1 in case of error
  Index := -1;
  try
    // Try to get index of translation
    Index := fVIData.IndexOfTranslation(Value.LanguageID, Value.CharSet);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.LastErrorMsg: WideString;
  {Returns error message generated from last operation, or '' if last operation
  was a success}
begin
  Result := fLastError;
end;

function TVerInfoBinary.ReadFromStream(const Stm: IStream): HResult;
  {Reads binary version information from given stream}
begin
  try
    fVIData.ReadFromStream(Stm);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetFixedFileInfo(
  const Value: TVSFixedFileInfo): HResult;
  {Sets fixed file information record in version information to given value}
begin
  try
    fVIData.SetFixedFileInfo(Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetFixedFileInfoArray(
  const Value: TFixedFileInfoArray): HResult;
  {Sets fixed file information in version information to information contained
  in given array}
var
  FFIAccess: TFixedFileInfoAccessor;  // union used to access FFI as array
begin
  Assert(SizeOf(TFixedFileInfoArray) = SizeOf(TVSFixedFileInfo));
  // Set data to write using array part of union
  FFIAccess.Elements := Value;
  // Set FFI using fixed file info record from union
  Result := SetFixedFileInfo(FFIAccess.Orig);
end;

function TVerInfoBinary.SetFixedFileInfoItem(
  const Offset: TFixedFileInfoOffset; const Value: DWORD): HResult;
  {Sets the given element of fixed file info to the given value}
var
  FFIArray: TFixedFileInfoArray;  // array used to access fixed file info
begin
  // Get existing FFI from version info as array
  Result := GetFixedFileInfoArray(FFIArray);
  if Succeeded(Result) then
  begin
    // Update required element of array
    FFIArray[Offset] := Value;
    // Store uptated FFI array back in version info
    Result := SetFixedFileInfoArray(FFIArray);
  end;
end;

function TVerInfoBinary.SetOrAddString(const TableIdx: Integer;
  const Name, Value: WideString; out StrIndex: Integer): HResult;
  {Set the string information item with the given name in the string table with
  the given index to the given value. If a string info item with the given name
  aleady exists then its value is overwritten, otherwise name item with the
  required name and value is created. StrIndex is set to the index of the string
  info item that is updated. It is an error if the string table index is out of
  bounds}
begin
  // Set string index to -1 in case of error
  StrIndex := -1;
  try
    // Find idex of string name (or -1 if no such item)
    StrIndex := fVIData.IndexOfString(TableIdx, Name);
    if StrIndex = -1 then
      // No such string: add it and record index
      StrIndex := fVIData.AddString(TableIdx, Name, Value)
    else
      // String exists: update value
      fVIData.SetStringValue(TableIdx, StrIndex, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetString(const TableIdx, StringIdx: Integer;
  const Value: WideString): HResult;
  {Sets the string value at the given index in the string table at the given
  table index. It is an error if either index is out of bounds}
begin
  try
    fVIData.SetStringValue(TableIdx, StringIdx, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetStringByName(const TableIdx: Integer;
  const Name, Value: WideString): HResult;
  {Sets the value of the string with the given name in the the string table with
  the given index. It is an error if the string table index is out of range or
  if a string with the given name does not exist}
var
  StrIdx: Integer;  // index of string in string table
begin
  try
    // Get index of string with given name: ensure it exists
    StrIdx := fVIData.IndexOfString(TableIdx, Name);
    if StrIdx = -1 then
      Error(sBadStrName, [Name, TableIdx]);
    // Set the string value
    fVIData.SetStringValue(TableIdx, StrIdx, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetTranslation(const Index: Integer;
  const Value: TTranslationCode): HResult;
  {Sets the translation at the given index to the given code. It is an error if
  the translation index is out of bounds}
begin
  try
    fVIData.SetTranslation(Index, Value.LanguageID, Value.CharSet);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.Success: HResult;
  {Sets a successful result: returns S_OK and clears the last error message}
begin
  Result := S_OK;
  fLastError := '';
end;

function TVerInfoBinary.WriteToStream(const Stm: IStream): HResult;
  {Writes the binary version information to the given stream}
begin
  try
    fVIData.WriteToStream(Stm);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

end.
