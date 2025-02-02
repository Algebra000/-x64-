@echo off
chcp 65001 >nul
set  LIB="%cd%\WindowsSDK64\lib"
set /p inputfile=输入汇编源文件：
%cd%\MASM64\ml64.exe %inputfile% /link /entry:main /subsystem:windows
pause