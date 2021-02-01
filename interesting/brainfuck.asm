; 作者：VioletTec
; 链接：https://zhuanlan.zhihu.com/p/343381852
; 来源：知乎
; 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

;AUTHOR: VioletTec (QQ:595585575)
;Date: 2020.11.20 ~ 2020.11.21
assume cs:code,ds:data,ss:stack_data
data segment
more_than_msg db 'this is >',0dH,0aH,'$';共12个字节，0~0BH (0dH和0aH是换行)
start_running_msg db 0dH,0aH,'BrainFuck Interpreter Running ! ',0dH,0aH,'$'
exit_msg db 0dH,0aH,'bye~$'
data ends
stack_data segment
    db 512 dup (0);用于临时存储数据的栈
stack_data ends
code segment
bf_stack db 256 dup (0);定义256个字节，用于BF的栈
code_stack db 512 dup (0);定义512个字节，存放BF代码
code_len dw 0
code_point dw 0
stack_point dw 0
get_input: ;返回:al:ASCII码 ah:扫描码
    mov ah,0
    int 16H
    ret
print_screen:;ds:dx输出，$停止
    push ax
    mov ah,9H;输出DL的字符到显示器，$终止
    int 21H
    pop ax
    ret
print_single_word:;DL作为参数，打印DL
    mov ah,2H
    int 21H
    ret
get_code:;获取输入的代码
    push si
    push dx
    call get_input
    mov si,code_len
    mov dl,al
    mov code_stack[si],dl;把输入的代码放到代码栈里
    inc code_len;代码长度+1 
    call print_single_word
    cmp dl,0dH;如果是回车
    pop dx
    pop si
    jne get_code;如果不是回车
    je start_run;如果是回车，则开始运行
start_run:
    dec code_len
    jmp start_get_code1;开始运行
more_than1:;如果是>符号，则stack指针+1
    inc stack_point
    jmp start_continue
less_than1:;如果是<符号，则stack指针-1
    dec stack_point
    jmp start_continue
inc_one1:;加号，则stack_point上的数据+1
    push si
    mov si,stack_point
    inc bf_stack[si]
    pop si
    jmp start_continue
dec_one1:;减号，则stack_point上的数据-1
    push si
    mov si,stack_point
    dec bf_stack[si]
    pop si
    jmp start_continue
;;==============检测到 [   查找 ]=================
find_right_bracket:;在当前stack_point所指向的bf_stack地址查找 ] （向右查找→），返回查到的字符串所在的指针位置 
;返回值在dx中保存
    push si;存储si
    mov si,code_point
    push si;存储当前code_point
    push ax
    push bx
    mov bx,0H;bx用来计数
    mov cx,code_len
    sub cx,code_point;cx存放剩下的代码长度
find_right_s:
    mov al,code_stack[si]
    cmp al,'['
    je find_right_find_left;如果查到了 [ 
    cmp al,']'
    pop ax
    je find_right_find_right
after_find_right:
    cmp bx,0
    je finded_right_bracket
    inc si;如果没查到继续+1再查
    loop find_right_s
    ;查找失败
    mov dx,0000H
    jmp after_find_right
find_right_find_left:;查找 [ 成功
    inc bx
    mov dx,si;此处si为查找到的字符的指针地址
find_right_find_right:;查找 ] 成功
    dec bx;bx+1
    jmp after_find_right
finded_right_bracket:;如果bx=0，找到了]则停止(finally)
    mov dx,si;当前si存放的是 ] 的位置
    pop bx
    pop ax;恢复之前的ax
    pop si
    mov code_point,si;恢复之前的code指针
    pop si;恢复之前的si
    ;现在的dx就是 ]所在位置 所在的code_point
    ret
left_bracket1:;检测到左中括号
    push si
    push ax
    mov si,stack_point
    mov al,bf_stack[si]
    cmp al,0H;
    pop ax
    pop si
    jne left_bracket1_not_zero;如果不是0
    je left_bracket1_is_zero;如果是0
left_bracket1_not_zero:;如果当前指针下数据不为0，则继续执行
    jmp start_continue;返回
