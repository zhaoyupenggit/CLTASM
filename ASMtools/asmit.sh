# !/bin/bash
# this is a script for use dosbox to run TASM/MASM tools
# ./asmit.sh <file> [-d <asmtools> -m <mode>]
tool='./'
dd=./Dosbox/
mode='1'
# check whether installed dosbox
if type dosbox
    then
        echo dosbox installed
    else
        echo You need install dosbox first
        echo Maybe U can use:sudo apt install dosbox
        exit
    fi
# check the file path installed
echo --$1--
if [ -z "$1" ]
then
    echo "./asmit.sh <file> [-d <asmtools> -m <mode>]"
    echo "./asmit.sh -h for help"
    exit
# display the help
elif [ "$1" = "-h" ]
then
    echo './asmit.sh <file> [-d <asmtools> -m <mode>]'
    echo '<file> file to be used '
    echo '<mode> choose mode the way display default is 1'
    echo '0 copy the files open dosbox add path'
    echo '1 tasm run output in shell'
    echo '2 tasm run output in dosbox'
    echo '3 tasm run pause exit'
    echo '4 tasm run and td'
    echo '5 masm run ouput in shell'
    echo '6 masm run output in dosbox'
    echo '7 masm run pause exit'
    echo '8 masm and debug'
    echo 'A open turbo debugger at test folder'
    echo 'B open masm debug at test folder'
    echo '<rootdir> the tools folder with subdir masm,tasm,test'
# make sure the file readable and is a ASM file
elif [ -r "$1" ]
then
    file=$1
    if [ ${file##*.} != ASM ] && [ ${file##*.} != asm ];then
    echo "the ${file##*.} file may not a assembly source code file"
    echo 
        if ! read -t 10 -p "press Y to use it as an asmfile: " selection || [ ${selection} != Y ]
        then
        echo "No \"Y\" catched back to shell"
        exit
        fi
    fi
    echo "run the script"
    shift
    while getopts :m:d: opt
    do
        case "$opt" in
            m) mode=$OPTARG;;
            d) tool=$OPTARG;;
            *) echo "unknown option: $opt";;
        esac
    done
    cd $tool
    echo Mode:$mode Time:$(date)
    echo ASMtoolsfrom:$(pwd)
    echo ASMfilefrom:$file
    if [ $mode!=A ] && [ $mode!=B ]
    then
    ls test/ || mkdir test && rm test/*.*
    cp "$file" test/T.ASM
    fi
    case "$mode" in
    0)
        echo *Copy file to Test folder and dosbox at the folder
        dosbox -conf "${dd}bigbox.conf" -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\masm;C:\tasm" -c "c:" -c "cd test"\
        -c "dir"
        exit;;
    1)
        echo *Output in terminal
        echo [dosbox] OUTPUT:
        dosbox -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM;C:\masm" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM>>T.TXT"\
        -c "if exist T.OBJ tlink/v/3 T>>T.TXT"\
        -c "if exist T.EXE T>T.OUT"\
        -c "exit"
        cat test/T.TXT
        if [ -r test/T.OUT ];then
        echo [YOUR program] OUTPUT:
        cat test/T.OUT
        fi
        exit;;
    2)
        echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ" -c "T.EXE"
        exit;;
    3)
        echo *Output in dosbox ，press any key to exit dosbox
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"\
        -c "pause" -c "exit"
        exit;;
    4)
        echo *Tasm and turbo debugger in dosbox
        cp ./TASM/TDC2.TD test/TDCONFIG.TD
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"\
        -c "Td t"
        exit;;
    5)
        echo *Output in terminal
        echo [dosbox] OUTPUT:
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;>T.txt"\
        -c "if exist T.OBJ link T.obj;>>T.txt"\
        -c "if exist T.EXE T>T.out"\
        -c "exit"
        cat test/T.TXT
        echo [YOUR program] OUTPUT:
        cat test/T.OUT
        exit;;
    6)
        echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;" -c "link T.OBJ;" -c "T.EXE"
        exit;;
    7)
        echo *Output in dosbox ，press any key to exit dosbox
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"\
        -c "pause" -c "exit"
        exit;;
    8)
        echo *Masm and debug in dosbox
        dosbox -conf ${dd}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;" -c "link T.OBJ;"\
        -c "debug T.EXE"
        exit;;
    A)
        echo *Turbo debugger without tasm first in dosbox
        cp ./TASM/TDC2.TD test/TDCONFIG.TD
        dosbox -conf ${dd}bigbox.conf \
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "td t"
        exit;;
    B)
        echo *Masm debugg without tasm first in dosbox
        dosbox -conf ${dd}bigbox.conf \
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "debug t.exe"
        exit;;
    *) echo "invalid mode";;
    esac
else
    echo invalid path $1
fi
exit