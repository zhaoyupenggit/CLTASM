@echo off
:: GB 2312
:: %1为选择执行命令的方式 %2为工作区根目录 %3为需要操作的文件
::输出编译信息
if "%1" == "" echo "no invar. please use ASMit.BAT <Mode> <WorkspaceRootPpath> <filepath>" && exit 4
set  bb=\ASMtools
set  cc=\ASMtools\Dosbox\
set "aa=%2%bb%"
set "dd=%2%cc%"
echo Time:%time% WorkspaceRoot:%2
echo DOSBox frome %dd% ASMtoolsfrom:%aa%
echo Mode:%1 ASMfilefrom:%3
::运行dosbox的准备工作
if not exist %aa%\test mkdir %aa%\test
cd %aa%\test
set mcd=-noautoexec -noconsole -c "mount c \"%aa%\"" -c "set path=C:\TASM;C:\masm" -c "c:" -c "cd test"
::根据%1指令执行相应调试操作
if %1==A goto dealA
if %1==B goto dealB
::进行汇编之前的准备工作，清理临时文件，写入当前文件
if %~x3==.ASM goto NEXT
if %~x3==.asm goto NEXT
echo %~x3 is not a supported assembly file
exit 1
:NEXT
if exist T.* del T.*>nul
copy %3 T.ASM>nul
::根据%1指令选择不同的编译运行操作
if %1==0 goto deal0 
if %1==1 goto deal1 
if %1==2 goto deal2 
if %1==3 goto deal3 
if %1==4 goto deal4 
if %1==5 goto deal5 
if %1==6 goto deal6 
if %1==7 goto deal7 
if %1==8 goto deal8 
echo invalid selection %1
exit 2
:deal0
    echo *Copy file to Test folder and dosbox at the folder
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%^
    -c"dir"
    exit
:deal1
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %dd%DOSBox %mcd%^
    -c "tasm/zi T.ASM>>T.txt"^
    -c "if exist T.OBJ tlink/v/3 T>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "EXIT"
    ::输出结果，在前面增加了两个空格
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.EXE echo [YOUR program] OUTPUT:
    ::TODO 显示运行结果，不知道可不可以实现同时打印行号
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    exit
:deal2
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dd%DOSBox -conf %dd%bigbox.conf %mcd% ^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"
    exit
:deal3
    echo *Output in dosbox ，press any key to exit dosbox
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"^
    -c "pause" -c "exit"
    exit
:deal4
    echo *Tasm and turbo debugger in dosbox
    cd ../tasm && copy TDCONFIG1 TDCONFIG.TD
    :: 使得td.exe 使用这个配置文件
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"^
    -c "Td t"
    exit
:deal5
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %dd%DOSBox %mcd%^
    -c "masm T.ASM;>T.txt"^
    -c "if exist T.OBJ link T.obj;>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "exit"
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.EXE echo [YOUR program] OUTPUT:
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    exit
:deal6
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dd%DOSBox -conf %dd%bigbox.conf %mcd% ^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"
    exit
:deal7
    echo *Output in dosbox ，press any key to exit dosbox
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"^
    -c "pause" -c "exit"
    exit
:deal8
    echo *Masm and debug in dosbox
    :: 使得td.exe 使用这个配置文件
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"^
    -c "debug T.EXE"
    exit
:dealA
    if  exist TD.TR echo tr exist
    if not exist T.EXE  echo no EXE file && exit 3
    echo *Turbo debugger without tasm first in dosbox
    cd ../tasm && copy TDCONFIG1 TDCONFIG.TD
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%-c "td t"
    exit
:dealB
    if not exist T.EXE  echo no EXE file && exit 3
    echo *Masm debugg without tasm first in dosbox
    %dd%DOSBox -conf %dd%bigbox.conf %mcd%-c "debug t.exe"
    exit
