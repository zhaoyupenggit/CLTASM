; 来自鑫的代码
; 计算值（001565A0H+0021B79EH）
; 共计32位，分为高低16位分别相加
DATA SEGMENT
	MES  DB 'The result is:$'
	XL   DW 65A0H
	XH   DW 0015H
	YL   DW 0B79EH
	YH   DW 0021H
DATA ENDS
CODE SEGMENT
	      ASSUME CS:CODE,DS:DATA
	START:MOV    AX,DATA
	      MOV    DS,AX
	      MOV    DX,OFFSET MES
	      MOV    AH,09H
	      INT    21H
	;低16位相加，保存在BX
	      MOV    AX,XL
	      ADD    AX,YL
	      MOV    BX,AX
	;高16位相加，保存在CX
	      MOV    AX,XH
	      ADC    AX,YH
	      MOV    CX,AX
	;调用子程序依次显示8位
	      MOV    DH,CH
	      CALL   SHOW
	      MOV    DH,CL
	      CALL   SHOW
	      MOV    DH,BH
	      CALL   SHOW
	      MOV    DH,BL
	      CALL   SHOW
	      MOV    AX,4C00H
	      INT    21H
SHOW PROC NEAR
	      PUSH   DX
	      PUSH   AX
	      MOV    AL,DH
	      AND    AL,0F0H
	      SHR    AL,1
	      SHR    AL,1
	      SHR    AL,1
	      SHR    AL,1
	      CMP    AL,0AH
	      JB     C2
	      ADD    AL,07H
	C2:   ADD    AL,30H
	      MOV    DL,AL
	      MOV    AH,02H
	      INT    21H
	      MOV    AL,DH
	      AND    AL,0FH
	      CMP    AL,0AH
	      JB     C3
	      ADD    AL,07H
	C3:   ADD    AL,30H
	      MOV    DL,AL
	      MOV    AH,02H
	      INT    21H
	      POP    AX
	      POP    DX
	      RET
SHOW ENDP
CODE    ENDS
    END START