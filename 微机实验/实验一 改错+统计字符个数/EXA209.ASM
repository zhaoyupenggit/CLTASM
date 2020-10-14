;exp1.2 bookexp2.09
; 从BUF单元开始存有一-字符串(长度<255)，
; 编程实现统计该串字符中的ASCII码在42H~45H之间的字符个数，
; 并将统计结果以一进制形式显示在屏幕上。
.386
DATA SEGMENT USE16
BUF    DB 'ABCD'
L      EQU $-BUF
STRING  DB 'COUNT Characters BETWEEN 42H and 45H: ',0DH,0AH,'answer='
ANSWER  DB 8 DUP(?),'B$'
RESULT  DB L DUP(?)
DATA ENDS

CODE  SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS,AX
       LEA BP,RESULT
        LEA BX,BUF
        MOV CX,L
 LAST:  CMP BYTE PTR[BX],45H;maximum
        JA NEXT
        CMP BYTE PTR[BX],42H;minimum
        JC NEXT
        INC SI;遍历到符合要求的数据就计数加一
 NEXT:  INC BX;
       LOOP LAST
       CALL BINA
        LEA DX,STRING
        MOV AH,09H
        INT 21H
        MOV AH,4CH
        INT 21H
;---------------子程序---------------
BINA PROC
  BBEG: MOV BX,SI
        MOV CX,8
        LEA DI,ANSWER
  BLAS: MOV AL,'0'
        ROL BL,1
        JNC BNEX
        MOV AL,'1'
  BNEX: MOV DS:[DI],AL
        INC DI
       LOOP BLAS
RET
BINA ENDP
CODE ENDS
        END BEG