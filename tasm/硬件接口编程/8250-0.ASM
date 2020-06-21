DATA	    SEGMENT  USE16
	BUF	    DB	         ‘HELLO’
	LEN          EQU	           $ - BUF
	DATA       ENDS
	CODE	    SEGMENT USE16
		    ASSUME    CS:CODE , DS:DATA
	BEG:	    MOV           AX , DATA
		    MOV	           DS , AX
            CALL	I8250
		LEA	BX, BUF
		MOV	CX, LENS
        SCAN:	MOV	DX, 3FDH
		TEST	AL, 20H
		JZ	SCAN
		MOV	DX, 3F8H
		MOV	AL, [BX]
