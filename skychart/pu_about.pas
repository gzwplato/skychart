unit pu_about;

{$MODE Delphi}{$H+}

{
Copyright (C) 2002 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 About form for Windows VCL application
}

interface

uses
  u_help, u_translation, u_constant, u_util, UScaleDPI,
  LCLIntf, Classes, Graphics, Forms, Controls, StdCtrls,
  sysutils, ExtCtrls, LResources, Buttons, LazHelpHTML_fix, ComCtrls;

type

  { Tf_about }

  Tf_about = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    PageControl1: TPageControl;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Page3: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel0: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panell1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang;
  end;

var
  f_about: Tf_about;

implementation

{$R *.lfm}

procedure Tf_about.SetLang;
begin
  Caption := rsAbout;
  if rsSkyCharts = 'Cartes du Ciel' then
    Label5.Caption := ''
  else
    Label5.Caption := rsSkyCharts;
  Label7.Caption := rsThisProgramI;
  Button1.Caption := rsClose;
  Label8.Caption := format(cdccpy,[cpydate]);
  Label3.Caption := rsPleaseReport;
  page1.Caption := rsAbout;
  page2.Caption := rsAuthors;
  page3.Caption := rsLicenseAgree;
  memo1.Text := rsProgrammer + crlf + cdcauthors + crlf + crlf + rsTranslator + crlf +
    rsCDCTranslator + crlf + crlf;
  SetHelp(self, hlpIndex);
end;

procedure Tf_about.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
  panel1.Caption := URL_WebHome;
  button2.Caption := URL_BugTracker;
  label2.Caption := rsVersion + blank + cdcversion + blank;
  if cdcbeta then label2.Caption :=label2.Caption+'beta-';
  label2.Caption :=label2.Caption+ RevisionStr + blank + compile_time;
  label4.Caption := rsCompiledWith + blank + compile_version;
end;

procedure Tf_about.Button2Click(Sender: TObject);
begin
  ExecuteFile(URL_BugTracker);
end;

procedure Tf_about.Panell1Click(Sender: TObject);
begin
  ExecuteFile(URL_WebHome);
end;

end.
 
