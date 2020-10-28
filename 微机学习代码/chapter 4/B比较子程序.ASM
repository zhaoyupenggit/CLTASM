;子程序调用示例
.386
CODE  SEGMENT USE16
           ASSUME  CS:CODE
BEN   DB      10101110B;=174
BEG:  MOV     BL,100
            CALL    CMPDISP
            MOV     BL,10
            CALL    CMPDISP
            MOV     BL,1
            CALL    CMPDISP
            MOV     AH,4CH
            INT     21H
			CMPDISP PROC
              MOV     DL,0   ;DL清0
LAST:   CMP     BEN,BL ;比较
              JC      NEXT   ;BEN ＜ BX 转
              INC     DL     ;DL加1
              SUB     BEN,BL ;BEN-BL→BEN
              JMP     LAST
NEXT:   ADD     DL,30H
              MOV     AH,2
              INT     21H    ;显示
              RET
CMPDISP ENDP
CODE    ENDS
             END     BEG