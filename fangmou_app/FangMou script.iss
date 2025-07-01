[Setup]
AppName=fangmou_app
AppVersion=1.0.0
DefaultDirName={pf}\fangmou_app
OutputDir=.\Output
OutputBaseFilename=fangmou_app_Installer
Compression=lzma

[Files]
Source: "D:\desktop\fangmou_app\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{commonprograms}\fangmou_app"; Filename: "{app}\fangmou_app.exe"