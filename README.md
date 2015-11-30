# DelphiDabbler Version Information Manipulator Library

## Overview

This library is a Windows DLL that can be used to access and manipulate binary version information from executable and binary resource files and to update and write version information to binary resource files.

The advantage of using this library over the Windows API for reading version information is that the library can cope with badly formed version information that would defeat the API routines. Furthermore, the library can enumerate contents of string tables and list and access non-standard string table entries. It also works with string tables in multiple languages (or translations).

The library's advantage in writing version information resources is that it can generate binary streams suitable for writing to binary resource files. This removes the need to create .rc files and, consequently, the need to use a resource compiler.

## Documentation

The library is copiously documented - see the `Docs` directory.

## License and copyright

The library in copyright (C) 2002-2007 Peter D Johnson, <http://www.delphidabbler.com>. See the file `Docs/License.txt` for details of the license.

Portions of the library's source code are released under the [Mozilla Public License v1.1](https://www.mozilla.org/en-US/MPL/1.1/).

## Contributing

> **Note:** I'm currently considering developing version 2 of the library that drops support for all the legacy 16 bit resources. Please bear that in mind if you would like to contribute.

This project is using the [Gitflow](http://nvie.com/posts/a-successful-git-branching-model/) methodology.

To contribute please fork the `develop` branch, create a feature branch with a name starting with `Feature\` and do your coding in that branch. When ready open a pull request for your feature branch.