@echo off
setlocal EnableExtensions

cd /d "%~dp0"
set "SOURCE_EXE=%~dp0AdaptiveRamOptimizer.exe"
if not exist "%SOURCE_EXE%" set "SOURCE_EXE=%~dp0dist\AdaptiveRamOptimizer.exe"

if not exist "%SOURCE_EXE%" (
    echo AdaptiveRamOptimizer.exe was not found.
    echo Keep the EXE next to setup.bat or inside the dist folder.
    echo If you downloaded a source archive, build the EXE first with build_exe.bat.
    pause
    exit /b 1
)

set "INSTALL_DIR=%LOCALAPPDATA%\AdaptiveRamOptimizer"
set "TARGET_EXE=%INSTALL_DIR%\AdaptiveRamOptimizer.exe"
set "START_MENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Adaptive RAM Optimizer"
set "DESKTOP_LINK=%USERPROFILE%\Desktop\Adaptive RAM Optimizer.lnk"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if errorlevel 1 (
    echo Could not create the application folder:
    echo %INSTALL_DIR%
    pause
    exit /b 1
)

copy /Y "%SOURCE_EXE%" "%TARGET_EXE%" >nul
if errorlevel 1 (
    echo Could not copy the application. Check file permissions and try again.
    pause
    exit /b 1
)

if not exist "%START_MENU_DIR%" mkdir "%START_MENU_DIR%"
if errorlevel 1 (
    echo Application installed, but the Start Menu shortcut could not be created.
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut($env:START_MENU_DIR + '\Adaptive RAM Optimizer.lnk'); $shortcut.TargetPath = $env:TARGET_EXE; $shortcut.WorkingDirectory = $env:INSTALL_DIR; $shortcut.IconLocation = $env:TARGET_EXE; $shortcut.Save()"
    if errorlevel 1 echo Start Menu shortcut creation failed.
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut($env:DESKTOP_LINK); $shortcut.TargetPath = $env:TARGET_EXE; $shortcut.WorkingDirectory = $env:INSTALL_DIR; $shortcut.IconLocation = $env:TARGET_EXE; $shortcut.Save()"
if errorlevel 1 echo Desktop shortcut creation failed.

echo.
echo Adaptive RAM Optimizer was installed successfully.
echo Installed file: %TARGET_EXE%
echo A Start Menu and desktop shortcut were created.
echo.
start "" "%TARGET_EXE%"
endlocal
