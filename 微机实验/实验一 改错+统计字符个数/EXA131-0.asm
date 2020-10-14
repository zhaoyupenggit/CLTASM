;排除语法错误。
; 下面给出的是一个通过比较法完成8位二进制数转换成十进制数送屏幕显示功能
; 的汇编语言源程序,但有很多语法错误。要求实验者按照原样对源程序进行编辑，
; 汇编后，根据MASM给出的错误信息对源程序进行修改，直到没有语法错误为止。
; 然后进行链接,并执行相应的可执行文件。正确的执行结果是在屏幕上显示25 +9=34。
;--------------------------------------------
;FILENAME EXA131.ASM
.386
DATA SEGME NT USE16 ;关键字segme nt 有多余的空格 
SUM  DB ?,?,;最后一个逗号多余
MESG DB '25+9='
     DB 0,0;缺少字符串结束标志
  N1 DB 9,F0H;十六进制数书写格式错误
  N2 Dw 25
DATA ENDS

CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS,AX
        MOV BX,OFFSET SUM
        MOV AH,N1
        MOV AL,N2;AL为八位，N2为十六位的字类型
        ADD AH,AL ;
        MOV [BX],AH
        CALL CHANG
        MOV AH,9
        MOV DX, OFFSET MEST;变量名没有定义
        INT 21H
        MOV AH,4CH
        INT 21H

 CHANG PROC
 LAST:  CMP [BX],10;操作数类型冲突
        JC  NEXT
        SUB [BX],10;操作数类型冲突
        INC  [BX+7];操作数类型冲突
        JMP  LAST
 NEXT:  ADD [BX+8],SUM;这里不可以直接操作
        ADD [BX+7],30H
        ADD [BX+8],30H
        RET
        CHANG: ENDP


        CODE ENDS
   END BEG

