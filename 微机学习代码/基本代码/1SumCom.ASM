;这是汇编为com文件的代码示例
;链接时需要加上参数/t 例如tlink/t T.OBJ
;没有输入输出
.386
CODE	SEGMENT	USE16
	ASSUME  CS:CODE
	ORG     100H
BEG: 
	JMP     START
	SUM      DB ?
START:
	MOV      AL, 46H            ;AL←46H
	ADD      AL,52H             ;AL←46H+52H
	MOV      SUM,AL             ;SUM←AL=46H+52H=98H
	MOV      AH,4CH
	INT      21H                ;返回DOS
CODE    ENDS
END     BEG   
