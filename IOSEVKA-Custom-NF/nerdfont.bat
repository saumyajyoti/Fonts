:: Copyright
:: Saumyajyoti Mukherjee
:: 2024


@echo off
setlocal
::  prerequisites in comments
:: tested in Windows11 setup

:: install nodejs, fontforge python 3 as mentioned in 
:: - https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md#building

SET IOSEVKA_PATH="%temp%\Iosevka"
SET "PATH=C:\Program Files (x86)\FontForgeBuilds\bin;%~dp0\..\bin;%PATH%"
SET FFPYTHON_EXE="C:\Program Files (x86)\FontForgeBuilds\bin\ffpython.exe"
SET FONTVERNUM=11
SET OUTPATH="D:\Font\Miosevka%FONTVERNUM%"
SET NERDFONT_PATCHER_PATH="%~dp0\..\bin\nerdfont\font-patcher"
SET FONTVER=Miosevka%FONTVERNUM%

rmdir /S /Q %OUTPATH%
mkdir %OUTPATH%

echo =======================================================

if exist %IOSEVKA_PATH%\ (
  echo Sync Iosevka 
  cd /d %IOSEVKA_PATH%
  rmdir /S /Q "%IOSEVKA_PATH%\dist"
  git pull --depth=1
) else (
  echo Clone Iosevka
  git clone https://github.com/be5invis/Iosevka.git %IOSEVKA_PATH% --depth=1
  cd /d %IOSEVKA_PATH%
)

call npm install
echo =======================================================
echo Build Miosevka
copy /Y %~dp0\miosevka-build-plans.toml  %IOSEVKA_PATH%\private-build-plans.toml
call npm run build -- ttf::Miosevka
echo =======================================================
echo Build Riosevka
copy /Y %~dp0\riosevka-build-plans.toml  %IOSEVKA_PATH%\private-build-plans.toml
call npm run build -- ttf::Riosevka

echo =======================================================
call :PATCH miosevka
call :PATCH riosevka

echo =======================================================
echo Copy Files
copy /Y %~dp0\..\*license.* %OUTPATH%
copy /Y "%IOSEVKA_PATH%\dist\miosevka\ttf\*.ttf" %OUTPATH%
copy /Y "%IOSEVKA_PATH%\dist\riosevka\ttf\*.ttf" %OUTPATH%

cd /d %OUTPATH%\..\

echo create %FONTVER%.zip 
tar.exe -a -c -f "%FONTVER%.zip" %OUTPATH%

REM :PROMPT
REM SET /P INSTALL=Install Fonts (yes/[no])?
REM IF /I "%INSTALL%" NEQ "yes" GOTO END

REM echo installing fonts
REM cd /d %OUTPATH%
REM start FontReg.exe /copy
REM cd ..
REM :END

explorer .
exit /b 0

::================ ROUTINE PATCH ====================
:PATCH

echo =======================================================

set fontdir="%IOSEVKA_PATH%\dist\%1\ttf"
echo patch fonts in %fontdir%
cd /d %fontdir%
:: setlocal enabledelayedexpansion
for /r %%f in (%1-*.ttf) do (
 echo "Patching: %%f"
 %FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c %%f
)
exit /b 0
::====================================================