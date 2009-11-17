
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
             DELPHIDABBLER VERSION INFORMATION MANIPULATOR LIBRARY
                                  README FILE
________________________________________________________________________________


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
What is the library?
________________________________________________________________________________

DelphiDabbler Version Information Manipulator Library is a DLL that can be used
to access and manipulate binary version information from executable and binary
resource files and to update and write version information to binary resource
files.

The advantage of using this library over the Windows API for reading version
information is that the library can cope with badly formed version information
that would defeat the API routines. Furthermore the library can enumerate
contents of string tables and list and access non-standard string table entries.
It also works with string tables in multiple languages (or translations).

The library's advantage in writing version information resources is that it can
generate binary streams suitable for writing to binary resource files. This 
removes the need to create .rc files and, consequently, the need to use a
resource compiler.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Installation
________________________________________________________________________________

The Library is disributed in a zip file.

To use the library simply copy the file VIBinData.dll to a suitable directory
and call into it from your program. It is recommended that the DLL is placed in
the same directory as the program(s) that call it.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Using the Library
________________________________________________________________________________

For details of how to use the library, along with some example code please refer
to the user guide (UserGuide.pdf) included with this distribution.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Licensing and Copyright
________________________________________________________________________________

The library in copyright (C) 2002-2007 Peter D Johnson, www.delphidabbler.com.
By installing and using the library you are deemed to accept the end user
license agreement contained in the file License.txt included with this
distribution. If you do not agree with the license please do not install or use
the library.

Portions of the library's source code are available under the Mozilla Public
License v1.1 from http://www.delphidabbler.com/software?id=vibindata.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Redistributing the Library
________________________________________________________________________________

Providing you comply with the terms and conditions of the end user license
agreement in License.txt, you may:

 * Distribute the library with with your applications and / or other libraries
   that call into the DLL.

 * Modify and redistribute modified versions of the library.

 * Redistribute the original DLL on its own.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Updates
________________________________________________________________________________

The latest version of the library is always available from
http://www.delphidabbler.com/software?id=vibindata

The file ChangeLog.txt, included with this distribution notes the changes to
date.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Peter Johnson
http://www.delphidabbler.com/
Contact via http://www.delphidabbler.com/contact
________________________________________________________________________________
