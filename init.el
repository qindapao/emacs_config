

;; 默认使用Unix的UTF-8格式打开文件
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

;; 设置包源
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; 刷新包源的内容
(unless package-archive-contents
  (package-refresh-contents))

;; 需要安装的包的列表
;; markdown-mode major-mode中的markdown-mode
;; recentf 打开最近的文件
;; undo-fu undo and redo
;; imenu-list buffer中的标签导航
;; avy 类似于vim的easy-motion插件，跳转到任意位置(https://github.com/abo-abo/avy)
;; neotree 文件管理器()
;; all-the-icons neotree 需要使用的字体依赖的包
(defvar myPackages
  '(evil markdown-mode recentf undo-fu imenu-list avy neotree all-the-icons))

;; 检查是否安装
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; vim按键绑定(evil)
(require 'evil)
(evil-mode 1)
;; Evil模式和emacs模式切换 :TODO: 需要把公司中的配置同步进来



;; 文件管理区域
;; 打开最近的文件
(require 'recentf)
(recentf-mode 1)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; 文件管理器(neotree)
(require 'neotree)
(require 'all-the-icons)
(global-set-key [f8] 'neotree-toggle)
;; 在图形界面下使用icons主题，否则使用arrow主题
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))




;; 基本设置区域
;; 设置默认字体
(set-face-attribute 'default nil :font "MSYH PragmataPro Mono" :height 140)
;; 设置光标不要闪烁
(blink-cursor-mode 0)
;; 开启像素级滚动
(pixel-scroll-precision-mode 1)
;; 开启全局行号模式
(global-display-line-numbers-mode t)
;; 使用相对行号
(setq display-line-numbers-type 'relative)
;; 临时文件放置到系统的临时目录中去 :TODO: 需要看下公司中的配置

;; 保存buffer和即时搜索颠倒
(global-set-key (kbd "C-s") 'save-buffer)
;; :TODO: 这里无效
(global-set-key (kbd "C-c C-s") 'isearch-forward)

;; 设置分屏操作
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "\\vv") 'split-window-horizontally)
  (define-key evil-normal-state-map (kbd "\\ss") 'split-window-vertically)
  (define-key evil-normal-state-map (kbd "C-S-h") 'windmove-left)
  (define-key evil-normal-state-map (kbd "C-S-l") 'windmove-right)
  (define-key evil-normal-state-map (kbd "C-S-j") 'windmove-down)
  (define-key evil-normal-state-map (kbd "C-S-k") 'windmove-up)
  (define-key evil-normal-state-map (kbd "\\cw") 'delete-window)
  (define-key evil-normal-state-map (kbd "\\ow") 'delete-other-windows))

;; 文件如果被改动，显示*号或者别的符号 :TODO: 同步公司的配置



;; TAB 标签页管理() :TODO: 文件如果被改动，标签页也需要有提示，比如也可以是星号 


;; 撤销和重做(undo-fu) :TODO: 同步下公司的配置
(require 'undo-fu)
;; 因为已经被evil-emacs-state占用
(global-unset-key (kbd "C-z"))
(define-key evil-motion-state-map (kbd "C-z") nil)
(define-key evil-emacs-state-map (kbd "C-z") nil)
(global-set-key (kbd "C-z") 'undo-fu-only-undo)
(define-key evil-motion-state-map (kbd "C-y") nil)
(define-key evil-emacs-state-map (kbd "C-y") nil)
(global-set-key (kbd "C-y") 'undo-fu-only-redo)


;; conceal

;; buffer 中的标签导航(imenu-list)
(require 'imenu-list)
(require 'imenu-list)
(add-hook 'find-file-hook 'imenu-list-smart-toggle)
(global-set-key (kbd "<f4>") 'imenu-list-smart-toggle)

;; 超级跳转功能(avy)
(require 'avy)
(global-set-key (kbd "C-;") 'avy-goto-word-0)
;; 

;; treesit

;; major mode
;;  markdown-mode
;;      默认显示内联图片 :TODO: 同步公司的配置
(defun my-markdown-mode-hook ()
  (when (eq major-mode 'markdown-mode)
    (markdown-display-inline-images)))
(add-hook 'markdown-mode-hook 'my-markdown-mode-hook)

;;      图像显示于关闭
(define-key evil-normal-state-map (kbd "gc") 'markdown-toggle-inline-images)
;;      图像强制刷新
(define-key evil-normal-state-map (kbd "gi") 'markdown-display-inline-images)
;;      缩放切换
(define-key evil-normal-state-map (kbd "gm") 'markdown-toggle-markup-hiding)

;; 主动补全

;; 代码片段


;; 自动补全和代码片段结合



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(undo-fu markdown-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
