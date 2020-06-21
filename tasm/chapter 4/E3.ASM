;print the binary of the number in BX
;from the ppt chapter 4 Page 58
;example of simple branch(JianDan FenZhi)
.486
CODE SEGMENT USE16
        ASSUME CS:CODE
 BEG:   MOV BX,0003H;
        MOV CX,16
 LAST:  MOV AL,'0';'0'=30H
        ROL BX,1;
        JNC NEXT
        MOV AL,'1';
 NEXT:  MOV AH,0EH
        INT 10H
        LOOP LAST
        MOV AH,4CH
        INT 21H
    CODE ENDS
 END BEG
