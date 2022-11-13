object VIReaderDemoForm: TVIReaderDemoForm
  Left = 0
  Top = 0
  Caption = 'VIBinData.dll | VIReaderDemo'
  ClientHeight = 549
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  DesignSize = (
    801
    549)
  TextHeight = 15
  object bvlDescription: TBevel
    AlignWithMargins = True
    Left = 8
    Top = 25
    Width = 785
    Height = 2
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitLeft = -84
    ExplicitWidth = 903
  end
  object lblDescription: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 4
    Width = 785
    Height = 17
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 4
    Align = alTop
    Caption = 
      'This project demonstrates how to read version information from a' +
      ' 32 or 64 bit Windows program or DLL.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 652
  end
  object lblDesc: TLabel
    Left = 8
    Top = 83
    Width = 136
    Height = 15
    Caption = 'Version information from:'
  end
  object lblExePath: TLabel
    Left = 150
    Top = 83
    Width = 60
    Height = 15
    Caption = '<Nothing>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object btnOpenExeOrDLL: TButton
    Left = 8
    Top = 47
    Width = 257
    Height = 25
    Caption = 'Choose a .exe or .dll file...'
    TabOrder = 0
    OnClick = btnOpenExeOrDLLClick
  end
  object memoView: TMemo
    Left = 8
    Top = 104
    Width = 785
    Height = 440
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object dlgExePath: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Executable files'
        FileMask = '*.exe;*.dll'
      end>
    Options = [fdoStrictFileTypes, fdoPathMustExist, fdoFileMustExist, fdoDontAddToRecent]
    Title = 'Open Executable File'
    Left = 304
    Top = 32
  end
end
