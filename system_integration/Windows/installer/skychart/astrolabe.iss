; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
 
[Setup]
AppName=Astrolabe
AppVerName=Astrolabe V3
AppPublisherURL=http://www.ap-i.net/skychart
AppSupportURL=http://www.ap-i.net/skychart
AppUpdatesURL=http://www.ap-i.net/skychart
DefaultDirName={reg:HKCU\Software\Astro_PC\Ciel,Install_Dir|{pf}\Ciel}
UsePreviousAppDir=false
DefaultGroupName=Astrolabe
AllowNoIcons=true
InfoBeforeFile=Presetup\readme_astrolabe.txt
OutputDir=.\
OutputBaseFilename=astrolabe-windows
Compression=lzma
SolidCompression=true
Uninstallable=true
UninstallLogMode=append
DirExistsWarning=no
ShowLanguageDialog=yes
AppID={{A261F28E-6053-4414-9B84-AA8FE5F47AD4}

[CustomMessages]
CreateStartupIcon=Launch astrolabe automatically on Windows startup

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}
Name: startupicon; Description: {cm:CreateStartupIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[InstallDelete]
Name: {app}\cdc.exe; Type: files; Components: ; Tasks:
Name: {app}\libFPlanetRender.dll; Type: files; Components: ; Tasks:
Name: {app}\plugins\bmptopnm.exe; Type: files; Components: ; Tasks:
Name: {app}\plugins\bmptops.bat; Type: files; Components: ; Tasks:
Name: {app}\plugins\celestrongps.exe; Type: files; Components: ; Tasks:
Name: {app}\plugins\cygwin1.dll; Type: files; Components: ; Tasks:
Name: {app}\plugins\indiserver.exe; Type: files; Components: ; Tasks:
Name: {app}\plugins\libnetpbm10.dll; Type: files; Components: ; Tasks:
Name: {app}\plugins\lx200generic.exe; Type: files; Components: ; Tasks:
Name: {app}\plugins\pnmtops.exe; Type: files; Components: ; Tasks:
Name: {app}\plugins\telescope\Ascom.tid; Type: files; Components: ; Tasks:
Name: {app}\plugins\telescope\encoder.tid; Type: files; Components: ; Tasks:
Name: {app}\plugins\telescope\Meade.tid; Type: files; Components: ; Tasks:
Name: {app}\plugins\telescope; Type: dirifempty; Components: ; Tasks:
Name: {app}\plugins; Type: dirifempty; Components: ; Tasks:
Name: {app}\data\Themes\default\*; Type: filesandordirs; Components: ; Tasks: 
Name: {app}\data\zoneinfo\*; Type: filesandordirs; Components: ; Tasks: 
Name: {app}\doc\wiki_doc\*; Type: filesandordirs; Components: ; Tasks: 

[Files]
Source: Data\*; DestDir: {app}; Flags: ignoreversion recursesubdirs createallsubdirs restartreplace
Source: PrivateFiles\*; DestDir: {localappdata}\skychart\; Flags: onlyifdoesntexist 
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Registry]
Root: HKCU; Subkey: Software\Astro_PC\Ciel; ValueType: string; ValueName: Install_Dir; ValueData: {app}; Flags: uninsdeletekey
Root: HKCU; Subkey: Software\Astro_PC\VarObs; ValueType: string; ValueName: Install_Dir; ValueData: {app}; Flags: uninsdeletekey

[Icons]
Name: {group}\Astrolabe; Filename: {app}\astrolabe.exe; WorkingDir: {app}
Name: {userdesktop}\Astrolabe; Filename: {app}\astrolabe.exe; WorkingDir: {app}; Tasks: desktopicon
Name: {userstartup}\Astrolabe; Filename: {app}\astrolabe.exe; WorkingDir: {app}; Tasks: startupicon
 
