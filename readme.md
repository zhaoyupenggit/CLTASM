# 汇编笔记

## 本代码库主要内容

- 微机原理与接口技术学习笔记，[详见](微型计算机原理与接口技术\总览.md)
- 汇编语言学习过程中用到的代码和一些实验内容的代码,详见tasm文件夹
- 汇编语言运行所需要的的一些文件,详见asm文件夹

## 运行环境（相关文件位于asm文件夹内）

64位系统下使用[dosbox](ASM/Dosbox/DOSBox.exe)模拟的16位汇编环境，使用[TASM](ASM/TASM)汇编工具集编译的程序，同时也可以细微调整之后使用[MASM](ASM/MASM)，（去掉use16）来进行汇编程序
配置方法如下

### 配置vscode一键运行任务tasks.json

参考[本代码库.vscode文件下的tasks.json](.vscode/tasks.json)
vscode 中如果安装了code runner插件的话也可以使用，在settings.json 中添加自定义命令的方式来运行汇编文件，没有测试过
本vscode的工作区文件中已经添加了汇编运行的一些命令，可以使用`运行生成任务`来一键运行，也可以使用code runner来运行（相关命令已经写在settings.json 中,但是对于有空格的文件名不是很支持）

### 配置notepad++一键编译运行环境

参考以下运行命令
> D:\DOS\DOSBox.exe -noautoexec -c "mount c d:dos\asm\tasm" -c "mount d \"$(CURRENT_DIRECTORY)\"" -c "c:" -c "del t.*" -c "copy d:\$(NAME_PART).asm c:\t.asm"-c "tasm/t/zi t.asm" -c "tlink/v/3 t.obj" -c "t.exe"
> cmd /c del d:dos\asm\tasm\t.* & copy  "$(FULL_CURRENT_PATH)" "d:dos\asm\tasm\t.asm" & D:\DOS\DOSBox.exe -noautoexec -c "mount c d:dos\asm\tasm"  -c "c:"  -c "tasm/t/zi t.asm" -c "tlink/v/3 t.obj" -c "t.exe" -c "pause" -c "exit"

一些常用链接

- <https://code.visualstudio.com/docs/editor/tasks-appendix>
- <https://code.visualstudio.com/docs/editor/variables-reference>
- <https://code.visualstudio.com/docs/editor/tasks#vscode>

git命令常用

```git
git fetch --all
git reset --hard origin/master
```
