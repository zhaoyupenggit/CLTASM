# 汇编笔记

## 本代码库主要内容

- 微机原理与接口技术学习笔记，详见[总览.md](微型计算机原理与接口技术\总览.md)
- 汇编语言学习过程中用到的代码和一些实验内容的代码,详见`tasm`文件夹
- 汇编语言运行所需要的的一些文件和程序,详见`ASM`文件夹

## 运行环境（相关文件位于asm文件夹内）

64位系统下使用[dosbox](ASM/Dosbox/DOSBox.exe)模拟的16位汇编环境，使用[TASM](ASM/TASM)汇编工具集编译的程序，同时也可以细微调整之后使用[MASM](ASM/MASM)，（如：去掉use16）来进行汇编程序。

- 如果使用vscode打开本仓库的话，可以直接使用**Ctrl+Shift+B**快捷键来运行*默认生成任务*实现汇编运行ASM源程序，因为本仓库在`.vscode`文件夹下的tasks.json 中定义了调用dosbox运行程序的任务

- vscode 中如果安装了code runner插件的话也可以使用**Ctrl+Alt+N**快捷键来运行程序，因为本仓库已经在settings.json 中添加了运行代码的自定义命令：效果如下图

![coderunner无错误截图](pics/CodeRunnerView.gif)
![coderunner有错误截图](pics/CodeRunnerErrView.gif)

- 配置notepad++一键编译运行环境，可以参考这个代码
`cmd /c del d:dos\asm\tasm\t.* & copy  "$(FULL_CURRENT_PATH)" "d:dos\asm\tasm\t.asm" & D:\DOS\DOSBox.exe -noautoexec -c "mount c d:dos\asm\tasm"  -c "c:"  -c "tasm/t/zi t.asm" -c "tlink/v/3 t.obj" -c "t.exe" -c "pause" -c "exit"`

一些常用链接

- [vscode tasks任务的帮助文档](https://code.visualstudio.com/docs/editor/tasks#vscode)
- [vscode variables变量的帮助文档](https://code.visualstudio.com/docs/editor/variables-reference)
- [dosbox 命令行参数的文档](https://www.dosbox.com/wiki/Usage)
- [dosbox 命令文档](https://www.dosbox.com/wiki/Commands)
