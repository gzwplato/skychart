unit ChildFrame;

{ Copyright (C) 2007 Patrick Chevalley

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, Math, SysUtils, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, GraphType, lclintf;

{  TChildFrame
   The "child form" component.
   This is a TPanel descendant that emulate a child form with sizeable border
   and button.
   Use: See TMultiFrame
}
type
  TCdCSplitter = class(TCustomSplitter)
  public
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  end;

  TCdCPanel = class(TCustomPanel)
  public
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseLeave;
    property OnDblClick;
  end;

  TChildFrame = class(TCustomPanel)
    TopLeftBar, TopRightBar, BotLeftBar, BotRightBar: TCdCSplitter;
    TopBar, BotBar, LeftBar, RightBar: TCdCSplitter;
    MenuBar: TCDCPanel;
    Title: TLabel;
    ButtonClose: TSpeedButton;
    ButtonMaximize: TSpeedButton;
  private
    { Private declarations }
    FDockedObject: TFrame;
    FCaption: string;
    startpoint: TPoint;
    moving, sizing, lockmove: boolean;
    movedirection, movecount: integer;
    FMaximized, FWireframeMoveResize: boolean;
    save_top, save_left, save_width, save_height, ini_width, ini_height: integer;
    borderw, titleheight: integer;
    titlecolor, bordercolor: TColor;
    FonClose: TNotifyEvent;
    FonMaximize: TNotifyEvent;
    FonRestore: TNotifyEvent;
    FonCaptionChange: TNotifyEvent;
    FOnCloseQuery: TCloseQueryEvent;
    procedure Maximize;
    procedure Restore;
    procedure SetDockedObject(Value: TFrame);
    procedure SetCaption(Value: string);
    procedure SetMaximized(Value: boolean);
    procedure MenuBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure MenuBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure MenuBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure MenuBarMouseLeave(Sender: TObject);
    procedure SizeBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ButtonCloseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ButtonMaximizeClick(Sender: TObject);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    procedure SizeBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure SizeBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetTitleColor(col: TColor);
    procedure SetBorderColor(col: TColor);
    procedure SetTitleHeight(x: integer);
    procedure SetBorderWdth(x: integer);
    procedure RestoreSize;
    property onMaximize: TNotifyEvent read FonMaximize write FonMaximize;
    property onRestore: TNotifyEvent read FonRestore write FonRestore;
    property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property onClose: TNotifyEvent read FonClose write FonClose;
    property onCaptionChange: TNotifyEvent read FonCaptionChange write FonCaptionChange;
  published
    { Published declarations }
    {
     Close the child form
    }
    procedure Close;
    {
     DockedObject is your docked frame
    }
    property DockedObject: TFrame read FDockedObject write SetDockedObject;
    {
     The child window title
    }
    property Caption: string read FCaption write SetCaption;
    {
     maximize the window
    }
    property Maximized: boolean read FMaximized write SetMaximized;
    {
     if WireframeMoveResize is true the window content is not show
     during move or resize.
    }
    property WireframeMoveResize: boolean read FWireframeMoveResize
      write FWireframeMoveResize;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FullRepaint;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnGetDockCaption;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

const
{$if DEFINED(lclgtk2) OR DEFINED(lclqt) OR DEFINED(lclcarbon) OR DEFINED(mswindows) }
  {$define childdoc_better_move}
{$endif}
{$ifdef childdoc_better_move}
  skipmouseeventcount = 4; // duplicate mousemove events
{$else}
  skipmouseeventcount = 1;

{$endif}

{$i childbutton.inc}

{ TCdCSplitter }

procedure TCdCSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited  MouseDown(Button, Shift, X, Y);
end;

procedure TCdCSplitter.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited  MouseMove(Shift, X, Y);
end;

procedure TCdCSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited  MouseUp(Button, Shift, X, Y);
end;

{
     Class creator
}
constructor TChildFrame.Create(AOwner: TComponent);
var
  m: TStringStream;
begin
  inherited Create(AOwner);
  BorderW := 2;
  TitleHeight := 15;
  BorderColor := clActiveCaption;
  TitleColor := clCaptionText;
  FWireframeMoveResize := True;
  FDockedObject := nil;
  FCaption := '';
  BevelOuter := bvNone;
  BevelWidth := 1;
  TopLeftBar := TCdCSplitter.Create(self);
  TopLeftBar.Parent := self;
  TopLeftBar.Tag := 5;
  TopLeftBar.Align := alNone;
  TopLeftBar.Height := borderw;
  TopLeftBar.Width := borderw;
  TopLeftBar.Top := 0;
  TopLeftBar.Left := 0;
  TopLeftBar.Color := BorderColor;
  TopLeftBar.Cursor := crSizeNWSE;
  TopLeftBar.Anchors := [akLeft, akTop];
  TopLeftBar.OnMouseDown := @SizeBarMouseDown;
  TopLeftBar.OnMouseUp := @SizeBarMouseUp;
  TopLeftBar.OnMouseMove := @SizeBarMouseMove;
  TopRightBar := TCdCSplitter.Create(self);
  TopRightBar.Tag := 6;
  TopRightBar.Align := alNone;
  TopRightBar.Parent := self;
  TopRightBar.Height := borderw;
  TopRightBar.Width := borderw;
  TopRightBar.Top := 0;
  TopRightBar.Left := Width - borderw;
  TopRightBar.Color := BorderColor;
  TopRightBar.Cursor := crSizeNESW;
  TopRightBar.Anchors := [akRight, akTop];
  TopRightBar.OnMouseDown := @SizeBarMouseDown;
  TopRightBar.OnMouseUp := @SizeBarMouseUp;
  TopRightBar.OnMouseMove := @SizeBarMouseMove;
  BotLeftBar := TCdCSplitter.Create(self);
  BotLeftBar.Tag := 7;
  BotLeftBar.Align := alNone;
  BotLeftBar.Parent := self;
  BotLeftBar.Width := borderw;
  BotLeftBar.Height := borderw;
  BotLeftBar.Top := Height - borderw;
  BotLeftBar.Left := 0;
  BotLeftBar.Color := BorderColor;
  BotLeftBar.Cursor := crSizeNESW;
  BotLeftBar.Anchors := [akLeft, akBottom];
  BotLeftBar.OnMouseDown := @SizeBarMouseDown;
  BotLeftBar.OnMouseUp := @SizeBarMouseUp;
  BotLeftBar.OnMouseMove := @SizeBarMouseMove;
  BotRightBar := TCdCSplitter.Create(self);
  BotRightBar.Parent := self;
  BotRightBar.Tag := 8;
  BotRightBar.Align := alNone;
  BotRightBar.Width := borderw;
  BotRightBar.Height := borderw;
  BotRightBar.Top := Height - borderw;
  BotRightBar.Left := Width - borderw;
  BotRightBar.Color := BorderColor;
  BotRightBar.Cursor := crSizeNWSE;
  BotRightBar.Anchors := [akRight, akBottom];
  BotRightBar.OnMouseDown := @SizeBarMouseDown;
  BotRightBar.OnMouseUp := @SizeBarMouseUp;
  BotRightBar.OnMouseMove := @SizeBarMouseMove;
  TopBar := TCdCSplitter.Create(self);
  TopBar.Parent := self;
  TopBar.Tag := 1;
  TopBar.Height := borderw;
  TopBar.Beveled := True;
  TopBar.Color := BorderColor;
  TopBar.Cursor := crSizeNS;
  TopBar.Align := alTop;
  TopBar.OnMouseDown := @SizeBarMouseDown;
  TopBar.OnMouseUp := @SizeBarMouseUp;
  TopBar.OnMouseMove := @SizeBarMouseMove;
  BotBar := TCdCSplitter.Create(self);
  BotBar.Tag := 2;
  BotBar.Parent := self;
  BotBar.Height := borderw;
  BotBar.Color := BorderColor;
  BotBar.Cursor := crSizeNS;
  BotBar.Align := alBottom;
  BotBar.OnMouseDown := @SizeBarMouseDown;
  BotBar.OnMouseUp := @SizeBarMouseUp;
  BotBar.OnMouseMove := @SizeBarMouseMove;
  LeftBar := TCdCSplitter.Create(self);
  LeftBar.Tag := 3;
  LeftBar.Parent := self;
  LeftBar.Width := borderw;
  LeftBar.Color := BorderColor;
  LeftBar.Cursor := crSizeWE;
  LeftBar.Align := alLeft;
  LeftBar.OnMouseDown := @SizeBarMouseDown;
  LeftBar.OnMouseUp := @SizeBarMouseUp;
  LeftBar.OnMouseMove := @SizeBarMouseMove;
  RightBar := TCdCSplitter.Create(self);
  RightBar.Parent := self;
  RightBar.Tag := 4;
  RightBar.Width := borderw;
  RightBar.Color := BorderColor;
  RightBar.Cursor := crSizeWE;
  RightBar.Align := alRight;
  RightBar.OnMouseDown := @SizeBarMouseDown;
  RightBar.OnMouseUp := @SizeBarMouseUp;
  RightBar.OnMouseMove := @SizeBarMouseMove;
  MenuBar := TCDCPanel.Create(self);
  MenuBar.Parent := self;
  MenuBar.Height := TitleHeight;
  MenuBar.BevelOuter := bvNone;
  MenuBar.Color := BorderColor;
  MenuBar.Align := alTop;
  MenuBar.OnMouseDown := @MenuBarMouseDown;
  MenuBar.OnMouseMove := @MenuBarMouseMove;
  MenuBar.OnMouseLeave := @MenuBarMouseLeave;
  MenuBar.OnMouseUp := @MenuBarMouseUp;
  MenuBar.OnDblClick := @ButtonMaximizeClick;
  ButtonClose := TSpeedButton.Create(self);
  ButtonClose.Width := TitleHeight - 2;
  ButtonClose.Height := TitleHeight - 2;
  ButtonClose.Transparent := True;
  ButtonClose.Flat := True;
  ButtonClose.Caption := '';
  m := TStringStream.Create(closebmp);
  m.Position := 0;
  ButtonClose.Glyph.LoadFromStream(m);
  m.Free;
  ButtonClose.Parent := MenuBar;
  ButtonClose.Align := alRight;
  ButtonClose.OnMouseUp := @ButtonCloseMouseUp;
  ButtonMaximize := TSpeedButton.Create(self);
  ButtonMaximize.Width := TitleHeight - 2;
  ButtonMaximize.Height := TitleHeight - 2;
  ButtonMaximize.Transparent := True;
  ButtonMaximize.Flat := True;
  ButtonMaximize.Caption := '';
  m := TStringStream.Create(maxibmp);
  m.Position := 0;
  ButtonMaximize.Glyph.LoadFromStream(m);
  m.Free;
  ButtonMaximize.Parent := MenuBar;
  ButtonMaximize.Align := alRight;
  ButtonMaximize.OnClick := @ButtonMaximizeClick;
  Title := TLabel.Create(self);
  Title.Parent := MenuBar;
  Title.Top := 0;
  Title.Left := 4;
  Title.Font.Height := -(TitleHeight - 2);
  Title.Font.Color := TitleColor;
  Title.Caption := FCaption;
  Title.OnMouseDown := @MenuBarMouseDown;
  Title.OnMouseUp := @MenuBarMouseUp;
  Title.OnMouseLeave := @MenuBarMouseLeave;
  Title.OnMouseMove := @MenuBarMouseMove;
  Title.OnDblClick := @ButtonMaximizeClick;
  TopBar.Top := 0;
  TopLeftBar.BringToFront;
  TopRightBar.BringToFront;
  BotLeftBar.BringToFront;
  BotRightBar.BringToFront;
  movecount := 0;
  moving := False;
  sizing := False;
  lockmove := False;
end;

{
    Class destructor
}
destructor TChildFrame.Destroy;
begin
  try
    inherited Destroy;
  except
  end;
end;

procedure TChildFrame.Paint;
var
  ARect: TRect;
begin
  ARect := GetClientRect;
  Canvas.Brush.Color := color;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(ARect);
  inherited Paint;
end;

procedure TChildFrame.SetDockedObject(Value: TFrame);
begin
  if FDockedObject <> nil then
    FDockedObject.Free;
  FDockedObject := Value;
  FDockedObject.Parent := self;
  save_top := top;
  save_left := left;
  ini_Width := FDockedObject.Width + 2 * borderw;
  ini_Height := FDockedObject.Height + 2 * borderw + titleheight;
  save_Width := ini_Width;
  save_Height := ini_Height;
  if not FMaximized then
  begin
    ClientWidth := ini_Width;
    ClientHeight := ini_Height;
  end;
  FDockedObject.Align := alClient;
  Caption := FDockedObject.Caption;
  TopLeftBar.BringToFront;
  TopRightBar.BringToFront;
  BotLeftBar.BringToFront;
  BotRightBar.BringToFront;
end;

procedure TChildFrame.SetCaption(Value: string);
begin
  FCaption := Value;
  Title.Caption := FCaption;
  if assigned(FonCaptionChange) then
    FonCaptionChange(self);
end;

procedure TChildFrame.MenuBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if assigned(onEnter) then
    onEnter(self);
  startpoint := clienttoscreen(point(X, titleheight div 2));
  moving := True;
  movecount := -1;
  if WireframeMoveResize then
    DockedObject.Hide;
  MenuBarMouseMove(Sender, Shift, X, Y);
end;

procedure TChildFrame.MenuBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  moving := False;
  if WireframeMoveResize then
    DockedObject.Show;
end;

procedure TChildFrame.MenuBarMouseLeave(Sender: TObject);
{$ifdef childdoc_better_move}
var
  P: Tpoint;
{$endif}
begin
{$ifdef childdoc_better_move}
  if moving and (not lockmove) then
  begin
    lockmove := True;
    P := mouse.CursorPos;
    top := top + P.Y - startpoint.Y;
    left := left + P.X - startpoint.X;
    top := max(top, 0);
    top := min(top, parent.ClientHeight - MenuBar.Height - Topbar.Height);
    left := max(left, -Width + 2 * MenuBar.Height);
    left := min(left, parent.ClientWidth - MenuBar.Height);
    startpoint := P;
    application.ProcessMessages;
    lockmove := False;
  end;
{$else}
  moving := False;
  if WireframeMoveResize then
    DockedObject.Show;
{$endif}
end;

procedure TChildFrame.MenuBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  P: Tpoint;
begin
  Inc(movecount);
  if movecount >= MaxInt then
    movecount := 0;
  if moving and (not lockmove) and ((movecount mod skipmouseeventcount) = 0) then
  begin
    lockmove := True;
    P := clienttoscreen(Point(X, Y));
    top := top + P.Y - startpoint.Y;
    left := left + P.X - startpoint.X;
    top := max(top, 0);
    top := min(top, parent.ClientHeight - MenuBar.Height - Topbar.Height);
    left := max(left, -Width + 2 * MenuBar.Height);
    left := min(left, parent.ClientWidth - MenuBar.Height);
    startpoint := P;
    application.ProcessMessages;
    lockmove := False;
  end;
end;

procedure TChildFrame.SizeBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if assigned(onEnter) then
    onEnter(self);
  GetCursorPos(startpoint);
  sizing := True;
  movedirection := (Sender as TCdCSplitter).Tag;
  if WireframeMoveResize then
    DockedObject.Hide;
  application.ProcessMessages;
end;

procedure TChildFrame.SizeBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  sizing := False;
  if WireframeMoveResize then
    DockedObject.Show;
end;

procedure TChildFrame.SizeBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  P: Tpoint;
  dx, dy: integer;
begin
  if sizing and (not lockmove) then
  begin
    lockmove := True;
    GetCursorPos(P);
    dy := P.Y - startpoint.Y;
    dx := P.X - startpoint.X;
    case movedirection of
      1:
      begin  // Top
        Height := Height - dy;
        top := top + dy;
      end;
      2:
      begin  // Bottom
        Height := Height + dy;
      end;
      3:
      begin // Left
        Width := Width - dx;
        left := left + dx;
      end;
      4:
      begin // Right
        Width := Width + dx;
      end;
      5:
      begin  // Top Left
        Height := Height - dy;
        top := top + dy;
        Width := Width - dx;
        left := left + dx;
      end;
      6:
      begin  // Top Right
        Height := Height - dy;
        top := top + dy;
        Width := Width + dx;
      end;
      7:
      begin // Bottom Left
        Height := Height + dy;
        Width := Width - dx;
        left := left + dx;
      end;
      8:
      begin // Bottom Right
        Height := Height + dy;
        Width := Width + dx;
      end;
    end;
    startpoint := P;
    Height := max(Height, MenuBar.Height + Topbar.Height);
    Width := max(Width, Title.Width + ButtonClose.Width + ButtonMaximize.Width);
    top := max(top, 0);
    top := min(top, parent.ClientHeight - MenuBar.Height - Topbar.Height);
    left := max(left, -Width + 2 * MenuBar.Height);
    left := min(left, parent.ClientWidth - MenuBar.Height);
    application.ProcessMessages;
    lockmove := False;
  end;
end;

procedure TChildFrame.Close;
begin
  if assigned(FonClose) then
    FonClose(self);
end;

procedure TChildFrame.ButtonCloseMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  canclose: boolean;
begin
  if (Button = mbLeft) then
  begin
    canclose := True;
    if assigned(FonCloseQuery) then
      FonCloseQuery(self, canclose);
    if canclose then
      Close;
  end;
end;

procedure TChildFrame.Maximize;
begin
  try
    FMaximized := True;
    save_top := top;
    save_left := left;
    save_width := Width;
    save_height := Height;
    top := 0;
    left := 0;
    Width := parent.ClientWidth;
    Height := parent.ClientHeight;
    MenuBar.Visible := False;
    TopLeftBar.Visible := False;
    TopRightBar.Visible := False;
    BotLeftBar.Visible := False;
    BotRightBar.Visible := False;
    TopBar.Visible := False;
    BotBar.Visible := False;
    LeftBar.Visible := False;
    RightBar.Visible := False;
    if assigned(FonMaximize) then
      FonMaximize(self);
  except
  end;
end;

procedure TChildFrame.Restore;
begin
  try
    FMaximized := False;
    top := save_top;
    left := save_left;
    Width := save_width;
    Height := save_height;
    MenuBar.Visible := True;
    TopLeftBar.Visible := True;
    TopRightBar.Visible := True;
    BotLeftBar.Visible := True;
    BotRightBar.Visible := True;
    TopBar.Visible := True;
    BotBar.Visible := True;
    LeftBar.Visible := True;
    RightBar.Visible := True;
    SetBorderWdth(BorderW);
    if assigned(FonRestore) then
      FonRestore(self);
  except
  end;
end;

procedure TChildFrame.RestoreSize;
begin
  Width := ini_width;
  Height := ini_height;
end;

procedure TChildFrame.SetMaximized(Value: boolean);
begin
  if FMaximized <> Value then
  begin
    FMaximized := Value;
    if FMaximized then
      Maximize
    else
      Restore;
  end;
end;

procedure TChildFrame.ButtonMaximizeClick(Sender: TObject);
begin
  if assigned(onEnter) then
    onEnter(self);
  Maximized := not FMaximized;
end;

procedure TChildFrame.SetTitleColor(col: TColor);
begin
  try
    TitleColor := col;
    Title.Font.Color := TitleColor;
  except
  end;
end;

procedure TChildFrame.SetBorderColor(col: TColor);
begin
  try
    BorderColor := col;
    TopLeftBar.Color := BorderColor;
    TopRightBar.Color := BorderColor;
    BotLeftBar.Color := BorderColor;
    BotRightBar.Color := BorderColor;
    TopBar.Color := BorderColor;
    BotBar.Color := BorderColor;
    LeftBar.Color := BorderColor;
    RightBar.Color := BorderColor;
    MenuBar.Color := BorderColor;
  except
  end;
end;

procedure TChildFrame.SetTitleHeight(x: integer);
begin
  try
    TitleHeight := x;
    MenuBar.Height := TitleHeight;
    ButtonMaximize.Width := TitleHeight - 2;
    ButtonMaximize.Height := TitleHeight - 2;
    ButtonClose.Width := TitleHeight - 2;
    ButtonClose.Height := TitleHeight - 2;
    Title.Font.Height := -(TitleHeight - 2);
  except
  end;
end;

procedure TChildFrame.SetBorderWdth(x: integer);
begin
{TopLeftBar.SendtoBack;   // crash on GTK2
TopRightBar.SendtoBack;
BotLeftBar.SendtoBack;
BotRightBar.SendtoBack;}
  try
    BorderW := x;
    TopLeftBar.Height := borderw;
    TopLeftBar.Width := borderw;
    TopLeftBar.Top := 0;
    TopLeftBar.Left := 0;
    TopRightBar.Height := borderw;
    TopRightBar.Width := borderw;
    TopRightBar.Top := 0;
    TopRightBar.Left := Width - borderw;
    BotLeftBar.Width := borderw;
    BotLeftBar.Height := borderw;
    BotLeftBar.Top := Height - borderw;
    BotLeftBar.Left := 0;
    BotRightBar.Width := borderw;
    BotRightBar.Height := borderw;
    BotRightBar.Top := Height - borderw;
    BotRightBar.Left := Width - borderw;
    TopBar.Height := borderw;
    TopBar.Top := 0;
    BotBar.Height := borderw;
    BotBar.Top := Height - borderw;
    LeftBar.Width := borderw;
    LeftBar.Left := 0;
    RightBar.Width := borderw;
    RightBar.Left := Width - borderw;
  except
  end;
{TopLeftBar.BringToFront;
TopRightBar.BringToFront;
BotLeftBar.BringToFront;
BotRightBar.BringToFront;  }
end;



initialization
  {$I multiframe.lrs}


end.
