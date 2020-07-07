# 汇编笔记代码及配置VSCode一键运行ASM

[English](readme.md)|[gitee仓库](https://gitee.com/chenliucx/CLTASM)|[github仓库](https://github.com/xsro/VSC-Tasm)

学习《微型计算机原理与接口技术》的时候正好刚刚接触了git和VSCode，苦于DOSBox的“专注于游戏”，编辑代码种种不爽。所以尝试通过脚本和**VSCode**的终端任务来简化编译过程，实现**一键编译运行ASM文件**:smiley:

## :file_folder:本代码库主要内容

- `tasm`：汇编语言学习过程中用到的代码和一些实验代码
- `ASMtools`：汇编语言运行所需要的的一些文件和程序，包括TASM、MASM汇编工具集，DOSBox软件。
- `.vscode`：为了在VSCode中实现汇编语言的编辑运行调试等工作增加的配置文件
- `notes`：微机原理与接口技术学习笔记，详见[总览.md](微型计算机原理与接口技术\总览.md)

## :star:使用方法

克隆本仓库，并使用VSCode打开，第二种方法需要先安装vscode的[CodeRunner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)插件。linux系统需要先安装[dosbox](https://www.dosbox.com)。

- **VSCode终端任务**：使用**Ctrl+Shift+B**快捷键[^task]来运行*默认生成任务*实现汇编运行ASM源程序，因为本仓库在`.vscode`文件夹下的[tasks.json](.vscode/tasks.json)中定义了调用dosbox运行相关程序的任务

![vscode tasks 效果示例](pics/tasksView.gif)

- **Code Runner自定义任务**：可以使用**Ctrl+Alt+N**快捷键来运行程序，因为本仓库已经在`.vscode/settings.json` 中添加了运行代码的自定义命令。如果使用linux 需要在[settings.json](.vscode/settings.json) 中按照注释要求修改 效果如下图

|编译成功截图|编译有错截图|
|------------|------|
|![coderunner无错误截图](pics/CodeRunnerView.gif)|![coderunner有错误截图](pics/CodeRunnerErrView.gif)|

- 配置notepad++一键编译运行环境，可以参考这个代码
`cmd /c del d:dos\asm\tasm\t.* & copy  "$(FULL_CURRENT_PATH)" "d:dos\asm\tasm\t.asm" & D:\DOS\DOSBox.exe -noautoexec -c "mount c d:dos\asm\tasm"  -c "c:"  -c "tasm/t/zi t.asm" -c "tlink/v/3 t.obj" -c "t.exe" -c "pause" -c "exit"`

- 建议安装一个代码高亮的插件，比如`x86 and x86_64 Assembly`

### :runner:实现原理

64位系统下使用[DOSBox](ASM/Dosbox/DOSBox.exe)模拟的16位汇编环境，使用[TASM](ASM/TASM)汇编工具集编译的程序，同时也可以细微调整之后使用[MASM](ASM/MASM)，（如：去掉use16）来进行汇编程序或尝试这个vscode插件[masm-code](https://github.com/Woodykaixa/masm-code)

编写了一个Batch/Shell脚本文件，用它来实现调用dosbox模拟相关操作，终端任务便是调用对应脚本来实现相关操作，脚本工作的主要流程如下：

1. 将需要编译的文件复制到`ASMtools\test`
2. 调用DOSBox，将TASM文件夹挂载到dosbox中，然后使用tasm.exe tlink.exe td.exe等工具进行操作

可以只参考里面的配置文件。可以将[.vscode](.vscode)和[ASMtools](ASMtools)放到（合并到）你的汇编工作区，这样就可以使用上面的这些一键编译运行的特性(目前只支持windows下使用dosbox运行TASM工具，linux下或者使用MASM应该类似，需要自己编写相关脚本（我不会）)

## :sparkling_heart:代码规范与协作

- markdown文件使用vscode的markdownlint规范
- ASM文件还没有找到好用的规范
- 希望能够添加一些代码，比如有意思的实验代码，基本的字符串处理或者进制转换的代码等等
- 实现一键编译运行的方法和相关笔记还需要完善（比如没有办法隐藏dosbox运行界面）

## :point_right:参考链接

- [vscode tasks任务的帮助文档](https://code.visualstudio.com/docs/editor/tasks#vscode)
- [vscode variables变量的帮助文档](https://code.visualstudio.com/docs/editor/variables-reference)
- [dosbox 命令行参数的文档](https://www.dosbox.com/wiki/Usage)
- [dosbox 命令文档](https://www.dosbox.com/wiki/Commands)

*Git 新手* 大家多指导呀

[^task]: 或者点击终端、运行默认生成任务(Terminal>Run Build Task)
