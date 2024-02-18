;; :TODO: 暂时先固化这个配置,有时间再来调整它的顺序

;; 设置默认的编码环境

(set-buffer-file-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

(setq default-buffer-file-coding-system 'utf-8-unix)

;; 系统中的find命令太多了，指定它的路径(使用windows默认的find会出问题)
;; :TODO: 如果其它依赖的二进制文件(比如grep git等)也找到的不是正确的路径,也需要变量指定
;;        具体需要设置的变量搜索下(或者整理系统,把错误的工具删除或者改名)
(setq find-program "\"D:/programes/git/Git/usr/bin/find.exe\"")
;; M-x
;; apropos-variable
;; program


;; conceal-rg 可以搜索中文
(add-to-list 'process-coding-system-alist '("rg" utf-8 . gbk))

;; 中文编码问题的魔幻处理方法(https://emacs-china.org/t/counsel-rg-win10/12474/15)
;;默认设置cos的car是输出到buffer的编码，cdr是传给命令行程序的编码，其他函数的编码有可能要单独设置，
(set-default 'process-coding-system-alist
             '(
               ("[pP][lL][iI][nN][kK]" utf-8-dos . gbk-dos)
               ("[cC][mM][dD][pP][rR][oO][xX][yY]" utf-8-dos . gbk-dos)
               ))

(defun counsel-locate-coding (orig-fun &rest args)
  (let ((process-coding-system-alist '(
               ("[pP][lL][iI][nN][kK]" undecided-dos . gbk-dos)
               ("[cC][mM][dD][pP][rR][oO][xX][yY]" undecided-dos . gbk-dos)
               )))
    (apply orig-fun args)))

(advice-add 'counsel-locate :around #'counsel-locate-coding)

(setenv "LC_ALL" "zh_CN.UTF-8")
(setenv "LANG" "zh_CN.UTF-8")

; 设置成utf-8不行,默认的编码是euc-cn
; (set-clipboard-coding-system 'utf-8)
(set-clipboard-coding-system 'euc-cn)
;; 下面这一段也能解决问题,但是上面就够了。
;; 解决剪切板乱码问题(https://emacs-china.org/t/windows-emacs/17115/3)
; (if (eq system-type 'windows-nt)
; 	(progn
; 	  ;; (setq selection-coding-system 'utf-16le-dos) ;; 修复从网页剪切文本过来时显示 \nnn \nnn 的问题
; 	  ;; (set-default selection-coding-system 'utf-16le-dos)
; 	  (set-selection-coding-system 'utf-16le-dos) ;; 别名set-clipboard-coding-system
; 	  )
;   (set-selection-coding-system 'utf-8))


;; 不用设置代理
; (setq url-proxy-services
;    '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;      ("http" . "xx.xx.xx:8080")
;      ("https" . "xx.xx.xx:8080")))
; (setq url-http-proxy-basic-auth-storage
;     (list (list "xx.xx.xx:8080"
;                 (cons "Input your LDAP UID !"
;                       (base64-encode-string "xxxx:254%2a%23%3Fxxxx")))))


(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; pasteex-mode 这个包是手动安装的
;; :TODO: git相关的插件处理和中文名相关的时候好像有问题，无法正确处理
(defvar my-package-list '(
                          find-file-in-project 
                          which-key 
                          elscreen 
                          counsel
                          ivy 
                          helm
                          all-the-icons-nerd-fonts 
                          all-the-icons 
                          neotree 
                          whitespace-cleanup-mode 
                          highlight-symbol
                          corfu
                          evil-surround
                          zim-wiki-mode
                          imenu-list
                          markdown-mode
                          evil
                          impatient-mode
                          flymake-shellcheck
                          counsel-etags
                          evil-search-highlight-persist
                          evil-visualstar
                          projectile-ripgrep
                          auto-complete
                          yasnippet
                          popup
                          ac-etags
                          undo-fu
                          magit
                          diff-hl
                          git-gutter+
                          evil-visual-mark-mode
                          rainbow-delimiters
                          evil-lion
                          evil-commentary
                          expand-region
                          vdiff
                          vdiff-magit
                          evil-matchit
                          modus-themes
                          ggtags
                          w32-browser
                          spaceline
                          helm-rg
                          helm-projectile
                          citre
                          winum
                          symbol-overlay
                          ))

(dolist (package my-package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; TAB替换为4个空格,但是perl文件不要替换
;; 默认情况下，将TAB替换为4个空格
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; 大小写字母和下划线作为一个整体
; (global-subword-mode 1)

;; 自动加载文件变化
(global-auto-revert-mode t)

;; 安装主题
(require 'modus-themes)
(load-theme 'modus-operandi t) ;; 或者 'modus-vivendi


(require 'evil)
(evil-mode 1)

;; 开启全词搜索(不然下划线会认为不是单词一部分)
(setq evil-symbol-word-search t)

(require 'spaceline-config)
(spaceline-spacemacs-theme)


;; gtags模式(:TODO:目前发现一个问题是无法自动加载,需要手动去激活)
;; 如果想跟踪软链接目录,可以写个脚本更新项目根目录下的gtags.files文件
(ggtags-mode 1)

;; 启动和切换ggtags模式
(evil-define-key 'normal global-map (kbd "\\g") 'ggtags-mode)

;; 设置其它语言标签的生成器
;; :TODO: 这个东西也支持ctags(https://github.com/leoliu/ggtags)
;;        空了可以研究下
(setenv "GTAGSLABEL" "native-pygments")
(setenv "GTAGSCONF" "C:/Users/pc/AppData/Roaming/.emacs.d/bin/gtags.conf")


;; 隐藏工具栏
(tool-bar-mode -1)

;; matchit
(require 'evil-matchit)
(global-evil-matchit-mode 1)

;; 智能滚动条===={
;; 隐藏水平滚动条
(horizontal-scroll-bar-mode -1)
; (global-yascroll-bar-mode 1)   ;; 暂时不用这个，用系统的滚动条
(add-to-list 'default-frame-alist '(scroll-bar-width . 18))
;; 智能滚动条====}


;; 打开vim标记
(require 'evil-visual-mark-mode)
(evil-visual-mark-mode)


;; 打开所有的vim标记列表
(evil-define-key 'normal global-map (kbd "\\sm") 'counsel-evil-marks)


;; 对于perl-mode，保留TAB
(add-hook 'perl-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode t)))



;; shell文件就打开shell_check
(add-hook 'sh-mode-hook 'flymake-mode)
(add-hook 'bash-ts-mode-hook 'flymake-mode)
(add-hook 'sh-mode-hook 'flymake-shellcheck-load)
(add-hook 'bash-ts-mode-hook 'flymake-shellcheck-load)



;; 开启全局行号显示
(global-display-line-numbers-mode t)
;; 设置行号类型为相对行号
(setq display-line-numbers-type 'relative)

;; 让滚动条更平滑(有像素滚动，这个没有必要使用了)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; 鼠标滚轮滚动一行
;; (setq mouse-wheel-progressive-speed nil) ;; 不加速滚动
;; (setq mouse-wheel-follow-mouse 't) ;; 滚动鼠标下的窗口
;; (setq scroll-step 1) ;; 键盘滚动一行

;; 设置默认字体
; 微软雅黑 PragmataPro Mono 这字体不支持斜体
(set-face-attribute 'default nil :font (font-spec :family "微软雅黑 PragmataPro Mono" :size 22))

;; buffer修改后标题显示一个点号
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))
        (:eval (if (buffer-modified-p)
                   " •"))
        " Emacs"))

;; 80的地方显示竖线(:TODO: 80和120同时显示暂时没有找到实现)
(setq-default fill-column 80) ;; M-x set-fill-column RET
(setq-default display-fill-column-indicator-character ?\u2502) ;; 使用 unicode 竖线
 ;; 设置竖线颜色为红色
(add-hook 'after-init-hook 'global-display-fill-column-indicator-mode)
;; 设置 fill-column-indicator 的前景色为灰色
(set-face-attribute 'fill-column-indicator nil :foreground "gray")

;; 开启像素级滚动
(pixel-scroll-precision-mode 1)
;; 设置像素滚动的精度（默认为 1）
(setq pixel-dead-time 0)
(setq pixel-resolution-fine-flag t)

;; ;; 中文字符的列宽有问题
;; (require 'whitespace)
;; (setq whitespace-line-column 80) ;; limit line length
;; (setq whitespace-style '(face lines-tail))
;; 
;; (set-face-attribute 'whitespace-line nil
;;                     :background "gray"
;;                     :foreground "white"
;;                     :weight 'bold)
;; 
;; (add-hook 'after-init-hook 'global-whitespace-mode)

;; 选择所有的文本
(global-set-key (kbd "C-a") 'mark-whole-buffer)

;; 使用系统剪切板
(setq x-select-enable-clipboard t)
;; 复制文本
(global-set-key (kbd "C-c c") 'kill-ring-save)
;; 剪切文本
(global-set-key (kbd "C-c x") 'kill-region)
;; 粘贴文本
(global-set-key (kbd "C-c v") 'yank)

;; 复制文本
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
;; 粘贴文本
;; (global-set-key (kbd "C-S-v") 'clipboard-yank)

(defun my-yank-replace-selection ()
  "Delete the selection and yank clipboard contents."
  (interactive)
  (when (region-active-p)
    (delete-region (region-beginning) (region-end)))
  (clipboard-yank))

(global-set-key (kbd "C-S-v") 'my-yank-replace-selection)


;; 粘贴文本
(global-set-key (kbd "C-S-x") 'clipboard-kill-region)
;; 如果要粘贴到evil的命令行需要使用 M-y命令


(evil-define-key 'motion evil-ex-search-keymap (kbd "C-S-c") 'clipboard-kill-ring-save)
(evil-define-key 'motion evil-ex-search-keymap (kbd "C-S-v") 'clipboard-yank)
(evil-define-key 'motion evil-ex-search-keymap (kbd "C-S-x") 'clipboard-kill-region)




;; Evil和emacs切换
(global-set-key (kbd "C-c C-z") 'evil-emacs-state)




;; 开启括号自动补全
(electric-pair-mode 1)
(setq electric-pair-pairs
      '(
        (?< . ?>) ;; 添加尖括号补齐
        (?\' . ?\') ;; 单引号
        (?\" . ?\") ;; 双引号
        (?~ . ?~) ;; 删除线
        (?* . ?*) ;; 斜体
        (?` . ?`) ;; 内联代码
        ))



;; 光标不要闪烁
(blink-cursor-mode 0)





;; 重新映射窗口分屏
(evil-define-key 'normal global-map (kbd "\\vv") 'split-window-right)
(evil-define-key 'normal global-map (kbd "\\ss") 'split-window-below)
(evil-define-key 'normal global-map (kbd "\\cw") 'delete-window)
(evil-define-key 'normal global-map (kbd "\\ow") 'delete-other-windows)
(evil-define-key 'normal global-map (kbd "C-S-h") 'evil-window-left)
(evil-define-key 'normal global-map (kbd "C-S-l") 'evil-window-right)
(evil-define-key 'normal global-map (kbd "C-S-j") 'evil-window-down)
(evil-define-key 'normal global-map (kbd "C-S-k") 'evil-window-up)

;; 定义向前和向后跳转
(evil-define-key 'normal global-map (kbd "C-i") 'evil-jump-forward)



;; 修正Evil的单词边界问题(:TODO:暂时不修复,因为修复可能有别的问题)
;; 当前emacs把_下划线作为单词边界


;; 默认显示图片
(setq org-startup-with-inline-images t)
;; markdown默认显示图片
(add-hook 'markdown-mode-hook 'markdown-toggle-inline-images)

;; 在markdown的表格中C-x C-d 自动对齐表格

;; markdown 切换标签的显示与隐藏
(evil-define-key 'normal markdown-mode-map (kbd "zi") 'markdown-toggle-markup-hiding)

;; :TODO: 流畅播放gif,还有一帧一帧播放

;; markdown内嵌字体修改
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:family "微软雅黑 PragmataPro Mono"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "purple"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "pink"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "brown"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "gray")))))


;; 打开按键帮助
(use-package which-key
  :ensure t
  :init
  (which-key-mode))


;; markdown文件默认打开目录导航栏
(global-set-key (kbd "<f4>") 'imenu-list-smart-toggle)


;; 使用zim-wiki-mode
; (require 'zim-wiki-mode)

;; 直接粘贴图像,这里的地址当前写死了,后面优化
;; :TODO: 当前不支持有中文的路径名啊
;; (add-to-list 'load-path (expand-file-name "C:/Users/q00208337/AppData/Roaming/.emacs.d/elisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
(require 'pasteex-mode)
;; 已经在环境变量中，不需要指定绝对路径
;; (setq pasteex-executable-path "D:/programs/emasc/bin/PasteEx.exe")
; (setq pasteex-macos-executable-path "D:/img/demo.png")
(setq pasteex-image-dir "img/")
(global-set-key (kbd "C-c p j") 'pasteex-image)
(global-set-key (kbd "C-c p x") 'pasteex-delete-img-link-and-file-at-line)

;; 删除图片

;; 更新图片显示
(evil-define-key 'normal markdown-mode-map (kbd "z p") 'markdown-display-inline-images)
;; 切换图片显示
(evil-define-key 'normal markdown-mode-map (kbd "z k") 'markdown-toggle-inline-images)


;; Evil-surround
(unless (package-installed-p 'evil-surround)
  (package-install 'evil-surround))
(require 'evil-surround)
(global-evil-surround-mode 1)


;; 重做 撤销
;; :TODO: 以后还可以考虑使用vundo,听说更好用

(require 'undo-fu)
(define-key evil-normal-state-map (kbd "C-z") 'undo-fu-only-undo)
(define-key evil-normal-state-map (kbd "C-y") 'undo-fu-only-redo)

;; 保存文件和即时搜索对调
(define-key evil-normal-state-map (kbd "C-s") 'save-buffer)
(define-key evil-normal-state-map (kbd "C-x C-s") 'isearch-forward)

;; 所有的临时文件保存到固定文件目录
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d/auto-save-list/" t)))
; (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
; (setq undo-tree-auto-save-history t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))


;; (require 'corfu)
;; 
;; (use-package corfu
;;   :ensure t
;;   :hook (after-init . corfu-global-mode)
;;   :custom
;;   (corfu-cycle t)
;;   (corfu-auto t)
;;   (corfu-quit-no-match t)
;;   (corfu-echo-documentation nil))


;; (add-hook 'after-init-hook 'global-company-mode)
;; 
;; 
;; (with-eval-after-load 'company
;;   (define-key evil-insert-state-map (kbd "C-n") 'company-complete))
;; 
;; ;; buffer中的单词补全
;; (with-eval-after-load 'company
;;   (add-to-list 'company-backends 'company-dabbrev))
;; ;; 补全是要区分大小写的
;; (setq company-dabbrev-ignore-case nil)
;; (setq company-dabbrev-downcase nil)
;; ;; 两个字符开始补全
;; (setq company-minimum-prefix-length 2)
;; 
;; ;; 配置etags补全源
;; (require 'company)



;; :TODO: 使用citre补全框架和代码浏览框架(ctags和GUN Global更强大)

;; 暂时用不着lsp功能
; ;; Eglot(Tools->Eglot)
; ;; :TODO: 研究Eglot的对应补全和其它功能
; (require 'eglot)
; (add-hook 'python-mode-hook 'eglot-ensure)
; ;; :TODO: 为什么是这个？后面学习
; (add-hook 'python-ts-mode-hook 'eglot-ensure)
; (add-hook 'c-mode-common-hook 'eglot-ensure)
; (add-hook 'c-ts-mode-hook 'eglot-ensure)


;; ================================
(require 'auto-complete-config)
(require 'yasnippet)
(ac-config-default)
(global-auto-complete-mode t)
(add-to-list 'ac-modes 'markdown-mode)
(add-to-list 'ac-modes 'perl-mode)
(add-to-list 'ac-modes 'c-mode-common-mode)
(add-to-list 'ac-modes 'c-mode)
(add-to-list 'ac-modes 'c-ts-mode)
(add-to-list 'ac-modes 'python-mode)
(add-to-list 'ac-modes 'python-ts-mode)
(add-to-list 'ac-modes 'sh-mode)
;; C-h v major-mode 查看当前主模式
(add-to-list 'ac-modes 'bash-ts-mode)



;; :TODO: 这里可能能这样简化
; (defun auto-complete-mode-maybe ()
;   "No maybe for you. Only AC!"
;   (unless (minibufferp (current-buffer))
;     (auto-complete-mode 1)))
; (global-auto-complete-mode t)




;; :TODO: 这个不起作用
;; :TODO: auto-complete-clangd




(require 'popup)
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 0.5)


;; (yas/global-mode 1)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(setq yas-snippet-dirs '("~/.emacs.d/snippets"))

(add-to-list 'ac-sources 'ac-source-words-in-buffer)
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)

(add-hook 'markdown-mode-hook 'yas-minor-mode)



;; 解决引号中的补全问题(使用emacs默认自带的补全)
;; (global-set-key (kbd "C-u") 'dabbrev-expand)
(require 'dabbrev)
;; 不区分大小写搜索 :TODO: 设置了也没有用,后面再看下
(setq dabbrev-case-fold-search t)
(setq dabbrev-upcase-means-case-search nil)

;; :TODO: 这两个设置两也没用,dabbrev-completion还是只在当前缓冲区中搜索
(setq dabbrev-check-all-buffers t)
(setq dabbrev-check-other-buffers t)

;; 没有弹出菜单，但是可以在所有的缓冲区中查找
(global-set-key (kbd "C-M-u") 'hippie-expand)
;; 有弹出菜单，只能在当前缓冲区中查找
(global-set-key (kbd "C-u") 'dabbrev-completion)


(define-key minibuffer-local-map (kbd "C-n") 'next-history-element)
(define-key minibuffer-local-map (kbd "C-p") 'previous-history-element)


;; # -*- mode: snippet -*-
;; # name: snippet3
;; # key: snippet-key3
;; # contributor: This snippet inserts a printf function.
;; # yas notes start
;; this x
;; thi s y
;; # yas notes end
;; # --
;; this is my sin 3?
;; # yas notes start 和 # yas notes end是注释的内容
;; :TODO: *YASnippet Documentation* 临时buffer无法自动关闭
;; :TODO: 补全特殊颜色不知道如何设定
;; :TODO: 文档长的情况是分两种,短的显示在弹窗中,长的显示在临时buffer中
;; :TODO: 公共的代码片段放哪里?
;; :TODO: 某些语言双引号中无法补全
(defun yas-documentation (key)
  "Get the documentation for a snippet with KEY."
  (let* ((template (yas-lookup-snippet key))
         (template-file (when template (yas--template-get-file template))))
    (when template-file
      (with-temp-buffer
        (insert-file-contents template-file)
        (goto-char (point-min))
        (when (re-search-forward "^# yas notes start$" nil t)
          (let ((start (progn (forward-line 1) (point))))
            (when (re-search-forward "^# yas notes end$" nil t)
              (forward-line -1)
              (let* ((end (line-end-position))
                     (notes (buffer-substring-no-properties start end))
                     (line-count (count-lines start end)))
                (if (> line-count 15)
                    (progn
                      (with-output-to-temp-buffer "*YASnippet Documentation*"
                        (princ notes))
                      notes)
                  notes)))))))))

(setq ac-source-yasnippet
  '((candidates . (lambda ()
                    (all-completions ac-target (mapcar 'yas--template-key (yas--all-templates (yas--get-snippet-tables))))))
    (document . yas-documentation)
    (symbol . " [snip]")
    (action . yas-expand)))


(require 'ac-etags)
(eval-after-load "etags"
  '(progn
      (ac-etags-setup)))

;; 下面这些设置好像都没有作用===={
;; (add-hook 'perl-mode-hook 'ac-etags-ac-setup)
;; ;; M-x visit-tags-table 开启tags补全
;; (add-hook 'python-mode-hook 'ac-etags-ac-setup)
;; (add-hook 'python-ts-mode-hook 'ac-etags-ac-setup)
;; (add-hook 'c-ts-mode-hook 'ac-etags-ac-setup)
;; (add-hook 'bash-ts-mode-hook 'ac-etags-ac-setup)
;; ==============================}

;; 重新加载tags文件的变化用于补全
(define-key evil-normal-state-map (kbd "\\aecc") 'ac-etags-clear-cache)

(defun add-custom-ac-sources ()
  (add-to-list 'ac-sources 'ac-source-yasnippet)
  (add-to-list 'ac-sources 'ac-source-etags)
  (add-to-list 'ac-sources 'ac-source-words-in-buffer)
  (add-to-list 'ac-sources 'ac-source-gtags))


(add-hook 'markdown-mode-hook 'add-custom-ac-sources)

;; :TODO:搞清楚为什么这个模式才是对的
(add-hook 'c-ts-mode-hook 'add-custom-ac-sources)
(add-hook 'c-mode-common-mode-hook 'add-custom-ac-sources)
(add-hook 'perl-mode-hook 'add-custom-ac-sources)
(add-hook 'sh-mode-hook 'add-custom-ac-sources)
(add-hook 'bash-ts-mode-hook 'add-custom-ac-sources)
(add-hook 'python-mode-hook 'add-custom-ac-sources)
(add-hook 'python-ts-mode-hook 'add-custom-ac-sources)




;;  ================================



  
;; 高亮光标下的符号
; (require 'highlight-symbol)
; ;; :TODO: 星号搜索不跳转当前不行(目前的实现方法都不优雅)
; (evil-define-key 'normal global-map (kbd "#") 'highlight-symbol)
; (evil-define-key 'normal global-map (kbd "<f3>") 'highlight-symbol-next)
; (evil-define-key 'normal global-map (kbd "S-<f3>") 'highlight-symbol-prev)
; (evil-define-key 'normal global-map (kbd "M-<f3>") 'highlight-symbol-query-replace)
; (evil-define-key 'normal global-map (kbd "\\hx") 'highlight-symbol-remove-all)

;; :TODO: 星号搜索不跳转当前不行(目前的实现方法都不优雅)
(evil-define-key 'normal global-map (kbd "#") 'symbol-overlay-put)
;; 下面这个绑定似乎没有效果
(evil-define-key 'visual global-map (kbd "#") 'symbol-overlay-put)
(evil-define-key 'normal global-map (kbd "<f3>") 'symbol-overlay-switch-forward)
(evil-define-key 'normal global-map (kbd "S-<f3>") 'symbol-overlay-switch-backward)
(evil-define-key 'normal global-map (kbd "M-<f3>") 'symbol-overlay-mode)
(evil-define-key 'normal global-map (kbd "\\hx") 'symbol-overlay-remove-all)


;; 安装文件浏览器(all-the-icons)
(use-package neotree
  :ensure t
  :init
  (setq neo-window-fixed-size nil
        neo-theme (if (display-graphic-p) 'icons 'arrow))
  :bind
  ("<f8>" . neotree-toggle))

;; ;; 设置neotree的手动刷新
(evil-define-key 'normal neotree-mode-map (kbd "\\nr") 'neotree-refresh)


;; avy的超级跳转功能(https://github.com/abo-abo/avy)
(use-package avy
  :ensure t
  :bind
  ("M-g f" . avy-goto-line))

;; 跳转到一个单词
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-;") 'avy-goto-word-0))


;; 使用ivy搜索框架
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :hook (after-init . ivy-mode))

(define-key evil-normal-state-map (kbd "\\sw") 'swiper)


;; 配置helm搜索
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (setq helm-autoresize-mode t))

(global-set-key (kbd "M-x") 'helm-M-x)


;; 文件查找
(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))

;; 用fd替换fzf(:TODO:当前遇到问题无法搜索)
;; (setq counsel-fzf-cmd "fd --type f --hidden --follow --exclude .git --color never '%s'")

;; 标签页的映射
;; 关闭其它标签页不要提醒


;; :TODO: 某些映射有点问题,后面定位
;; :TODO: 标签页修改后希望标题多显示一个*号标识
(require 'elscreen)
(elscreen-start)
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "tc") 'elscreen-kill)
  (define-key evil-normal-state-map (kbd "tn") 'elscreen-create)
  (define-key evil-normal-state-map (kbd "TAB") 'elscreen-next)
  (define-key evil-normal-state-map (kbd "<S-tab>") 'elscreen-previous))

;; 数字键切换标签页
(with-eval-after-load 'evil
  (dotimes (i 10)
    (define-key evil-normal-state-map (kbd (format "M-%d" i)) `(lambda () (interactive) (elscreen-goto ,i)))))
    
;; 关闭其它标签页不要提醒
(defun my-elscreen-kill-others ()
  "Kill all screens except for the current one, without confirmation."
  (interactive)
  (dolist (screen (delq (elscreen-get-current-screen) (elscreen-get-screen-list)))
    (elscreen-kill-internal screen))
  (elscreen-display-screen-name-list)  ;; 刷新 ElScreen 的状态
  (elscreen-notify-screen-modification 'force-immediately)) ;; 马上更新绘图

(evil-define-key 'normal global-map (kbd "to") 'my-elscreen-kill-others)

;; 不存显示标签栏
(setq elscreen-display-tab nil)
;; 切换标签栏的显示与关闭
(defun toggle-elscreen-tab-display ()
  (interactive)
  (setq elscreen-display-tab (not elscreen-display-tab))
  (elscreen-notify-screen-modification 'force-immediately))
(define-key evil-normal-state-map (kbd "\\se") 'toggle-elscreen-tab-display)



;; 项目中搜索
;; 在一个没有项目文件(.git .root)的目录中就可以指定目录进行搜索
(define-key evil-normal-state-map (kbd "C-p") 'project-find-file)
;; 还有个更简单的方式是使用M-x cd命令改变工作目录然后运行C-p即可



;; 打开上次关闭的缓冲区(这个增加启动时间,屏蔽)
;; (require 'desktop)
;; (desktop-save-mode 1)
;; (add-to-list 'desktop-locals-to-save 'evil-markers-alist)

;; gun global工具相关链接(https://www.gnu.org/software/global/links.html)
;; 设置etags自动更新
(require 'counsel-etags)
;; 普通模式
(evil-define-key 'normal 'global (kbd "C-]") 'counsel-etags-find-tag-at-point)
;; 可视模式
(evil-define-key 'visual 'global (kbd "C-]") 'counsel-etags-find-tag-at-point)



(defun my-find-tag-other-window ()
  (interactive)
  (let ((current-window (selected-window)))
    (split-window-below)
    (select-window current-window)
    (counsel-etags-find-tag-at-point)))
;; 分屏跳转
(evil-define-key 'normal 'global (kbd "C-w ]") 'my-find-tag-other-window)
(evil-define-key 'visual 'global (kbd "C-w ]") 'my-find-tag-other-window)





;; 跳转过去,但是保持minibuffer打开的状态
(define-key completion-list-mode-map [mouse-3] 'completion-mouse-choose-completion)



(setq counsel-etags-update-interval 60)
(add-hook 'prog-mode-hook
  (lambda () (add-hook 'after-save-hook
                       'counsel-etags-virtual-update-tags 'append 'local)))


;; 自动更新
;; Don't ask before rereading the TAGS files if they have changed
(setq tags-revert-without-query t)
;; Don't warn when TAGS files are large
(setq large-file-warning-threshold nil)
;; Setup auto update now
(add-hook 'prog-mode-hook
  (lambda ()
    (add-hook 'after-save-hook
              'counsel-etags-virtual-update-tags 'append 'local)))

;; 设置排除目录
;; (with-eval-after-load 'counsel-etags
;;   ;; counsel-etags-ignore-directories does NOT support wildcast
;;   (push "build_clang" counsel-etags-ignore-directories)
;;   (push "build_clang" counsel-etags-ignore-directories)
;;   ;; counsel-etags-ignore-filenames supports wildcast
;;   (push "TAGS" counsel-etags-ignore-filenames)
;;   (push "*.json" counsel-etags-ignore-filenames))


;; 其它文件,其实通过文件夹链接更好
;; (setq counsel-etags-extra-tags-files '("/usr/include/TAGS" "/usr/local/include/TAGS"))

;; 搜索高亮
;; C-x Spc 取消高亮
(require 'highlight)
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

;; 星号不要立即跳转(:TODO:暂时有BUG)
(require 'evil-visualstar)
(global-evil-visualstar-mode t)
  

  
(defun my-click-minibuffer-item (event)
  "Click a minibuffer item without closing the minibuffer.
EVENT is the mouse event."
  (interactive "e")
  (let ((window (posn-window (event-end event)))
        (buffer (window-buffer (minibuffer-window))))
    (if (and (window-minibuffer-p window)
             (minibuffer-window-active-p window))
        (with-current-buffer buffer
          (let ((pos (posn-point (event-end event))))
            (when pos
              (goto-char pos))))
      (mouse-set-point event))))



(global-set-key [C-down-mouse-1] nil)
(global-set-key [C-mouse-1] #'my-click-minibuffer-item)

;; :TODO: C-x 的时候在命令行上会多出一个^符号出来

;; 内置的语法树,没有markdown
;; https://github.com/iquiw/emacs-tree-sitter-module-dll
;; https://github.com/iquiw/emacs-tree-sitter-module-dll/releases/tag/20240201
(use-package treesit
  :when (and (fboundp 'treesit-available-p)
             (treesit-available-p))
  :custom (major-mode-remap-alist
           '((c-mode . c-ts-mode)
             (c++-mode . c++-ts-mode)
             (cmake-mode . cmake-ts-mode)
             (conf-toml-mode . toml-ts-mode)
             (css-mode . css-ts-mode)
             (js-mode . js-ts-mode)
             (js-json-mode . json-ts-mode)
             (python-mode . python-ts-mode)
             (sh-mode . bash-ts-mode)
             (typescript-mode . typescript-ts-mode))))

;; magit :TODO: 目前使用的很多功能都感觉有问题不稳定，暂时还不知道如何使用
;; 左右分屏
(setq ediff-split-window-function 'split-window-horizontally)
;; 同步滚动
(setq ediff-scroll-vertically 'sync)
(setq ediff-scroll-horizontally 'sync)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; 书签
;; 变更一个书签就保存
(setq bookmark-save-flag 1)
(define-key evil-normal-state-map (kbd "\\ba") 'bookmark-set)
(define-key evil-normal-state-map (kbd "\\bs") 'bookmark-save)
;; (define-key evil-normal-state-map (kbd "\\bj") 'bookmark-jump)
(define-key evil-normal-state-map (kbd "\\bl") 'bookmark-bmenu-list)
(define-key evil-normal-state-map (kbd "\\bx") 'bookmark-delete)
(define-key evil-normal-state-map (kbd "\\bc") 'counsel-bookmark)
(define-key evil-normal-state-map (kbd "\\bd") 'counsel-bookmarked-directory)

;; 高亮显示git变更
(require 'diff-hl)
(global-diff-hl-mode)

;; 缓冲区git操作(方便跳转前一个hunk和后一个hunk)
;; :TODO: git hunk直接在编辑的文件中的撤销与重做
;; M-x revert-buffer 
(require 'git-gutter+)
(global-git-gutter+-mode)
(evil-define-key 'normal global-map (kbd "[[") 'git-gutter+-previous-hunk)
(evil-define-key 'normal global-map (kbd "]]") 'git-gutter+-next-hunk)

;; :TODO: eglot与auto-complete的配合(不是很容易,eglot和company-mode配合比较好)

;; 彩虹括号
(require 'cl-lib)
(require 'color)
(require 'rainbow-delimiters)

;; 调整括号显示的颜色的饱和度
(cl-loop
 for index from 1 to rainbow-delimiters-max-face-count
 do
 (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
   (cl-callf color-saturate-name (face-foreground face) 80)))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)



;; 智能对齐
(require 'evil-lion)
(evil-lion-mode)
;; glip= 等号对齐
;; 可视模式下 先选 然后 gl= 等号对齐

;; 好用的注释插件
;; gcc gc
(evil-commentary-mode)

;; 增加或者减小选区
(require 'expand-region)
(evil-define-key 'normal global-map (kbd "+") 'er/expand-region)
(evil-define-key 'normal global-map (kbd "-") 'er/contract-region)

;; 文件对比
(require 'vdiff)
; (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map)
(evil-define-key 'normal vdiff-mode-map "," vdiff-mode-prefix-map)
;; vdiff和magit的结合===={
(require 'vdiff-magit)
(define-key magit-mode-map "e" 'vdiff-magit-dwim)
(define-key magit-mode-map "E" 'vdiff-magit)
(transient-suffix-put 'magit-dispatch "e" :description "vdiff (dwim)")
(transient-suffix-put 'magit-dispatch "e" :command 'vdiff-magit-dwim)
(transient-suffix-put 'magit-dispatch "E" :description "vdiff")
(transient-suffix-put 'magit-dispatch "E" :command 'vdiff-magit)
;; 所有的变更块都显示字符级别差异
(setq vdiff-auto-refine t)

;; This flag will default to using ediff for merges.
;; (setq vdiff-magit-use-ediff-for-merges nil)

;; Whether vdiff-magit-dwim runs show variants on hunks.  If non-nil,
;; vdiff-magit-show-staged or vdiff-magit-show-unstaged are called based on what
;; section the hunk is in.  Otherwise, vdiff-magit-dwim runs vdiff-magit-stage
;; when point is on an uncommitted hunk.
;; (setq vdiff-magit-dwim-show-on-hunks nil)

;; Whether vdiff-magit-show-stash shows the state of the index.
;; (setq vdiff-magit-show-stash-with-index t)

;; Only use two buffers (working file and index) for vdiff-magit-stage
;; (setq vdiff-magit-stage-is-2way nil)


;; vdiff模式下的按键映射
(define-key evil-normal-state-map (kbd "\\vo") 'vdiff-mode)
(define-key evil-normal-state-map (kbd "\\vd") 'vdiff-magit-show-working-tree)
;; 一个commit id或者A..B对比两个(更牛逼的操作是直接在ll的git log界面中鼠标选择范围,然后dd)
(define-key evil-normal-state-map (kbd "\\vr") 'magit-diff-range)
;; 退出vdiff回到前面的界面
(define-key evil-normal-state-map (kbd "\\vq") 'vdiff-quit)
(define-key evil-normal-state-map (kbd "\\vm") 'magit)
(define-key evil-normal-state-map (kbd "\\vc") 'vdiff-magit-compare)


; , h	vdiff-hydra/body	输入 vdiff-Hydra
; , r	vdiff-receive-changes	从其他缓冲区接收更改
; , R	vdiff-receive-changes-and-step	C-c r和当时一样C-c n
; , s	vdiff-send-changes	将此更改发送到其他缓冲区
; , S	vdiff-send-changes-and-step	C-c s和当时一样C-c n
; , f	vdiff-refine-this-hunk	突出显示 hunk 中更改的单词
; , x	vdiff-remove-refinements-in-hunk	删除细化突出显示
; （没有任何）	vdiff-refine-this-hunk-symbol	根据符号进行细化
; （没有任何）	vdiff-refine-this-hunk-word	根据文字进行细化
; , F	vdiff-refine-all-hunks	突出显示更改的单词
; （没有任何）	vdiff-refine-all-hunks-symbol	根据符号细化所有内容
; （没有任何）	vdiff-refine-all-hunks-word	一切以文字为基础进行细化
; , u	vdiff-refresh	强制刷新差异
; , q	vdiff-quit	退出vdiff










;; magit的相关操作
;; magit-log-buffer-file
(define-key evil-normal-state-map (kbd "\\mlbf") 'magit-log-buffer-file)


;; vdiff和magit的结合====}

;; 当前目录下打开windows的文件浏览器
(require 'w32-browser)
(define-key evil-normal-state-map (kbd "\\of") 'w32explore)

;; 浏览器中打开远程连接
(defun git-get-current-branch-remote-url ()
  (interactive)
  (let* ((remote-branch-info (shell-command-to-string "git rev-parse --abbrev-ref --symbolic-full-name @{upstream}"))
         (remote-name-branch-name (split-string remote-branch-info "/"))
         (remote-name (nth 0 remote-name-branch-name))
         (branch-name (nth 1 remote-name-branch-name))
         (init-addr (shell-command-to-string "git config --get remote.origin.url"))
         (middle-info (replace-regexp-in-string "xxxxhub-dg-y.xxx.com:2222" "xxxxhub-y.xxx.com" init-addr))
         (middle-info (nth 1 (split-string middle-info "@")))
         (middle-info (nth 0 (split-string middle-info ".git")))
         (get-adr (concat "https://" middle-info "/files?ref=" branch-name)))
    (browse-url get-adr)))
(define-key evil-normal-state-map (kbd "\\i") 'git-get-current-branch-remote-url)

;; emacs原生支持的occur和
(defun my-occur ()
  (interactive)
  (let ((query (if (region-active-p)
                   (buffer-substring-no-properties (region-beginning) (region-end))
                 (thing-at-point 'word))))
    (deactivate-mark)
    (occur query)))

;; 直接跳到选区
(evil-define-key 'normal global-map (kbd "\\oc") 'my-occur)
(evil-define-key 'visual global-map (kbd "\\oc") 'my-occur)
;; 原始的搜索
(evil-define-key 'normal global-map (kbd "\\ooc") 'occur)

;; 自定义的项目搜索======{
(defun my-ripgrep-search-no-confirm (&optional force-current-directory manual-input)
  "Perform a ripgrep search with the current word or region, without confirmation.
If FORCE-CURRENT-DIRECTORY is non-nil, force the search in the current directory.
If MANUAL-INPUT is non-nil, prompt for the search term and directory."
  (interactive "P\nP")
  (let* ((search-term
          (if manual-input
              (read-string "Enter search term: " (if (or (evil-visual-state-p) (region-active-p))
                                                     (buffer-substring-no-properties (region-beginning) (region-end))
                                                   (thing-at-point 'word)))
            (if (or (evil-visual-state-p) (region-active-p))
                (buffer-substring-no-properties (region-beginning) (region-end))
              (thing-at-point 'word))))
         (default-directory (if manual-input
                                (read-directory-name "Enter directory: " default-directory)
                              (if force-current-directory
                                  default-directory
                                (or (locate-dominating-file default-directory ".git")
                                    (locate-dominating-file default-directory ".root")
                                    default-directory)))))
    (ripgrep-regexp search-term default-directory)))

(defun my-ripgrep-search-no-confirm-current-dir ()
  "Perform a ripgrep search with the current word or region in the current directory, without confirmation."
  (interactive)
  (my-ripgrep-search-no-confirm t))

(defun my-ripgrep-search-manual-input ()
  "Prompt for the search term and directory, and perform a ripgrep search without confirmation."
  (interactive)
  (my-ripgrep-search-no-confirm nil t))

(evil-define-key 'normal 'global (kbd "\\rg") 'my-ripgrep-search-no-confirm)
(evil-define-key 'visual 'global (kbd "\\rg") 'my-ripgrep-search-no-confirm)
(evil-define-key 'normal 'global (kbd "\\rcg") 'my-ripgrep-search-no-confirm-current-dir)
(evil-define-key 'visual 'global (kbd "\\rcg") 'my-ripgrep-search-no-confirm-current-dir)
(evil-define-key 'normal 'global (kbd "\\rmg") 'my-ripgrep-search-manual-input)
(evil-define-key 'visual 'global (kbd "\\rmg") 'my-ripgrep-search-manual-input)

;; 定制ripgrep-regexp 的rg参数(这只是一个范例)
;; :TODO: 目前无法把默认的--ignore-case参数覆盖掉，没找到方法,其它参数也有类似问题
(defun ripgrep-search-special (&optional directory)
  "Perform a ripgrep search including hidden files."
  (interactive (list (read-directory-name "Enter directory: ")))
  (let* ((default-term (if (region-active-p)
                           (buffer-substring-no-properties (region-beginning) (region-end))
                         (thing-at-point 'word))))
    (ripgrep-regexp (read-string (format "Enter search term (default \"%s\"): " default-term) nil nil default-term)
                    ;; "--hidden" "--no-ignore" "-C 5" "--heading"
                    ;; 搜索隐藏文件 显示上下文 跟踪符号链接
                    directory '("--hidden" "-C 5" "--follow"))))

(define-key evil-normal-state-map (kbd "\\rsg") 'ripgrep-search-special)
(define-key evil-visual-state-map (kbd "\\rsg") 'ripgrep-search-special)

;; find-name-dired(完整正则表达式)
(define-key evil-normal-state-map (kbd "\\fnd") 'find-name-dired)



;; 其它的字符串查找(比较卡C-j可以跳到匹配的地方,优点是有交互式的模糊搜索)
;; helm-projectile-grep
;; helm-projectile-rg无法显示数据，原因未知
(define-key evil-normal-state-map (kbd "\\hpg") 'helm-projectile-grep)
(define-key evil-visual-state-map (kbd "\\hpg") 'helm-projectile-grep)
;; 找到数据后可以按Tab键,但是跳转麻烦,作用并不明显

;; 自定义的项目搜索======}

;; 关闭除当前buffer外的所有buffer
(defun kill-other-buffers-if-saved ()
  "Kill all other buffers if they are saved and not special."
  (interactive)
  (let ((unsaved-buffers
         (delq nil
               (mapcar (lambda (buffer)
                         (and (buffer-modified-p buffer)
                              (buffer-file-name buffer)
                              (not (string-prefix-p "*" (buffer-name buffer)))
                              buffer))
                       (buffer-list)))))
    (if unsaved-buffers
        (message "Cannot kill buffers: unsaved or special buffers exist.")
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))))
(define-key evil-normal-state-map (kbd "\\kob") 'kill-other-buffers-if-saved)

;; eshell
;; 定义一个函数，用来在下面的窗口中打开eshell
(defun bottom-side-eshell ()
  "Open an eshell window in the bottom side."
  (interactive)
  (evil-window-split) ; 上下分屏
  (evil-window-down 1) ; 移动到下面的窗口
  (eshell)) ; 打开eshell

;; 定义一个函数，用来杀死eshell的buffer
(defun kill-eshell-buffer ()
  "Kill the eshell buffer."
  (interactive)
  (kill-buffer "*eshell*")) ; 杀死名为*eshell*的buffer

;; 为evil的普通模式绑定快捷键
(evil-define-key 'normal global-map (kbd "\\eo") 'bottom-side-eshell) ; \eo用来打开eshell
(evil-define-key 'normal global-map (kbd "\\ex") 'kill-eshell-buffer) ; \ex用来关闭eshell


(add-to-list 'load-path "C:/Users/pc/AppData/Roaming/.emacs.d/clue")
;; (https://github.com/AmaiKinono/clue)
(require 'clue)
(add-hook 'find-file-hook #'clue-auto-enable-clue-mode)

(evil-define-key 'normal 'global (kbd "\\ccy") 'clue-copy)
(evil-define-key 'normal 'global (kbd "\\ccp") 'clue-paste)
;; evil 下可以直接 :!diagon Tree 这种方式调用外部程序


(use-package citre
  :defer t
  :init
  ;; This is needed in `:init' block for lazy load to work.
  (require 'citre-config)
  ;; Bind your frequently used commands.  Alternatively, you can define them
  ;; in `citre-mode-map' so you can only use them when `citre-mode' is enabled.
  (evil-define-key 'normal 'global (kbd "\\cj") 'citre-jump)
  (evil-define-key 'normal 'global (kbd "\\cb") 'citre-jump-back)
  (evil-define-key 'normal 'global (kbd "\\ca") 'citre-ace-peek)
  (evil-define-key 'normal 'global (kbd "\\cp") 'citre-peek)
  (evil-define-key 'normal 'global (kbd "\\cu") 'citre-update-this-tags-file)
  (evil-define-key 'normal 'global (kbd "\\clp") 'citre-peek-paste-clue-link)
  (evil-define-key 'normal 'global (kbd "\\cly") 'citre-peek-copy-clue-link)
  
  ;; 让evil的左右键失效,这样才能使用citre-peek的左右键还有分支查看
  (define-key evil-motion-state-map (kbd "<left>") nil)
  (define-key evil-motion-state-map (kbd "<right>") nil)
  (define-key evil-motion-state-map (kbd "<up>") nil)
  (define-key evil-motion-state-map (kbd "<down>") nil)
  
  
  ; M-n, M-p: Next/prev line.                 ok
  ; M-N, M-P: Next/prev definition.           ok(如果一个定义在多个源文件中,这里可以选择我们想要的那一个,然后按M-l f把它设置为第一个，然后就可以来回跳转了)
  ; M-l j: Jump to the definition.            ok
  ; M-l p: citre-peek-through                 ok
  ; C-g: Close the peek window.               ok
  ; C-l: 光标放到中央                         ok
  ; <left>和<right> 在标记历史记录中移动
  ; S-<up>和S-<down> 上下移动定义
  ; M-l f 设定为第一个定义
  ; M-l d 删除符号后的当前分支
  ; M-l D 删除符号后的所有分支
  ; citre-peek-save-session 只在当前session有效,并不保存磁盘
  ; citre-peek-load-session 只在当前session有效,并不保存磁盘
  
  ;citre-peek-save-session
  ;citre-peek-paste-clue-link
  ;citre-peek-load-session
  ;citre-peek                    ok
  ;citre-peek-next-line          ok
  ;citre-peek-prev-line          ok
  ;citre-peek-move-current-tag-up
  ;citre-peek-move-current-tag-down
  ;citre-delete-branch
  ;citre-peek-next-tag
  ;citre-peek-prev-tag
  ;citre-peek-reference
  ;citre-jump-to-reference
  ;citre-peek-make-current-tag-first
  ;citre-peek-mode
  ;citre-peek-copy-clue-link
  ;citre-peek-next-branch
  ;citre-ace-peek-reference
  ;citre-peek-jump
  ;citre-peek-restore
  ;citre-peek-prev-branch
  ;citre-peek-abort
  ;citre-peek-chain-forward
  ;citre-peek-chain-backward
  ;citre-peek-through-reference
  ;citre-peek-delete-branches
  ;

  :config
  (setq
   ;; Set these if readtags/ctags is not in your PATH.
   citre-readtags-program "C:/Users/pc/.vim/ctags/readtags.exe"
   citre-ctags-program "C:/Users/pc/.vim/ctags/ctags.exe"
   ; 下面的设置并没有作用
   citre-tags-files '(".citre_tags")
   ;; Set these if gtags/global is not in your PATH (and you want to use the
   ;; global backend)
   ; citre-gtags-program "/path/to/gtags"
   ; citre-global-program "/path/to/global"
   ;; Set this if you use project management plugin like projectile.  It's
   ;; used for things like displaying paths relatively, see its docstring.
   ;; 这个也已经无效了
   ; citre-project-root-function #'projectile-project-root
   ;; Set this if you want to always use one location to create a tags file.
   citre-default-create-tags-file-location 'global-cache
   ;; See the "Create tags file" section above to know these options
   ;; (这个已经无效了)
   ; citre-use-project-root-when-creating-tags t
   ; 询问生成哪种语言的ctags
   citre-prompt-language-for-ctags-command t
   ;; By default, when you open any file, and a tags file can be found for it,
   ;; `citre-mode' is automatically enabled.  If you only want this to work for
   ;; certain modes (like `prog-mode'), set it like this.
   citre-auto-enable-citre-mode-modes '(prog-mode)))


;; 屏幕编号
(setq winum-keymap
    (let ((map (make-sparse-keymap)))
      ;; (define-key map (kbd "C-`") 'winum-select-window-by-number)
      ;; (define-key map (kbd "C-2") 'winum-select-window-by-number)
      (define-key map (kbd "C-0") 'winum-select-window-0-or-10)
      (define-key map (kbd "C-1") 'winum-select-window-1)
      (define-key map (kbd "C-2") 'winum-select-window-2)
      (define-key map (kbd "C-3") 'winum-select-window-3)
      (define-key map (kbd "C-4") 'winum-select-window-4)
      (define-key map (kbd "C-5") 'winum-select-window-5)
      (define-key map (kbd "C-6") 'winum-select-window-6)
      (define-key map (kbd "C-7") 'winum-select-window-7)
      (define-key map (kbd "C-8") 'winum-select-window-8)
      map))
(require 'winum)
(winum-mode)


(defun dokuwiki-header-p ()
  "Check if the current buffer starts with a DokuWiki header."
  (save-excursion
    (goto-char (point-min))
    (message "DokuWiki check enter.")
    (let ((header (buffer-substring-no-properties (point-min) (min (point-max) 1000))))
      (let ((result (and (string-match-p "Content-Type: text/x-zim-wiki" header)
                         (string-match-p "Wiki-Format: zim [0-9.]+" header)
                         )))
        (when result
          (message "DokuWiki header found."))
        result))))

(add-to-list 'auto-mode-alist '("\\.txt\\'" . (lambda ()
                                                (when (dokuwiki-header-p)
                                                  (message "Switching to DokuWiki mode.")
                                                  (dokuwiki-mode)))))

(evil-define-key 'normal global-map (kbd "\\dwx") 'dokuwiki-remove-inline-images)
(evil-define-key 'normal global-map (kbd "\\dwr") 'dokuwiki-refresh-inline-images)
(evil-define-key 'normal global-map (kbd "\\dwm") 'dokuwiki-toggle-markup-hiding)

(defun open-web-link-at-point ()
  "Open the web link under point in the default web browser."
  (interactive)
  (let ((url (thing-at-point 'url)))
    (when url
      (browse-url url))))

(evil-define-key 'normal 'global (kbd "\\wol") 'open-web-link-at-point)

(defun open-web-link-or-file-in-visual-mode ()
  "Open the web link or local file in visual mode in the default web browser or Emacs."
  (interactive)
  (let ((url (buffer-substring-no-properties (region-beginning) (region-end))))
    (when url
      (if (file-exists-p url)
          ;; If the URL is a local file, open it in Emacs
          (find-file url)
        ;; Otherwise, open it in the default web browser
        (browse-url url)))))

(evil-define-key 'visual 'global (kbd "\\wol") 'open-web-link-or-file-in-visual-mode)

(defun open-web-link-or-file-in-visual-mode-windows ()
  "Open the web link or local file in visual mode in the default web browser or the default program on Windows."
  (interactive)
  (let* ((url (buffer-substring-no-properties (region-beginning) (region-end)))
         (buffer-file-directory (file-name-directory (buffer-file-name)))
         (buffer-file-basename (file-name-base (buffer-file-name)))
         (subdir-path (concat buffer-file-directory buffer-file-basename "/" url)))
    (when url
      (if (file-exists-p url)
          ;; If the URL is a local file, open it in the default program
          (w32-shell-execute "open" (expand-file-name url))
        (if (file-exists-p subdir-path)
            ;; If the file exists in the subdirectory, open it in the default program
            (w32-shell-execute "open" (expand-file-name subdir-path))
          ;; Otherwise, open it in the default web browser
          (browse-url url))))))

(evil-define-key 'visual 'global (kbd "\\wwl") 'open-web-link-or-file-in-visual-mode-windows)



;; 通过gvim来打开当前文件
(evil-define-key 'normal 'global (kbd "\\ov")
  (lambda ()
    (interactive)
    (shell-command (concat "gvim " (buffer-file-name)))))


;; 禁用启动屏幕
(setq inhibit-startup-screen t)
;; 启用打开最近文件功能
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(setq recentf-max-saved-items 100)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(defun check-file-or-show-recent ()
  (unless (buffer-file-name)
    (recentf-open-files)))
(add-hook 'emacs-startup-hook 'check-file-or-show-recent)

