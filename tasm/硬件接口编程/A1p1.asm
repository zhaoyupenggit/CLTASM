;日时钟中断，不精确计时
;使用1cH
.386
DATA      SEGMENT USE16
MESG	  DB       'HELLO!',0DH,0AH,'$' ;要打印的串
OLD1C     DD      ?						;保存自定义的程序的地址	
ICOUNT    DB      18                    ;中断计数初值
COUNT     DB      10                    ;显示行数控制
DATA      ENDS
CODE      SEGMENT USE16
ASSUME  CS:CODE,DS:DATA
BEG:	MOV     AX,DATA
		MOV     DS,AX
		;---
		CLI                           ;关中断
		CALL    READ1C
		CALL    WRITE1C
		STI                           ;开中断
SCAN:	CMP	COUNT,0
		JNZ	SCAN
		CALL RESET
		MOV AH,4CH
		INT 21H
		
;---------中断服务程序----------
SERVICE   PROC
		PUSHA             ;保护现场
		PUSH    DS        ;DS=40H压栈
		MOV     AX,DATA
		MOV     DS,AX 	  ;重新给DS赋值
		DEC     ICOUNT 	  ;中断计数
		JNZ     EXIT	  ;不满18次转
		MOV	    ICOUNT,18
		DEC 	COUNT	  ; 显示行数减1
		MOV	  AH,9		  ;显示字符串
		LEA	  DX,MESG
		INT 	  21H   
EXIT:   POP     DS         ;恢复现场
		POPA
		IRET               ;返回系统8型中断服务程序
SERVICE   ENDP

;--------------转移系统1CH型中断向量--------------------
READ1C    PROC                 
		MOV     AX,351CH;dos调用的35H功能将1CH的中断向量读出来
		INT      21H
		MOV     WORD PTR OLD1C,BX
		MOV     WORD PTR OLD1C+2,ES
		RET
READ1C    ENDP

;-------------写入用户1CH型中断向量--------------------
WRITE1C   PROC                
		PUSH    DS
		MOV     AX,CODE;seg service
		MOV     DS,AX
		MOV     DX,OFFSET SERVICE
		MOV     AX,251CH;dos调用25H功能写中断向量
		INT      21H
		POP      DS
		RET
WRITE1C   ENDP

;------------恢复系统1CH型中断向量---------------------
RESET     PROC                 
		MOV     DX,WORD PTR OLD1C;!!!!这一条指令与下一条指令不能颠倒
		MOV     DS,WORD PTR OLD1C+2;!!!!
		MOV     AX,251CH
		INT      21H
		RET
RESET     ENDP

CODE      ENDS
END     BEG


