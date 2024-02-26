@echo off
cd /D "%~dp0"

echo Installing apps fron winget config file....
wingetd.bat

echo Running Shutup 10....
oosu10.exe shutmouth.cfg /quiet

echo Stopping and Disabling Windows Update services...
net stop wuauserv
sc config wuauserv start= disabled
net stop bits
sc config bits start= disabled
net stop dosvc
sc config dosvc start= disabled

echo Setting region to world....
PowerShell Set-WinHomeLocation -GeoID 39070
reg import set-to-world.reg

echo Removing stuff CTT Utility missed....
Get-AppxPackage -alluser *Paint* | Remove-Appxpackage
Get-AppxPackage -alluser *Notepad* | Remove-Appxpackage
Get-AppxPackage -alluser *DevHome* | Remove-Appxpackage
Get-AppxPackage -alluser *YourPhone* | Remove-Appxpackage
Get-AppxPackage -alluser *WindowsStore* | Remove-Appxpackage

echo Done.
pause