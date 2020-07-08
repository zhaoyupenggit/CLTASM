# !/bin/bash
# this is a script for use dosbox to run TASM/MASM tools
# ./asmit.sh <file> [-d <asmtools> -m <mode>]
tool="$(dirname $0)/"
db=$tool/Dosbox/
mode='1'
# check whether installed dosbox
if type dosbox
    then 
        echo !Msg:  dosbox installed
    else
        echo !Msg:  You need install dosbox first
        echo !Msg:  *Maybe You can use:sudo apt install dosbox
        exit
    fi
# check the file path installed
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
    # get the options
    echo 
    shift
    while getopts :m:d: opt
    do
        case "$opt" in
            m) mode=$OPTARG;;
            d) tool=$OPTARG
             if [ -d ${tool} ];
             then
                echo Your directory concludes
                ls ${tool}
             else
                echo invalid ${tool} not a readable directory
                exit 
                fi;;
            *) echo "unknown option: $opt";;
        esac
    done
    # output infomation
    echo !Msg:  ASMtoolsfrom:$(pwd)
    echo !Msg:  ASMfilefrom:$file
    echo !Msg:  Mode:$mode Time:$(date)
    # check the file
    if [ $mode != A ] && [ $mode != B ] 
    then
        if [ ${file##*.} != ASM ] && [ ${file##*.} != asm ];then
        echo "the ${file##*.} file may not a assembly source code file"
        echo ---
            if ! read -t 10 -p "press Y to use it as an asmfile: " selection || [ ${selection} != Y ]
            then
            echo "No \"Y\" catched back to shell"
            exit
            fi
        fi
        # copy file to test
        ls ${tool}test/ || mkdir ${tool}test && rm ${tool}test/*.*
        cp "$file" ${tool}test/T.ASM
        # echo deleted temp files 
    fi
    echo 
    pwd
    # do the operation
    cd ${tool}
    case "$mode" in
    0)
        echo !Msg:  Copy file to Test folder and dosbox at the folder
        echo "!Msg:  [dosbox] status:"
        dosbox -conf "${db}bigbox.conf" -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\masm;C:\tasm" -c "c:" -c "cd test"\
        -c "dir"
        exit;;
    1)
        echo !Msg:  Output in terminal
        echo "!Msg:  [dosbox] status:"
        dosbox -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM;C:\masm" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM>>T.TXT"\
        -c "if exist T.OBJ tlink/v/3 T>>T.TXT"\
        -c "if exist T.EXE T>T.OUT"\
        -c "exit"
        echo 
        echo "!Msg:  [dosbox] output:"
        cat test/T.TXT|tr -d '\r'|tr -s '\n'
        if [ -r test/T.OUT ];then
        echo "!Msg:  [YOUR program] OUTPUT:"
        cat test/T.OUT
        echo 
        fi
        exit;;
    2)
        echo !Msg:  Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ" -c "T.EXE"
        exit;;
    3)
        echo !Msg:  Output in dosbox ，press any key to exit dosbox
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"\
        -c "pause" -c "exit"
        exit;;
    4)
        echo !Msg:  Tasm and turbo debugger in dosbox
        cp ./TASM/TDC2.TD test/TDCONFIG.TD
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"\
        -c "Td t"
        exit;;
    5)
        echo !Msg:  Output in terminal
        echo "!Msg:  [dosbox] status:"
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;>T.txt"\
        -c "if exist T.OBJ link T.obj;>>T.txt"\
        -c "if exist T.EXE T>T.out"\
        -c "exit"
        echo 
        echo !Msg:  [dosbox] output:
        cat test/T.TXT|tr -d '\r'|tr -s '\n'
        if [ -r test/T.OUT ];then
            echo !Msg:  [YOUR program] OUTPUT:
            cat test/T.OUT
        echo 
        fi
        exit;;
    6)
        echo !Msg:  Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;" -c "link T.OBJ;" -c "T.EXE"
        exit;;
    7)
        echo !Msg:  Output in dosbox ，press any key to exit dosbox
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"\
        -c "pause" -c "exit"
        exit;;
    8)
        echo !Msg:  Masm and debug in dosbox
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf -noautoexec\
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "masm T.ASM;" -c "link T.OBJ;"\
        -c "debug T.EXE"
        exit;;
    A)
        echo !Msg:  Turbo debugger without tasm first in dosbox
        cp ./TASM/TDC2.TD test/TDCONFIG.TD
        if [ -r test/T.EXE ]
        then 
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf \
        -c "mount c \"$tool\"" -c "set path=%path%;C:\TASM" -c "c:" -c "cd test"\
        -c "td t"
        else
        echo "no T.EXE for TD"
        fi
        exit;;
    B)
        echo !Msg:  Masm debugg without tasm first in dosbox
        if [ -r test/T.EXE ]
        then
        echo "!Msg:  [dosbox] status:"
        dosbox -conf ${db}bigbox.conf \
        -c "mount c \"$tool\"" -c "set path=%path%;C:\MASM" -c "c:" -c "cd test"\
        -c "debug t.exe"
        else
        echo "no T.TXT for debug"
        fi
        exit;;
    *) echo "invalid mode";;
    esac
else
    echo invalid path $1
fi
exit