setlocal
:: TODO/prerequisites in comments
:: tested in Windows11 setup

:: install nodejs, ttfautohint, fontforge python 3 as mentioned in 
:: - https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md#building
:: - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FontPatcher.zip

:: set IOSEVKA_PATH
cd /d %IOSEVKA_PATH%
:: Copy private-build-plans.toml here
call npm run build -- ttf::iosevka-sm

SET "PATH=C:\Program Files (x86)\FontForgeBuilds\bin>;%PATH%"
:: SET OUTPATH
:: SET NERDFONT_PATCHER_PATH [ download from https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FontPatcher.zip]
cd /d %OUTPATH%
SET FFPYTHON_EXE="C:\Program Files (x86)\FontForgeBuilds\bin\ffpython.exe"
%FFPYTHON_EXE% "%NERDFONT_PATCHER_PATH%\font-patcher" -c --careful "%OUTPATH%\iosevka-sm-regular.ttf"
%FFPYTHON_EXE% "%NERDFONT_PATCHER_PATH%\font-patcher" -c --careful "%OUTPATH%\iosevka-sm-bolditalic.ttf"
%FFPYTHON_EXE% "%NERDFONT_PATCHER_PATH%\font-patcher" -c --careful "%OUTPATH%\iosevka-sm-italic.ttf"
%FFPYTHON_EXE% "%NERDFONT_PATCHER_PATH%\font-patcher" -c --careful "%OUTPATH%\iosevka-sm-bold.ttf"
%FFPYTHON_EXE% "%NERDFONT_PATCHER_PATH%\font-patcher" -c --careful "%OUTPATH%\iosevka-sm-semibold.ttf"
%FFPYTHON_EXE% "%NERDFONT_PATCHER_PATH%\font-patcher" -c --careful "%OUTPATH%\iosevka-sm-semibolditalic.ttf"
