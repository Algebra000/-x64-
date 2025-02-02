@echo off
chcp 65001 >nul
set ori=%cd%
cd ..
echo %cd%
set LIB="%cd%\WindowsSDK64\lib"
set prt=%cd%
cd %ori%
%prt%\MASM64\ml64.exe win.asm /link /entry:main /subsystem:windows
win.exe
pause
