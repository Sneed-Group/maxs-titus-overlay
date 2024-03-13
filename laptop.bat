@echo off
cd /D "%~dp0"
color 0a
title [Laptop] Sams Chris Titus Overlay

echo Installing apps fron winget config file....
wingetl.bat

powershell -command "irm | 'http://nodemixaholic.com:3002/nodemixaholic/sams-christutus-overlay/raw/branch/main/common-stream.ps1' iex"
echo Done.
pause