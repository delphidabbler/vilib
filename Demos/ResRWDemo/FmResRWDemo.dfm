object ResRWDemoForm: TResRWDemoForm
  Left = 0
  Top = 0
  Caption = 'VIBinData.dll | ResRWDemo'
  ClientHeight = 524
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  DesignSize = (
    919
    524)
  TextHeight = 15
  object lblDescription: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 4
    Width = 903
    Height = 17
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 4
    Align = alTop
    Caption = 
      'This project demonstrates how to read / write version informatio' +
      'n in 32 resource files.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 535
  end
  object bvlDescription: TBevel
    AlignWithMargins = True
    Left = 8
    Top = 25
    Width = 903
    Height = 2
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitLeft = 0
    ExplicitTop = 41
    ExplicitWidth = 624
  end
  object btnView: TButton
    Left = 8
    Top = 125
    Width = 129
    Height = 25
    Caption = 'View Version Info'
    TabOrder = 0
    OnClick = btnViewClick
  end
  object memoView: TMemo
    Left = 8
    Top = 152
    Width = 903
    Height = 364
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
  object btnOpen: TButton
    Left = 8
    Top = 34
    Width = 129
    Height = 25
    Caption = 'Open Resource File'
    TabOrder = 2
    OnClick = btnOpenClick
  end
  object btnSave: TButton
    Left = 8
    Top = 62
    Width = 129
    Height = 25
    Caption = 'Save Resource File'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnViewRaw: TButton
    Left = 143
    Top = 125
    Width = 129
    Height = 25
    Caption = 'View Raw Data'
    TabOrder = 4
    OnClick = btnViewRawClick
  end
  object btnViewResFile: TButton
    Left = 278
    Top = 125
    Width = 129
    Height = 25
    Caption = 'View Resource File'
    TabOrder = 5
    OnClick = btnViewResFileClick
  end
  object btnAddTranslation: TButton
    Left = 143
    Top = 34
    Width = 129
    Height = 25
    Hint = 
      'Enter character set and language ID for translation in Character' +
      ' set & Language ID edit boxes'
    Caption = 'Add Translation'
    TabOrder = 6
    OnClick = btnAddTranslationClick
  end
  object leCharSet: TLabeledEdit
    Left = 842
    Top = 34
    Width = 69
    Height = 23
    Anchors = [akTop, akRight]
    EditLabel.Width = 99
    EditLabel.Height = 15
    EditLabel.Caption = 'Character set (hex)'
    EditLabel.Layout = tlBottom
    LabelPosition = lpLeft
    TabOrder = 7
    Text = ''
    OnKeyPress = HexEditKeyPress
  end
  object leLanguageID: TLabeledEdit
    Left = 842
    Top = 63
    Width = 69
    Height = 23
    Anchors = [akTop, akRight]
    EditLabel.Width = 96
    EditLabel.Height = 15
    EditLabel.Caption = 'Language ID (hex)'
    EditLabel.Layout = tlBottom
    LabelPosition = lpLeft
    TabOrder = 8
    Text = ''
    OnKeyPress = HexEditKeyPress
  end
  object leStringName: TLabeledEdit
    Left = 683
    Top = 92
    Width = 228
    Height = 23
    Anchors = [akTop, akRight]
    EditLabel.Width = 64
    EditLabel.Height = 15
    EditLabel.Caption = 'String name'
    EditLabel.Layout = tlBottom
    LabelPosition = lpLeft
    TabOrder = 9
    Text = ''
  end
  object leStringValue: TLabeledEdit
    Left = 683
    Top = 121
    Width = 228
    Height = 23
    Anchors = [akTop, akRight]
    EditLabel.Width = 62
    EditLabel.Height = 15
    EditLabel.Caption = 'String value'
    EditLabel.Layout = tlBottom
    LabelPosition = lpLeft
    TabOrder = 10
    Text = ''
  end
  object btnDeleteTrans: TButton
    Left = 143
    Top = 91
    Width = 129
    Height = 25
    Hint = 'Enter index in Translation index # edit box'
    Caption = 'Delete Translation'
    TabOrder = 11
    OnClick = btnDeleteTransClick
  end
  object btnIndexOfTrans: TButton
    Left = 143
    Top = 62
    Width = 129
    Height = 25
    Hint = 
      'Enter translation'#39's character set and language ID in Character s' +
      'et & Language ID edit boxes'
    Caption = 'Index Of Translation'
    TabOrder = 12
    OnClick = btnIndexOfTransClick
  end
  object leTransIdx: TLabeledEdit
    Left = 683
    Top = 34
    Width = 44
    Height = 23
    Hint = 'Enter index of translation'
    Anchors = [akTop, akRight]
    EditLabel.Width = 99
    EditLabel.Height = 15
    EditLabel.Caption = 'Translation index #'
    EditLabel.Layout = tlBottom
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 13
    Text = ''
  end
  object leStrTableIdx: TLabeledEdit
    Left = 683
    Top = 63
    Width = 44
    Height = 23
    Hint = 'Enter index of translation'
    Anchors = [akTop, akRight]
    EditLabel.Width = 103
    EditLabel.Height = 15
    EditLabel.Caption = 'String Table index #'
    EditLabel.Layout = tlBottom
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 14
    Text = ''
  end
  object btnAddStrTable: TButton
    Left = 278
    Top = 34
    Width = 129
    Height = 25
    Hint = 
      'Enter character set and language ID for string table in Characte' +
      'r set & Language ID edit boxes'
    Caption = 'Add String Table'
    TabOrder = 15
    OnClick = btnAddStrTableClick
  end
  object btnIndexOfStrTable: TButton
    Left = 278
    Top = 62
    Width = 129
    Height = 25
    Hint = 
      'Enter string table'#39's character set and language ID in Character ' +
      'set & Language ID edit boxes'
    Caption = 'Index Of String Table'
    TabOrder = 16
    OnClick = btnIndexOfStrTableClick
  end
  object btnDeleteStrTable: TButton
    Left = 278
    Top = 91
    Width = 129
    Height = 25
    Hint = 'Enter index of string table in String Table index # edit box'
    Caption = 'Delete String Table'
    TabOrder = 17
    OnClick = btnDeleteStrTableClick
  end
  object btnAddOrUpdateString: TButton
    Left = 413
    Top = 34
    Width = 129
    Height = 25
    Hint = 
      'Enter string name && value in String name && String value edit b' +
      'oxes and string table index per String Table index # edit box'
    Caption = 'Add or Update String'
    TabOrder = 18
    OnClick = btnAddOrUpdateStringClick
  end
  object btnDeleteString: TButton
    Left = 413
    Top = 91
    Width = 129
    Height = 25
    Hint = 
      'Enter name of string in String name edit box and string table in' +
      'dex in String Table index # edit box'
    Caption = 'Delete String'
    TabOrder = 19
    OnClick = btnDeleteStringClick
  end
  object btnSetFFI: TButton
    Left = 8
    Top = 91
    Width = 129
    Height = 25
    Caption = 'Set FFI'
    TabOrder = 20
    OnClick = btnSetFFIClick
  end
  object btnIndexOfString: TButton
    Left = 413
    Top = 62
    Width = 129
    Height = 25
    Hint = 
      'Enter string name String name #edit box and string table index p' +
      'er String Table index # edit box'
    Caption = 'Index Of String'
    TabOrder = 21
    OnClick = btnIndexOfStringClick
  end
end
