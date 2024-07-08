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
SET FONTVERNUM=10
SET OUTPATH="D:\Font\Miosevka%FONTVERNUM%"
SET NERDFONT_PATCHER_PATH="%~dp0\..\bin\nerdfont\font-patcher"
SET FONTVER=Miosevka%FONTVERNUM%
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

mkdir %OUTPATH%
cd /d %OUTPATH%
echo =======================================================
echo patch fonts
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-regular.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-italic.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-bold.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-boldItalic.ttf"

%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\riosevka\ttf\riosevka-regular.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\riosevka\ttf\riosevka-italic.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\riosevka\ttf\riosevka-bold.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c "%IOSEVKA_PATH%\dist\riosevka\ttf\riosevka-boldItalic.ttf"
echo =======================================================
echo Copy Files
copy /Y %~dp0\..\*license.* %OUTPATH%
copy /Y "%IOSEVKA_PATH%\dist\miosevka\ttf\*.ttf" %OUTPATH%
copy /Y "%IOSEVKA_PATH%\dist\riosevka\ttf\*.ttf" %OUTPATH%
cd ..
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
