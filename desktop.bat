@echo off
cd /D "%~dp0"
color 0a
title [Desktop] Sams Chris Titus Overlay

echo Doing common stuff...
powershell -command "irm 'http://nodemixaholic.com:3002/nodemixaholic/sams-christutus-overlay/raw/branch/main/common-stream.ps1' | iex"

echo Installing apps fron winget config file....
wingetd.bat

echo Done.
pause