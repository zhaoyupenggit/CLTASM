.386
DATA     SEGMENT  USE16
MESG1   DB 'HELLO $'
MESG2   DB 'I AM A STUDENT';
LL       =$-MESG2;
DATA     ENDS
CODE  SEGMENT  USE16
        ASSUME  CS:CODE
        ASSUME  DS:DATA
        ASSUME  ES:DATA
BEG:    MOV   AX, DATA
        MOV   DS, AX
        MOV   ES,  AX
        MOV   AX, 0003H
        INT   10H
        MOV   AH, 9
        MOV   DX,OFFSET  MESG1
        INT   21H
        MOV   AX, 1301H
        MOV   BH,  0
        MOV   BL, 01001111B
        MOV   CX,  LL
        MOV   DH,12
        MOV   DL, (80-LL)/2
        MOV   BP, OFFSET  MESG2
        INT   10H
        MOV   AH,  4CH
        INT      21H
      CODE       ENDS
END    BEG
