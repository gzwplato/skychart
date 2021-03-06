unit demo1;

{$MODE Delphi}

{                                        
Copyright (C) 2005 Patrick Chevalley

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
 Sample application using the Virtual Observatory interface component.
}

interface

uses Messages, SysUtils, Classes, Graphics, Controls, Forms, FileUtil,
  Dialogs, StdCtrls, Menus, pr_vodetail, ComCtrls, Grids, ExtCtrls,
  LResources, Buttons, u_voconstant, cu_vocatalog, cu_vodetail, cu_vodata;

type

  { TForm1 }

  TForm1 = class(TForm)
    CatFilter: TEdit;
    VO_Catalogs1: TVO_Catalogs;
    PageControl1: TPageControl;
    TabCat: TTabSheet;
    TabDetail: TTabSheet;
    VO_Detail1: TVO_Detail;
    PageControl2: TPageControl;
    TabData: TTabSheet;
    DataGrid: TStringGrid;
    Panel1: TPanel;
    msg: TLabel;
    Label1: TLabel;
    Button11: TButton;
    Edit1: TEdit;
    ButtonFind: TButton;
    ButtonNext: TButton;
    Button12: TButton;
    OnlyCoord: TCheckBox;
    VO_TableData1: TVO_TableData;
    CatList: TStringGrid;
    Panel2: TPanel;
    Label2: TLabel;
    ep: TEdit;
    Label3: TLabel;
    sys: TEdit;
    Label4: TLabel;
    eq: TEdit;
    Timer1: TTimer;
    ServerList: TComboBox;
    SaveDialog1: TSaveDialog;
    tn: TEdit;
    Button1: TButton;
    TabRegistry: TTabSheet;
    RadioGroup1: TRadioGroup;
    Button13: TButton;
    procedure ButtonFindClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure SearchCatalog(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SelectCatalog(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonSave(Sender: TObject);
    procedure SelectRegistry(Sender: TObject);
  private
    { Private declarations }
    vopath : string;
    procedure SetServerList;
    procedure FillCatList;
    procedure ClearCatalog;
    procedure ClearDataGrid;
    procedure SaveGrid;
    procedure search(txt:string);
    procedure GetData(Sender: TObject);
    procedure ReceiveData(Sender: TObject);
    procedure DefColumns(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DecimalSeparator:='.';
  vopath:=ExpandFileName('~/.skychart/vo');
  if not DirectoryExists(vopath) then CreateDir(vopath);
  VO_Catalogs1.CachePath:=vopath;
  VO_Detail1.CachePath:=vopath;
  VO_TableData1.CachePath:=vopath;
  CatList.ColWidths[0]:=100;
  CatList.ColWidths[1]:=400;
  CatList.ColWidths[2]:=150;
  CatList.ColWidths[3]:=400;
  CatList.Cells[0,0]:='Name';
  CatList.Cells[1,0]:='Description';
  CatList.Cells[2,0]:='Info';
  CatList.Cells[3,0]:='URL';
  VO_Catalogs1.vo_source:=Tvo_source(RadioGroup1.itemindex);
  SetServerList;
  VO_Catalogs1.ClearCatList;
  PageControl1.ActivePage:=TabCat;
end;

procedure TForm1.SetServerList;
var i : integer;
begin
  ServerList.Items.Clear;
  for i:=1 to vo_maxurl do
    if vo_url[VO_Catalogs1.vo_source,i,2]<>'' then
      ServerList.Items.Add(vo_url[VO_Catalogs1.vo_source,i,2]);
  ServerList.ItemIndex:=0;
end;

procedure TForm1.FillCatList;
var i,p: integer;
    buf: string;
begin
CatList.RowCount:=VO_Catalogs1.CatList.Count+1;
for i:=0 to VO_Catalogs1.CatList.Count-1 do begin
  buf:=VO_Catalogs1.CatList[i];
  p:=pos(tab,buf);
  CatList.Cells[0,i+1]:=copy(buf,1,p-1);
  delete(buf,1,p);
  p:=pos(tab,buf);
  CatList.Cells[1,i+1]:=copy(buf,1,p-1);
  delete(buf,1,p);
  p:=pos(tab,buf);
  CatList.Cells[2,i+1]:=copy(buf,1,p-1);
  delete(buf,1,p);
  CatList.Cells[3,i+1]:=buf;
end;
msg.Caption:=inttostr(CatList.RowCount)+' Catalogs availables.';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 ClearCatalog;
 ClearDataGrid;
 Timer1.Enabled:=true;
end;

procedure TForm1.SearchCatalog(Sender: TObject);
var buf:string;
begin
screen.Cursor:=crHourGlass;
buf:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
buf:=buf+'-source='+trim(CatFilter.Text)+'&-meta&-meta.max=1000';
VO_Catalogs1.ListUrl:=buf;
try
 msg.Caption:='';
 if VO_Catalogs1.ForceUpdate then
    FillCatList
 else
    msg.Caption:='Cannot connect to server. '+VO_Catalogs1.LastErr;
finally
screen.Cursor:=crDefault;
end;
end;

procedure TForm1.search(txt:string);
var i:integer;
begin
i:=VO_Catalogs1.search(txt);
if i>=0 then begin
  CatList.Row:=i+1;
  CatList.TopRow:=i+1;
  msg.Caption:=inttostr(CatList.RowCount)+' Catalogs availables.';
end
else
  msg.Caption:='Not Found!';
end;

procedure TForm1.ButtonFindClick(Sender: TObject);
begin
search(edit1.Text);
end;


procedure TForm1.ButtonNextClick(Sender: TObject);
var i:integer;
begin
i:=VO_Catalogs1.SearchNext;
if i>=0 then begin
  CatList.Row:=i+1;
  CatList.TopRow:=i+1;
end;
end;

function dedupstr(txt:string):string;
var i,p,l: integer;
    buf1,buf2:string;
begin
l:=length(txt);
p:=l div 2;
buf1:=copy(txt,1,p);
buf2:=copy(txt,p+2,9999);
if buf1=buf2 then result:=buf1
   else result:=txt;
end;

procedure TForm1.SelectCatalog(Sender: TObject);
var i,n: integer;
    buf,catname: string;
    tb:TTabsheet;
    fr:Tf_vodetail;
begin
screen.Cursor:=crHourGlass;
try
if CatList.Row>0 then begin
  i:=CatList.Row;
  buf:=CatList.Cells[0,i];
  catname:=CatList.Cells[1,i];
  VO_Detail1.CachePath:=VO_Catalogs1.CachePath;
  VO_Detail1.BaseUrl:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
  VO_Detail1.vo_type:=VO_Catalogs1.vo_type;
  VO_Detail1.Update(buf);
  for n:=0 to Pagecontrol2.PageCount-1 do
      Pagecontrol2.Pages[0].Free;
  for n:=0 to VO_Detail1.NumTables-1 do begin
    if OnlyCoord.Checked and (not VO_Detail1.HasCoord[n]) then continue;
     tb:=TTabsheet.Create(PageControl2);
     tb.PageControl:=Pagecontrol2;
     fr:=Tf_vodetail.Create(tb);
     fr.MainPanel.Parent:=tb;
     fr.onGetData:=GetData;
     with fr do begin
       Grid.ColCount:=6;
       Grid.ColWidths[0]:=20;
       Grid.ColWidths[1]:=100;
       Grid.ColWidths[2]:=120;
       Grid.ColWidths[3]:=70;
       Grid.ColWidths[4]:=70;
       Grid.ColWidths[5]:=500;
       Grid.Cells[0,0]:='x';
       Grid.Cells[1,0]:='Field Name';
       Grid.Cells[2,0]:='UCD';
       Grid.Cells[3,0]:='Data Type';
       Grid.Cells[4,0]:='Unit';
       Grid.Cells[5,0]:='Description';
       Grid.RowCount:=VO_Detail1.RecName[n].Count+1;
       for i:=1 to VO_Detail1.RecName[n].Count do begin
         Grid.Cells[0,i]:='x';
         Grid.Cells[1,i]:=VO_Detail1.RecName[n][i-1];
         Grid.Cells[2,i]:=VO_Detail1.RecUCD[n][i-1];
         Grid.Cells[3,i]:=VO_Detail1.RecDatatype[n][i-1];
         Grid.Cells[4,i]:=VO_Detail1.RecUnits[n][i-1];
         Grid.Cells[5,i]:=VO_Detail1.RecDescription[n][i-1];
       end;
       SelectAll:=true;
       tn.Text:=VO_Detail1.TableName[n];
       tb.Caption:=VO_Detail1.TableName[n];
       if VO_Detail1.Rows[n]=0 then tr.Text:='?'
          else tr.Text:=inttostr(VO_Detail1.Rows[n]);
       if trim(VO_Detail1.description[n])>'' then desc.text:=dedupstr(VO_Detail1.description[n])
          else desc.text:=Catname;
       ep.text:=VO_Detail1.epoch[n];
       sys.text:=VO_Detail1.system[n];
       eq.text:=VO_Detail1.equinox[n];
       radec1.Enabled:=VO_Detail1.HasCoord[n];
       radec2.Enabled:=VO_Detail1.HasCoord[n];
       radec3.Enabled:=VO_Detail1.HasCoord[n];
       if not radec1.Enabled then begin
          radec1.value:=0;
          radec2.value:=0;
          radec3.value:=0;
       end;
       firstrow.Enabled:=not radec1.Enabled;
       co.Checked:=VO_Detail1.HasCoord[n];
       if not VO_Detail1.HasCoord[n] then
          RadioGroup1.ItemIndex:=0
       else if (VO_Detail1.HasSize[n])or(not VO_Detail1.HasMag[n]) then
          RadioGroup1.ItemIndex:=2
       else
          RadioGroup1.ItemIndex:=1;
     end;
  end;
  if Pagecontrol2.PageCount=0 then ClearCatalog;
  Pagecontrol1.ActivePage:=TabDetail;
  Pagecontrol2.ActivePageIndex:=0;
end;
finally
screen.Cursor:=crDefault;
end;
end;

procedure TForm1.ClearCatalog;
var tb:TTabsheet;
    fr:Tf_vodetail;
begin
 tb:=TTabsheet.Create(PageControl2);
 tb.PageControl:=Pagecontrol2;
 fr:=Tf_vodetail.Create(tb);
 fr.Parent:=tb;
 with fr do begin
   Grid.ColCount:=2;
   Grid.ColWidths[1]:=500;
   Grid.Cells[1,1]:='No catalog selected or table of selected catalog don''t contain coordinates information.';
 end;
end;

procedure TForm1.GetData(Sender: TObject);
var coordselection, objtype, extfn: string;
    f: textfile;
    i: integer;
begin
screen.Cursor:=crHourGlass;
try
ClearDataGrid;
if sender is Tf_vodetail then
   with sender as Tf_vodetail do begin
       VO_TableData1.vo_type:=VO_Detail1.vo_type;
       VO_TableData1.BaseUrl:=stringreplace(VO_Detail1.BaseUrl,VO_Detail1.CatalogName+'/*',tn.Text,[]);
       VO_TableData1.SelectCoord:=Radec1.Enabled;
       VO_TableData1.ra:=RaDec1.value;
       VO_TableData1.dec:=RaDec2.value;
       VO_TableData1.fov:=RaDec3.value;
       if VO_TableData1.SelectCoord then
           coordselection:='at RA:'+RaDec1.text+' DEC:'+RaDec2.text+' FOV:'+RaDec3.text
       else
           coordselection:='';
       DataGrid.cells[1,1]:=DataGrid.cells[1,1]+coordselection;
       VO_TableData1.FirstRec:=strtointdef(firstrow.Text,1);
       VO_TableData1.maxdata:=strtointdef(maxrow.Text,50);
       VO_TableData1.SelectAllFields:=SelectAll;
       VO_TableData1.FieldList.Clear;
       for i:=1 to grid.RowCount-1 do begin
          if grid.Cells[0,i]='x' then
             VO_TableData1.FieldList.Add(grid.Cells[1,i]);
       end;
       VO_TableData1.onColsDef:=DefColumns;
       VO_TableData1.onDataRow:=ReceiveData;
       case RadioGroup1.ItemIndex of
         0: objtype:='na';
         1: objtype:='star';
         2: objtype:='dso';
       end;
       VO_TableData1.GetData(tn.Text,objtype);
       extfn:=slash(VO_TableData1.CachePath)+ChangeFileExt(VO_TableData1.Datafile,'.def');
       AssignFile(f,extfn);
       rewrite(f);
       writeln(f,'objtype='+objtype);
       writeln(f,'defsize='+DefSize.Text);
       writeln(f,'defmag='+DefMag.Text);
       CloseFile(f);
   end;
tn.Text:=VO_TableData1.TableName;
ep.text:=VO_TableData1.epoch;
sys.text:=VO_TableData1.system;
eq.text:=VO_TableData1.equinox;
Pagecontrol1.ActivePage:=TabData;
finally
screen.Cursor:=crDefault;
end;
end;

procedure TForm1.ClearDataGrid;
begin
with DataGrid do begin
  RowCount:=2;
  ColCount:=2;
  colwidths[1]:=400;
  cells[1,1]:='No Data ';
end;
ep.text:='';
sys.text:='';
eq.text:='';
end;

procedure TForm1.ReceiveData(Sender: TObject);
var i: integer;
begin
with DataGrid do begin
  RowCount:=RowCount+1;
  FixedRows:=1;
  for i:=0 to VO_TableData1.Cols-1 do begin
    cells[i,rowcount-1]:=VO_TableData1.DataRow[i];
  end;
end;
end;

procedure TForm1.DefColumns(Sender: TObject);
var i: integer;
begin
with DataGrid do begin
  RowCount:=1;
  ColCount:=VO_TableData1.Cols;
  for i:=0 to VO_TableData1.Cols-1 do begin
    cells[i,0]:=VO_TableData1.Columns[i];
    colwidths[i]:=75;
  end;
end;
end;

Procedure TForm1.SaveGrid;
var buf : string;
    Lines: TStringList;
    i,j : integer;
begin
Lines:=TstringList.Create;
try
for i:=0 to datagrid.RowCount-1 do begin
  for j:=0 to datagrid.ColCount-1 do begin
    if j=0 then buf:= '"'+stringreplace(datagrid.cells[j,i],'"','""',[rfReplaceAll])
           else buf:=buf+'";"'+stringreplace(datagrid.cells[j,i],'"','""',[rfReplaceAll]);
  end;
  buf:=buf+'"';
  Lines.add(buf);
end;
Savedialog1.DefaultExt:='.csv';
Savedialog1.Filename:=stringreplace(tn.Text,'/','_',[rfReplaceAll])+'.csv';
Savedialog1.filter:='Comma Separated File (*.csv)|*.csv';
if SaveDialog1.Execute then
   Lines.SavetoFile(savedialog1.Filename);
finally
Lines.free;
end;
end;

procedure TForm1.ButtonSave(Sender: TObject);
begin
SaveGrid;
end;

//////////////  Registry selection not used at the moment ////////////////////

procedure TForm1.SelectRegistry(Sender: TObject);
begin
 VO_Catalogs1.vo_source:=Tvo_source(RadioGroup1.itemindex);
 SetServerList;
 VO_Catalogs1.ClearCatList;
 Timer1.Enabled:=true;
 Pagecontrol1.ActivePage:=TabCat;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
screen.Cursor:=crHourGlass;
try
 msg.Caption:='Loading catalog list. Please wait ...';
 msg.Refresh;
 VO_Catalogs1.ListUrl:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
 FillCatList;
 msg.Caption:=VO_Catalogs1.LastErr;
 if msg.Caption='' then msg.Caption:=inttostr(CatList.RowCount)+' Catalogs availables.';
finally
screen.Cursor:=crDefault;
end;
end;



initialization
  {$i demo1.lrs}

end.
