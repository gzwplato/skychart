unit cu_tcpserver;

{
Copyright (C) 2010 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{ TCP/IP Connexion, based on Synapse Echo demo }

{$MODE Delphi}{$H+}

interface

uses u_constant, u_util, blcksock, synsock,
     FileUtil, LCLIntf, SysUtils, Classes;

type

  TStringProc = procedure(var S: string) of object;
  TIntProc = procedure(var i: integer) of object;
  TExCmd = function(S:string; L:Tstringlist):string of object;

  TTCPThrd = class(TThread)
  private
    FSock:TTCPBlockSocket;
    CSock: TSocket;
    cmd : TStringlist;
    cmdresult : string;
    FConnectTime : double;
    FTerminate : TIntProc;
    FExecuteCmd: TExCmd;
  public
    id : integer;
    keepalive,abort,lockexecutecmd,stoping : boolean;
    active_chart,remoteip,remoteport : string;
    Constructor Create (hsock:tSocket);
    procedure Execute; override;
    procedure SendData(str:string);
    procedure ExecuteCmd;
    property sock : TTCPBlockSocket read FSock;
    property ConnectTime : double read FConnectTime;
    property Terminated;
    property onTerminate : TIntProc read FTerminate write FTerminate;
    property onExecuteCmd : TExCmd read FExecuteCmd write FExecuteCmd;
  end;

  TTCPDaemon = class(TThread)
  private
    Sock:TTCPBlockSocket;
    active_chart : string;
    FGetActiveChart : TStringProc;
    FErrorMsg : TStringProc;
    FShowSocket: TStringProc;
    FIPaddr,FIPport : string;
    FExecuteCmd: TExCmd;
    procedure ShowError;
    procedure ThrdTerminate(var i : integer);
  public
    keepalive, stoping : boolean;
    TCPThrd: array [1..Maxwindow] of TTCPThrd ;
    ThrdActive: array [1..Maxwindow] of boolean ;
    Constructor Create;
    procedure Execute; override;
    procedure ShowSocket;
    procedure GetActiveChart;
    property IPaddr : string read FIPaddr write FIPaddr;
    property IPport : string read FIPport write FIPport;
    property onGetACtiveChart : TStringProc read FGetActiveChart write FGetActiveChart;
    property onErrorMsg : TStringProc read FErrorMsg write FErrorMsg;
    property onShowSocket : TStringProc read  FShowSocket write FShowSocket;
    property onExecuteCmd : TExCmd read FExecuteCmd write FExecuteCmd;
  end;

implementation

Constructor TTCPDaemon.Create;
begin
  FreeOnTerminate:=true;
  keepalive:=false;
  inherited create(false);
end;

procedure TTCPDaemon.ShowError;
var msg: string;
begin
msg:=inttostr(sock.lasterror)+' '+sock.GetErrorDesc(sock.lasterror);
if assigned(FErrorMsg) then FErrorMsg(msg);
end;

procedure TTCPDaemon.ShowSocket;
var locport:string;
begin
sock.GetSins;
locport:=inttostr(sock.GetLocalSinPort);
if assigned(FShowSocket) then FShowSocket(locport);
end;

procedure TTCPDaemon.ThrdTerminate(var i : integer);
begin
ThrdActive[i]:=false;
end;

procedure TTCPDaemon.GetActiveChart;
begin
if assigned(FGetActiveChart) then FGetActiveChart(active_chart);
end;

procedure TTCPDaemon.Execute;
var
  ClientSock:TSocket;
  i,n : integer;
begin
stoping:=false;
for i:=1 to MaxWindow do ThrdActive[i]:=false;
sock:=TTCPBlockSocket.create;
try
  with sock do
    begin
      CreateSocket;
      if lasterror<>0 then Synchronize(ShowError);
      MaxLineLength:=1024;
      setLinger(true,1000);
      if lasterror<>0 then Synchronize(ShowError);
      bind(FIPaddr,FIPport);
      if lasterror<>0 then Synchronize(ShowError);
      listen;
      if lasterror<>0 then Synchronize(ShowError);
      Synchronize(ShowSocket);
      repeat
        if stoping or terminated then break;
        if canread(500) and (not terminated) then
          begin
            ClientSock:=accept;
            if lastError=0 then begin
              n:=-1;
              for i:=1 to Maxwindow do
                 if (not ThrdActive[i])
                    or(TCPThrd[i]=nil)
                    or(TCPThrd[i].Fsock=nil)
                    or(TCPThrd[i].terminated)
                    then begin
                      n:=i;
                      break;
                    end;
              if n>0 then begin
                 TCPThrd[n]:=TTCPThrd.create(ClientSock);
                 TCPThrd[n].onTerminate:=ThrdTerminate;
                 TCPThrd[n].onExecuteCmd:=FExecuteCmd;
                 TCPThrd[n].keepalive:=keepalive;
                 i:=0; while (TCPThrd[n].Fsock=nil)and(i<100) do begin sleep(100); inc(i); end;
                 if not TCPThrd[n].terminated then begin
                      TCPThrd[n].id:=n;
                      ThrdActive[n]:=true;
                      Synchronize(GetActiveChart);
                      if active_chart=msgFailed then
                        TCPThrd[n].senddata(msgFailed+' Cannot activate a chart.')
                      else begin
                        TCPThrd[n].active_chart:=active_chart;
                        TCPThrd[n].senddata(msgOK+' id='+inttostr(n)+' chart='+active_chart);
                      end;
                 end;
              end else
                 with TTCPThrd.create(ClientSock) do begin
                   i:=0; while (sock=nil)and(i<100) do begin sleep(100); inc(i); end;
                   if not terminated then begin
                      if Sock<>nil then Sock.SendString(msgFailed+' Maximum connection reach!'+CRLF);
                      terminate;
                   end;
              end;
            end
            else Synchronize(ShowError);
          end;
      until false;
    end;
finally
  suspend;
  Sock.CloseSocket;
  Sock.free;
  terminate;
end;
end;

Constructor TTCPThrd.Create(Hsock:TSocket);
begin
  Csock := Hsock;
  FreeOnTerminate:=true;
  cmd:=TStringlist.create;
  keepalive:=false;
  abort:=false;
  lockexecutecmd:=false;
  inherited create(false);
end;

procedure TTCPThrd.Execute;
var
  s: string;
  i: integer;
begin
  Fsock:=TTCPBlockSocket.create;
  FConnectTime:=now;
  stoping:=false;
  try
    Fsock.socket:=CSock;
    Fsock.GetSins;
    Fsock.MaxLineLength:=1024;
    remoteip:=Fsock.GetRemoteSinIP;
    remoteport:=inttostr(Fsock.GetRemoteSinPort);
    with Fsock do
      begin
        repeat
          if stoping or terminated then break;
          s := RecvString(500);
          //if s<>'' then writetrace(s);   // for debuging only, not thread safe!
          if lastError=0 then begin
             if (uppercase(s)='QUIT')or(uppercase(s)='EXIT') then break;
             splitarg(s,blank,cmd);
             for i:=cmd.count to MaxCmdArg do cmd.add('');
             Synchronize(ExecuteCmd);
             SendString(cmdresult+crlf);
             if lastError<>0 then break;
             if (cmdresult=msgOK)and(uppercase(cmd[0])='SELECTCHART') then active_chart:=cmd[1];
          end else
             if keepalive then begin
                SendString('.'+crlf);      // keepalive check
                if lastError<>0 then break;  // if send failed we close the connection
          end;
        until false;
      end;
  finally
    if assigned(FTerminate) then FTerminate(id);
    Fsock.SendString(msgBye+crlf);
    Fsock.CloseSocket;
    Fsock.Free;
    cmd.free;
    suspend;
    terminate;
  end;
end;

procedure TTCPThrd.Senddata(str:string);
begin
try
if Fsock<>nil then
 with Fsock do begin
   if terminated then exit;
   SendString(UTF8ToSys(str)+CRLF);
   if LastError<>0 then
      terminate;
 end;
except
terminate;
end;
end;

procedure TTCPThrd.ExecuteCmd;
begin
if lockexecutecmd then exit;
lockexecutecmd:=true;
try
  if Assigned(FExecuteCmd) then cmdresult:=FExecuteCmd(active_chart,cmd);
finally
  lockexecutecmd:=false;
end;
end;

end.

