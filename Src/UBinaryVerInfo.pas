{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2002-2023, Peter Johnson (https://gravatar.com/delphidabbler).
 *
 * Class implementing the various interfaces exported from the DLL. Also defines
 * a function used to create an object that supports the interfaces.
}

unit UBinaryVerInfo;

interface

///  <summary>Creates an object that supports all the interfaces implemented in
///  the DLL.</summary>
///  <param name="Obj">[out] Receives the required object. Pass in a variable of
///  any of the supported interface types.</param>
///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
function CreateInstance(out Obj): HResult; stdcall;

implementation

uses
  // Delphi
  SysUtils, Windows, ActiveX,
  // vilib
  DelphiDabbler.Lib.VIBin.Resource,
  // Project
  IntfBinaryVerInfo;

type

  ///  <summary>Class that implements the object exported from the DLL.
  ///  </summary>
  TVerInfoBinary = class(TInterfacedObject,
    IUnknown,
    IVerInfoBinaryReader,
    IVerInfoBinaryReader2,
    IVerInfoBinary,
    IVerInfoBinary2
  )
  private

    ///  <summary>Object used to access and manipulate binary version
    ///  information resource data.</summary>
    fVIData: TVIBinResource;
    ///  <summary>Last error message or empty string if no error.</summary>
    fLastError: WideString;
    ///  <summary>Returns successful result value of <c>S_OK</c> and clears
    ///  last error message.</summary>
    function Success: HResult;
    ///  <summary>Handles the exception <c>E</c>, sets the last error message to
    ///  the exception's message and returns <c>E_FAIL</c>.</summary>
    function HandleException(const E: Exception): HResult;

  protected

    ///  <summary>Fetches the version information's fixed file information
    ///  record.</summary>
    ///  <param name="Value">[out] Set to the fixed file version information
    ///  record.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetFixedFileInfo(out Value: TVSFixedFileInfo): HResult; stdcall;

    ///  <summary>Fetches the version information's fixed file information
    ///  record, interpreted as an array</summary>
    ///  <param name="Value">[out] Set to the array containing fixed file
    ///  information.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetFixedFileInfoArray(out Value: TFixedFileInfoArray): HResult;
      stdcall;

    ///  <summary>Fetches an element from the version information fixed file
    ///  information, when the fixed file information is interpreted as an
    ///  array.</summary>
    ///  <param name="Offset">[in] Offset (i.e. index) of the required element
    ///  in the array.</param>
    ///  <param name="Value">[out] Set to the value of the required array
    ///  element.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetFixedFileInfoItem(const Offset: TFixedFileInfoOffset;
      out Value: DWORD): HResult; stdcall;

    ///  <summary>Sets the version information's fixed file information record.
    ///  </summary>
    ///  <param name="Value">[in] Fixed file information record to be set.
    ///  </param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function SetFixedFileInfo(const Value: TVSFixedFileInfo): HResult; stdcall;

    ///  <summary>Sets the version information's fixed file information record
    ///  to the data contained in an array of values.</summary>
    ///  <param name="Value">[in] Array containing data to be set.</param>
    function SetFixedFileInfoArray(const Value: TFixedFileInfoArray): HResult;
      stdcall;

    ///  <summary>Sets an element of the version information's fixed file
    ///  information, when viewed as an array.</summary>
    ///  <param name="Offset">[in] Offset (i.e. index) of element of array to
    ///  be set.</param>
    ///  <param name="Value">[in] Value of array element to be set.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function SetFixedFileInfoItem(const Offset: TFixedFileInfoOffset;
      const Value: DWORD): HResult; stdcall;

    ///  <summary>Gets the number of translations in the version information.
    ///  </summary>
    ///  <param name="Count">[out] Set to the number of translations.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetTranslationCount(out Count: Integer): HResult; stdcall;

    ///  <summary>Gets the translation code of a specified translation.
    ///  </summary>
    ///  <param name="Index">[in] Index of translation in translation table.
    ///  </param>
    ///  <param name="Value">[out] Set to the required translation code.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetTranslation(const Index: Integer;
      out Value: TTranslationCode): HResult; stdcall;

    ///  <summary>Gets the translation string of a specified translation.
    ///  </summary>
    ///  <param name="Index">[in] Index of translation in translation table/
    ///  </param>
    ///  <param name="Value">[out] Set to the required translation string.
    ///  </param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    ///  <remarks>A translation string is an eight digit hex representation of
    ///  a translation code.</remarks>
    function GetTranslationAsString(const Index: Integer;
      out Value: WideString): HResult; stdcall;

    ///  <summary>Sets a translation code of a specified translation.</summary>
    ///  <param name="Index">[in] Index of translation in translation table/
    ///  </param>
    ///  <param name="Value">[in] Translation code to be set.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function SetTranslation(const Index: Integer;
      const Value: TTranslationCode): HResult; stdcall;

    ///  <summary>Adds a new translation to the translation table.</summary>
    ///  <param name="Value">[in] Translation code of the new translation.
    ///  </param>
    ///  <param name="NewIndex">[out] Set to the index of the new translation in
    ///  the translation table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function AddTranslation(const Value: TTranslationCode;
      out NewIndex: Integer): HResult; stdcall;

    ///  <summary>Deletes a specified translation from the translation table.
    ///  </summary>
    ///  <param name="Index">[in] Index of the translation to be deleted from
    ///  the translation table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function DeleteTranslation(const Index: Integer): HResult; stdcall;

    ///  <summary>Finds the index of a specified translation in the translation
    ///  table.</summary>
    ///  <param name="Value">[in] Translation code of the translation to be
    ///  found.</param>
    ///  <param name="Index">[out] Set to the ndex of the translation or -1 if
    ///  the translation doesn't exist in the translation table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    ///  <remarks>If there is more than one translation with the same code then
    ///  the index of the first one found will be returned.</remarks>
    function IndexOfTranslation(const Value: TTranslationCode;
      out Index: Integer): HResult; stdcall;

    ///  <summary>Gets the number of string tables in the version information.
    ///  </summary>
    ///  <param name="Count">[out] Set to the number of string tables.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringTableCount(out Count: Integer): HResult; stdcall;

    ///  <summary>Gets the translation string of a specified string table.
    ///  </summary>
    ///  <param name="Index">[in] Index of the string table.</param>
    ///  <param name="TransStr">[out] Set to the required translation string.
    ///  </param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringTableTransString(const Index: Integer;
      out TransStr: WideString): HResult; stdcall;

    ///  <summary>Gets the translation code associated with a specified string
    ///  table.</summary>
    ///  <param name="Index">[in] Index of the string table.</param>
    ///  <param name="TransCode">[out] Set to the required translation code.
    ///  </param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringTableTransCode(const Index: Integer;
      out TransCode: TTranslationCode): HResult; stdcall;

    ///  <summary>Adds a new string table with a given translation string to
    ///  the version information.</summary>
    ///  <param name="TransStr">[in] Translation string that identifies the
    ///  string table.</param>
    ///  <param name="NewIndex">[out] Set to the index of the new string table,
    ///  or -1 if an error occurs.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function AddStringTable(const TransStr: WideString;
      out NewIndex: Integer): HResult; stdcall;

    ///  <summary>Adds a new string table with a given translation code to
    ///  the version information.</summary>
    ///  <param name="Code">[in] Translation code that identifies the string
    ///  table.</param>
    ///  <param name="NewIndex">[out] Set to the index of the new string table,
    ///  or -1 if an error occurs.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function AddStringTableByCode(const TransCode: TTranslationCode;
      out NewIndex: Integer): HResult; stdcall;

    ///  <summary>Deletes a specified string table from the version information.
    ///  </summary>
    ///  <param name="Index">[in] Index of the string table to be deleted.
    ///  </param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function DeleteStringTable(const Index: Integer): HResult; stdcall;

    ///  <summary>Finds the index of the string table in the version information
    ///  from its translation string.</summary>
    ///  <param name="TransStr">[in] Translation string of the string table.
    ///  </param>
    ///  <param name="Index">[out] Set to the index of the required string table
    ///  or -1 if there is no such string table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    ///  <remarks>If there is more than one string table with the same
    ///  translation string then the index of the first one found will be
    ///  returned.</remarks>
    function IndexOfStringTable(const TransStr: WideString;
      out Index: Integer): HResult; stdcall;

    ///  <summary>Finds the index of the string table in the version information
    ///  from its translation code.</summary>
    ///  <param name="Code">[in] Translation code of the string table.</param>
    ///  <param name="Index">[out] Set to the index of the required string table
    ///  or -1 if there is no such string table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    ///  <remarks>If there is more than one string table with the same
    ///  translation code then the index of the first one found will be
    ///  returned.</remarks>
    function IndexOfStringTableByCode(const Code: TTranslationCode;
      out Index: Integer): HResult; stdcall;

    ///  <summary>Gets the number of string items in a specified string table.
    ///  </summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Count">[out] Set to the number of string items in the
    ///  string table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringCount(const TableIdx: Integer;
      out Count: Integer): HResult; stdcall;

    ///  <summary>Gets the name of a specified string item in a specified string
    ///  table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="StringIdx">[in] Index of the string item in the string
    ///  table.</param>
    ///  <param name="Name">[out] Set to the required name.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringName(const TableIdx, StringIdx: Integer;
      out Name: WideString): HResult; stdcall;

    ///  <summary>Gets the value of a specified string item in a specified
    ///  string table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="StringIdx">[in] Index of the string item in the string
    ///  table.</param>
    ///  <param name="Value">[out] Set to the required value.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringValue(const TableIdx, StringIdx: Integer;
      out Value: WideString): HResult; stdcall;

    ///  <summary>Gets the value of a named string item in a specified string
    ///  table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Name">[in] Name of the string item in the string table.
    ///  </param>
    ///  <param name="Value">[out] Set to the required value.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function GetStringValueByName(const TableIdx: Integer;
      const Name: WideString; out Value: WideString): HResult; stdcall;

    ///  <summary>Sets the value of a specified string item in a specified
    ///  string table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="StringIdx">[in] Index of the string item in the string
    ///  table.</param>
    ///  <param name="Value">[in] Value of string item to be set.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function SetString(const TableIdx, StringIdx: Integer;
      const Value: WideString): HResult; stdcall;

    ///  <summary>Sets the value of a named string item in a specified string
    ///  table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Name">[in] Name of the string item in the string table.
    ///  </param>
    ///  <param name="Value">[in] Value of string item to be set.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function SetStringByName(const TableIdx: Integer;
      const Name, Value: WideString): HResult; stdcall;

    ///  <summary>Adds a new string item to a specified string table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Name">[in] Name of the new string item.</param>
    ///  <param name="Value">[in] Value of the new string item.</param>
    ///  <param name="StrIdx">[out] Set to the index of the new string item in
    ///  the string table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function AddString(const TableIdx: Integer;
      const Name, Value: WideString; out StrIdx: Integer): HResult; stdcall;

    ///  <summary>Sets the value of a named string information item in a
    ///  specified string table, adding a new item if one doesn't already exist
    ///  with that name.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Name">[in] Name of the string item.</param>
    ///  <param name="Value">[in] Value of the string item.</param>
    ///  <param name="StrIdx">[out] Set to the index of the updated or added
    ///  string item in the string table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function SetOrAddString(const TableIdx: Integer;
      const Name, Value: WideString; out StrIndex: Integer): HResult; stdcall;

    ///  <summary>Deletes a specified string item from a specified string table.
    ///  </summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="StringIdx">[in] Index of the string item to be deleted in
    ///  the string table.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function DeleteString(const TableIdx, StringIdx: Integer): HResult; stdcall;

    ///  <summary>Deletes a named string item from a specified string table.
    ///  </summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Name">[in] Name of the string item to be deleted.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function DeleteStringByName(const TableIdx: Integer;
      const Name: WideString): HResult; stdcall;

    ///  <summary>Finds the index of a named string item in a specified string
    ///  table.</summary>
    ///  <param name="TableIdx">[in] Index of the string table.</param>
    ///  <param name="Name">[in] Name of the string item.</param>
    ///  <param name="Index">[out] Set to the index of the required string item
    ///  or -1 if there is no such item.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    ///  <remarks>If there is more than one string item with the same name then
    ///  the index of the first one found will be returned.</remarks>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function IndexOfString(TableIdx: Integer; const Name: WideString;
      out Index: Integer): HResult; stdcall;

    ///  <summary>Clears the version information data and restores it to a
    ///  valid default state.</summary>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    ///  <remarks>The default state is a version information object containing
    ///  an empty fixed file information record, an empty string table list and
    ///  an empty translation table.</remarks>
    function Clear: HResult; stdcall;

    ///  <summary>Assigns the content of another version information object to
    ///  this object, overwriting any existing version information data.
    ///  </summary>
    ///  <param name="Source">[in] Version information object to be assigned to
    ///  this object.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function Assign(const Source: IVerInfoBinaryReader): HResult; stdcall;

    ///  <summary>Reads the binary version information from a stream,
    ///  overwriting any existing version information data stored in the object.
    ///  </summary>
    ///  <param name="Stm">[in] Stream containing the required data.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function ReadFromStream(const Stm: IStream): HResult; stdcall;

    ///  <summary>Writes the binary version information from the object to a
    ///  stream.</summary>
    ///  <param name="Stm">[in] Stream to receive the data.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function WriteToStream(const Stm: IStream): HResult; stdcall;

    ///  <summary>Gets a message describing any error generated by the previous
    ///  operation on this object.</summary>
    ///  <returns><c>WideString</c>. The error message or '' if the previous
    ///  operation was a success.</returns>
    function LastErrorMsg: WideString; stdcall;

  public

    ///  <summary>Object consturctor. Creates a new version information object
    ///  in its default, empty state.</summary>
    ///  <remarks>The default state is a version information object containing
    ///  an empty fixed file information record, an empty string table list and
    ///  an empty translation table.</remarks>
    constructor Create;

    ///  <summary>Object destructor.</summary>
    destructor Destroy; override;

  end;

  ///  <summary>Variant record that enables fixed file version information to be
  ///  accessed either as a standard record or as an array of <c>DWORD</c>
  ///  elements.</summary>
  ///  <remarks>
  TFixedFileInfoAccessor = packed record
    case Integer of
      1: (Elements: TFixedFileInfoArray);   // array of fixed file info
      2: (Orig: TVSFixedFileInfo);          // standard record
  end;

