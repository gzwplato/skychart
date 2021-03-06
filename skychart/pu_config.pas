unit pu_config;

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
 Configuration form
}

interface

uses
  u_help, u_translation, u_constant, u_util, UScaleDPI,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, enhedits,
  cu_fits, cu_catalog, cu_database,
  fu_config_chart, fu_config_observatory, fu_config_time, fu_config_catalog,
  fu_config_system, fu_config_pictures, fu_config_display, fu_config_solsys,
  fu_config_internet, fu_config_calendar,
  LResources, PairSplitter, LazHelpHTML_fix;

type

  { Tf_config }

  Tf_config = class(TForm)
    f_config_calendar1: Tf_config_calendar;
    f_config_catalog1: Tf_config_catalog;
    f_config_chart1: Tf_config_chart;
    f_config_display1: Tf_config_display;
    f_config_observatory1: Tf_config_observatory;
    f_config_system1: Tf_config_system;
    f_config_time1: Tf_config_time;
    PageControl1: TPageControl;
    PanelConfig: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet0: TTabSheet;
    TabSheet9: TTabSheet;
    TreeView1: TTreeView;
    previous: TButton;
    Next: TButton;
    PanelBottom: TPanel;
    Applyall: TCheckBox;
    OKBtn: TButton;
    Apply: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    f_config_solsys1: Tf_config_solsys;
    f_config_pictures1: Tf_config_pictures;
    f_config_internet1: Tf_config_internet;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
  private
    { Déclarations privées }
    locktree: boolean;
    Fccat: Tconf_catalog;
    Fcshr: Tconf_shared;
    Fcsc: Tconf_skychart;
    Fcplot: Tconf_plot;
    Fcmain: Tconf_main;
    Fcdss: Tconf_dss;
    astpage, compage, dbpage: integer;
    lastSelectedNode: TTreeNode;
    FApplyConfig,FDisableAsteroid,FEnableAsteroid: TNotifyEvent;
    FDBChange: TNotifyEvent;
    FSaveAndRestart: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    FGetTwilight: TGetTwilight;
    function GetFits: TFits;
    procedure SetFits(Value: TFits);
    function GetCatalog: Tcatalog;
    procedure SetCatalog(Value: Tcatalog);
    function GetDB: Tcdcdb;
    procedure SetDB(Value: Tcdcdb);
    procedure SetCcat(Value: Tconf_catalog);
    procedure SetCshr(Value: Tconf_shared);
    procedure SetCsc(Value: Tconf_skychart);
    procedure SetCplot(Value: Tconf_plot);
    procedure SetCmain(Value: Tconf_main);
    procedure SetCdss(Value: Tconf_dss);
    procedure ShowDBSetting(Sender: TObject);
    procedure ShowCometSetting(Sender: TObject);
    procedure ShowAsteroidSetting(Sender: TObject);
    procedure LoadMPCSample(Sender: TObject);
    procedure SysDBChange(Sender: TObject);
    procedure SysSaveAndRestart(Sender: TObject);
    function SolSysPrepareAsteroid(jd1, jd2, step: double; msg: TStrings): boolean;
    procedure TimeGetTwilight(jd0: double; out ht: double);
    procedure ShowPage(i, j: integer);
    procedure ActivateChanges;
    procedure EnableAsteroid(Sender: TObject);
    procedure DisableAsteroid(Sender: TObject);
  public
    { Déclarations publiques }
    procedure SetLang;
    property ccat: Tconf_catalog read Fccat write SetCcat;
    property cshr: Tconf_shared read Fcshr write SetCshr;
    property csc: Tconf_skychart read Fcsc write SetCsc;
    property cplot: Tconf_plot read Fcplot write SetCplot;
    property cmain: Tconf_main read Fcmain write SetCmain;
    property cdss: Tconf_dss read Fcdss write SetCdss;
    property fits: TFits read GetFits write SetFits;
    property catalog: Tcatalog read GetCatalog write SetCatalog;
    property db: Tcdcdb read GetDB write SetDB;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
    property onPrepareAsteroid: TPrepareAsteroid
      read FPrepareAsteroid write FPrepareAsteroid;
    property onGetTwilight: TGetTwilight read FGetTwilight write FGetTwilight;
    property onDisableAsteroid: TNotifyEvent read FDisableAsteroid write FDisableAsteroid;
    property onEnableAsteroid: TNotifyEvent read FEnableAsteroid write FEnableAsteroid;
  end;

var
  f_config: Tf_config;

implementation

{$R *.lfm}

