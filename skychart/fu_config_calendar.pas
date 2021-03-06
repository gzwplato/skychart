unit fu_config_calendar;

{$mode objfpc}{$H+}

interface

uses u_help, u_translation, u_constant, u_util, enhedits,
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, ComCtrls, StdCtrls;

type

  { Tf_config_calendar }

  Tf_config_calendar = class(TFrame)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    LongEdit1: TLongEdit;
    Mainpanel: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    procedure LongEdit1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
  private
    { private declarations }
    LockChange: boolean;
    FApplyConfig: TNotifyEvent;
  public
    { public declarations }
    mycsc: Tconf_skychart;
    csc: Tconf_skychart;
    procedure SetLang;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;  // old formshow
    procedure Lock;  // old formclose
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

{$R *.lfm}

procedure Tf_config_calendar.LongEdit1Change(Sender: TObject);
begin
  csc.CalGraphHeight := LongEdit1.Value;
end;

procedure Tf_config_calendar.PageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if parent is TForm then
    TForm(Parent).ActiveControl := PageControl1;
end;

procedure Tf_config_calendar.SetLang;
begin
  TabSheet1.Caption := rsCalendarGrap;
  GroupBox1.Caption := rsCalendarGrap;
  label2.Caption := rsGraphHeight;
end;

constructor Tf_config_calendar.Create(AOwner: TComponent);
begin
  mycsc := Tconf_skychart.Create;
  csc := mycsc;
  inherited Create(AOwner);
  SetLang;
end;

destructor Tf_config_calendar.Destroy;
begin
  mycsc.Free;
  inherited Destroy;
end;

procedure Tf_config_calendar.Init;
begin
  LockChange := True;
  LongEdit1.Value := csc.CalGraphHeight;
  LockChange := False;
end;

procedure Tf_config_calendar.Lock;
begin
  LockChange := True;
end;

end.
