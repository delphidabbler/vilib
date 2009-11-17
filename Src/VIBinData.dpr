{ ##
  @FILE                     VIBinData.dpr
  @COMMENTS                 Main project file.
  @PROJECT_NAME             Binary Version Information Manipulator Library
  @PROJECT_DESC             Enables binary version information data to be read
                            from and written to streams and to be updated.
  @AUTHOR                   Peter D Johnson, LLANARTH, Ceredigion, Wales, UK.
  @EMAIL                    delphidabbler@yahoo.co.uk
  @COPYRIGHT                © Peter D Johnson, 2002-2007.
  @WEBSITE                  http://www.delphidabbler.com/
  @HISTORY(
    @REVISION(
      @VERSION              1.0
      @DATE                 02/08/2002
      @COMMENTS             Original version.
    )
    @REVISION(
      @VERSION              1.1
      @DATE                 23/08/2007
      @COMMENTS             Changed path to IntfBinaryVerInfo.pas. Now located
                            in Exports sub folder - this file is required by
                            any application that uses VIBinData.dll.
    )
  )
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

