;修改后的代码1
;脚痛剁脚修改法
;file name EXA1311.ASM
.386
DATA SEGMENT USE16
MESG DB '25+9='
     DB 0,0
     DB '$'
  N1 DB 9;err
  N2 DB 25
DATA ENDS

CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS,AX
        MOV BX,OFFSET MESG
        MOV AH,N1
        MOV AL,N2;
        ADD AH,AL ;
        CALL CHANG
        MOV AH,9
        MOV DX, OFFSET MESG;ERRname
        INT 21H
        MOV AH,4CH
        INT 21H
 ;------------------------------------------
 CHANG PROC
 LAST:  CMP AH,10
        JC  NEXT
        SUB AH,10
        INC  byte ptr[BX+5]
        JMP  LAST
 NEXT:
		MOV DX, OFFSET MESG
        ADD [BX+6],AH
        ADD byte ptr[BX+5],30H
        ADD byte ptr[BX+6],30H
        RET
   CHANG ENDP
        CODE ENDS
   END BEG

