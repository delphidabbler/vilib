# Version Information Manipulator Library User Guide

> This user guide assumes that you know what kinds of information can be stored in version information resources. If you need to brush up on your knowledge please see Microsoft's  [Version Information Reference](https://learn.microsoft.com/en-us/windows/win32/menurc/version-information-reference) and their [VERSIONINFO resource](https://learn.microsoft.com/en-us/windows/win32/menurc/versioninfo-resource) documentation.
## Contents

* [Introduction](#introduction)
* [Accessing the DLL's Functionality](#accessing-the-dlls-functionality)
    * [Loading the DLL & _CreateInstance_](#loading-the-dll--createinstance)
    * [Checking if a file can be read by the DLL](#checking-if-a-file-can-be-read-by-the-dll)
* [Using the Objects](#using-the-objects)
    * [Return Values & Calling Conventions](#return-values--calling-conventions)
    * [_IVerInfoBinaryReader_ / _IVerInfoBinaryReader2_ Methods](#iverinfobinaryreader--iverinfobinaryreader2-methods)
    * [_IVerInfoBinary_ / _IVerInfoBinary2_ Methods](#iverinfobinary--iverinfobinary2-methods)
* [Accessing Binary Version Information](#accessing-binary-version-information)
    * [Reading Version Information from a 32/64 Bit Executable](#reading-version-information-from-a-3264-bit-executable)
    * [Reading & Writing Version Information In 32 Bit Resource Files](#reading--writing-version-information-in-32-bit-resource-files)

## Introduction

The library enables you to read raw binary version information data that has been extracted from either a 32 or 64 bit Windows executable file or a DLL or from an `RT_VERSION` resource in a 32 bit binary resource file. The library can be used to create, update and write out binary version information data suitable for inclusion in a 32 bit binary resource file.

> **NOTE:** The library reads and writes correctly formatted version information. However you are responsible for extracting raw version information from executables and for extracting data from, and inserting data into, binary resource files. Details of how to do this, along with example Delphi Pascal source code is provided in the [Accessing Binary Version Information](#accessing-binary-version-information) section below.

The library is provided in a 32 bit Windows DLL named `VIBinData.dll`. It is recommended that the DLL is placed in the same directory as the executable file that is going to call into it.

> **WARNING:** `VIBinData.dll` is only available as a 32 bit DLL so it can't be used with 64 bit programs.

## Accessing the DLL's Functionality

Access to all the DLL's functionality is via interfaces to an object that is exposed by the DLL. The object is created by calling the _CreateInstance_ function, which is the only function exported by the DLL.

_CreateInstance_ is exported by name as:

~~~pascal
function CreateInstance(out Obj): HResult; stdcall;
~~~

You must pass a variable of the any of the supported interface types as the _Obj_ parameter. If all goes well then an object implementing the interface it is created and stored in _Obj_ and _S_OK_ is returned. If there is any other error then _Obj_ is set to **nil** and _E_FAIL_ is returned.  The supported interfaces are:

| Interface | Descriptions |
|:----------|:-------------|
| _IVerInfoBinaryReader_ & _IVerInfoBinaryReader2_ | Provide read only access to 32 bit binary version information. |
| _IVerInfoBinary_, _IVerInfoBinary2_ | Provide read/write access to 32 bit binary version information. |

The interfaces and their methods are discussed in detail [below](#using-the-objects).

> The file `IntfBinaryVerInfo.pas` is provided with the DLL. It is a Delphi Pascal unit that defines all the supported interfaces, some supporting data types and the type of _CreateInstance_. Delphi users can add this unit to any project that uses the DLL.

### Loading the DLL & _CreateInstance_

The DLL can either be loaded statically or dynamically.

#### Static loading & use

If you're sure the DLL will be present at run time you can import _CreateInstance_ statically like this:

~~~pascal
function CreateInstance(out Obj): HResult; stdcall;
  external 'VIBinData.dll';
~~~

or, if you want to use a different name for the function:

~~~pascal
function CreateFunc(out Obj): HResult; stdcall;
  external 'VIBinData.dll' name 'CreateInstance';
~~~

_CreateInstance_ can then be used to create the required object as follows:

~~~pascal
var
  VI: IVerInfoBinaryReader2; // could be IVerInfoBinaryReader
begin
  // Load the required object: here we're using the read only object
  if Failed(CreateInstance(VI)) then
    raise Exception.Create('Can''t instantiate required object');
  // ...
  // Do something with object referenced by VI
  // ...
end;
~~~

#### Dynamic loading and use

To import dynamically you can something like the following code:

~~~pascal
var
  DLL: THandle;
  CreateFunc: TVerInfoBinaryCreateFunc;
  VI: IVerInfoBinary2;  // could be IVerInfoBinary
begin
  // Set default values in case of exceptions
  DLL := 0;
  VI := nil;
  try
    // Load the DLL
    DLL := SafeLoadLibrary('VIBinData.dll'); // Provide a path if necessary
    if DLL = 0 then
      raise Exception.Create('Can''t load VIBinData.dll');
    // Load CreateInstance in CreateFunc variable
    CreateFunc := GetProcAddress(fDLL, 'CreateInstance');
    if not Assigned(CreateFunc) then
      raise Exception.Create('Can''t load "CreateInstance" function from DLL');
    // Load the required object here we're using the read/write object
    if Failed(CreateFunc(VI)) then
      raise Exception.Create('Can''t instantiate required object in DLL');
    // ...
    // Do something with object referenced by VI
    // ...
  finally
    // Ensure the object is released before freeing the library
    VI := nil;
    // Free the library
    if DLL <> 0 then
      FreeLibrary(DLL);
  end;
end;
~~~

In a real program, you would probably make the variables in the above listing fields of a class, place the code in the try block in the constructor and the code in the finally block in the destructor. Doing that is left as an exercise.

### Checking if a file can be read by the DLL

The DLL can only be used to read and write 32 bit binary version information. The kinds of version information data that can be accessed are:

_either_

* Data contained in resources of 32 & 64 bit programs when read from a program running on a Windows NT operating system (i.e. Windows NT, 2000, XP, 7 and later), 

_or_

* All 32 bit binary Windows resource files.

> Note that only 32 bit Unicode format binary version information data is supported. ANSI format data cannot be processed. If you need to work with ANSI format data please use a v1.x release.

In the unlikely event that you can't safely assume a Windows NT based OS, you can check with the following function:

~~~pascal
uses
  System.SysUtils, Winapi.Windows;

function IsWinNT: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT);
end;
~~~

Detecting the type of an executable file is more complicated. However there's a function and enumerated type defined in the [delphidabbler/UExeType.pas](https://gist.github.com/delphidabbler/1b90a542f94ae686509e285805a31665) Gist that does the job. The function is defined as:

~~~pascal
function ExeType(const FileName: string): TExeType;
~~~

You pass the full path to the file being examined and get back value from an enumerated type that describes the type of file. If you have a 32 or 64 bit executable then you will get back a value in the set `[etExe32, etExe64, etDLL32, etDLL64]`.

You can test for a 32 bit binary resource file by checking if the first eight bytes in the file are:

~~~text
$00 $00 $00 $00 $20 $00 $00 $00
~~~

Once you checked that a file is valid you can read it's version information using an object created using _CreateInstance_ as described in [Loading the DLL & CreateInstance](#loading-the-dll--createinstance) above.

This just leaves the problem of how to access version information stored in executable and resource files. We'll come on to that [later](#accessing-binary-version-information), after we've reviewed the methods exposed by the object interfaces.

## Using the Objects

As you know each object exposes either a read-only _IVerInfoBinaryReader_ / _IVerInfoBinaryReader2_ interface or a _IVerInfoBinary_ / _IVerInfoBinary2_ read/write interface. We will discuss them separately below.

### Return Values & Calling Conventions

With the sole exception of _LastErrorMsg_, every method of either interface returns an _HRESULT_ value. Any data returned from the methods is always passed out via an **out** parameter.

All methods use the **stdcall** calling convention.

The _HRESULT_ will either be _S_OK_ if the method call completes successfully or _E_FAIL_ on error. More information can be found about the last error by calling the _LastErrorMsg_ method which returns a _WideString_ containing the error message.

> This technique of returning an _HRESULT_ to signal success or failure was adopted to make the DLL easier to call from other languages. Unfortunately for Delphi users, this does make the DLL harder to use than if Delphi's **safecall** convention had been adopted.

You should always check the _HRESULT_ return value. The following code checks the given _HRESULT_ and raises an exception if the _HRESULT_ represents a failure:

~~~pascal
procedure Check(Value: HRESULT);
begin
  if Failed(Value) then
    raise Exception.Create('Error in call to VIBinData.dll');
end;
~~~

Every call to one of the methods exposed by the library can be wrapped in a call to _Check_. For example, the _GetTranslationCount_ method can be called like this:

~~~pascal
var
  Count: Integer;
begin
  // ...
  Check(GetTranslationCount(Count));
  // Do something with Count
end;
~~~

### _IVerInfoBinaryReader_ / _IVerInfoBinaryReader2_ Methods

Being read-only, _IVerInfoBinaryReader_ & _IVerInfoBinaryReader2_ are used when you just want to explore some existing version information without modifying it.

In this section the available methods are reviewed and a brief explanation of their purpose is is provided. Except where explicitly stated all methods are supported by both interfaces.

> Details of parameters and exactly how to call each method are not provided here because the methods are individually documented in the `IntfBinaryVerInfo.pas` unit. Please read that unit to learn how to call each method.

To get the fixed file information use one of the following methods:

* _GetFixedFileInfo_ - returns the _TVSFixedFileInfo_ structure.
* _GetFixedFileInfoArray_ - returns an array of fixed file information fields.
* _GetFixedFileInfoItem_ - returns a specified fixed file information field.

To iterate the supported translations we first need to find the number of translations that exist in the translation table. We find the number of translations by calling:

* _GetTranslationCount_ - returns the required count or `0` if no translations have been defined.

We can find details of each translation using these methods, which both take the zero based index of the required translation as a parameter:

* _GetTranslation_ - returns a record containing the translation's language ID and character set (code page).
* _GetTranslationAsString_ - returns an eight character hexadecimal string representation of the translation, with the 1st four hex digits being the language ID and the 2nd four digit being the character set.

We can also get the index of a specified translation, or check if it exists by calling:

* _IndexOfTranslation_ - given a record containing the translation's language ID and character set, returns a zero based index or `-1` if the translation doesn't exist.

To find the number of string tables available we can call:

* _GetStringTableCount_ - returns the required count or `0` no string tables exist.

Each string table is identified by an 8 digit hexadecimal key string, with the first 4 digits representing a language ID and the 2nd 4 digits representing a character set. We can find out which translation a string table belongs to by using one of the following methods, which both take as a parameter the zero based index of the string table in question:

* _GetStringTableTransString_ - returns the 8 digit hexadecimal key string that identifies the string table.
* _GetStringTableTransCode_ - returns a record containing fields for the string table's language ID and character set represented by the table's hexadecimal key string.

We can also get the index of a string table key in the table, or check if it exists by using:

* _IndexOfStringTable_ - given the hexadecimal key string returns it's index in the string table or `-1` on error.
* _IndexOfStringTableByCode_ - given a record storing the language id / character set that represent the string table key, returns the key's index in the string table or `-1` on error.

We can now find the number strings in a specified string table by using the following method. It takes the index of required string table as a parameter:

* _GetStringCount_ - returns the number of strings in the given string table or 0 if the table contains no strings.

Strings are stored as name/value pairs. The next three methods are used to get the name and value of a specified string item within a string table. They all take the index of the relevant string table as one of the parameters:

* _GetStringName_ - get the name of string at given index in string table.
* _GetStringValue_ - get the value at given index in string table.
* _GetStringValueByName_ - get the value associated with the given name in the string table.

For _IVerInfoBinaryReader2_ only, we can also get the index of a string by name within a string table, or check if it exists by using:

* _IndexOfString_ [_IVerInfoBinaryReader2_ only] - get the index of named string within string table with given index, or `-1` on error.

Finally, there are some miscellaneous methods:

* _Clear_ - deletes all translations and string tables and zeros all the fixed file information fields, except for the signature and structure version.
* _Assign_ - copies version information from another _IVerInfoBinaryReader_ / _IVerInfoBinaryReader2_ object.
* _ReadFromStream_ - reads binary version information from an _IStream_ opened on some version information data. For details see [Accessing Binary Version Information](#accessing-binary-version-information) below.
* _LastErrorMessage_ - returns a _WideString_ value that gives a description of the last error. This is the only method that doesn't return a _HRESULT_ value.

### _IVerInfoBinary_ / _IVerInfoBinary2_ Methods

_IVerInfoBinary_ descends from _IVerInfoBinaryReader_ while _IVerInfoBinary2_ descends from _IVerInfoBinaryReader2_. The purpose of these interfaces is to enable modification of version information before writing it to, for example, a 32 bit resource file.

The interfaces expose all of the methods of their parent interfaces, as described above.

In this section we will only discuss the methods that are unique to _IVerInfoBinary_ & _IVerInfoBinary2_, i.e. those that are used to modify version information. All of the following methods are supported by both interfaces.

To update the fixed file information use one of the following methods:

* _SetFixedFileInfo_ - sets the whole of the fixed file information to that supplied in a _TVSFixedFileInfo_ record.
* _SetFixedFileInfoArray_ - sets the whole of the fixed file informaton to that supplied in an array of fixed file information fields.
* _SetFixedFileInfoItem_ - sets a given fixed file information field.

The translation table can be modified using the following methods:

* _SetTranslation_ - updates the translation at a given index in the translation list.
* _AddTranslation_ - adds a new translation to the translation list.
* _DeleteTranslation_ - deletes the translation at a given index in the translation list.

The string table list can be modified using the following methods:

* _AddStringTable_ - adds a new string table with a given 8 character hexadecimal key.
* _AddStringTableByCode_ - adds a new string table with a key calculated from a given record containing the language ID and character set.
* _DeleteStringTable_ - deletes the string table at a given index in the table list.

String names within a specified string table can be modified using the following methods. All the methods take a parameter that specifies the index of the string table to be operated on:

* _SetString_ - sets the value of the string at a given index in the string table to a new value.
* _SetStringByName_ - sets the value of a string with a given name to a new value.
* _AddString_ - adds a new string with a specified name and value to a string table.
* _SetOrAddString_ - if a string with a given name is not in the string table then its value is updated, otherwise the string name & value are added to the table.
* _DeleteString_ - deletes the string at a given index in the string table.
* _DeleteStringByName_ - deletes the string with a given name from the string table.

Lastly there are the following additional or modified methods:

* _Assign_ - sets the content to that of another _IVerInfoBinary_ / _IVerInfoBinary2_ object instance.
* _WriteToStream_ - writes binary version information to an _IStream_ that can update the output document. For details of how to do this see [Accessing Binary Version Information](#accessing-binary-version-information) below .

## Accessing Binary Version Information

Now you know how to load the DLL, how to create an object and how to choose which object you want. You also know to manipulate version information using the objects exposed by the DLL. But how to you get to the version information embedded in executable files and binary version information?

The techniques for executable and resource files are different and will be dealt with separately.

### Reading Version Information from a 32/64 Bit Executable

First we'll define a _TStream_ descendant that can read version information from the execuatble file. Here's the code:

~~~pascal
{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2022, Peter Johnson (https://gravatar.com/delphidabbler).
 *
 * Defines a class that provides a TStream interface to a Windows version
 * information resource embedded in a file of a type that can have Windows
 * resources, including executable files and DLLs.
}

unit UVerInfoFileStream;

interface

uses
  System.Classes;

type
  TVerInfoFileStream = class(TCustomMemoryStream)
  strict private
    var
     fInfoBuffer: Pointer;
     fInfoBufferSize: Integer;
    procedure AllocBuffer(const Size: Integer);
    procedure FreeBuffer;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    function Write(const Buffer; Count: LongInt): LongInt; override;
end;

implementation

uses
  System.SysUtils,
  WinApi.Windows;

resourcestring
  // Error messages
  sNoFile = 'File "%s" does not exist';
  sCantWrite =  'Can''t write version information into an executable file';
  sNoVerInfo = 'No version information present in file "%s"';

{ TVerInfoFileStream }

procedure TVerInfoFileStream.AllocBuffer(const Size: Integer);
begin
  if (fInfoBufferSize <> Size) or (fInfoBuffer = nil) then
  begin
    // We need to allocate buffer wrong size
    // first free any old buffer
    FreeBuffer;
    if Size > 0 then
      // non-zero size specified: allocate the buffer
      GetMem(fInfoBuffer, Size);
    // record new buffer size
    fInfoBufferSize := Size;
  end;
end;

constructor TVerInfoFileStream.Create(const FileName: string);
var
  Dummy: DWORD; // used in call to GetFileVersionInfoSize
  VerInfoSize: Integer; // size of version information data
begin
  inherited Create;
  // Check file exists
  if not FileExists(FileName) then
    raise EStreamError.CreateFmt(sNoFile, [FileName]);
  // Get size of version information data in file
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if VerInfoSize > 0 then
  begin
    // Allocate buffer of required size to hold ver info
    AllocBuffer(VerInfoSize);
    // Read version info into memory stream
    if not GetFileVersionInfo(
      PChar(FileName), Dummy, fInfoBufferSize, fInfoBuffer
    ) then
     // read failed: free the allocated buffer
      FreeBuffer;
  end;
  // If we didn't get version info we raise exception
  if fInfoBufferSize = 0 then
    raise EStreamError.CreateFmt(sNoVerInfo, [FileName]);
  // Set the stream's memory pointer to buffer where ver info is
  SetPointer(fInfoBuffer, fInfoBufferSize);
end;

destructor TVerInfoFileStream.Destroy;
begin
  FreeBuffer;
  inherited;
end;

procedure TVerInfoFileStream.FreeBuffer;
begin
  if fInfoBufferSize > 0 then
  begin
    // Buffer size > 0 => we must have buffer, so free it
    Assert(Assigned(fInfoBuffer));
    FreeMem(fInfoBuffer, fInfoBufferSize);
    // Reset buffer and size to indicate buffer not assigned
    fInfoBuffer := nil;
    fInfoBufferSize := 0;
  end;
end;

function TVerInfoFileStream.Write(const Buffer; Count: LongInt): LongInt;
begin
  raise EStreamError.Create(sCantWrite);
end;
~~~

To save you some typing, you can find this class in the file `UVerInfoFileStream.pas` included with the project's demo programs.

The following function will load any version information contained in executable file _ExeFile_ into the read-only version information object _VI_:

~~~pascal
procedure ReadVIFromExe(VI: IVerInfoBinaryReader; ExeFile: string);
  // Note: A IVerInfoBinaryReader2 instance can be passed to this procedure
var
  ExeStream: TVerInfoFileStream;
  VIStream: IStream;
begin
  try
    ExeStream := TVerInfoFileStream.Create(ExeFile);
    VIStream := TStreamAdapter.Create(ExeStream, soReference);
    if Failed(VI.ReadFromStream(VIStream)) then
      raise Exception.Create('Some error message');
  finally
    ExeStream.Free;
  end;
end;
~~~

The main point to note is that _TVerInfoFileStream_ is a _TStream_ descendant while _IVerInfoBinaryReader.ReadFromStream_ takes an _IStream_ parameter. We use Delphi's _TStreamAdapter_ to provide an _IStream_ interface to the _TVerInfoFileStream_ object.

### Reading & Writing Version Information In 32 Bit Resource Files

Reading from a 32 bit resource file is a bit more complex because you have to know the 32 bit resource file format in order to locate and read any version information resource it contains. Luckily there's a Delphi library that can help. This is the [ddablib/resfile](https://github.com/ddablib/resfile) source code library on GitHub.

The file containing the required code is `PJResFile.pas`, which needs to be added to your project. We're not going to explain how to use this library - it is [copiously documented online](https://delphidabbler.com/url/resfile-docs) if you are interested. We'll just use it in the following example code.

First let us consider how to read data from a resource file:

~~~pascal
procedure ReadVIFromResourceFile(VI: IVerInfoBinaryReader; ResFilePath: string);
  // Note: A IVerInfoBinaryReader2 instance can be passed to this procedure
var
  ResFile: TPJResourceFile;
  VIEntry: TPJResourceEntry;
  DataStreamAdapter: IStream;
begin
  // Resource file must exist
  if not TFile.Exists(ResFilePath) then
    raise Exception.Create('Resource file not found');
  // Create a resource file object and load resource file into it
  ResFile := TPJResourceFile.Create;
  try
    ResFile.LoadFromFile(ResFilePath);
    // Find RT_VERSION resource, if present (always have resource id 1)
    VIEntry := ResFile.FindEntry(RT_VERSION, MakeIntResource(1));
    if Assigned(VIEntry) then
    begin
      // Found resource entry: load data from it into version
      // information object VI
      DataStreamAdapter: IStream := TStreamAdapter.Create(VIEntry.Data);
      if Failed(VI.ReadFromStream(DataStreamAdapter)) then
        raise Exception.Create('Error reading resource data');
    end
    else
      // Version information resource not found: clear existing VI data
      VI.Clear;
  finally
    ResFile.Free;
  end;
end;
~~~

In outline, the routine opens the resource file, searches for a suitable version information resource and then opens it. The resource file library exposes resources as _TPJResourceEntry_ objects. Those objects in turn expose the resource's raw data as a _TStream_. Once again we need to access the _TStream_ containing the data as an _IStream_ and we use _TStreamAdapter_ to do that.

Finally, we need to be able to write a version information resource to a resource file. Production code would be able to either replace any existing version information resource or create one if none existed. It would also be able to leave any other resources in the resource file alone. Now _TPJResourceFile_ can do all those things, but for the purposes of this user guide we will just create a resource file containing a single version information resource.

~~~pascal
procedure WriteVIToResourceFile(VI: IVerInfoBinary; ResFilePath: string);
  // Note: A IVerInfoBinary2 instance can be passed to this procedure
var
  ResFile: TPJResourceFile;
  VIEntry: TPJResourceEntry;
  DataStreamAdapter: IStream;
begin
  // Create a resource file object and add an empty version info resource to it
  ResFile := TPJResourceFile.Create;
  try
    // Version info resources have type RT_VERSION and *always* have ID of 1
    VIEntry := ResFile.AddEntry(RT_VERSION, MakeIntResource(1));
    DataStreamAdapter := TStreamAdapter.Create(VIEntry.Data);
    if Failed(VI.WriteToStream(DataStreamAdapter) then
      raise Exception.Create('Error writing data');
    // Save resource file containing a single RT_VERSION resource.
    ResFile.SaveToFile(ResFilePath);
  finally
    ResFile.Free;
  end;
end;
~~~

Here we create an empty resource file, add a version information resource to it then wrap an _IStream_ round the resource entry's data stream. Then we write the version information data to the resource entry and then save the resource file.
