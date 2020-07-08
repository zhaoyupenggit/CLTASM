@echo off
:: GB 2312
:: %1为需要操作的文件 %2为选择执行命令的方式 %3为汇编工具和dosbox所在文件夹 
::输出编译信息
if "%~f1" NEQ "" goto SetValues
    echo "asmit.bat <file> [<mode>] [<toolsdir>]"
    echo "<file> file to be used "
    echo "<mode> choose mode the way display default is 1"
    echo "0 copy the files open dosbox add path"
    echo "1 tasm run output in shell"
    echo "2 tasm run output in dosbox"
    echo "3 tasm run pause exit"
    echo "4 tasm run and td"
    echo "5 masm run ouput in shell"
    echo "6 masm run output in dosbox"
    echo "7 masm run pause exit"
    echo "8 masm and debug"
    echo "A open turbo debugger at test folder"
    echo "B open masm debug at test folder"
    echo "<toolsdir> the tools folder with subdir masm,tasm,test"
    goto end
:SetValues
set "cdo=%CD%"
set "file=%~f1"
set "mode=1"
set "tool=%~dp0"
    :: 运行中产生的文件存放的位置**可自行修改**
    set "test=%tool%test\"
    if not exist %test% mkdir %test%
    ::dosbox使用的提高resolution的配置文件
    set "bigboxconf=%tool%dosbox\bigbox.conf" 
    ::TASM调试工具TD的配置文件
    set "TDconfig=%tool%tasm\TDC2.td"
    ::dosbox路径及需要先使用的一些配置
    set "dosbox=%tool%dosbox\DOSBox.exe"
    set mcd=-noautoexec -noconsole ^
    -c "mount c \"%tool%\"" -c "mount d \"%test%\"" ^
    -c "set path=C:\TASM;C:\masm" -c "d:"
        ::根据输入调整变量
        if "%2" neq "" set "mode=%2"
        if "%3" neq "" set "tool=%~f3"

:OutputInfo
    echo Time:%time%
    echo ASMtoolsfrom:%tool%
    echo Mode:%mode% ASMfilefrom:%file%
::运行dosbox的准备工作
cd %test%
echo =========
    :ModeSelect
        if %mode%==A goto dealA
        if %mode%==B goto dealB
    ::进行汇编之前的准备工作，清理临时文件，写入当前文件
    if "%~x1"==".ASM" goto NEXT
    if "%~x1"==".asm" goto NEXT
    echo %~x1 is not a supported assembly file
    goto end
    :NEXT
        if not exist "%file%" echo no such file && goto end
        if exist T.* del T.*
        copy "%file%" T.ASM
        if "%mode%"=="0" goto deal0 
        if "%mode%"=="1" goto deal1 
        if "%mode%"=="2" goto deal2 
        if "%mode%"=="3" goto deal3 
        if "%mode%"=="4" goto deal4 
        if "%mode%"=="5" goto deal5 
        if "%mode%"=="6" goto deal6 
        if "%mode%"=="7" goto deal7 
        if "%mode%"=="8" goto deal8 
    echo invalid mode %mode%
    goto end

:deal0
    echo *Copy file to Test folder and dosbox at the folder
    %dosbox% %mcd% -conf %bigboxconf%^
    -c "dir"
    goto end
:deal1
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %dosbox% %mcd% ^
    -c "tasm/zi T.ASM>>T.txt"^
    -c "if exist T.OBJ tlink/v/3 T>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "EXIT"
    ::输出结果，在前面增加了两个空格
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.OUT echo [YOUR program] OUTPUT:
    ::TODO 显示运行结果，不知道可不可以实现同时打印行号
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    goto end
:deal2
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd% ^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"
    goto end
:deal3
    echo *Output in dosbox ，press any key to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"^
    -c "pause" -c "exit"
    goto end
:deal4
    echo *Tasm and turbo debugger in dosbox
    if exist "%TDconfig%" copy "%TDconfig%" TDCONFIG.TD
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"^
    -c "Td t"
    goto end
:deal5
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %dosbox% %mcd%^
    -c "masm T.ASM;>T.txt"^
    -c "if exist T.OBJ link T.obj;>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "exit"
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.OUT echo [YOUR program] OUTPUT:
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    goto end
:deal6
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd% ^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"
    goto end
:deal7
    echo *Output in dosbox ，press any key to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"^
    -c "pause" -c "exit"
    goto end
:deal8
    echo *Masm and debug in dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"^
    -c "debug T.EXE"
    goto end
:dealA
    if not exist T.EXE  echo no EXE file && goto end
    echo *Turbo debugger without tasm first in dosbox
    if exist "%TDconfig%" copy "%TDconfig%" TDCONFIG.TD
    %dosbox% -conf "%bigboxconf%" %mcd%-c "td t"
    goto end
:dealB
    if not exist T.EXE  echo no EXE file && goto end
    echo *Masm debugg without tasm first in dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%-c "debug t.exe"
    goto end
:end
cd %cdo%