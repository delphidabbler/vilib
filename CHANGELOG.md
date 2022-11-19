
# Change Log

This is the change log for the _DelphiDabbler Version Information Manipulator Library_.

All notable changes to this project are documented in this file.

This change log begins with the first ever release, v1.0.0. Releases are listed in reverse version number order.

Version numbering adheres to the principles of [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.1.0 of 2022-11-20

+ Added new _IndexOfString_ method, exposed via new _IVerInfoBinary2_ and _IVerInfoBinaryReader2_ interfaces, that descend from _IVerInfoBinary_ and _IVerInfoBinaryReader_ respectively.
+ Implemented proper support for Unicode strings throughout the code. This avoids the potential loss of information in converting back and forth between Unicode and ANSI when reading Unicode (32 bit) version information.
+ Refactoring:
    + Pushed down numerous changes from interface implementation code into lower level supporting code.
    + Moved some procedural code into classes.
    + Updated and/or removed code as a result of update in Delphi Pascal language version.
    + Other minor rename refactoring.
+ Minor changes to correct the library's version information resource.
+ Added source code for two demo programs to the repository.
+ Changed license:
    + Main library updated from Mozilla Public License v1.1 to v2.0.
    + Most of demo code licensed under the MIT license, except for a few files that use the Mozilla Public License v2.0.
+ Changes to deployed files:
    + Included additional documentation in release zip file.
    + Included Pascal interface definition unit in release zip file.
+ Major overhaul of documentation:
    + Rewrote readme file, moved into repo root and converted to Markdown.
    + Revised change log, moved to repo root and converted to Markdown.
    + Updated main license file re change of license, moved to repo root and converted to Markdown.
    + Rewrote user guide and changed from PDF & ODF formats to Markdown.
    + Added documentation for demo programs.
    + Updated and corrected URLs in documentation and source code comments.
    + Removed some redundant documentation files.
    + Extracted history logs from source & `.phf` files into new `PreSVNHistory.txt` files. This file now contains the update history up to release v1.0.5, prior to bringing the project under version control.
+ Changes to build environment:
    + Changed to compile with Delphi 11 instead of Delphi 7.
    + Added new `Deploy.bat` file to compile the library and create a distribution zip file.
    + Everything now compiles via MSBuild instead of from a series of batch files.
    + Removed old `DevTools` directory containing batch files.
    + Source code now under version control with Git.

## v1.0.5 of 2007-08-26

+ Changed to new EULA and made changes to library's version information to reflect this.
+ Restructured source code tree and changed references accordingly.
+ Added batch file used to build the library.

## v1.0.4 of 2004-10-19

+ Fixed minor bug in error error reporting routine.

## v1.0.3 of 2003-08-17

+ Modified method used to read version information to deal with further badly formed value entries in version information.

## v1.0.2 of 2003-06-22

+ Fixed bug causing access violation when attempt was made to add a string table.
+ Also fixed so that version info root nodes are named correctly.

## v1.0.1 of 2003-05-31

+ Modified input method to be able to read wide string values from version information without using value length stored in version info since this can't be relied upon to be consistent.

## v1.0.0 of 2002-08-04

+ First release.