procedure Tf_config.SetLang;
begin
  Caption := rsConfiguratio;
  TreeView1.items[0].Text := '1- ' + rsGeneral;
  TreeView1.items[1].Text :=   '1- ' + rsLanguage2;
  TreeView1.items[2].Text :=   '2- ' + rsTelescope;
  TreeView1.items[3].Text :=   '3- ' + rsGeneral;
  TreeView1.items[4].Text :=   '4- ' + rsServer;
  TreeView1.items[5].Text :=   '5- ' + 'SAMP';
  TreeView1.items[6].Text := '2- ' + rsDateTime2;
  TreeView1.items[7].Text :=   '1- ' + rsDateTime2;
  TreeView1.items[8].Text :=   '2- ' + rsTimeSimulati;
  TreeView1.items[9].Text :=   '3- ' + rsAnimation;
  TreeView1.items[10].Text :='3- ' + rsObservatory;
  TreeView1.items[11].Text :=  '1- ' + rsObservatory;
  TreeView1.items[12].Text :=  '2- ' + rsHorizon;
  TreeView1.items[13].Text :='4- ' + rsChartCoordin;
  TreeView1.items[14].Text :=  '1- ' + rsChartCoordin;
  TreeView1.items[15].Text :=  '2- ' + rsFieldOfVisio;
  TreeView1.items[16].Text :=  '3- ' + rsProjection;
  TreeView1.items[17].Text :=  '4- ' + rsObjectFilter;
  TreeView1.items[18].Text :=  '5- ' + rsGridSpacing;
  TreeView1.items[19].Text :=  '6- ' + rsObjectList;
  TreeView1.items[20].Text :='5- ' + rsCatalog;
  TreeView1.items[21].Text :=  '1- ' + rsCdCStars;
  TreeView1.items[22].Text :=  '2- ' + rsCdCNebulae;
  TreeView1.items[23].Text :=  '3- ' + rsCatalog;
  TreeView1.items[24].Text :=  '4- ' + 'VO ' + rsCatalog;
  TreeView1.items[25].Text :=  '5- ' + rsUserDefinedO;
  TreeView1.items[26].Text :=  '6- ' + rsOtherSoftwar;
  TreeView1.items[27].Text :=  '7- ' + rsObsolete+blank+rsStars;
  TreeView1.items[28].Text :=  '8- ' + rsObsolete+blank+rsNebulae;
  TreeView1.items[29].Text :='6- ' + rsSolarSystem;
  TreeView1.items[30].Text :=  '1- ' + rsSolarSystem;
  TreeView1.items[31].Text :=  '2- ' + rsPlanet;
  TreeView1.items[32].Text :=  '3- ' + rsComet;
  TreeView1.items[33].Text :=  '4- ' + rsAsteroid;
  TreeView1.items[34].Text :='7- ' + rsDisplay;
  TreeView1.items[35].Text :=  '1- ' + rsDisplay;
  TreeView1.items[36].Text :=  '2- ' + rsDisplayColou;
  TreeView1.items[37].Text :=  '3- ' + rsDeepSkyObjec;
  TreeView1.items[38].Text :=  '4- ' + rsSkyBackgroun;
  TreeView1.items[39].Text :=  '5- ' + rsLines;
  TreeView1.items[40].Text :=  '6- ' + rsLabels;
  TreeView1.items[41].Text :=  '7- ' + rsFonts;
  TreeView1.items[42].Text :=  '8- ' + rsFinderCircle;
  TreeView1.items[43].Text :=  '9- ' + rsFinderRectan;
  TreeView1.items[44].Text :='8- ' + rsPictures;
  TreeView1.items[45].Text :=  '1- ' + rsObject;
  TreeView1.items[46].Text :=  '2- ' + rsBackground;
  TreeView1.items[47].Text :=  '3- ' + rsDSSRealSky;
  TreeView1.items[48].Text :=  '4- ' + rsImageArchive;
  TreeView1.items[49].Text :='9- ' + rsInternet;
  TreeView1.items[50].Text :=  '1- ' + rsProxy;
  TreeView1.items[51].Text :=  '2- ' + rsOrbitalEleme;
  TreeView1.items[52].Text :=  '3- ' + rsOnlineDSSPic;
  TreeView1.items[53].Text :=  '4- ' + rsArtificialSa2;
  TreeView1.items[54].Text :='10- ' + rsCalendar;
  TreeView1.items[55].Text :=  '1- ' + rsGraphs;

  Applyall.Caption := rsApplyChangeT;
  Apply.Caption := rsApply;
  OKBtn.Caption := rsOK;
  CancelBtn.Caption := rsCancel;
  HelpBtn.Caption := rsHelp;
  if f_config_catalog1 <> nil then
    f_config_catalog1.SetLang;
  if f_config_chart1 <> nil then
    f_config_chart1.SetLang;
  if f_config_display1 <> nil then
    f_config_display1.SetLang;
  if f_config_internet1 <> nil then
    f_config_internet1.SetLang;
  if f_config_observatory1 <> nil then
    f_config_observatory1.SetLang;
  if f_config_pictures1 <> nil then
    f_config_pictures1.SetLang;
  if f_config_solsys1 <> nil then
    f_config_solsys1.SetLang;
  if f_config_system1 <> nil then
    f_config_system1.SetLang;
  if f_config_time1 <> nil then
    f_config_time1.SetLang;
  if f_config_calendar1 <> nil then
    f_config_calendar1.SetLang;
  SetHelp(self, hlpMenuSetup);
