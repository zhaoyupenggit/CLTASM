; 宏指令调用例子
.386
CMPDISP   MACRO    NN
LOCAL   LAST, NEXT
        MOV DL,0  ;DL清0
LAST:   CMP BEN, NN    ;比较
        JC  NEXT ;BEN＜NN转
        INC DL      ;DL加1
        SUB BEN, NN
        JMP LAST
NEXT:   ADD DL, 30H
        MOV AH, 2
        INT 21H     ;显示
ENDM

CODE   SEGMENT  USE16
    ASSUME CS: CODE
BEN     DB    10101110B  ; = 174
BEG:    CMPDISP      100
        CMPDISP     10
        CMPDISP     1
        MOV    AH,4CH
        INT      21H
CODE   ENDS
END    BEG
