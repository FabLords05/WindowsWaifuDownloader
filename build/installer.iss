; Inno Setup script for Windows Waifu Downloader
; Edit values below as needed, then compile with Inno Setup (ISCC.exe)

[Setup]
AppName=Windows Waifu Downloader
AppVersion=0.1
DefaultDirName={pf}\Windows Waifu Downloader
DefaultGroupName=Windows Waifu Downloader
DisableProgramGroupPage=no
OutputBaseFilename=WindowsWaifuInstaller
Compression=lzma
SolidCompression=yes
OutputDir=dist\installer

; If you want to show a license, put a LICENSE.txt file next to this script and uncomment the line below.
; LicenseFile=..\LICENSE

[Files]
; Source should point to the built exe (from pyinstaller). Use backslashes (Windows)
Source: "dist\WindowsWaifuDownloader.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Windows Waifu Downloader"; Filename: "{app}\WindowsWaifuDownloader.exe"
Name: "{commondesktop}\Windows Waifu Downloader"; Filename: "{app}\WindowsWaifuDownloader.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: checkedonce

[Run]
Filename: "{app}\WindowsWaifuDownloader.exe"; Description: "Launch Windows Waifu Downloader"; Flags: nowait postinstall skipifsilent
