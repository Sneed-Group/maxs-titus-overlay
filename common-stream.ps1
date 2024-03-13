irm https://community.chocolatey.org/install.ps1 | iex

echo Stopping and Disabling Windows Update services...
Stop-Service -Name wuauserv
Set-Service -Name wuauserv -StartupType Disabled
Stop-Service -Name bits
Set-Service -Name bits -StartupType Disabled
Stop-Service -Name dosvc
Set-Service -Name dosvc -StartupType Disabled

echo installing winget....
$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

echo Setting region to Denmark....
Set-WinHomeLocation -GeoID 61

echo Removing bloat...
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name BingSearchEnabled -Value 0
irm "https://github.com/ChrisTitusTech/winutil/raw/main/edgeremoval.ps1" | iex
powershell -command 'irm "http://nodemixaholic.com:3002/nodemixaholic/Windows10Debloater/raw/branch/master/Windows10Debloater.ps1" | iex
Get-AppxPackage -alluser *Paint* | Remove-Appxpackage
Get-AppxPackage -alluser *Notepad* | Remove-Appxpackage
Get-AppxPackage -alluser *DevHome* | Remove-Appxpackage
et-AppxPackage -alluser *YourPhone* | Remove-Appxpackage
Get-AppxPackage -alluser *WindowsStore* | Remove-Appxpackage
irm "http://nodemixaholic.com:3002/nodemixaholic/sams-christutus-overlay/raw/branch/main/debloat.ps1" | iex

Invoke-WebRequest -Uri "http://nodemixaholic.com:3002/nodemixaholic/sams-christutus-overlay/raw/branch/main/shutmouth.cfg" -OutFile "shutmouth.cfg"
Invoke-WebRequest -Uri "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -OutFile "oosu10.exe"
irm "http://nodemixaholic.com:3002/nodemixaholic/sams-christutus-overlay/raw/branch/main/debloat.ps1" | iex
./oosu10.exe shutmouth.cfg /quiet