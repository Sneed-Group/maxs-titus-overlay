@echo off
cd /D "%~dp0"
color 0a
title [Laptop] Sams Chris Titus Overlay

echo Installing apps fron winget config file....
wingetl.bat


echo Stopping and Disabling Windows Update services...
net stop wuauserv
sc config wuauserv start= disabled
net stop bits
sc config bits start= disabled
net stop dosvc
sc config dosvc start= disabled

echo Setting region to Denmark....
PowerShell Set-WinHomeLocation -GeoID 61

common.bat

echo Done.
pause