end;

procedure Tf_config.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  Fcsc := Tconf_skychart.Create;
  Fccat := Tconf_catalog.Create;
  Fcshr := Tconf_shared.Create;
  Fcplot := Tconf_plot.Create;
  Fcmain := Tconf_main.Create;
  Fcdss := Tconf_dss.Create;
  SetLang;
  compage := 32;
  astpage := 33;
  dbpage := 1;
  f_config_solsys1.onShowDB := ShowDBSetting;
  f_config_solsys1.onPrepareAsteroid := SolSysPrepareAsteroid;
  f_config_system1.onShowAsteroid := ShowAsteroidSetting;
  f_config_system1.onShowComet := ShowCometSetting;
  f_config_system1.onLoadMPCSample := LoadMPCSample;
  f_config_system1.onDBChange := SysDBChange;
  f_config_system1.onSaveAndRestart := SysSaveAndRestart;
  f_config_time1.onGetTwilight := TimeGetTwilight;
end;

procedure Tf_config.FormShow(Sender: TObject);
{$ifdef mswindows}var
  i: integer;
{$endif}
begin
  locktree := False;
  f_config_time1.Init;
  f_config_observatory1.Init;
  f_config_chart1.Init;
  f_config_catalog1.Init;
  f_config_solsys1.Init;
  f_config_display1.Init;
  f_config_pictures1.Init;
  f_config_system1.Init;
  f_config_internet1.Init;
  f_config_calendar1.Init;
  TreeView1.FullCollapse;
  Treeview1.selected := Treeview1.items[0];
  Treeview1.selected := Treeview1.items[cmain.configpage];
  lastSelectedNode := Treeview1.selected;
end;

procedure Tf_config.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  i, j: integer;
begin
  if locktree then
    exit;
  if node = nil then
  begin
    Treeview1.selected := lastSelectedNode;
    exit;
  end;
  try
    if node.level = 0 then
    begin
      Treeview1.selected := Treeview1.items[(Treeview1.selected.absoluteindex + 1)];
      TreeView1Change(Sender, Treeview1.selected);
    end
    else
    begin
      locktree := True;
      i := node.parent.index;
      j := node.index;
      ShowPage(i, j);
      TreeView1.FullCollapse;
      node.Parent.Expand(True);
    end;
    lastSelectedNode := Treeview1.selected;
    application.ProcessMessages;
  finally
    locktree := False;
  end;
end;

procedure Tf_config.ShowPage(i, j: integer);
begin
  // before the page change:
  if PageControl1.PageIndex = 4 then
  begin // config catalog
    if f_config_catalog1.PageControl1.ActivePage = f_config_catalog1.Page1 then
      f_config_catalog1.ActivateGCat;
    if f_config_catalog1.PageControl1.ActivePage = f_config_catalog1.Page1b then
      f_config_catalog1.ActivateUserObjects;
  end;
  if PageControl1.PageIndex = 0 then
  begin // config system
    if f_config_system1.PageControl1.ActivePage = f_config_system1.Page3 then
      f_config_system1.ActivateDBchange;
  end;
  // page change
  PageControl1.PageIndex := i;
  case i of
    0:
    begin
      f_config_system1.PageControl1.PageIndex := j;
      f_config_system1.Init;
    end;
    1:
    begin
      f_config_time1.PageControl1.PageIndex := j;
      f_config_time1.Init;
    end;
    2:
    begin
      f_config_observatory1.PageControl1.PageIndex := j;
      f_config_observatory1.Init;
    end;
    3:
    begin
      f_config_chart1.PageControl1.PageIndex := j;
      f_config_chart1.Init;
    end;
    4:
    begin
      f_config_catalog1.PageControl1.PageIndex := j;
      f_config_catalog1.Init;
    end;
    5:
    begin
      f_config_solsys1.PageControl1.PageIndex := j;
      f_config_solsys1.Init;
    end;
    6:
    begin
      f_config_display1.PageControl1.PageIndex := j;
      f_config_display1.Init;
    end;
    7:
    begin
      f_config_pictures1.PageControl1.PageIndex := j;
      f_config_pictures1.Init;
    end;
    8:
    begin
      f_config_internet1.PageControl1.PageIndex := j;
      f_config_internet1.Init;
    end;
    9:
    begin
      f_config_calendar1.PageControl1.PageIndex := j;
      f_config_calendar1.Init;
    end;
  end;
  cmain.configpage_i := i;
  cmain.configpage_j := j;
