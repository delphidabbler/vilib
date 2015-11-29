{
  Main project file.
}


{
 * ***** BEGIN LICENSE BLOCK *****
 *
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is VIBinData.dpr.
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2002-2007 Peter
 * Johnson. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK *****
}


library VIBinData;

uses
  ComObj,
  UBinaryVerInfo in 'UBinaryVerInfo.pas',
  UVerInfoData in 'UVerInfoData.pas',
  UVerInfoRec in 'UVerInfoRec.pas',
  UVerInfoBinIO in 'UVerInfoBinIO.pas',
  IntfBinaryVerInfo in 'Exports\IntfBinaryVerInfo.pas';

exports
  // Routine exported from DLL that is used to create required objects
  CreateInstance;

{$Resource 'VVIBinData.res'}  // version information

begin
end.

