@rem ---------------------------------------------------------------------------
@rem Script used to create zip file containing source code of the Version
@rem Information Manipulator Library.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2007
@rem ---------------------------------------------------------------------------

@echo off

rem Tidy up temp and non required files
call Tidy.bat

setlocal

cd ..

set OutFile=Release\dd-vibindata-src.zip

rem Delete any existing source release zip file
if exist %OutFile% del %OutFile%

rem Copy all source files except .dsk files to Src sub directory
zip -r -9 %OutFile% Src
zip -d %OutFile% *.dsk

rem Copy binary resource files to Bin subsdirectory
zip -r -9 %OutFile% Bin\*.res

rem Copy subsidiary documentation files to Doc sub directory
zip -r -9 %OutFile% Docs\License.txt Docs\UserGuide.rtf Docs\ChangeLog.txt
zip -r -9 %OutFile% Docs\ReadMe.txt

rem Copy main documentation files to root directory
zip -j -9 %OutFile% Docs\ReadMe-Src.txt Docs\MPL.txt Docs\SourceCodeLicenses.txt

endlocal
