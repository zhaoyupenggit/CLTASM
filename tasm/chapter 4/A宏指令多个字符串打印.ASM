; 宏指令调用
; BIOS 13H功能 实现彩色打印多个字符串
.386
DISP	MACRO	Y, X, VAR, LENGTH, COLOR
		 MOV         AH,13H
		 MOV         AL,1
		 MOV         BH,0                   ;选择0页显示屏
		 MOV         BL,COLOR               ;属性字(颜色值) →BL
		 MOV         CX,LENGTH              ;串长度 →CX
		 MOV         DH,Y                   ;行号 →DH
		 MOV         DL,X                   ;列号 →DL
		 MOV         BP,OFFSET VAR          ;串有效地址→BP
		 INT         10H
		 ENDM
 EDATA    SEGMENT USE16
     SS1     DB   'HELLO'
     SS2     DB   'WELCOME !'
     SS3     DB   'BYE_BYE'
EDATA    ENDS
CODE       SEGMENT USE16
   ASSUME  CS:CODE,ES:EDATA
BEG:  MOV   AX,EDATA
      MOV   ES,AX
      MOV   AX,3
      INT   10H
      DISP  0, 5, SS1, 5, 2
      ;0行5列显示绿色HELLO
      DISP  12, 36, SS2, 8, 4
      ;12行36列显示红色WELCOME
      DISP  24, 66, SS3, 7, 0EH
      ;24行66列显示黄色BYE_BYE
SCAN: MOV   AH,1
      INT   16H
      JZ    SCAN
      ;等待用户键入,无键入转
      MOV   AX,2
      INT   10H
      ;恢复80×25黑白文本方式
      MOV   AH,4CH
      INT   21H
 CODE  ENDS
END     BEG