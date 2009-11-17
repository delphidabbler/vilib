
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
             DELPHIDABBLER VERSION INFORMATION MANIPULATOR LIBRARY
                          SOURCE CODE DOWNLOAD NOTES
________________________________________________________________________________

Source code for the current version of the DelphiDabbler Version Information
Manipulator Library (the "Library") is always available from
http://www.delphidabbler.com/download?id=vibindata&type=src.

The library's source code is provided in a zip file, dd-vibindata-src.zip. This
file includes all of the Library's original code. Files should be extracted from
the zip file and the directory structure should be preserved.

The directory structure is:

<root>         : Documentation describing source code distribution
  Bin          : Required binary resource files
  Docs         : Documentation included in installation
  Src          : Main source code.
    Exports    : Interface to the DLL that is required by apps using the library

In order to compile the source you also need to create a "Exe" directory at the
same level as the "Bin" and "Src" directories.

No additional libraries other than the Delphi 7 VCL are required to compile the
source code.

The program requires a binary resource file named "VVIBinData.res". This file is
provided in the "Bin" directory. The file is contains the library's version
information. See the following section for information on how to modify this
file (but note that the end user license agreement - see License.txt - requires
that the copyright statement and web addresses may not be changed.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Build Tools
________________________________________________________________________________

The library has its own build.bat batch file that can be used to automate full
or partial builds. The batch file must be called using a command line parameter,
as follows:

  all - builds everything
  res - builds binary resource files (requires VIEd and BRCC32)
  pas - builds Pascal source and links with resource files (requires DCC32)
    
The programs required by the build process are:

+ VIEd    - DelphiDabbler Version Information Editor, available from
            www.delphidabbler.com. Requires v2.11 or later.
+ BRCC32  - Borland Resource Compiler, supplied with Delphi 7.
+ DCC32   - Delphi Command Line Compiler, supplied with Delphi 7.
        
The batch files require that the following environment variable is set:

+ DELPHI7 - set to the install directory of Delphi 7: used to find BRCC32,
   DCC32 and HCRTF

VIEd is expected to be on the path. If it is not add its install directory to
the PATH environment variable


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Licensing
________________________________________________________________________________

Please see SourceCodeLicenses.txt for information about source code licenses.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Documentation
________________________________________________________________________________

The following documents are provided:

 * MPL.txt - The Mozilla Public License.
 * ReadMe-Src.txt - This file.
 * SourceCodeLicenses.txt - Information about license applying to source code.
 * Docs\ChangeLog.txt - Library's change log. Update this if you modify the
   library.
 * Docs\License.txt - The End User License Agreement that applies to the
   executable (binary) code of the library. Do not alter. Will be required if
   you distribute a modified version of the library on its own.
 * Docs\ReadMe.txt - ReadMe file distributed with executable version of the
   library. May need to be updated if the library is modified. Will be required
   if you distribute a modified version of the library on its own.
 * Docs\UserGuide.rtf - "Source" document for UserGuide.pdf distributed with the
   binary version of the library. May need updating if the library is modified.

 
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Peter Johnson
http://www.delphidabbler.com/
Contact via http://www.delphidabbler.com/contact
________________________________________________________________________________
