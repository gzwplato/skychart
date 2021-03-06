object Form1: TForm1
  Left = 237
  Top = 207
  Caption = 'Tycho 2 Catalogue conversion utility'
  ClientHeight = 381
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 52
    Width = 100
    Height = 13
    Caption = 'Path to original files : '
  end
  object Label2: TLabel
    Left = 112
    Top = 92
    Width = 80
    Height = 13
    Caption = 'Destination path '
  end
  object Label3: TLabel
    Left = 136
    Top = 132
    Width = 50
    Height = 13
    Caption = 'Progress : '
  end
  object Label5: TLabel
    Left = 56
    Top = 16
    Width = 407
    Height = 16
    Caption = 
      'I/259           The Tycho-2 Catalogue                    (Hog+  ' +
      '2000)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 352
    Top = 132
    Width = 36
    Height = 13
    Caption = 'of 9537'
  end
  object Button1: TButton
    Left = 216
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Conversion'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 216
    Top = 48
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'D:\data'
  end
  object Edit2: TEdit
    Left = 216
    Top = 88
    Width = 225
    Height = 21
    TabOrder = 2
    Text = 'C:\ciel\cat\tycho2'
  end
  object Edit3: TEdit
    Left = 216
    Top = 128
    Width = 129
    Height = 21
    TabOrder = 3
  end
  object Button2: TButton
    Left = 344
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 192
    Width = 489
    Height = 185
    Lines.Strings = (
      
        'This program convert the Tycho-2 Catalogue for use with "Cartes ' +
        'du Ciel" / "Sky Charts" program.'
      
        'Note it is also possible to use the original files without conve' +
        'rsion, but the converted file is ten time '
      'smaller than the original and provide speediest access.'
      
        'In the first field enter the complete directory path where you p' +
        'ut the files catalog.dat, suppl_1.dat, '
      
        'and index.dat of the original catalog, this is the \data of the ' +
        'cd-rom ( keep the files in DOS fomat '
      
        'with fixed record length, do NOT convert it in Unix format, if y' +
        'ou download the files in multiple '
      
        'segments first concat all 20 files to catalog.dat and be sure it' +
        ' is in DOS format). '
      
        'In the second field enter the path where to install the converte' +
        'd catalog, I suggest you keep the '
      'default: <Sky Chart path>\cat\tycho2'
      
        'You must have 50 MB free disk space on the destination directory' +
        '.'
      
        'Press "Conversion" key and be patient... there is 2'#39'557'#39'501 star' +
        's in 9537 regions to convert. This '
      
        'may take from ten minutes to more than one hour, depending on yo' +
        'ur machine. '
      'When it finish press *Exit" key.')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 5
  end
end
