{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2002-2022, Peter Johnson (https://gravatar.com/delphidabbler).
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

  {
  TFixedFileInfoOffset:
    Enumeration used as index into fixed file information when accessed as an
    array. Each item in the enumeration accesses a different DWORD element of
    fixed file information
  }
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

  {
  TFixedFileInfoArray:
    This array is the same size as the TVSVersionInfo structure and enables
    fixed file info to be accessed as an array of values indexed by the
    TFixedFileInfoOffset enumeration.
  }
  TFixedFileInfoArray = packed array[TFixedFileInfoOffset] of DWORD;

  {
  TTranslationCode:
    Permits access to a translation code either by its DWORD value or by its
    language ID and character set values.
  }
  TTranslationCode = packed record
    case Integer of
      0: (LanguageID: Word; CharSet: Word);
      1: (Code: DWORD);
  end;

  {
  IVerInfoBinaryReader:
    Interface that enables read only access to binray version information data.

    Inheritance: IVerInfoBinaryReader -> [IUnknown]
  }
  IVerInfoBinaryReader = interface(IUnknown)
    ['{6CFEA4E2-FEC4-4828-80F5-7C9285666783}']
    // Fixed file info
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
    // Variable file info
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
    function IndexOfTranslation(const Value: TTranslationCode;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the translation with the given code in the
      version info, or -1 if there is no such translation}
    // String tables
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
    function IndexOfStringTable(const TransStr: WideString;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the the string table identified by the the
      given translation string, or -1 if no such string table}
    function IndexOfStringTableByCode(const Code: TTranslationCode;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the string table identified by a translation
      string made up from the given translation code, or -1 if no such string
      table}
    // String information
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
    // General
    function Clear: HResult; stdcall;
      {Clears the version information data}
    function Assign(const Source: IVerInfoBinaryReader): HResult; stdcall;
      {Assigns contents of given object to this object}
    function ReadFromStream(const Stm: IStream): HResult; stdcall;
      {Reads binary version information from given stream}
    function LastErrorMsg: WideString; stdcall;
      {Returns error message generated from last operation, or '' if last
      operation was a success}
  end;

  {
  IVerInfoBinaryReader2:
    Extension of IVerInfoBinaryReader tthat ads new IndexOfString method.

    Inheritance: IVerInfoBinaryReader2 -> IVerInfoBinaryReader -> [IUnknown]
  }
  IVerInfoBinaryReader2 = interface(IVerInfoBinaryReader)
    ['{D94AC867-16FE-45CA-92AA-A1B690EF38D5}']
    function IndexOfString(TableIdx: Integer; const Name: WideString;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the string with the given name in the string
      table with the given TableIdx, or -1 if no such string exists}
  end;

  {
  IVerInfoBinary:
    Interface that enables access to and modification of binary version
    information data. It supports all the methods of IVerInfoBinaryReader plus
    other methods that modify and write out binary version information.

    Inheritance: IVerInfoBinary -> IVerInfoBinaryReader -> [IUnknown]
  }
  IVerInfoBinary = interface(IVerInfoBinaryReader)
    ['{2E6F3972-BDA1-4E61-AC87-22BCB0FB80BD}']
    // Additional fixed file info methods
    function SetFixedFileInfo(const Value: TVSFixedFileInfo): HResult; stdcall;
      {Sets fixed file information record in version information to given value}
    function SetFixedFileInfoArray(const Value: TFixedFileInfoArray): HResult;
      stdcall;
      {Sets fixed file information in version information to information
      contained in given array}
    function SetFixedFileInfoItem(const Offset: TFixedFileInfoOffset;
      const Value: DWORD): HResult; stdcall;
      {Sets the given element of fixed file info to the given value}
    // Additional variable file info methods
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
    // Additional string table methods
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
    // Additional string information methods
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
    // Additional general methods
    function WriteToStream(const Stm: IStream): HResult; stdcall;
      {Writes the binary version information to the given stream}
  end;

  {
  IVerInfoBinary2:
    Extension of IVerInfoBinary tthat ads new IndexOfString method.

    Inheritance: IVerInfoBinary2 -> IVerInfoBinary -> [IUnknown]
  }
  IVerInfoBinary2 = interface(IVerInfoBinary)
    ['{0068F5D1-7338-494C-8226-0A3A1081F513}']
    function IndexOfString(TableIdx: Integer; const Name: WideString;
      out Index: Integer): HResult; stdcall;
      {Sets Index to the index of the string with the given name in the string
      table with the given TableIdx, or -1 if no such string exists}
  end;

  ///  <summary>Prototype for <c>CreateInstance2</c> function that is used to
  ///  create an instance of the object supported by this DLL.</summary>
  ///  <param name="Obj">Typeless [out] Receives the required object. Pass in a
  ///  variable of any of the supported interface types.</param>
  ///  <returns><c>HResult</c> Success or failure code.</returns>
  TVerInfoBinaryCreateFunc = function(out Obj): HResult; stdcall;

implementation

end.
