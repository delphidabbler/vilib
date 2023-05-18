{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2002-2022, Peter Johnson (https://gravatar.com/delphidabbler).
 *
 * Main project file. Exports a function used to create objects within the DLL.
 * This function is the only entry point into the DLL.
}

library VIBinData;

uses
  ComObj,
  UBinaryVerInfo in 'UBinaryVerInfo.pas',
  IntfBinaryVerInfo in 'Exports\IntfBinaryVerInfo.pas',
  DelphiDabbler.Lib.VIBin.Resource in 'Vendor\DelphiDabbler.Lib.VIBin.Resource.pas',
  DelphiDabbler.Lib.VIBin.VarRec in 'Vendor\DelphiDabbler.Lib.VIBin.VarRec.pas';

exports
  // Routine exported from DLL that is used to create required objects
  CreateInstance;

{$Resource 'VVIBinData.res'}  // version information

begin
end.

