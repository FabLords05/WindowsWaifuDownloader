; Inno Setup script for WaifuDownloader
; Edit values below as needed, then compile with Inno Setup (ISCC.exe)

[Setup]
AppName=WaifuDownloader
AppVersion=0.1
DefaultDirName={pf}\WaifuDownloader
DefaultGroupName=WaifuDownloader
DisableProgramGroupPage=no
OutputBaseFilename=WaifuDownloaderSetup
Compression=lzma
SolidCompression=yes
OutputDir=..\dist

; Show the project's LICENSE file during install
LicenseFile=..\LICENSE

; Use an .ico for the installer if present. If you only have a PNG, convert it to an ICO (see build script).
SetupIconFile=..\data\icons\moe.nyarchlinux.waifudownloader.ico

[Files]
; Source should point to the built exe (from PyInstaller). Path is relative to this script (build/)
Source: "..\dist\WaifuDownloader.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\WaifuDownloader"; Filename: "{app}\WaifuDownloader.exe"
Name: "{commondesktop}\WaifuDownloader"; Filename: "{app}\WaifuDownloader.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: checkedonce

[Run]
Filename: "{app}\WaifuDownloader.exe"; Description: "Launch WaifuDownloader"; Flags: nowait postinstall skipifsilent