function CreateInstance(out Obj): HResult; stdcall;
begin
  try
    Result := S_OK;
    IVerInfoBinary2(Obj) := TVerInfoBinary.Create as IVerInfoBinary2;
  except
    Pointer(Obj) := nil;
    Result := E_FAIL;
  end;
end;

{ TVerInfoBinary }

function TVerInfoBinary.AddString(const TableIdx: Integer; const Name,
  Value: WideString; out StrIdx: Integer): HResult;
begin
  StrIdx := -1;
  try
    StrIdx := fVIData.AddString(TableIdx, Name, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.AddStringTable(const TransStr: WideString;
  out NewIndex: Integer): HResult;
begin
  NewIndex := -1;
  try
    NewIndex := fVIData.AddStringTable(TransStr);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.AddStringTableByCode(
  const TransCode: TTranslationCode; out NewIndex: Integer): HResult;
begin
  NewIndex := -1;
  try
    NewIndex := fVIData.AddStringTableByTrans(
      TransCode.LanguageID, TransCode.CharSet
    );
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.AddTranslation(const Value: TTranslationCode;
  out NewIndex: Integer): HResult;
begin
  NewIndex := -1;
  try
    NewIndex := fVIData.AddTranslation(Value.LanguageID, Value.CharSet);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.Assign(const Source: IVerInfoBinaryReader): HResult;
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
begin
  try
    fVIData.Reset;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

constructor TVerInfoBinary.Create;
begin
  inherited Create;
  fVIData := TVIBinResource.Create(vrtUnicode);
end;

function TVerInfoBinary.DeleteString(const TableIdx,
  StringIdx: Integer): HResult;
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
begin
  try
    fVIData.DeleteStringByName(TableIdx, Name);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.DeleteStringTable(
  const Index: Integer): HResult;
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
begin
  fVIData.Free;
  inherited;
end;

function TVerInfoBinary.GetFixedFileInfo(
  out Value: TVSFixedFileInfo): HResult;
begin
  FillChar(Value, SizeOf(Value), 0);
  try
    Value := fVIData.GetFixedFileInfo;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetFixedFileInfoArray(
  out Value: TFixedFileInfoArray): HResult;
var
  FFIAccess: TFixedFileInfoAccessor;  // record to interpret data as array
begin
  Assert(SizeOf(TFixedFileInfoArray) = SizeOf(TVSFixedFileInfo));
  // Get fixed file info record and store in variant record
  Result := GetFixedFileInfo(FFIAccess.Orig);
  // Return the data interpreted as an array
  Value := FFIAccess.Elements;
end;

function TVerInfoBinary.GetFixedFileInfoItem(
  const Offset: TFixedFileInfoOffset; out Value: DWORD): HResult;
var
  FFIArray: TFixedFileInfoArray;  // array of fixed file info data
begin
  Result := GetFixedFileInfoArray(FFIArray);
  Value := FFIArray[Offset];
end;

function TVerInfoBinary.GetStringCount(const TableIdx: Integer;
  out Count: Integer): HResult;
begin
  Count := 0;
  try
    Count := fVIData.GetStringCount(TableIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringName(const TableIdx,
  StringIdx: Integer; out Name: WideString): HResult;
begin
  Name := '';
  try
    Name := fVIData.GetStringName(TableIdx, StringIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringTableCount(
  out Count: Integer): HResult;
begin
  Count := 0;
  try
    Count := fVIData.GetStringTableCount;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringTableTransCode(const Index: Integer;
  out TransCode: TTranslationCode): HResult;
begin
  TransCode.Code := 0;
  try
    TransCode.LanguageID := fVIData.GetStringTableLanguageID(Index);
    TransCode.CharSet := fVIData.GetStringTableCharSet(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringTableTransString(
  const Index: Integer; out TransStr: WideString): HResult;
begin
  TransStr := '00000000';
  try
    TransStr := fVIData.GetStringTableTransStr(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringValue(const TableIdx,
  StringIdx: Integer; out Value: WideString): HResult;
begin
  Value := '';
  try
    Value := fVIData.GetStringValue(TableIdx, StringIdx);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetStringValueByName(const TableIdx: Integer;
  const Name: WideString; out Value: WideString): HResult;
begin
  Value := '';
  try
    Value := fVIData.GetStringValueByName(TableIdx, Name);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetTranslation(const Index: Integer;
  out Value: TTranslationCode): HResult;
begin
  Value.Code := 0;
  try
    Value.LanguageID := fVIData.GetTranslationLanguageID(Index);
    Value.CharSet := fVIData.GetTranslationCharSet(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetTranslationAsString(const Index: Integer;
  out Value: WideString): HResult;
begin
  Value := '00000000';
  try
    Value := fVIData.GetTranslationString(Index);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.GetTranslationCount(
  out Count: Integer): HResult;
begin
  Count := 0;
  try
    Count := fVIData.GetTranslationCount;
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.HandleException(const E: Exception): HResult;
begin
  Result := E_FAIL;
  fLastError := E.Message;
end;

function TVerInfoBinary.IndexOfString(TableIdx: Integer; const Name: WideString;
  out Index: Integer): HResult;
begin
  Index := -1;
  try
    Index := fVIData.IndexOfString(TableIdx, Name);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.IndexOfStringTable(const TransStr: WideString;
  out Index: Integer): HResult;
begin
  Index := -1;
  try
    Index := fVIData.IndexOfStringTable(TransStr);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.IndexOfStringTableByCode(
  const Code: TTranslationCode; out Index: Integer): HResult;
begin
  Index := -1;
  try
    Index := fVIData.IndexOfStringTableByTrans(Code.LanguageID, Code.CharSet);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.IndexOfTranslation(
  const Value: TTranslationCode; out Index: Integer): HResult;
begin
  Index := -1;
  try
    Index := fVIData.IndexOfTranslation(Value.LanguageID, Value.CharSet);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.LastErrorMsg: WideString;
begin
  Result := fLastError;
end;

function TVerInfoBinary.ReadFromStream(const Stm: IStream): HResult;
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
var
  FFIArray: TFixedFileInfoArray;  // array used to access fixed file info
begin
  Result := GetFixedFileInfoArray(FFIArray);
  if Succeeded(Result) then
  begin
    FFIArray[Offset] := Value;
    Result := SetFixedFileInfoArray(FFIArray);
  end;
end;

function TVerInfoBinary.SetOrAddString(const TableIdx: Integer;
  const Name, Value: WideString; out StrIndex: Integer): HResult;
begin
  StrIndex := -1;
  try
    StrIndex := fVIData.AddOrUpdateString(TableIdx, Name, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetString(const TableIdx, StringIdx: Integer;
  const Value: WideString): HResult;
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
begin
  try
    fVIData.SetStringValueByName(TableIdx, Name, Value);
    Result := Success;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TVerInfoBinary.SetTranslation(const Index: Integer;
  const Value: TTranslationCode): HResult;
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
begin
  Result := S_OK;
  fLastError := '';
end;

function TVerInfoBinary.WriteToStream(const Stm: IStream): HResult;
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