end;

procedure Tf_config.ActivateChanges;
begin
  if Treeview1.selected <> nil then
    cmain.configpage := Treeview1.selected.absoluteindex;
  if PageControl1.PageIndex = 4 then
  begin // config catalog
    if f_config_catalog1.PageControl1.ActivePage = f_config_catalog1.Page1 then
      f_config_catalog1.ActivateGCat;
    if f_config_catalog1.PageControl1.ActivePage = f_config_catalog1.Page1b then
      f_config_catalog1.ActivateUserObjects;
  end;
  if PageControl1.PageIndex = 0 then
  begin // config system
    if f_config_system1.PageControl1.ActivePage = f_config_system1.Page3 then
      f_config_system1.ActivateDBchange;
  end;
  Fcdss := f_config_internet1.cdss;
end;

procedure Tf_config.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ActivateChanges;
end;

procedure Tf_config.FormDestroy(Sender: TObject);
begin
  Fcsc.Free;
  Fccat.Free;
  Fcshr.Free;
  Fcplot.Free;
  Fcmain.Free;
  Fcdss.Free;
end;

procedure Tf_config.HelpBtnClick(Sender: TObject);
begin
  case PageControl1.PageIndex of
    0: f_config_system1.ShowHelp;
    1: f_config_time1.ShowHelp;
    2: f_config_observatory1.ShowHelp;
    3: f_config_chart1.ShowHelp;
    4: f_config_catalog1.ShowHelp;
    5: f_config_solsys1.ShowHelp;
    6: f_config_display1.ShowHelp;
    7: f_config_pictures1.ShowHelp;
    8: f_config_internet1.ShowHelp;
    9: f_config_calendar1.ShowHelp;
  end;
end;

procedure Tf_config.OKBtnClick(Sender: TObject);
begin
  f_config_observatory1.Button6Click(nil);
  f_config_solsys1.ActivateJplEph;
end;

procedure Tf_config.nextClick(Sender: TObject);
begin
  if (Treeview1.selected <> nil) and (Treeview1.selected.absoluteindex <
    Treeview1.items.Count - 1) then
  begin
    Treeview1.selected := Treeview1.selected.GetNext;
    treeview1.topitem := Treeview1.selected;
    TreeView1Change(Sender, Treeview1.selected);
  end;
end;

procedure Tf_config.previousClick(Sender: TObject);
var
  i: integer;
begin
  if (Treeview1.selected <> nil) and (Treeview1.selected.absoluteindex > 1) then
  begin
    locktree := True;
    Treeview1.selected := Treeview1.selected.GetPrev;
    if Treeview1.selected.level = 0 then
      Treeview1.selected := Treeview1.selected.GetPrev;
    i := Treeview1.selected.absoluteindex;
    locktree := False;
    Treeview1.selected := Treeview1.items[i];
    treeview1.topitem := Treeview1.selected;
    TreeView1Change(Sender, Treeview1.selected);
  end;
end;

procedure Tf_config.ShowDBSetting(Sender: TObject);
begin
  Treeview1.selected := Treeview1.items[dbpage];
end;

procedure Tf_config.ShowCometSetting(Sender: TObject);
begin
  Treeview1.selected := Treeview1.items[compage];
end;

procedure Tf_config.ShowAsteroidSetting(Sender: TObject);
begin
  Treeview1.selected := Treeview1.items[astpage];
end;

procedure Tf_config.LoadMPCSample(Sender: TObject);
begin
  f_config_solsys1.LoadSampleData;
end;

procedure Tf_config.SysDBChange(Sender: TObject);
begin
  if Assigned(FDBChange) then
    FDBChange(self);
end;

procedure Tf_config.SysSaveAndRestart(Sender: TObject);
begin
  if Assigned(FSaveAndRestart) then
    FSaveAndRestart(self);
end;

function Tf_config.SolSysPrepareAsteroid(jd1, jd2, step: double; msg: TStrings): boolean;
begin
  if assigned(FPrepareAsteroid) then
    Result := FPrepareAsteroid(jd1, jd2, step, msg)
  else
    Result := False;
