.486
CODE   SEGMENT   USE16
       ASSUME     CS:CODE
BEG:    MOV    BX,5678H
        MOV    CX,16
LAST:   MOV    AL,'0'    ;‘0’ =30H
	    ROL    BX,1 ;可否为其他方式
	    JNC    NEXT
	    MOV    AL,'1'   ;‘1’ =31H
NEXT:   MOV    AH,0EH
        INT    10H
        LOOP   LAST
        MOV    AH,4CH
        INT    21H
CODE   ENDS
END    BEG   