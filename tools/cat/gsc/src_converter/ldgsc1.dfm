object Form1: TForm1
  Left = 200
  Top = 34
  Caption = 'Form1'
  ClientHeight = 167
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 40
    Height = 13
    Caption = 'Region :'
  end
  object Button1: TButton
    Left = 160
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 16
    Top = 88
    Width = 225
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object Tgsc: TTable
    DatabaseName = 'astroGSC'
    TableName = 'GSC'
    Left = 296
    Top = 96
  end
  object astroGSC: TDatabase
    AliasName = 'astroGSC'
    DatabaseName = 'astroGSC'
    Params.Strings = (
      'USER NAME=STARS')
    SessionName = 'Default'
    TransIsolation = tiDirtyRead
    OnLogin = astroGSCLogin
    Left = 296
    Top = 40
  end
end
