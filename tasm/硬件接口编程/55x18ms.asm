;日时钟中断，不精确计时的日时钟中断
.386
DATA      SEGMENT  USE16
	MESG      DB      'HELLO！',0DH,0AH,'$'
	ICOUNT    DB      18
	COUNT     DB      10
DATA      ENDS
	
CODE      SEGMENT USE16
	OLD08     DD ? ;代码段中保存系统08H中断向量变量 
	ASSUME  CS:CODE,DS:DATA
BEG:  	MOV     AX,DATA
		MOV     DS,AX
		;-------------
		CLI    			  	;关中断
		CALL    READ08 	  	;保存原来的08中断向量
		CALL    WRITE08   	;置换08H型中断向量指向自定义中断服务程序
		STI 				;开中断
SCAN:   CMP     COUNT,0
		JNZ     SCAN		;是否已经显示10行，否转
		CLI
		CALL    RESET 	   	;恢复系统08中断向量
		STI
		MOV     AH,4CH
		INT      21H 		;返回 DOS
		
SERVICE   PROC    		   	;中断服务程序
		PUSHA
		PUSH     DS                      
		MOV     AX,DATA
		MOV     DS,AX
		DEC      ICOUNT	 	;计18次55msx18=990ms
		JNZ       EXIT
		MOV      ICOUNT,18
		DEC	    COUNT       ;显示行数减1
		MOV      AH,9      	;显示字符串
		MOV      DX,OFFSET MESG       
		INT       21H
EXIT:   POP      DS
		POPA
		JMP      CS:OLD08   ;转向原来的08H服务程序
SERVICE   ENDP

READ08    PROC 				;保存原来系统的08H 中断向量
		MOV      AX,3508H
		INT       21H
		MOV      WORD PTR OLD08,BX
		MOV      WORD PTR OLD08+2,ES
		RET
READ08    ENDP 
WRITE08  PROC      			;置换08H型中断向量指向自定义中断服务程序
		PUSH      DS                                        
		MOV      AX,CODE
		MOV      DS,AX
		MOV      DX,OFFSET SERVICE 
		MOV      AX,2508H
		INT       21H
		POP       DS
		RET
WRITE08   ENDP

RESET     PROC 						;恢复系统08中断向量
		MOV   DX,WORD PTR OLD08  	;注意和后一条指令顺序
		MOV  DS,WORD PTR OLD08+2
		MOV       AX,2508H
		INT        21H
RET
RESET     ENDP

CODE      ENDS
END     BEG 
