; 假设从BUF单元开始为一个 ASCII码字符串,找出其中的最大数送屏幕显示。
; 代码1
.386
DATA   SEGMENT USE16
BUF    DB    'QWERTYUIOP123'
FLAG   DB     -1 ;设置串结束标志
MAX    DB    'MAX=',?,0DH,0AH,'$'
DATA   ENDS
CODE   SEGMENT USE16  
       ASSUME  CS:CODE,DS:DATA
BEG:   MOV     AX,DATA
	   MOV     DS,AX
	   MOV     AL,0               
	 ;无符号最小数 0 →AL
	   LEA     BX,BUF               
	 ;串首址偏移量→BX
LAST:  CMP    BYTE PTR [BX], -1 
	 ;[BX]=串结束标志 ?
	   JZ     DISP   ;是,转
	   CMP    [BX],AL
	   JNA    NEXT
	   MOV   AL,[BX]  
	  ;大数→AL
NEXT:   INC     BX
	    JMP     LAST
DISP:   MOV    MAX+4,AL      
	 ;最大数→MAX+4 单元
		MOV     AH,9
		MOV  DX,OFFSET MAX
		INT        21H    ;显示结果
		MOV     AH,4CH
		INT        21H    ;返回 DOS
CODE ENDS
             END     BEG  