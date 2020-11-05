;there are 9 people in a department
;calculate the number of people whose incomes are between 2000 and 4000
;display them in the form of decimal numbers
.386
DATA  SEGMENT  USE16
NUM    DW   1000,23232,2300,4895,2999,1299,8769,4545,9990
DATA  ENDS
CODE  SEGMENT  USE16
      ASSUME   CS:CODE,DS:DATA
BEG:  MOV   AX,DATA
      MOV   DS,AX
      MOV   BX,OFFSET NUM
      MOV   CX,9
      MOV   DL,0
LAST: CMP   WORD PTR [BX],2000
      JC    NEXT
      CMP  WORD PTR[BX],4000
      JA  　NEXT
　    INC   DL
NEXT: INC   BX
　    INC   BX
      LOOP  LAST
      ADD   DL,30H
      MOV   AH,2
      INT   21H
      MOV   AH,4CH
      INT   21H
  CODE  ENDS
END    BEG