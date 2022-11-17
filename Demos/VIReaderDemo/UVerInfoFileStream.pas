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

end.
