;二进制的方式打印寄存器值print the binary of the number in BX
;from the ppt chapter 4 Page 58
;简单分支的应用
.386
CODE SEGMENT USE16
        ASSUME CS:CODE
 BEG:   MOV BX,0003H;
        MOV CX,16
 LAST:  MOV AL,'0';'0'=30H
        ROL BX,1;其他方式也可
        JNC NEXT
        MOV AL,'1';‘1’ =31H
 NEXT:  MOV AH,0EH
        INT 10H
        LOOP LAST
        MOV AH,4CH
        INT 21H
    CODE ENDS
 END BEG
