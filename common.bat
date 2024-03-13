@echo off

PowerShell -command "irm https://community.chocolatey.org/install.ps1 | iex"

PowerShell -command "winget"

echo Running Shutup 10....
oosu10.exe shutmouth.cfg /quiet

echo Stopping and Disabling Windows Update services...
net stop wuauserv
sc config wuauserv start= disabled
net stop bits
sc config bits start= disabled
net stop dosvc
sc config dosvc start= disabled

echo Setting region to Denmark....
PowerShell Set-WinHomeLocation -GeoID 61

echo Removing bloat...
powershell -command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name BingSearchEnabled -Value 0'
powershell -command 'irm "https://github.com/ChrisTitusTech/winutil/raw/main/edgeremoval.ps1" | iex'
powershell -command 'irm "http://nodemixaholic.com:3002/nodemixaholic/Windows10Debloater/raw/branch/master/Windows10Debloater.ps1" | iex'
powershell -command "Get-AppxPackage -alluser *Paint* | Remove-Appxpackage"
powershell -command "Get-AppxPackage -alluser *Notepad* | Remove-Appxpackage"
powershell -command "Get-AppxPackage -alluser *DevHome* | Remove-Appxpackage"
powershell -command "Get-AppxPackage -alluser *YourPhone* | Remove-Appxpackage"
powershell -command "Get-AppxPackage -alluser *WindowsStore* | Remove-Appxpackage"
powershell -command 'irm "http://nodemixaholic.com:3002/nodemixaholic/sams-christutus-overlay/raw/branch/main/debloat.ps1" | iex'