left_bracket1_is_zero:;如果当前指针下数据为0，则跳转到最近的一个右括号，则结束循环
    push dx
    call find_right_bracket;查找 ]
    ;dx为返回的stack位置（失败为0000H）
    mov code_point,dx
    pop dx
    jmp start_continue;返回
;;==============检测到 ] 查找 [ =======================
find_left_bracket:;查找 [
;返回值在dx中保存
    push si;存储si
    mov si,code_point
    push si;存储当前code_point
    push ax
    push bx
    mov bx,0H;bx用来计数
    mov cx,code_point;只需要循环code指针个即可
find_left_s:;循环体
    mov al,code_stack[si]
    cmp al,'['
    je find_left_find_left;如果查到了 [
    cmp al,']'
    je find_left_find_right
after_find_left:
    cmp bx,0
    je finded_left_bracket
    dec si;如果没查到继续-1再查
    loop find_left_s
    ;查找失败
    mov dx,0000H
    jmp left_bracket1
find_left_find_left:;查找 [ 成功
    dec bx;bx-1
    mov dx,si;此处si为查找到的字符的指针地址
    jmp after_find_left
find_left_find_right:;查找 ] 成功
    inc bx;bx+1
    jmp after_find_left
finded_left_bracket:;如果bx=0，找到了[则停止(finally)
    mov dx,si;当前si存放的是 ] 的位置
    pop bx
    pop ax;恢复之前的ax
    pop si
    mov code_point,si;恢复之前的code指针
    pop si;恢复之前的si
    ;现在的dx就是 [ 所在的code_point
    ret
right_bracket1:;检测到 ]  准备 查找 [
    push si
    push ax
    mov si,stack_point;存储代码指针
    mov al,bf_stack[si]
    cmp al,0H;
    pop ax
    pop si
    jne right_bracket1_not_zero;如果不是0
    je right_bracket1_is_zero;如果是0
right_bracket1_is_zero:;如果当前指针下数据为0，则继续执行
    jmp start_continue;返回
right_bracket1_not_zero:;如果当前指针下数据不为0，则跳转到最近的一个左[括号，继续循环
    push dx
    call find_left_bracket;查找 [
    ;dx为返回的stack位置（失败为0000H）
    mov code_point,dx
    pop dx
    jmp start_continue;返回
;;======================================
comma_print1:;如果是,逗号，则打印
    push ax 
    push dx
    push si
    mov si,stack_point
    mov dl,bf_stack[si];打印单个字符（使用ASCII码)
    call print_single_word;dl是参数，打印
    pop si
    pop dx
    pop ax
    jmp start_continue
exit:
    push ds
    push dx
    push ax
    mov ax,data
    mov ds,ax
    lea dx,exit_msg
    call print_screen
    pop ax
    pop dx
    pop ds
    ret
more_than:
    jmp more_than1
less_than:
    jmp less_than1
inc_one:
    jmp inc_one1
dec_one:
    jmp dec_one1
comma_print:
    jmp comma_print1
left_bracket:
    jmp left_bracket1
right_bracket:
    jmp right_bracket1
start:
    ;初始栈顶
    mov si,stack_data
    mov ss,si
    mov sp,14cH;512+1为栈底
    call get_code;获取代码，放到code_stack里
start_get_code1:
    ;此时code_stack里装的是代码，code_point在code_stack起始位置
    push ds
    push dx
    mov ax,data
    mov ds,ax
    lea dx,start_running_msg;打印开始解释BF的提示语
    call print_screen
    pop dx
    pop ds
run:
    mov ax,code_point
    mov bx,code_len
    cmp ax,bx
    je stop;如果code_point超出长度，则执行结束
    mov si,code_point
    mov al,code_stack[si];读取代码
    cmp al,'>'
    je more_than
    cmp al,'<'
    je less_than
    cmp al,'+'
    je inc_one  
    cmp al,'-'
    je dec_one
    cmp al,','
    je comma_print
    cmp al,'['
    je left_bracket
    cmp al,']'
    je right_bracket
start_continue:
    inc code_point;代码指针+1
    jmp run;继续循环
stop:
    call exit
    mov ax,4c00H
    int 21H
code ends
end start