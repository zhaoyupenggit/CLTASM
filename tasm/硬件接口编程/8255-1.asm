     .486
DATA      SEGMENT use16
OLD1C		DD      ?
ICOUNT	DB      18
TAB		DB	 11111110B
DATA      ENDS
CODE      SEGMENT use16
          ASSUME  CS:CODE,DS:DATA
BEG:	MOV      AX,DATA
          	MOV      DS,AX
          	CLI
         	CALL     I8255A         	;8255A初始化
          	CALL     READ1C 
        	CALL     WRITE1C         ;置换1CH型中断向量
          	STI                               	 ;开中断
SCAN:	MOV      AH,1
         	INT     16H 
	JZ       SCAN                       ;无转
	CALL     RESET          
	MOV      AH,4CH
          	INT      21H                        ;返回 DOS

SERVICE   PROC
          	PUSH	AX
          	PUSH    DS
          	MOV	AX,DATA
          	MOV	DS,AX
          	DEC	ICOUNT
          	JNZ	EXIT
			MOV     ICOUNT, 18
          	MOV	AL,TAB
			MOV	DX,230H
			OUT	DX,AL
			NOT	TAB
EXIT:		POP	DS
          	POP	AX
          	IRET                                        ;中断返回
SERVICE   ENDP
I8255A    PROC
          	MOV       DX,233H
          	MOV       AL,80H                   ;10000000B
          	OUT       DX,AL                     ;写入方式字
       	RET
I8255A    ENDP

WRITE1C   PROC
          PUSH     DS                                        
          MOV      AX,CODE
          MOV      DS,AX
          MOV      DX,OFFSET SERVICE 
          MOV      AX,251CH
          INT      21H  
          POP       DS
          RET
WRITE1C   ENDP









READ1C    PROC                  	  ;转移系统原1CH型中断向量
          MOV     AX,351CH
          INT       21H
          MOV     WORD PTR OLD1C,BX
          MOV     WORD PTR OLD1C+2,ES
          RET
READ1C    ENDP

RESET     PROC
          MOV      DX, WORD PTR OLD1C
          MOV      DS, WORD PTR OLD1C+2
          MOV      AX,251CH
          INT      21H          
          RET
RESET     ENDP

         CODE     ENDS
         END       BEG
