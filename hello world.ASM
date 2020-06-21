 ;hello world 程序
 .586
 data segment use16
 mesg db 'hello world','$'
 data ends
 CODE SEGMENT USE16
 ASSUME CS:CODE,DS:DATA
 BEG:MOV AX,DATA
     MOV DS, AX
 LAST:MOV AH,9
 MOV DX, OFFSET MESG
 INT 21H
 MOV AH,4CH
 INT 21H;BACK TO DOS
 CODE ENDS
 END  BEG
