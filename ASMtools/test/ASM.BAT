@echo on
if "%1"=="" goto info
:mainpart
copy T.asm TEMP.asm
del T.*
copy TEMP.asm T.asm
if %2==t goto tasm
if %2==m goto masm
:tasm
set path=%path%;c:\tasm;
if %3==r  goto tasmrun
if %3==rr goto tasmrunredirect
if %3==re goto tasmrunleave
if %3==d  goto turbodebug
if %3==ad goto tasmtd
    :tasmrun
        tasm T.asm
        if exist T.obj tlink T
        echo -----
        if exist T.exe T
        goto end
    :tasmrunredirect
        tasm T.asm>T.txt
        if exist T.obj tlink T>>T.txt
        if exist T.exe T>T.out
        goto end
    :tasmrunleave
        tasm T.asm
        if exist T.obj tlink T
        if exist T.exe T
        pause
        exit
        goto end
    :tasmtd
        c:/tasm/TDCONF1.TD
        tasm/zi T.asm
        if exist T.obj tlink/v/3 T
        if exist T.exe td T
        goto end
    :turbodebug
        copy c:\tasm\TDCONF1.TD c:\tasm\TDCONFIG.TD
        if exist T.exe td T
        goto end
:masm
set path=%path%;c:\masm
cd test
if %3==r  goto masmrun
if %3==rr goto masmrunredirct
if %3==re goto masmrunleave
if %3==d  goto mdebug
if %3==ad goto masmdebug
    :masmrun
        masm T.asm;
        if exist T.obj link T;
        echo -----
        if exist T.exe T
        goto end
    :masmrunredirct
        masm T.asm;>T.txt
        if exist T.obj link T;>>T.txt
        if exist T.exe T>T.out
        goto end
    :masmrunleave
        masm T.asm;
        if exist T.obj link T;
        if exist T.exe T
        pause
        exit
        goto end
    :masmdebug
        c:/masm/TDCONF1.TD
        masm T.asm;
        if exist T.obj link T;
        if exist T.exe debug T
        goto end
    :mdebug
        if exist T.exe debug T
        goto end






:info
echo %%1 file path %%2 %%3 %%4 choose Mode
echo %%2 m:masm t:masm
echo %%3 r:run in dosbox rl:run in dosbox and leave dosbox
echo %%3 rr:run redirect to file
echo    ad:asm and debug d:debug without asm
:end

