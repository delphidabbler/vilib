@rem ---------------------------------------------------------------------------
@rem Script used to build Pascal source files for the Version Information
@rem Manipulator Library.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2007
@rem ---------------------------------------------------------------------------

@echo off

rem Build Windows application
setlocal
cd ..\Src
call build pas
endlocal
