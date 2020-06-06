;将打印字符改成BIOS的功能调用
.586
DATA	SEGMENT USE16
TEXT	DB    'string'
        DB      0DH,0AH
LLL	EQU     $-TEXT
DATA 	ENDS
CODE	SEGMENT USE16
    ASSUME  CS:CODE,DS:DATA
BEG: 	MOV     AX,DATA
        MOV     DS,AX
        CALL    I8250;主串口初始化
        ;循环体
AGAIN:  MOV     CX,LLL 	        ;字符串长度送CX
        MOV     BX,OFFSET TEXT  ;字符串偏移地址送BX
SCAN:	MOV     DX,3FDH         ;检查通信线状态寄存器
        IN      AL,DX
        TEST    AL,20H          ;D6为1则表示发送移位寄存器空闲
        JZ      SCAN  		;不允许发送就重新检查
        MOV     AL,[BX]  	;取待发送字符
SEND: 	MOV     DX,3F8H         ;发送保持寄存器
        OUT     DX,AL 		;发送到主串口
RSCAN:	MOV     DX,3FDH         ;通信线状态寄存器
        IN      AL,DX
        TEST    AL,01H 		;D0 接收数据准备好标志位 为1表示已接收到一帧完整数据
        JZ      RSCAN;收完转
RECEIVE:MOV     DX,3F8H         ;接收缓冲寄存器
        IN      AL,DX		;读数据
        AND     AL,7FH
DISP:	MOV     AH, 0eh         ;屏幕显示
        INT     10H
        INC     BX
        LOOP    SCAN
        ;循环体
RETURN:	MOV     AH,4CH
        INT     21H   		;返回 DOS
;----------------------------------
I8250	PROC
        ;规定传输频率
	MOV	DX, 3FBH        ;通信线路控制寄存器
	MOV	AL, 80H          ;最高位置1表示下次访问9H的时候指的是除数锁存器低位，而不是中断允许寄存器
	OUT	DX, AL
	MOV	DX, 3F9H        ;访问除数锁存器高位MSB
	MOV	AL, 0
	OUT	DX, AL
	MOV	DX, 3F8H        ;访问除数锁存器低位LSB
	MOV	AL, 30H
	OUT	DX, AL
        ;设置数据帧格式，中断以及modem控制
	MOV	DX, 3FBH        ;通信线控制寄存器
	MOV	AL, 00001010B    ;0非除数寄存器0正常通信001奇效验0一位停止位107位数据位（ASCII码为七位）
	OUT	DX, AL
	MOV	DX, 3F9H        ;访问中断允许寄存器
	MOV	AL, 01H          ;允许接收中断
	OUT	DX, AL
        MOV	DX, 3FCH        ;modem控制寄存器
	MOV	AL, 18H          ;D4置1，内环自检，允许送出中断请求
	OUT	DX, AL
	RET
        I8250  ENDP
CODE      ENDS
END     BEG
