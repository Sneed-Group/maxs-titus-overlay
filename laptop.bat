@echo off
cd /D "%~dp0"
color 0a
title [Laptop] Sams Chris Titus Overlay

echo Installing apps fron winget config file....
wingetl.bat

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

echo Removing stuff CTT Utility missed....
Get-AppxPackage -alluser *Paint* | Remove-Appxpackage
Get-AppxPackage -alluser *Notepad* | Remove-Appxpackage
Get-AppxPackage -alluser *DevHome* | Remove-Appxpackage
Get-AppxPackage -alluser *YourPhone* | Remove-Appxpackage
Get-AppxPackage -alluser *WindowsStore* | Remove-Appxpackage

echo Done.
pause