;模8加法
;比较直观地显示计算机中的加法
;TODO:如果能将标志位的信息也打印出来就好了
.386
CODE SEGMENT USE16
ASSUME CS:CODE
MESG DB 'CF=0,OF=0'
BEG:MOV BL,-110;被加数
    MOV DH,BL
    CALL DISPBIN;打印被加数的补码
    MOV DH,-70;加数
    MOV DL,'+'
    MOV AH,2
    INT 21H
    CALL DISPBIN;打印加数的补码
    MOV DL,'='
    MOV AH,2
    INT 21H
    ADD DH,BL
    CALL DISPBIN;打印计算机的计算结果
    MOV AH,4CH
    INT 21H

DISPBIN PROC
    MOV CX,8
    MOV BH,DH
START:  MOV DL,0
        ROL DX,1
        ADD DL,30H
        MOV AH,2
        INT 21H
        MOV DL,0
        LOOP START
        MOV DL,'B'
        MOV AH,2
        INT 21H
        MOV DH,BH
    RET
DISPBIN ENDP
CODE ENDS
END BEG