# Collection of some assembly Codes

[![Open in Visual Studio Code](https://open.vscode.dev/badges/open-in-vscode.svg)](https://open.vscode.dev/dosasm/dos-assembly-codes)

欢迎补充，一些在DOSBox环境下可以运行的汇编代码，可以在[github.dev](https://github.com/dosasm/dos-assembly-codes)中在线编辑，部分可以运行。

- :file_folder:文件夹[微机学习代码](微机学习代码/)和[微机实验](微机实验)是学习NJUPT微机时整理的一些代码
- :file_folder:文件夹[interesting](interesting/)是在网上寻找的有趣的代码
- :file_folder:文件夹[简化段定义](简化段定义)是简化段定义的一些代码，需要MASM6.x以上版本


## 清理

使用GIT命令可以清除不被git跟踪的文件

```sh
git clean -xfd --dry-run 
#加上--dry-run会显示将要清除的文件而不清除，不加则会自动清除
```

## 部分来源

这里是interesting文件夹的一些代码来源

|名称和链接|描述|TASM是否通过|
|---|----|---|
|[asm16_projects](https://github.com/hasherezade/asm16_projects)|ASCII画图，猜字符，井字棋|:heavy_check_mark:|
|[ASVr_Piano](https://github.com/WolfDroid/ASVr_Piano)|弹钢琴|:heavy_check_mark:|
|[snake](https://github.com/bengabay11/snake)|贪吃蛇 上下左右键控制方向 好像是w开始|:heavy_check_mark:|
|[RussiaCube(CSDN)](https://blog.csdn.net/zjbh89757/article/details/53816106)|俄罗斯方块|:heavy_check_mark:(会警告，但是完全可玩)|
|[TASM-8086-Lab-Codes](https://github.com/shb9019/TASM-8086-Lab-Codes)|TASM 8086 Assembly codes for Microprocessors Lab as part of course plan for 3rd Year CSE NIT Trichy|:heavy_check_mark:|
|[dos-virus](https://github.com/johangardhage/dos-virus)|好像是一个病毒，不敢试|  |
|[file-manager-assembly-tasm](https://github.com/pishangujeniya/file-manager-assembly-tasm)|文件系统|:heavy_check_mark:（TASM通过但是有警告信息）|

所有代码都在VSCode中测试通过了，[VSCode extension MASM/TASM](https://marketplace.visualstudio.com/items?itemName=xsro.masm-tasm)下测试。如果侵权，请联系删除
