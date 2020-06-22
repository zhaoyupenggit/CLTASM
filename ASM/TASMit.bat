@echo off
REM %1为选择执行命令的方式 %2为工作区根目录 %3为需要操作的文件
set  bb=\ASM\TASM
set  cc=\ASM\Dosbox\
set "aa=%2%bb%"
set "dd=%2%cc%"

echo workspaceRoot:%2
echo ASMfilefrom:%3
echo ASMtoolsfrom:%aa%
cd %aa%
if %1==4 goto D
if exist T.* del T.*>nul
copy %3 T.ASM>nul
if %1==0 goto deal0 REM 在终端中输出结果，code runner没有设置在终端中运行的话会在输出中输出结果
if %1==1 goto deal1 REM 在dosbox中汇编链接运行
if %1==3 goto deal3 REM 在dosbox中汇编链接调试
if %1==2 goto deal2 REM 在dosbox中运行程序，按任意键结束关闭dosbox，对于一些会检测键盘状态的程序，比如chapter 4/OC.asm会自动关闭
if %1==5 goto deal5 REM 将文件复制到TASM文件夹中，dosbox打开该文件夹
if %1==6 goto deal6 %3 REM 使用dosbox打开当前文件所在文件夹
:deal0
    echo output in terminal
    echo DOSBOX OUTPUT:
    REM -conf %dd%minbox.conf
    %dd%DOSBox -noconsole^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/t/zi T.ASM>T.txt" ^
    -c "if exist T.OBJ tlink/v/3 T>>T.txt"^
    -c "echo ----->>T.txt"^
    -c "if exist T.EXE T>>T.txt"^
    -c "EXIT"
    echo.>>T.txt
    type T.txt
    exit
:deal1
    echo output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"
    exit
:deal2
    echo output in dosbox ，press any key to exit dosbox
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf  ^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"^
    -c "pause" -c "exit"
    exit
:deal3
    echo tasm and turbo debugger in dosbox
    copy TDCONFIG1 TDCONFIG.TD
    REM 使得td.exe 使用这个配置文件
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"^
    -c "Td t"
    exit

:deal5
    echo copy file to TASM folder and dosbox at the folder
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount c %aa%" -c "c:" -c"dir"
    exit
:deal6
    echo dosbox here with tasm added to path
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount d %aa%" -c "set path=D:"^
    -c "mount c '%~d3%~p3'" -c "c:" -c "dir"
    exit
)^
exit
:D
if exist TD.TR echo tr exist
    echo turbo debugger without tasm first in dosbox
    copy TDCONFIG1 TDCONFIG.TD
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf^
    -c "mount c %aa%" -c "c:" -c "td t"
echo ---end---
exit