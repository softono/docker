@echo off
set FOLDER_NAME=%1

if "%FOLDER_NAME%"=="" (
    echo Usage: setup.bat ^<folder_name^>
    exit /b 1
)

powershell.exe -ExecutionPolicy Bypass -File "%~dp0setup.ps1" "%FOLDER_NAME%"
