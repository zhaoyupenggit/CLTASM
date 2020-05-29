.486
CODE SEGMENT USE16
ASSUME CS:CODE
BEG:
KEY:    MOV DX,3FBH;LCR
        MOV AL,80H
        OUT DX,AL
        MOV DX,3F8H
        MOV AL,12
        OUT DX,AL
        INC DX
        MOV AL,0
        OUT DX,AL
        MOV AL,0BH
        OUT DX,AL
        MOV AL,13H
        ;MOV AL,03H
        MOV DX,3FCH
        OUT DX,AL
CHECK: MOV DX,3FDH
        IN AL,DX
        TEST AL,1
        JNZ REV
        TEST AL,20H
        JZ CHECK
TR:     MOV AH,1
        INT 16H
        JZ CHECK
        MOV DX,3F8H
        OUT DX,AL
        JMP CHECK
REV:    MOV DX,3F8H
        IN AL,DX
        AND AL,7FH
        MOV BX,0041H
        MOV AH,14
        INT 10H
        JMP CHECK

CODE ENDS
END BEG