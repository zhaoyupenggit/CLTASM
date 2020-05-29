.486
DATA     SEGMENT  USE16
MESG1   DB 'HELLO $' 
MESG2   DB 'I AM A STUDENT'; 
LL       =$-MESG2; 
DATA     ENDS
CODE     SEGMENT  USE16
                 ASSUME  CS:CODE 
                 ASSUME  DS:DATA
                 ASSUME  ES:DATA	;将数据段与附加段定义在一起
BEG:      MOV   AX, DATA
                 MOV   DS, AX
                 MOV   ES,  AX
              MOV   AX, 0003H
              INT   10H            
			  MOV   AH, 9
              MOV   DX,OFFSET  MESG1
              INT   21H		;DOS09H显示字符串，响应ctrl_C
              MOV   AX, 1301H	;AL=0~3,0/1can display color charactor
              MOV   BH,  0;set page number
              MOV   BL, 01001111B;属性字
              MOV   CX,  LL
              MOV   DH,12
              MOV   DL, (80-LL)/2
              MOV   BP, OFFSET  MESG2
              INT   10H	;	BIOS13H调用显示字符串
              MOV   AH,  4CH
              INT      21H
      CODE       ENDS 
               END    BEG  
