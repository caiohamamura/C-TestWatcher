@echo off
IF NOT DEFINED VSINSTALLDIR (
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
) 
powershell "watchTest.ps1" %1