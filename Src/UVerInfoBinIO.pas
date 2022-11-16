{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2002-2022, Peter Johnson (https://gravatar.com/delphidabbler).
 *
 * Class used to input from and output to a wrapped stream: the class provides a
 * convenient interface to the stream.
}

unit UVerInfoBinIO;

interface

uses
  // Delphi
  ActiveX;

type

  {
  TVerInfoBinIO:
    IO object used to input from and output to a wrapped stream: the object
    simply provides a convenient interface to the stream.

    Inheritance: TVerInfoBinIO -> [TObject]
  }
  TVerInfoBinIO = class(TObject)
  private
    fStream: IStream;
      {The wrapped stream}
  public
    constructor Create(const Stream: IStream);
      {Class constructor: records reference to wrapped stream}
    procedure ReadBuffer(var Buffer; Count: Integer);
      {Reads Count bytes from stream into given buffer. Raises exception if
      Count bytes cannot be read or if underlying stream read fails. Note that
      Buffer is not a pointer}
    procedure WriteBuffer(const Buffer; Count: Integer);
      {Writes Count bytes from Buffer to the stream. Raises exception if Count
      bytes cannot be written or if underlying stream write fails. Note that
      Buffer is not a pointer}
    function Seek(Move: LongInt; Origin: Integer): LongInt;
      {Sets the position in the stream to Move bytes from the given origin.
      Raises exception if the stream doesn't support the seek operation. The
      origin is specified in same way as when calling IStream.Seek. Returns the
      new position}
    function GetPosition: LongInt;
      {Returns the current position in the stream. Raises exception if position
      can't be read}
    function GetSize: LongInt;
      {Returns the size of the stream. Raises exception if size cannot be
      determined}
  end;

implementation

uses
  // Delphi
  Classes;

resourcestring
  // Error messages
  sCantGetSize = 'Can''t get size of stream';
  sCantGetPos = 'Can''t get current position in stream';
  sCantSeek = 'Can''t perform seek on stream';
  sReadError = 'IStream read error';
  sWriteError = 'IStream write error';

{ TVerInfoBinIO }

constructor TVerInfoBinIO.Create(const Stream: IStream);
  {Class constructor: records reference to wrapped stream}
begin
  inherited Create;
  fStream := Stream;
end;

function TVerInfoBinIO.GetPosition: LongInt;
  {Returns the current position in the stream. Raises exception if position can't
  be read}
var
  CurPos: UInt64;  // position in stream
begin
  // Attempt to get position in stream
  if not Succeeded(fStream.Seek(0, STREAM_SEEK_CUR, CurPos)) then
    raise EStreamError.Create(sCantGetPos);
  // Return position found, converted to 32 bits
  Result := CurPos;
end;

function TVerInfoBinIO.GetSize: LongInt;
  {Returns the size of the stream. Raises exception if size cannot be
  determined}
var
  StatStg: TStatStg;  // structure returned from IStream.Stat
begin
  // Get status record for given stream (contains size)
  if not Succeeded(fStream.Stat(StatStg, STATFLAG_DEFAULT)) then
    raise EStreamError.Create(sCantGetSize);
  // Read stream size from status record
  Result := StatStg.cbSize;
end;

procedure TVerInfoBinIO.ReadBuffer(var Buffer; Count: Integer);
  {Reads Count bytes from stream into given buffer. Raises exception if Count
  bytes cannot be read or if underlying stream read fails. Note that Buffer is
  not a pointer}
var
  BytesRead: LongInt; // number of bytes read
begin
  // Check there's something to do
  if (Count <> 0) then
    // Attempt to read: raise exception if required number of bytes not read
    if Failed(fStream.Read(@Buffer, Count, @BytesRead))
      or (BytesRead <> Count) then
      raise EStreamError.Create(sReadError);
end;

function TVerInfoBinIO.Seek(Move, Origin: Integer): LongInt;
  {Sets the position in the stream to Move bytes from the given origin. Raises
  exception if the stream doesn't support the seek operation. The origin is
  specified in same way as when calling IStream.Seek. Returns the new position}
var
  NewPos: UInt64;  // new position in stream
begin
  // Attempt to seek to required position
  if not Succeeded(fStream.Seek(Move, Origin, NewPos)) then
    raise EStreamError.Create(sCantSeek);
  // Return new position converted to 32 bits
  Result := LongInt(NewPos);
end;

procedure TVerInfoBinIO.WriteBuffer(const Buffer; Count: Integer);
  {Writes Count bytes from Buffer to the stream. Raises exception if Count bytes
  cannot be written or if underlying stream write fails. Note that Buffer is not
  a pointer}
var
  BytesWritten: LongInt;  // number of bytes written
begin
  // Check there's something to do
  if Count <> 0 then
  begin
    // Try to write data: raise exception if required num of bytes not written
    if Failed(fStream.Write(@Buffer, Count, @BytesWritten))
      or (BytesWritten <> Count) then
      raise EStreamError.Create(sWriteError);
  end;
end;

end.
