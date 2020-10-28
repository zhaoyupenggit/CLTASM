;这是用来输出一个数字的代码
.model  small
.stack
.data
wordTEMP dw 0212ah
.code
.startup
mov ax,wordTEMP
call byax   ;调用参数为ax的函数
mov dx,wordTEMP
push dx
call bystack  ;调用参数用stack的函数
pop dx
call bywordTemp ;调用参数为变量的函数
.exit 0


;通过ax传递
byax PROC
mov cl,12       
again:
push ax
mov dx,ax
shr dx,cl
and dl,0fh
add dl,30h
cmp dl,39h
jc print
add dl,27h
print:          
mov ah,02h
int 21h
pop ax
sub cl,4
jnc again
mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h
ret
byax ENDP

;通过堆栈传递，然后调用前面参数为ax的函数完成
bystack PROC
push bp
push si
mov bp,sp
add bp,6
mov ax,[bp]
call byax
pop si
pop bp
ret     
bystack ENDP

;通过wordTemp变量传递，然后调用前面参数为ax的函数完成
bywordTemp PROC
    mov ax,wordTEMP
    call byax
    ret
bywordTemp ENDP
end
