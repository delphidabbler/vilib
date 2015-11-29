@rem ---------------------------------------------------------------------------
@rem Script used to build all of the Version Information Manipulator Library.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2007
@rem ---------------------------------------------------------------------------

@echo off

setlocal

rem First build binary resource files
:Build_Resources
call BuildResources.bat

rem Next build pascal files (requires resource file to exist)
:Build_Pascal
call BuildPascal.bat

endlocal
