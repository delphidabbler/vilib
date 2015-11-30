# ------------------------------------------------------------------------------
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at http://mozilla.org/MPL/2.0/
#
# Copyright (C) 2005-2015, Peter Johnson (www.delphidabbler.com).
#
# Makefile for the vilib project.
# ------------------------------------------------------------------------------


# Required macros
# ---------------
#
#   DELPHIROOT
#     Install directory of Delphi compiler to be used. The preferred compiler is
#     Delphi XE. Later compilers may work but may require some minor alterations
#     to the code. It is possible that Delphi 2009 and 2010 could work, but
#     earlier, non-Unicode compilers are not suitable.
#
# Optional macros
# ---------------
#
#   VIEDROOT
#     Set to the install directory of VIEd, the DelphiDabbler Version
#     Information Editor. If not set then the program is expected to be on the
#     system path.
#
#   ZIPROOT
#     Set to the install directory of the INFO-ZIP Zip program. If not set then
#     the program is expected to be on the system path.


# Check for required macros

!ifndef DELPHIROOT
!error DELPHIROOT environment variable required.
!endif

# Set required directory macros

ROOT = ..
SRC = $(ROOT)\Src
DOCS = $(ROOT)\Docs
BUILD = $(ROOT)\Build
EXE = $(BUILD)\Exe
BIN = $(BUILD)\Bin
RELEASE = $(BUILD)\Release
RELEASEFILENAME = vilib.zip
RELEASEFILEPATH = $(RELEASE)\$(RELEASEFILENAME)

# Define common macros that access required build tools

MAKE = "$(MAKEDIR)\Make.exe" -$(MAKEFLAGS)

DCC32 = "$(DELPHIROOT)\Bin\DCC32.exe"

BRCC32 = "$(DELPHIROOT)\Bin\BRCC32.exe"

!ifdef VIEDROOT
VIED = "$(VIEDROOT)\VIEd.exe" -makerc
!else
VIED = VIEd.exe -makerc
!endif

!ifdef ZIPROOT
ZIP = "$(ZIPROOT)\Zip.exe"
!else
ZIP = Zip.exe
!endif

# Implicit rules

# Delphi projects are assumed to contain required output and search path
# locations in the project options .cfg file.
.dpr.dll:
  @echo +++ Compiling Delphi Project $< +++
  @$(DCC32) $< -B

# Resource files are compiled to the Bin directory using RC.
#.rc.res:
#  @echo +++ Compiling Resource file $< to $(@F) +++
#  @$(RC) -fo$(BIN)\$(@F) $<

# Temporary resource files with special extension .tmp-rcx are compiled to the
# Bin directory using BRCC32.
.tmp-rcx.res:
  @echo +++ Compiling Resource file $< to $(@F) +++
  @$(BRCC32) -fo$(BIN)\$(@F) $<
  -@del $(<B).tmp-rcx

# Version info files are compiled by VIEd to a temporary .tmp-rcx resource file.
.vi.tmp-rcx:
  @echo +++ Compiling Version Info file $< to $(@F) +++
  @$(VIED) .\$<
  -@ren $(@B).rc $(@F)

# Default target is to configure and build the ViBinData DLL
default: dll

# Configure and build the DLL
dll: config resources pascal

# Build DLL and create release file
all: dll release

# Configure source folders
config:
  @echo Configuring vilib
  # Create .cfg file from templates
  #@copy /Y VIBinData.cfg.tplt VIBinData.cfg
  # Create build folders if necessary
  @if not exist $(BUILD) @mkdir $(BUILD)
  @if not exist $(BIN) @mkdir $(BIN)
  @if not exist $(EXE) @mkdir $(EXE)
  @if not exist $(RELEASE) @mkdir $(RELEASE)

# Compiles the resources
resources: VVIBinData.res

# Builds PasHi pascal files and links program
pascal: VIBinData.dll

# Build release files (.zip)
release:
  @echo Creating Release File $(RELEASEFILENAME)
  -@if exist $(RELEASEFILEPATH) del $(RELEASEFILEPATH)
  @$(ZIP) -j -9 $(RELEASEFILEPATH) $(EXE)\VIBinData.dll
  #@$(ZIP) -j -9 $(RELEASEFILEPATH) $(DOCS)\ReadMe.txt $(ROOT)\LICENSE

# Clean up unwanted files
clean:
  @cd ..
  # remove unwanted files: temps (~ or .~*), .dsk, .ddp, .local, .identcache
  -@del /S *.~* 2>nul
  -@del /S ~* 2>nul
  -@del /S *.dsk 2>nul
  -@del /S *.ddp 2>nul
  -@del /S *.local 2>nul
  -@del /S *.identcache 2>nul
  -@del /S *.tvsconfig 2>nul
  # remove any __history folders
  -@for /F "usebackq" %i in (`dir /S /B /A:D ..\__history`) do @rmdir /S /Q %i
  @cd Src

deepclean: clean
  # remove files created by make config
  #-@del /S *.cfg 2>nul
  # remove folders created by make config
  -@if exist $(BIN) rmdir /S /Q $(BIN)
  -@if exist $(EXE) rmdir /S /Q $(EXE)
  -@if exist $(RELEASE) rmdir /S /Q $(RELEASE)
  -@if exist $(BUILD) rmdir /S /Q $(BUILD)