@echo off
cd /D "%~dp0"
color 0a
title [Desktop] Sams Chris Titus Overlay

echo Doing common stuff...
common.bat

echo Installing apps fron winget config file....
wingetd.bat

echo Done.
pause