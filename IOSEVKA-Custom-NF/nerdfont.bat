setlocal
:: TODO/prerequisites in comments
:: tested in Windows11 setup

:: install nodejs, ttfautohint, fontforge python 3 as mentioned in 
:: - https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md#building
:: - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FontPatcher.zip

set IOSEVKA_PATH="D:\SOURCE\github\Iosevka"
cd /d %IOSEVKA_PATH%
rmdir /S /Q "%IOSEVKA_PATH%\dist"
git pull --depth=1
copy /Y %~dp0\private-build-plans.toml %IOSEVKA_PATH%
:: Copy private-build-plans.toml here
call npm install
call npm run build -- ttf::miosevka

SET "PATH=C:\Program Files (x86)\FontForgeBuilds\bin>;%PATH%"
SET FFPYTHON_EXE="C:\Program Files (x86)\FontForgeBuilds\bin\ffpython.exe"
SET FONTVER=Miosevka5
SET OUTPATH="D:\Font\%FONTVER%"
:: SET NERDFONT_PATCHER_PATH [ download from https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FontPatcher.zip]
mkdir %OUTPATH%
cd /d %OUTPATH%
SET NERDFONT_PATCHER_PATH="D:\SETUP.tmp\nerdfont\font-patcher"

%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-regular.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-italic.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-bold.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-boldItalic.ttf"

copy /Y %~dp0\license.* %OUTPATH%
copy /Y "%IOSEVKA_PATH%\dist\miosevka\ttf\*.ttf" %OUTPATH%
cd ..
 
tar.exe -a -c -f "%FONTVER%.zip" %OUTPATH%

explorer .
