 ;21h的9号功能打印字符串
 .386
 data segment use16
 mesg db 'I LOVE YOU DONT U KNOW','$'
 data ends
 CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS, AX
 LAST:  MOV AH,9
        MOV DX, OFFSET MESG
        INT 21H
        MOV AH,4CH
        INT 21H;BACK TO DOS
 CODE ENDS
 END  BEG
