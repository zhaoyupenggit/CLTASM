@echo off
:: GB 2312
:: %1为需要操作的文件 %2为选择执行命令的方式 %3为汇编工具和dosbox所在文件夹 
::输出编译信息
set "cdo=%CD%"
if '%1' == '' echo "no input please use ASMit.BAT <filepath> <Mode> <ASMtoolspath> " && goto end
set "file=%~f1"
set "mode=1"
set "tool=%~dp0"
if "%2" neq "" set "mode=%2"
if "%3" neq "" set "tool=%~f3"
set "db=..\dosbox\"
echo Time:%time%
echo ASMtoolsfrom:%tool%
echo Mode:%mode% ASMfilefrom:%file%
::运行dosbox的准备工作
cd %tool%
::到文件所在盘中，注意没有冒号
%~d0 
echo =========
if not exist test mkdir test
cd test
set mcd=-noautoexec -noconsole -c "mount c \"%tool%\"" -c "set path=C:\TASM;C:\masm" -c "c:" -c "cd test"
::根据%mode%指令执行相应调试操作
if %mode%==A goto dealA
if %mode%==B goto dealB
::进行汇编之前的准备工作，清理临时文件，写入当前文件
if %~x1==.ASM goto NEXT
if %~x1==.asm goto NEXT
echo %~x1 is not a supported assembly file
goto end
:NEXT
if not exist "%file%" echo no such file &&goto end
if exist T.* del T.*>nul
copy "%file%" T.ASM>nul
::根据%mode%指令选择不同的编译运行操作
if %mode%==0 goto deal0 
if %mode%==1 goto deal1 
if %mode%==2 goto deal2 
if %mode%==3 goto deal3 
if %mode%==4 goto deal4 
if %mode%==5 goto deal5 
if %mode%==6 goto deal6 
if %mode%==7 goto deal7 
if %mode%==8 goto deal8 
echo invalid selection %mode%
goto end
:deal0
    echo *Copy file to Test folder and dosbox at the folder
    %db%DOSBox -conf %db%bigbox.conf %mcd%^
    -c"dir"
    goto end
:deal1
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %db%DOSBox %mcd%^
    -c "tasm/zi T.ASM>>T.txt"^
    -c "if exist T.OBJ tlink/v/3 T>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "EXIT"
    ::输出结果，在前面增加了两个空格
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.EXE echo [YOUR program] OUTPUT:
    ::TODO 显示运行结果，不知道可不可以实现同时打印行号
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    goto end
:deal2
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %db%DOSBox -conf %db%bigbox.conf %mcd% ^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"
    goto end
:deal3
    echo *Output in dosbox ，press any key to exit dosbox
    %db%DOSBox -conf %db%bigbox.conf %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"^
    -c "pause" -c "exit"
    goto end
:deal4
    echo *Tasm and turbo debugger in dosbox
    copy ..\tasm\TDC2.td TDCONFIG.TD
    :: 使得td.exe 使用这个配置文件
    %db%DOSBox -conf %db%bigbox.conf %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"^
    -c "Td t"
    goto end
:deal5
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %db%DOSBox %mcd%^
    -c "masm T.ASM;>T.txt"^
    -c "if exist T.OBJ link T.obj;>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "exit"
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.EXE echo [YOUR program] OUTPUT:
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    goto end
:deal6
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %db%DOSBox -conf %db%bigbox.conf %mcd% ^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"
    goto end
:deal7
    echo *Output in dosbox ，press any key to exit dosbox
    %db%DOSBox -conf %db%bigbox.conf %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"^
    -c "pause" -c "exit"
    goto end
:deal8
    echo *Masm and debug in dosbox
    :: 使得td.exe 使用这个配置文件
    %db%DOSBox -conf %db%bigbox.conf %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"^
    -c "debug T.EXE"
    goto end
:dealA
    if  exist TD.TR echo tr exist
    if not exist T.EXE  echo no EXE file && exit 3
    echo *Turbo debugger without tasm first in dosbox
    copy ..\tasm\TDC2.td TDCONFIG.TD
    %db%DOSBox -conf %db%bigbox.conf %mcd%-c "td t"
    goto end
:dealB
    if not exist T.EXE  echo no EXE file && exit 3
    echo *Masm debugg without tasm first in dosbox
    %db%DOSBox -conf %db%bigbox.conf %mcd%-c "debug t.exe"
    goto end
:end
cd %cdo%
echo %cdo%