end;

procedure Tf_config.EnableAsteroid(Sender: TObject);
begin
   if assigned(FEnableAsteroid) then FEnableAsteroid(self);
end;

procedure Tf_config.DisableAsteroid(Sender: TObject);
begin
   if assigned(FDisableAsteroid) then FDisableAsteroid(self);
end;

procedure Tf_config.TimeGetTwilight(jd0: double; out ht: double);
begin
  if assigned(FGetTwilight) then
    FGetTwilight(jd0, ht)
  else
    ht := -99;
end;

function Tf_config.GetFits: TFits;
begin
  Result := f_config_pictures1.Fits;
end;

procedure Tf_config.SetFits(Value: TFits);
begin
  f_config_pictures1.Fits := Value;
end;

function Tf_config.GetCatalog: Tcatalog;
begin
  Result := f_config_catalog1.catalog;
end;

procedure Tf_config.SetCatalog(Value: Tcatalog);
begin
  f_config_catalog1.catalog := Value;
end;

function Tf_config.GetDB: Tcdcdb;
begin
  Result := f_config_system1.cdb;
end;

procedure Tf_config.SetDB(Value: Tcdcdb);
begin
  f_config_system1.cdb := Value;
  f_config_solsys1.cdb := Value;
  f_config_pictures1.cdb := Value;
  f_config_observatory1.cdb := Value;
  f_config_time1.cdb := Value;
end;

procedure Tf_config.SetCcat(Value: Tconf_catalog);
begin
  Fccat.Assign(Value);
  f_config_time1.ccat := Fccat;
  f_config_observatory1.ccat := Fccat;
  f_config_chart1.ccat := Fccat;
  f_config_catalog1.ccat := Fccat;
  f_config_solsys1.ccat := Fccat;
  f_config_display1.ccat := Fccat;
  f_config_pictures1.ccat := Fccat;
  f_config_system1.ccat := Fccat;
end;

procedure Tf_config.SetCshr(Value: Tconf_shared);
begin
  Fcshr.Assign(Value);
  f_config_time1.cshr := Fcshr;
  f_config_observatory1.cshr := Fcshr;
  f_config_chart1.cshr := Fcshr;
  f_config_catalog1.cshr := Fcshr;
  f_config_solsys1.cshr := Fcshr;
  f_config_display1.cshr := Fcshr;
  f_config_pictures1.cshr := Fcshr;
  f_config_system1.cshr := Fcshr;
end;

procedure Tf_config.SetCsc(Value: Tconf_skychart);
begin
  Fcsc.Assign(Value);
  f_config_time1.csc := Fcsc;
  f_config_observatory1.csc := Fcsc;
  f_config_chart1.csc := Fcsc;
  f_config_catalog1.csc := Fcsc;
  f_config_solsys1.csc := Fcsc;
  f_config_display1.csc := Fcsc;
  f_config_pictures1.csc := Fcsc;
  f_config_system1.csc := Fcsc;
  f_config_calendar1.csc := Fcsc;
end;

procedure Tf_config.SetCplot(Value: Tconf_plot);
begin
  Fcplot.Assign(Value);
  f_config_time1.cplot := Fcplot;
  f_config_observatory1.cplot := Fcplot;
  f_config_chart1.cplot := Fcplot;
  f_config_catalog1.cplot := Fcplot;
  f_config_solsys1.cplot := Fcplot;
  f_config_display1.cplot := Fcplot;
  f_config_pictures1.cplot := Fcplot;
  f_config_system1.cplot := Fcplot;
end;

procedure Tf_config.SetCmain(Value: Tconf_main);
begin
  Fcmain.Assign(Value);
  f_config_time1.cmain := Fcmain;
  f_config_observatory1.cmain := Fcmain;
  f_config_chart1.cmain := Fcmain;
  f_config_catalog1.cmain := Fcmain;
  f_config_solsys1.cmain := Fcmain;
  f_config_display1.cmain := Fcmain;
  f_config_pictures1.cmain := Fcmain;
  f_config_system1.cmain := Fcmain;
  f_config_internet1.cmain := Fcmain;
end;

procedure Tf_config.SetCdss(Value: Tconf_dss);
begin
  Fcdss.Assign(Value);
  f_config_pictures1.cdss := Fcdss;
  f_config_internet1.cdss := Fcdss;
end;

procedure Tf_config.applyClick(Sender: TObject);
begin
  f_config_observatory1.Button6Click(nil);
  f_config_solsys1.ActivateJplEph;
  ActivateChanges;
  if assigned(FApplyConfig) then
    FApplyConfig(Self);
end;

end.
