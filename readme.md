# ALL ABOUT TASM in DOSBox(notes,codes and vscode settings for run)

[CN](readme.zh.md)|[github repo](https://github.com/xsro/VSC-Tasm)|[gitee repo](https://gitee.com/chenliucx/CLTASM)

When I study the course <principles& peripheral technology of microprocessor>, I need to study some knowledge about assembly,but those assembly tools(TASM and MASM) runs in 16 bits microprocessor system which is not supported by most computers today. We use **DOSBox** to emulate the 16-bit environment, but DOSBox is designed for games,it is a little unfriendly for coding.So I write some **VSCode** settings and tasks to run the **TASM** assembly.Hope helpful for you:smiley:

## Overview

### :sweat_smile:Main Features

Just clone this repository to your folder and then you can use these features. And this features are runable in linux and windows now [Getting Start](#getting-start)

- if installed the vscode extension *code runner*, we can run TASM with a click or **Ctrl+Alt+N**

|Code Runner no error|Code Runner some error|
|---|---|
|![coderunner_OutputTheResult](pics/CodeRunnerView.gif)|![coderunner_OutputTheErrMsg](pics/CodeRunnerErrView.gif)|

- we can also use the *VSCode Terminal Tasks* with **Ctrl+Shift+B** or click **Terminal->Run Build Tasks**,to do more things

![vscode tasks](pics/tasksView.gif)|

### :file_folder:Content

1. Folder [ASMtools](ASMtools):windows programs of dosbox,TASM,and MASM
2. Folder [.vscode](.vscode):tasks.json for Build Task,settings.json mainly for CodeRunner
3. Folder [tasm](tasm):codes of TASM
4. Folder [notes](notes):some notes for reference in Chinese

### Getting Start

1. Clone the repository to your folder
    - If installed GIT,we can use command like `cd yourfolder;git clone --depth=1 https://github.com/xsro/VSC-Tasm.git`
    - Or click`code`,`download zip` and unzip to your folder
2. Open the Folder with VSCode [Download VSCode](https://code.visualstudio.com/Download)
3. Then you can write your own TASM or MASM code with the assitance of the powerful VSCode

#### for linux

For linux, we should **Install the `dosbox` first**.Use command like `sudo apt install dosbox` or download from website[DOSBox](https://www.dosbox.com). Since I have put the dosbox.exe in the folder `ASMtools\dosbox`,so it's not necessary to install dosbox for windows users

#### Partly use

We can also copy the folder .vscode and ASMtools to your workspace to use them for running dosbox

## :raising_hand:Need your help

- The way to run code is runable but imperfect
- Codes still needed to collect more
- The notes is also not enough and out of order
- and other things
