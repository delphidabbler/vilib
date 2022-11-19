:: Deploy script for VILib
::
:: This script compiles a release of VILib's VIBinData.dll and places the DLL
:: into zip files, along with documentation, ready for release.
::
:: This script uses MSBuild, VIEd.exe and Zip.exe

:: To use the script:
::
::   1) Start the Embarcadero RAD Studio Command Prompt to set the environment
::      variables required by MSBuild.
::
::   2) Set the ZIPROOT environment variable to the directory where zip.exe is
::      installed. A suitable verson of Zip.exe can be obtained from
::      http://stahlforce.com/dev/index.php?tool=zipunzip
::
::   3) Set the VIEDROOT environment variable to the directory where the
::      DelphiDabbler Version Information Editor (VIEd) is installed.
::      VIEd can be obtained from https://delphidabbler.com/software/vied
::
::   4) Change directory to that where this script is located.
::
::   5) Run the script:
::
::        Usage:
::          Deploy <version>
::        where
::          <version> is the version number of the release, e.g. 1.0.5

@echo off

echo -----------------------
echo Deploying VILib Release
echo -----------------------

:: Check for required parameter
if "%1"=="" goto paramerror

:: Check for required environment variables
if "%ZipRoot%"=="" goto envvarerror
if "%VIEdRoot%"=="" goto envvarerror

:: Set variables used by this script
set Version=%1
set BuildRoot=.\_build
set BuildExeRoot=%BuildRoot%\Exe
set ReleaseDir=%BuildRoot%\release
set OutFile=%ReleaseDir%\vilib-32bit-%Version%.zip
set SrcDir=Src
set ExportDir=%SrcDir%\Exports
set DocsDir=Docs

:: Set environment variable required in an MSBuild target
set BDSBin=%BDS%\bin

:: Make a clean directory structure
if exist %BuildRoot% rmdir /S /Q %BuildRoot%
mkdir %BuildExeRoot%
mkdir %ReleaseDir%

setlocal

:: Build Pascal
cd %SrcDir%

echo.
echo Building DLL (32 bit only)
echo.
msbuild VIBinData.dproj
echo.

endlocal

:: Create zip file
echo.
echo Creating zip files
%ZipRoot%\zip.exe -j -9 %OutFile% %BuildExeRoot%\VIBinData.dll
%ZipRoot%\zip.exe -j -9 %OutFile% README.md
%ZipRoot%\zip.exe -j -9 %OutFile% LICENSE.md
%ZipRoot%\zip.exe -j -9 %OutFile% CHANGELOG.md
%ZipRoot%\zip.exe -j -9 %OutFile% %DocsDir%\UserGuide.md
%ZipRoot%\zip.exe -j -9 %OutFile% %ExportDir%\IntfBinaryVerInfo.pas

echo.
echo ---------------
echo Build completed
echo ---------------

goto end

:: Error messages

:paramerror
echo.
echo ***ERROR: Please specify a version number as a parameter
echo.
goto end

:envvarerror
echo.
echo ***ERROR: ZipRoot or VIEdRoot environment variables not set
echo.
goto end

:: End
:end