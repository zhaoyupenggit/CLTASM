# 汇编笔记
## 运行环境
64位系统下使用[dosbox](ASM/Dosbox/DOSBox.exe)模拟的16位汇编环境，使用[TASM](ASM/TASM)汇编工具集编译的程序，同时也可以细微调整之后使用[MASM](ASM/MASM)，（去掉use16）来进行汇编程序
## 配置vscode一键运行任务tasks.json
参考[本代码库.vscode文件下的tasks.json](.vscode/tasks.json)
## 配置notepad++一键编译运行环境
参考以下运行命令
> D:\DOS\DOSBox.exe -noautoexec -c "mount c d:dos\asm\tasm" -c "mount d \"$(CURRENT_DIRECTORY)\"" -c "c:" -c "del t.*" -c "copy d:\$(NAME_PART).asm c:\t.asm"-c "tasm/t/zi t.asm" -c "tlink/v/3 t.obj" -c "t.exe" 

> cmd /c del d:dos\asm\tasm\t.* & copy  "$(FULL_CURRENT_PATH)" "d:dos\asm\tasm\t.asm" & D:\DOS\DOSBox.exe -noautoexec -c "mount c d:dos\asm\tasm"  -c "c:"  -c "tasm/t/zi t.asm" -c "tlink/v/3 t.obj" -c "t.exe" -c "pause" -c "exit" 

一些常用链接

- https://code.visualstudio.com/docs/editor/tasks-appendix
- https://code.visualstudio.com/docs/editor/variables-reference
- https://code.visualstudio.com/docs/editor/tasks#vscode

git命令常用

```
git fetch --all
git reset --hard origin/master
```
