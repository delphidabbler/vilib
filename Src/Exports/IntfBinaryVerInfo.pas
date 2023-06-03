{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2002-2023, Peter Johnson (https://gravatar.com/delphidabbler).
 *
 * Provides interfaces for binary version information reader and writer objects
 * exported from the DLL along with all the supporting types required and a
 * prototype for the DLL's exported function.
}

unit IntfBinaryVerInfo;

interface

uses
  // Delphi
  Windows, ActiveX;


type

  ///  <summary>Enumeration of values that can be used as an index into a fixed
  ///  information structure when accessed as an array. Each item in the
  ///  enumeration accesses a different <c>DWORD</c> element of fixed file
  ///  information</summary>
  TFixedFileInfoOffset = (
    foSignature,          // accesses the FFI structure's signature element
    foStrucVersion,       // accesses the FFI strusture's version number
    foFileVersionMS,      // accesses the MS DWORD of the file version number
    foFileVersionLS,      // accesses the LS DWORD of the file version number
    foProductVersionMS,   // accesses the MS DWORD of the product version number
    foProductVersionLS,   // accesses the LS DWORD of the product version number
    foFileFlagsMask,      // accesses the file flags mask element of FFI
    foFileFlags,          // accesses the file flags element of FFI
    foFileOS,             // accesses the file OS element of FFI
    foFileType,           // accesses the file type of FFI
    foFileSubtype,        // accesses the file sub type of FFI
    foFileDateMS,         // accesses the MS DWORD of the file date
    foFileDateLS          // accesses the LS DWORD of the file date
  );

  ///  <summary>An array occupying the same number of bytes as a
  ///  <c>TVSVersionInfo</c> record that permits each field to be accessed by
  ///  a member of the <c>TFixedFileInfoOffset</c> enumeration.</c>
  TFixedFileInfoArray = packed array[TFixedFileInfoOffset] of DWORD;

  ///  <summary>Variant record that provides access to a translation code either
  ///  by its <c>DWORD</c> value or split into the encoded langauge ID and
  ///  character set (or code page) values.</summary>
  TTranslationCode = packed record
    case Integer of
      0: (LanguageID: Word; CharSet: Word);
      1: (Code: DWORD);
  end;

  ///  <summary>Interface supported by objects that enable read only access to
  ///  binary version information data with the exception that the data can be
  ///  cleared, assigned to and read from a stream.</summary>
  IVerInfoBinaryReader = interface(IUnknown)
    ['{6CFEA4E2-FEC4-4828-80F5-7C9285666783}']

    //-  Fixed file info

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

    //-  Variable file info

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

    //-  String tables

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

    //-  String information

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

    //-  General

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

    ///  <summary>Gets a message describing any error generated by the previous
    ///  operation on this object.</summary>
    ///  <returns><c>WideString</c>. The error message or '' if the previous
    ///  operation was a success.</returns>
    function LastErrorMsg: WideString; stdcall;

  end;

  ///  <summary>Extension of <c>IVerInfoBinaryReader</c> that adds a new method.
  ///  </summary>
  IVerInfoBinaryReader2 = interface(IVerInfoBinaryReader)
    ['{D94AC867-16FE-45CA-92AA-A1B690EF38D5}']

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

  end;

  ///  <summary>Interface supported by object that enable access to and
  ///  modification of binary version information data. It supports all the
  ///  methods of <c>IVerInfoBinaryReader</c> plus other methods that modify and
  ///  write out binary version information.</summary>
  IVerInfoBinary = interface(IVerInfoBinaryReader)
    ['{2E6F3972-BDA1-4E61-AC87-22BCB0FB80BD}']

    //-  Additional fixed file info methods

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

    //-  Additional variable file info methods

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

    //-  Additional string table methods

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

    //-  Additional string information methods

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

    //-  Additional general methods

    ///  <summary>Writes the binary version information from the object to a
    ///  stream.</summary>
    ///  <param name="Stm">[in] Stream to receive the data.</param>
    ///  <returns><c>S_OK</c> on success or <c>E_FAIL</c> on error.</returns>
    function WriteToStream(const Stm: IStream): HResult; stdcall;

  end;

  ///  <summary>Extension of <c>IVerInfoBinary</c> that adds a new method.
  ///  </summary>
  IVerInfoBinary2 = interface(IVerInfoBinary)
    ['{0068F5D1-7338-494C-8226-0A3A1081F513}']

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

  end;

  ///  <summary>Prototype for <c>CreateInstance2</c> function that is used to
  ///  create an instance of the object supported by this DLL.</summary>
  ///  <param name="Obj">Typeless [out] Receives the required object. Pass in a
  ///  variable of any of the supported interface types.</param>
  ///  <returns><c>HResult</c> Success or failure code.</returns>
  TVerInfoBinaryCreateFunc = function(out Obj): HResult; stdcall;

implementation

end.
