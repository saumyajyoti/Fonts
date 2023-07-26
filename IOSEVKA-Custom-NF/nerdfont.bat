setlocal
:: TODO/prerequisites in comments
:: tested in Windows11 setup

:: install nodejs, ttfautohint, fontforge python 3 as mentioned in 
:: - https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md#building
:: - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FontPatcher.zip

set IOSEVKA_PATH="D:\SOURCE\github\Iosevka"
cd /d %IOSEVKA_PATH%
rmdir /S /Q "%IOSEVKA_PATH%\dist"
:: Copy private-build-plans.toml here
call npm run build -- ttf::miosevka

SET "PATH=C:\Program Files (x86)\FontForgeBuilds\bin>;%PATH%"
SET FFPYTHON_EXE="C:\Program Files (x86)\FontForgeBuilds\bin\ffpython.exe"
SET OUTPATH="D:\Font\Miosevka4"
:: SET NERDFONT_PATCHER_PATH [ download from https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FontPatcher.zip]
cd /d %OUTPATH%
SET NERDFONT_PATCHER_PATH="D:\SETUP.tmp\nerdfont\font-patcher"

%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-regular.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-italic.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-bold.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-boldItalic.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-semibold.ttf"
%FFPYTHON_EXE% %NERDFONT_PATCHER_PATH% -c -l "%IOSEVKA_PATH%\dist\miosevka\ttf\miosevka-semiboldItalic.ttf"
