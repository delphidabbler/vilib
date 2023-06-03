{
  Part of a demo project for VIBinData.dll.

  MIT License: https://delphidabbler.mit-license.org/2022/
}

unit ULogger;

interface

uses
  Vcl.StdCtrls;

type
  TLogger = class(TObject)
  strict private
    var
      fMemo: TMemo;
      fColWidth: UInt8;
  public
    constructor Create(Memo: TMemo; ColWidth: UInt8);
    type
      TNumberFmt = (Decimal, Hex, HexC);
    procedure Log; overload;
    procedure Log(Txt: string); overload;
    procedure Log(Fmt: string; Args: array of const); overload;
    procedure Log(Txt: string; Value: string); overload;
    procedure Log(Txt: string; Value: Int64; Fmt: TNumberFmt = Decimal); overload;
    procedure Log(Txt: string; Value: Word; Fmt: TNumberFmt = HexC); overload;
    procedure Log(Txt: string; Value: LongWord; Fmt: TNumberFmt = HexC); overload;
    procedure HexDump(Data: array of Byte);
  end;

implementation

uses
  System.SysUtils;

{ TLogger }

constructor TLogger.Create(Memo: TMemo; ColWidth: UInt8);
begin
  inherited Create;
  fMemo := Memo;
  fColWidth := ColWidth;
end;

procedure TLogger.Log;
begin
  Log('');
end;

procedure TLogger.Log(Txt: string);
begin
  fMemo.Lines.Add(Txt);
end;

procedure TLogger.Log(Fmt: string; Args: array of const);
begin
  Log(Format(Fmt, Args));
end;

procedure TLogger.Log(Txt, Value: string);
begin
  Log(
    StringOfChar(' ', fColWidth - Txt.Length) + Txt + ' | ' + Value
  );
end;

procedure TLogger.Log(Txt: string; Value: Int64; Fmt: TNumberFmt);
begin
  case Fmt of
    Decimal:  Log(Txt, Value.ToString);
    Hex:      Log(Txt, Value.ToHexString(16));
    HexC:     Log(Txt, '0x' + Value.ToHexString(16));
  end;
end;

procedure TLogger.HexDump(Data: array of Byte);
const
  cColCount = 16;
  cLineFmt = '%-48s %s';
begin
  var Pos: Integer := 1;
  var HexLine: string := '';
  var CharLine: string := '';
  for var B in Data do
  begin
    var BHex := IntToHex(B);
    HexLine := HexLine + BHex + ' ';
    if B in [32..126] then
      CharLine := CharLine + Chr(B)
    else
      CharLine := CharLine + '.';
    if Pos = cColCount then
    begin
      Log(cLineFmt, [HexLine, CharLine]);
      HexLine := '';
      CharLine := '';
      Pos := 1;
    end
    else
      Inc(Pos);
  end;
  if HexLine <> '' then
    Log('%-48s %s', [HexLine, CharLine]);
end;

procedure TLogger.Log(Txt: string; Value: LongWord; Fmt: TNumberFmt);
begin
  case Fmt of
    Decimal:  Log(Txt, Value.ToString);
    Hex:      Log(Txt, Value.ToHexString(8));
    HexC:     Log(Txt, '0x' + Value.ToHexString(8));
  end;
end;

procedure TLogger.Log(Txt: string; Value: Word; Fmt: TNumberFmt);
begin
  case Fmt of
    Decimal:  Log(Txt, Value.ToString);
    Hex:      Log(Txt, Value.ToHexString(4));
    HexC:     Log(Txt, '0x' + Value.ToHexString(4));
  end;
end;

end.
