;设ARRAY是5个字元素的数组，用子程序计算数组元素的累加和(不计进位)，并将结果存入变量RESULT中。
;这个程序似乎使用MASM无法通过
.386
DATA      SEGMENT USE16
ARRAY     DW      1111H,2222H,3333H,4444H,5555H
RESULT    DW      ?
DATA      ENDS
CODE      SEGMENT USE16
				  ASSUME  CS:CODE,DS:DATA
BEG:      MOV     AX,DATA
				MOV     DS,AX
				MOV     CX,5	;数组元素个数→CX
				MOV     BX,OFFSET ARRAY ;数组偏移地址→BX 
CALL    COMPUTE							;调用子程序
XYZ:      MOV     RESULT,AX               ;处理出口参数
EXIT:     MOV     AH,4CH
				 INT     21H
;------------------------------------
COMPUTE   PROC
		MOV     AX,0
AGA:    ADD      AX,[BX]            　;求和
		ADD     BX,2
		LOOP   AGA
		RET                                      ;返回断点XYZ
COMPUTE   ENDP
CODE      ENDS
END     BEG