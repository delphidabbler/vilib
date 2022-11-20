# DelphiDabbler Version Information Manipulator Library

## Overview

This library is a Windows DLL that can be used to read and manipulate binary version information from executable and binary resource files. It can also update the version information and write it in a binary format suitable for inclusion in binary resource files.

The advantage of using this library over the Windows API for reading version information is that the library can cope with badly formed version information that would defeat the API routines. Furthermore, the library can enumerate the contents of string tables and list and access non-standard string table entries. It also works with string tables in multiple languages.

The library's advantage in writing version information resources is that it generates correctly formatted binary date suitable for writing to binary resource files. This removes the need to create `.rc` files and, consequently, the need to use a resource compiler for version information.

The library has a [web page](https://delphidabbler.com/software/vibindata) on delphidabbler.com.

## Installation

The Library is distributed in a zip file. The latest version is available from the project's [releases page](https://github.com/delphidabbler/vilib/releases) on GitHub.

To use the library simply extract the file `VIBinData.dll`, copy it to a suitable directory and call into it from your program. It is recommended that the DLL is placed in the same directory as the program that calls it.

The zip file also contains the following files:

* `IntfBinaryVerInfo.pas` - Delphi Pascal source file that defines the interfaces, class IDs and entry point for `VIBinData.dll`.
* `README.md` - this file.
* `UserGuide.md` - information about how to use the DLL.
* `CHANGELOG.md` - records changes in each release.
* `LICENSE.md` - the library's open source license.

## Documentation & Demos

For details of how to use the library, along with some example code, please refer to the user guide (`UserGuide.md`).

There are also two demos programs in the `Demos` directory. See `Demos/README.md` for details.

## License and copyright

The library is copyright (C) 2002-2022 Peter D Johnson, <https://gravatar.com/delphidabbler>. See the file `LICENSE.md` for details of the license.

Portions of the library's source code are released under the [Mozilla Public License v2.0](https://mozilla.org/MPL/2.0/).

> ***By using the library you are deemed to have accepted the terms of the license.***

## Redistributing the Library

Providing you comply with the terms and conditions of the end user license agreement in `LICENSE.md`, you may:

* Distribute the library with with your applications and / or other libraries that call into the DLL.
* Modify and redistribute modified versions of the library.
* Redistribute the original DLL.

Any redistribrutions must be accompanied by a copy the license.

## Contributing

> **Note:** I'm planning to drop support for all the legacy 16 bit resources in a future major release. Please bear that in mind if you would like to contribute.

This project uses the [Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) methodology.

To contribute please fork the [repo](https://github.com/delphidabbler/vilib), clone your fork and then switch to the `develop` branch. Create a feature branch off `develop` with a name starting with `feature/` and do your coding in that branch. If you are implementing an issue then start the name with the issue number and leave a comment on the issue that you're working on it. Commit all your changes to the feature branch. When ready open a pull request for your feature branch.

## Compiling

Delphi 11 is used for development. Later versions may be able to be used. It is possible, but not tested, that Delphi 10.4 may be suitable.

Open `Src/VIBinData.dproj` to build the DLL or `VIBinDataDemos.groupproj` to build the demos.

### Prerequisites

`Src/VIBinData.dproj` has a build event that requires [DelphiDabbler Version Information Editor](https://delphidabbler.com/software/vied) (`VIEd.exe`) v2.14.0 or later to be installed. The `VIEDROOT` environment variable must be set to the directory containing `VIEd.exe`. `VIEDROOT` can either be set before starting the IDE, or it can be set in the _Environment Variables_ pane of the _Options_ dialogue box (Use _Tools | Options_ to display it).

### Deployment

Releases ready for deployment are created by running `Deploy.bat` in the repo root. See the comments in `Deploy.bat` for further information.

## Updates

The latest version of the library is always available from the [releases page](https://github.com/delphidabbler/vilib/releases) of the GitHub repository.

The file `CHANGELOG.md` notes the changes in each release.
