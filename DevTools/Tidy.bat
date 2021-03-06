@rem ---------------------------------------------------------------------------
@rem Script used to delete VIBinData's temp and backup source files
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2007
@rem ---------------------------------------------------------------------------

setlocal

@echo off
set SrcDir=..\Src
set DocsDir=..\Docs

echo Deleting *.~* from "%SrcDir%" and subfolders
del /S %SrcDir%\*.~*
echo.

echo Deleting *.~* from "%DocsDir%" and subfolders
del /S %DocsDir%\*.~*
echo.

echo Done.

endlocal
