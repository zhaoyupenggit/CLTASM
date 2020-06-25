.586
CODE	SEGMENT	USE16
	ASSUME  CS:CODE
	ORG     100H
BEG: 
	JMP     START
	SUM      DB ?                  
	START:
	MOV      AL, 46H               ;AL←46H
	ADD      AL,52H                  ;AL←46H+52H
	MOV      SUM,AL               ;SUM←AL
	MOV      AH,4CH
	INT      21H                   ;返回DOS
CODE    ENDS
END     BEG   
