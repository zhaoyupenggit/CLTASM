汇编开发可以参考[link](###汇编工具使用),输入命令`d:`回车`mario`可以玩游戏
ctrl+F5截屏
# DOSbox下汇编语言学习

[toc]

### dosbox 

#### dosbox快捷键

这里是[DOSBox v0.74-3 Manual](https://www.dosbox.com/DOSBoxManual.html)提供的快捷键表格，鼠标总是停留在doxbox中时可以使用ctrl+F10

| **ALT-ENTER**    | Switch to full screen and back.                              |
| ---------------- | ------------------------------------------------------------ |
| **ALT-PAUSE**    | Pause emulation (hit ALT-PAUSE again to continue).           |
| **CTRL-F1**      | Start the keymapper.                                         |
| **CTRL-F4**      | Change between mounted floppy/CD images. Update directory cache for all drives. |
| **CTRL-ALT-F5**  | Start/Stop creating a movie of the screen. (avi video capturing) |
| **CTRL-F5**      | Save a screenshot. (PNG format)                              |
| **CTRL-F6**      | Start/Stop recording sound output to a wave file.            |
| **CTRL-ALT-F7**  | Start/Stop recording of OPL commands. (DRO format)           |
| **CTRL-ALT-F8**  | Start/Stop the recording of raw MIDI commands.               |
| **CTRL-F7**      | Decrease frameskip.                                          |
| **CTRL-F8**      | Increase frameskip.                                          |
| **CTRL-F9**      | Kill DOSBox.                                                 |
| `CTRL`-``F10`    | Capture/Release the mouse.                                   |
| `CTRL`-``F11`    | Slow down emulation (Decrease DOSBox Cycles).                |
| `CTRL`-``F12`    | Speed up emulation (Increase DOSBox Cycles)[^note1].         |
| **ALT-F12**      | Unlock speed (turbo button/fast forward)[^note2]             |
| **F11, ALT-F11** | (machine=cga) change tint in NTSC output modes[^note3]       |
| **F11**          | (machine=hercules) cycle through amber, green, white colouring[^note3] |

 

[^note1]: Once you increase your DOSBox cycles beyond your computer CPU resources, it will produce the same effect as slowing down the emulation. This maximum will vary from computer to computer. 
[^note2]:  You need free CPU resources for this (the more you have, the faster it goes), so it won't work at all with cycles=max or a too high amount of fixed cycles. You have to keep the keys pressed for it to work!
[^note3]: These keys won't work if you saved a mapper file earlier with a different machine type. So either reassign them or reset the mapper.



#### dos命令

每个指令加上`/?`后可以查看对应的帮助信息

![dosbox帮助界面](dosbox下汇编语言笔记.assets/dosbox帮助界面.png)

```dosbox
z: #c:等切换盘符
cd ,, #返回父目录
```

### 汇编工具使用

#### TASM汇编语言使用

```
tasm/zi a1.asm		#.asm可以省略，编译程序，不加参数可能无法调试
tlink/v/3 a1.obj	#.obj 可以省略，链接程序，不加参数可能无法调试
td a1.exe			#a1可以省略，调试程序
```


#### masm汇编工具使用

进入DOSBOX窗口，事先在NotePad++写好了汇编程序，接下来就调试运行它了

| 命令：         | 功能                                                         |
| -------------- | ------------------------------------------------------------ |
| masm name      | 得到目标程序文件即obj文件                                    |
| `link name     | 生成可执行文件即exe文件                                      |
| name.exe       | 运行该程序，有结果就输入，<br>若需要查看存储器和寄存器情况，就需要进行debug模式了 |
| debug name.exe | 对指定程序进行debug                                          |
| debug          | 不特定                                                       |

根据不同的debug命令进行想要的操作
常用命令 debug模式下：

```
-g ：执行完name.exe文件显示运行结果
-a ：编写汇编命令
-t ：单步执行
-p ：直接执行完不是单步执行
-u ：反编译
-r ：查看修改寄存器的值
-d ：查看内存单元
-e ：修改内存单元
-? ：查看指令帮助
```

最近使用的常用命令的详细说明：
-d：查看128个内存单元内容。

-d 段地址:偏移地址
查看指定地址128个内存单元的内容。

-d 段地址:偏移地址1 偏移地址2
查看指定地址1 到 指定地址2 内存单元的内容。

-d 段地址:偏移地址 位移量
查看指定地址开始的位移量个长度的内存单元内容

-t：ma
单步执行每条指令，每执行一条指令就显示寄存器内容和逻辑地址还有执行的指令。

### 常用ASCII表查询

| ASCII十进制编号 | 十六进制编号 | 代表字符 |
| --------------- | ------------ | -------- |
| 10D             | 0AH          | 回到行首 |
| 13D             | 0DH          | 回车     |
| 32D~41H         | 20H~29H      | 0-9      |

#### `dosbox.conf`常用代码段

**调整dos窗口大小：**在``dosbox.conj `中写入

```
[sdl]
fullscreen=false
fulldouble=false
fullresolution=original
windowresolution=1080x800
output=opengl
autolock=true
sensitivity=100
waittrue
priority=higher,normal
mapperfile=mapper-0.74.map
usescancodes=true

[render]

frameskip=0
aspect=false
scaler=normal2x
```

调整分辨率在上面代码中的windowresolution中调整