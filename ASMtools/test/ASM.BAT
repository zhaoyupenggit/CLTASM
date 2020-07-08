@echo off
if "%1" == "" goto info
if "%1" == "/h" goto info1
if "%1" == "/hm" goto info2
if "%1" == "/m" goto Mode
:mainpart
:delpastfile
rename T.asm tempor.ary
if exist T.* del T.*
rename tempor.ary T.asm

set path=%path%c:\tasm
if "%1" == "0" goto end
if "%1" == "t" goto tasm
if "%1" == "m" goto masm
echo invalid tool %2
:tasm
    set path=%path%;c:\tasm
    if "%2" == "rr" goto trr
    if "%2" == "d" goto td
    tasm/zi T.asm
    if exist T.obj tlink/v/3 T
    if "%2" == "rd" goto td
    if exist T.exe T
    if "%2" == "r" goto end
    if "%2" == "rp" pause
    goto end
    :td
        copy c:\tasm\tdc2.td tdconfig.td
        td t
        goto end
    :trr
        tasm T.asm>T.txt
        if exist T.obj tlink T>>T.txt
        if exist T.exe T>T.out
        goto end
        
:masm
set path=%path%;c:\masm
    if "%2" == "rr" goto mrr
    if "%2" == "d" goto debug
    masm T.asm;
    if exist T.obj link T;
    if "%2" == rd goto debug
    if exist T.exe T
    if "%2" == "rp" pause
    goto end
    :debug
        debug t
        goto end
    :mrr
        tasm T.asm>T.txt
        if exist T.obj tlink T>>T.txt
        if exist T.exe T>T.out
        goto end
goto end
:Mode
    if "%2" == "0" asm 0
    if "%2" == "1" asm t rr q
    if "%2" == "2" asm t r 
    if "%2" == "3" asm t rp q
    if "%2" == "4" asm t rd q
    if "%2" == "5" asm m rr q
    if "%2" == "6" asm m r 
    if "%2" == "7" asm m rp q
    if "%2" == "8" asm m rd q
    if "%2" == "A" asm t d q
    if "%2" == "B" asm m d q
    goto end

:info
    echo "asm -m <mode> [q];           asm/hm for help"
    echo "asm t/m r/rr/rp/rd/d, asm 0; asm/h for help"
    goto end
:info1
    echo "T:use TASM M:use MASM"
    echo "  r:run in dosbox"
    echo " rr:run redirected to file"
    echo " rp:run pause exit"
    echo " rd:tasm run and td"
    echo "asm T d:TASM turbo debugger"
    echo "asm M d:MASM debug"
    echo "asm 0  :do nothing"
    goto end
:info2
    echo "0 asm 0"
    echo "1 asm t rr q"
    echo "2 asm t r "
    echo "3 asm t rp q"
    echo "4 asm t rd q"
    echo "5 asm m rr q"
    echo "6 asm m r "
    echo "7 asm m rp q"
    echo "8 asm m rd q"
    echo "A asm t d q"
    echo "B asm m d q"
    goto end
:end
if "%1" == "0" dir
if "%3" == "q" exit


