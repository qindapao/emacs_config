# emacs_config
emacs config for my personal use 

## 安装

可以在这个[链接](https://mirrors.ustc.edu.cn/gnu/emacs/windows/emacs-29/)找到windows版本的安装包。选择`zip`的压缩包可以不用安装直接使用。

当前我使用的是：`29.2`版本，后面可以尝试更新的版本。

安装启动`emacs`后，初始配置和安装包在这个目录: `C:\Users\pc\AppData\Roaming\.emacs.d`。具体的目录以你当前登录的用户名而定。

在这个目录下可以创建一个`init.el`文件，我们可以把我们的配置放这里。`emacs`加载配置文件的顺序是：

* ~/.emacs
* ~/.emacs.el
* ~/.emacs.d/init.el
* ~/.config/emacs/init.el

按照顺序，它找到一个配置文件，就会停止查找。

为了方便管理，我使用`init.el`文件，然后和`vim`的配置文件类似，还是使用`mklink`创建快捷方式的方式来进行管理。`emacs`使用的是一个远程链接，真正的配置文件在`git`仓库中管理。

```cmd
cd C:\Users\pc\AppData\Roaming\.emacs.d
C:
mklink init.el E:\code\emacs\emacs_config\init.el
```

>记得用管理员的权限来运行`cmd`


`emacs`执行过程中可能会依赖一些二进制文件，我们可以在配置目录下创建一个`bin`目录，用于放置二进制文件，并且也好管理，注意，需要把这个目录添加到环境变量中。

```txt
C:\Users\pc\AppData\Roaming\.emacs.d\bin
```

安装完`emacs`后，安装目录下默认会安装很多二进制文件，有些二进制文件在系统中已经存在重名的，但是功能不同。比如`ctags.exe`目前是有两个版本：

* Exuberant-ctags
* Universal-ctags

如果系统上已经安装了`Universal-ctags`了，那么为了其它的`ctags.exe`不会对真正的`Universal-ctags`产生影响，那么最好是把所有的`Exuberant-ctags`对应的`ctags.exe`备份起来。

![ctags_exe_path](img/ctags_exe_path.png)

比如上面的红线的标注的工具都改个名或者删除。不然`vim`的`tagbar`或者是`emacs`相关的功能都可能被影响。


## vim模式

作为`vim`用户，已经习惯了那套按键映射，所以为了在`emacs`中使用`vim`的映射，先安装插件`Evil`。

## 基本操作

* 重启emacs M-x restart-emacs

### 查找某个按键映射映射到什么函数

举个例子：

如果你想查看C-z当前映射到哪个命令，你可以在Emacs中使用describe-key函数。只需按下C-h k（或者M-x describe-key），然后按下你想查询的键（在这个例子中是C-z），Emacs就会显示该键当前绑定的命令。


## 文件管理器

当前我使用的文件管理器是`neotree`，要正常使用它，有一些依赖

* 先安装`all-the-icons`这个包。
* 然后运行`M-x all-the-icons-install-fonts`这个命令，所有的字体文件会下载到一个目录下
* 手动进入字体文件下载的目录下，双击所有的字体文件，安装到`windows`系统中。


## 常用的二进制文件

### fzf

项目的主页在[这里](https://github.com/junegunn/fzf)。

### PasteEx

可以方便的粘贴剪切板里面的图像。项目的主页在[这里](https://github.com/huiyadanli/PasteEx)。在有这个二进制工具的基础上，`emacs`有一个扩展叫[pasteex-mode](https://github.com/dnxbjyj/pasteex-mode)。安装上以后可以方便的粘贴图像。

### shfmt

`bash`代码的格式化工具，一般情况下用处不大。项目的主页在[这里](https://github.com/mvdan/sh)。

### tree-sitter

一个代码语法树分析工具，项目主页在[这里](https://github.com/tree-sitter/tree-sitter)。所有的语法文件从[这里](https://github.com/iquiw/emacs-tree-sitter-module-dll/)下载，使用的是`emacs`内置的`treesit`模块。下载后一般放置到这个目录`~/.emacs.d/tree-sitter`。

或者直接在`emacs`中使用`treesit-install-language-grammar`来安装和更新语法。


## 常见问题解决

* 安装过程中如果提示某个模块找不到，那么可能是本地包的缓存需要更新，发下这个命令即可：`M-x package-refresh-contents`。然后重新运行`emacs`。

* emacs中可以交互式测试正则表达式：
    * 打开一个包含你想要测试的文本的文件。
    * 调用 M-x re-builder。屏幕底部将创建一个新窗口，其中包含空的正则表达式 ""。

* 如果要在其它的程序中通过命令行启动emacs，那么需要把它的可执行文件路径添加到环境变量。如：`D:\programes\emacs\bin`

## 通过emacs服务的方式来打开文件

这样不用新开一个实体，可以节约打开需要的时间。需要先在emacs中运行服务

```elisp
(add-hook 'emacs-startup-hook 'server-start)
```

然后就可以配置在别的引用程序中来通过`emacs`来打开文件。并且是用当前已经运行的实体来打开，几乎是秒开。如果过程中遇到提示说文件夹的所有权不对的问题，可以参考下面的解决方案解决。

```txt
问题可能是由于 ~/.emacs.d/server 目录的所有者设置不正确导致的。你可以尝试以下步骤来解决这个问题：

找到 ~/.emacs.d/server 目录，右键点击并选择“属性”（菜单中的最后一项。
在属性窗口中选择“安全”选项卡，然后点击“高级”按钮。
在弹出的窗口中选择“所有者”选项卡，将所有者从 Administrators 更改为你的登录用户名。
这样应该可以解决你的问题。如果问题仍然存在，你可能需要检查 ~/.emacs.d/server 目录的权限设置，确保你有足够的权限来读写这个目录。希望这个信息对你有所帮助！

要查看当前处于什么用户名，可以在powershell中运行 whoami命令
```


