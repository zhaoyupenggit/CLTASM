;exp1.2 bookexp2.09
.586
DATA SEGMENT USE16
BUF    DB 42H,45H,44H,24H,'sadfsadf',43H,66
		 ;DB '1234LZXCVBNM'
L      EQU $-BUF
STRING  DB ' COUNT Characters BETWEEN 42H and 45H: ',0DH,0AH,' answer='
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
		MOV DL,BYTE PTR [BX]
		MOV BYTE PTR DS:[BP],DL
        INC BP
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
  BBEG: SUB BP,OFFSET RESULT
		MOV BX,BP
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