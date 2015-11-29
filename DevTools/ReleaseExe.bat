@rem ---------------------------------------------------------------------------
@rem Script used to create zip file containing binary release of the Version
@rem Information Manipulator Library.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2007
@rem ---------------------------------------------------------------------------

@echo off

setlocal

cd ..

set OutFile=Release\dd-vibindata.zip

rem Delete any existing binary release zip file
if exist %OutFile% del %OutFile%

rem Store setup file in zip file
zip -j -9 %OutFile% Exe\VIBinData.dll
rem Store documentation in zip file
zip -j -9 %OutFile% Docs\ReadMe.txt
zip -j -9 %OutFile% Docs\License.txt
zip -j -9 %OutFile% Docs\ChangeLog.txt
zip -j -9 %OutFile% Docs\UserGuide.pdf
rem Store interface file in zip file
zip -j -9 %OutFile% Src\Exports\IntfBinaryVerInfo.pas

endlocal
