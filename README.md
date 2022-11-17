# DelphiDabbler Version Information Manipulator Library

## Overview

This library is a Windows DLL that can be used to access and manipulate binary version information from executable and binary resource files and to update and write version information to binary resource files.

The advantage of using this library over the Windows API for reading version information is that the library can cope with badly formed version information that would defeat the API routines. Furthermore, the library can enumerate contents of string tables and list and access non-standard string table entries. It also works with string tables in multiple languages (or translations).

The library's advantage in writing version information resources is that it can generate binary streams suitable for writing to binary resource files. This removes the need to create `.rc` files and, consequently, the need to use a resource compiler.

## Installation

The Library is distributed in a zip file.

To use the library simply extract the file `VIBinData.dll`, copy it to a suitable directory and call into it from your program. It is recommended that the DLL is placed in the same directory as the program that calls it.

The zip file also contains four Markdown formatted text files:

* `README.md` - this file.
* `UserGuide.md` - information about how to use the DLL.
* `CHANGELOG.md` - records changes in each release.
* `LICENSE.md` - by using the library you are deemed to have agrred to this license.

## Documentation & Demos

For details of how to use the library, along with some example code please refer to the user guide (`UserGuide.md`) included with this distribution.

There are also two demos programs in the `Demos` directory. See `Demos/README.md`.

## License and copyright

The library in copyright (C) 2002-2022 Peter D Johnson, <https://gravatar.com/delphidabbler>. See the file `LICENSE.md` for details of the license. Do not use `VIBinData.dll` if you do not agree with the license.

Portions of the library's source code are released under the [Mozilla Public License v2.0](https://mozilla.org/MPL/2.0/).

## Redistributing the Library

Providing you comply with the terms and conditions of the end user license agreement in `LICENSE.md`, you may:

* Distribute the library with with your applications and / or other libraries that call into the DLL.
* Modify and redistribute modified versions of the library.
* Redistribute the original DLL on its own.

## Contributing

> **Note:** I'm currently considering developing version 2 of the library that drops support for all the legacy 16 bit resources. Please bear that in mind if you would like to contribute.

This project is using the [Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) methodology.

To contribute please fork the `develop` branch, create a feature branch with a name starting with `feature/` and do your coding in that branch. If you are implementing an issue start the name with the issue number. When ready open a pull request for your feature branch.

### Compiling

Delphi 11 is used for development. Later versions may be able to be used. It is possible, but not tested, that Delphi 10.4 may be suitable.

Open `Src/VIBinData.dproj` to build the DLL or `VIBinDataDemos.groupproj` to build the demos.

#### Prerequisites

`Src/VIBinData.dproj` has a build event that requires [DelphiDabbler Version Information Editor](https://delphidabbler.com/software/vied) (`VIEd.exe`) to be installed and the path of the directory where `VIEd.exe` is installed to be available in the `VIEDROOT` environment variable. `VIEDROOT` can either be set before starting the IDE, or it can be set in the _Environment Variables_ pane of the _Options_ dialogue box (Use _Tools | Options_ to display it).

> **Note:** `VIEd.exe` is used in a build target to create the required version information resource.

### Deployment

To create a zip file suitable for deploying a modified version of the library, run `Deploy.bat` (in the repo root) from the command line. See the comments in `Deploy.bat` for how to run the script.

## Updates

The latest version of the library is always available from the [releases page](https://github.com/delphidabbler/vilib/releases) of the GitHub repository.

The file `CHANGELOG.md` notes the changes in each release.
