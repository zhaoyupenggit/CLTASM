;修改后的代码2
;EXA1312.ASM
.386
DATA SEGMENT USE16		;关键字segme nt 去除多余的空格
SUM  DB ?,?			;去除多余的逗号
MESG DB '25+9='
     DB 0,0,0AH,0DH,'$'	;打印字符串的结束标记
  N1 DB 9,0FH			;修改错误的数据，十六进制数以字母开头的需要在前面添加0，这里该数据多余
  N2 Dw 25				;这里实际上不需要使用DW ，DB即可
DATA ENDS

CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS,AX
        MOV BX,OFFSET SUM
        MOV AH,N1
        MOV AL,BYTE PTR N2;这里两操作数类型不同，需要使用ptr修改
        ADD AH,AL ;
        MOV [BX],AH;
        CALL CHANG
        MOV AH,9
        MOV DX, OFFSET MESG
        INT 21H
        MOV AH,4CH
        INT 21H
 ;------------------------------------------
 CHANG PROC
 LAST:  CMP BYTE PTR [BX],10;两操作数类型都没有确定需要ptr规定
        JC  NEXT
        SUB BYTE PTR [BX],10
        INC BYTE PTR [BX+7]
        JMP  LAST
 NEXT:  MOV AL,SUM
		ADD [BX+8],AL;这里不可以直接操作
        ADD BYTE PTR[BX+7],30H
        ADD BYTE PTR[BX+8],30H
        RET
 CHANG ENDP
 
        CODE ENDS
   END BEG
