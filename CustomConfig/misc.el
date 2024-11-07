;;; misc.el -*- lexical-binding: t; -*-




;;-------------------------------------------------------------------------------------------
;;
;; globl settings
;;
;;-------------------------------------------------------------------------------------------
;;
;;
;; onedark theme

;; (add-to-list 'custom-theme-load-path "~/.config/doom/atom-one-dark-theme/")
;; (load-theme 'atom-one-dark t)
;; (setq doom-theme 'atom-one-dark)

;;--------------------------------------------
;;自定义滚动
;;--------------------------------------------
;;

;; (defvar expanded-cursor-size 10
;;   "Number of lines to expand above and below current line for expanded cursor.")

;; (defvar expanded-cursor-mode nil
;;   "Whether expanded-cursor-mode is enabled.")

;; (defvar cursor-region-overlay
;;   (let ((overlay (make-overlay 1 1)))
;;     (overlay-put overlay 'face '(:background "#333333"))
;;     overlay)
;;   "Overlay used to highlight the expanded cursor region.")

;; (defun expanded-cursor-region ()
;;   "Return the boundaries of expanded cursor region as (start . end) line numbers."
;;   (let* ((current-line (line-number-at-pos))
;;          (start-line (max 1 (- current-line expanded-cursor-size)))
;;          (end-line (+ current-line expanded-cursor-size)))
;;     (cons start-line end-line)))

;; (defun expanded-cursor-region-at-pos (pos)
;;   "Return the boundaries if cursor were at POS."
;;   (let* ((current-line (line-number-at-pos pos))
;;          (start-line (max 1 (- current-line expanded-cursor-size)))
;;          (end-line (+ current-line expanded-cursor-size)))
;;     (cons start-line end-line)))

;; (defun expanded-cursor-will-hit-boundary-p (delta)
;;   "Check if moving by DELTA lines will cause the expanded region to hit window boundaries."
;;   (let* ((target-pos (save-excursion
;;                        (forward-line delta)
;;                        (point)))
;;          (region (expanded-cursor-region-at-pos target-pos))
;;          (start-line (car region))
;;          (end-line (cdr region))
;;          (window-start-line (line-number-at-pos (window-start)))
;;          (window-end-line (line-number-at-pos (window-end))))
;;     (or (< start-line window-start-line)
;;         (> end-line window-end-line))))

;; (defun move-expanded-cursor (delta)
;;   "Move the expanded cursor by DELTA lines, with smart scrolling."
;;   (when expanded-cursor-mode
;;     (let* ((target-pos (save-excursion
;;                          (forward-line delta)
;;                          (point)))
;;            (at-boundary (expanded-cursor-will-hit-boundary-p delta)))
;;       (when (and target-pos (> target-pos 0))
;;         (if at-boundary
;;             ;; If we'll hit a boundary, scroll the window
;;             (progn
;;               (forward-line delta)
;;               (if (< delta 0)
;;                   (scroll-down 1)
;;                 (scroll-up 1)))
;;           ;; If we won't hit a boundary, just move the cursor
;;           (forward-line delta))))))

;; (defun highlight-expanded-cursor-region ()
;;   "Highlight the expanded cursor region."
;;   (when expanded-cursor-mode
;;     (let* ((region (expanded-cursor-region))
;;            (start-line (car region))
;;            (end-line (cdr region))
;;            (start-pos (save-excursion
;;                         (goto-char (point-min))
;;                         (forward-line (1- start-line))
;;                         (point)))
;;            (end-pos (save-excursion
;;                       (goto-char (point-min))
;;                       (forward-line (1- end-line))
;;                       (end-of-line)
;;                       (point))))
;;       (move-overlay cursor-region-overlay start-pos end-pos))))

;; (defun expanded-cursor-scroll-handler (event)
;;   "Handle mouse scroll events for expanded cursor."
;;   (interactive "e")
;;   (when expanded-cursor-mode
;;     (let ((delta (if (eq (event-basic-type event) 'wheel-up) -1 1)))
;;       (move-expanded-cursor delta)
;;       (highlight-expanded-cursor-region))))

;; (define-minor-mode expanded-cursor-mode
;;   "Toggle expanded cursor mode.
;; When enabled, creates a virtual expanded cursor region (±10 lines around point).
;; Mouse scrolling will move only the cursor while the region is fully visible,
;; and will scroll the window only when the region would hit window boundaries."
;;   :init-value nil
;;   :lighter " ExpCursor"
;;   :global t
;;   (if expanded-cursor-mode
;;       (progn
;;         ;; Enable mode
;;         (add-hook 'post-command-hook 'highlight-expanded-cursor-region)
;;         ;; Override mouse wheel events
;;         (global-set-key (vector 'mouse-4) 'expanded-cursor-scroll-handler)
;;         (global-set-key (vector 'mouse-5) 'expanded-cursor-scroll-handler)
;;         ;; Handle trackpad/touch scroll events
;;         (global-set-key [wheel-up] 'expanded-cursor-scroll-handler)
;;         (global-set-key [wheel-down] 'expanded-cursor-scroll-handler)
;;         (highlight-expanded-cursor-region))
;;     ;; Disable mode
;;     (remove-hook 'post-command-hook 'highlight-expanded-cursor-region)
;;     (delete-overlay cursor-region-overlay)
;;     ;; Restore default mouse wheel behavior
;;     (global-set-key (vector 'mouse-4) nil)
;;     (global-set-key (vector 'mouse-5) nil)
;;     (global-set-key [wheel-up] nil)
;;     (global-set-key [wheel-down] nil)))

;; ;; Optional: Add customization options
;; (defcustom expanded-cursor-scroll-step 1
;;   "Number of lines to scroll for each mouse wheel movement."
;;   :type 'integer
;;   :group 'expanded-cursor)

;; ;; 定义缓冲区大小（上下各多少行）
;; (defvar smooth-scroll-margin 10
;;   "Number of lines of margin at the top and bottom of a window.")

;; ;; 定义触摸板滚动的速度倍数
;; (defvar touchpad-scroll-speed-multiplier 1
;;   "Multiplier for touchpad scroll speed, applied only to touchpad events.")

;; (defun get-scroll-margin ()
;;   "Get the effective scroll margin, accounting for window size."
;;   (min smooth-scroll-margin
;;        (/ (window-body-height) 4)))

;; (defun current-line-from-top ()
;;   "Get current line number from top of window."
;;   (count-lines (window-start) (point)))

;; (defun current-line-from-bottom ()
;;   "Get current line number from bottom of window."
;;   (count-lines (point) (window-end)))

;; (defun custom-scroll-up (&optional n)
;;   "Scroll up command with margin awareness. N is number of lines to scroll."
;;   (interactive)
;;   (let* ((margin (get-scroll-margin))
;;          (lines (or n 1)))
;;     (if (>= (current-line-from-bottom) margin)
;;         (forward-line lines)
;;       (scroll-up lines))))

;; (defun custom-scroll-down (&optional n)
;;   "Scroll down command with margin awareness. N is number of lines to scroll."
;;   (interactive)
;;   (let* ((margin (get-scroll-margin))
;;          (lines (or n 1)))
;;     (if (>= (current-line-from-top) margin)
;;         (forward-line (- lines))
;;       (scroll-down lines))))

;; ;; 定义触摸板事件处理函数，仅在触摸板滚动时应用平滑滚动
;; (defun custom-touchpad-scroll (direction)
;;   "Handle touchpad scroll with smooth scrolling. DIRECTION should be 'up or 'down."
;;   (interactive)
;;   (if (eq direction 'up)
;;       (custom-scroll-down (* touchpad-scroll-speed-multiplier 1))
;;     (custom-scroll-up (* touchpad-scroll-speed-multiplier 1))))

;; ;; 绑定键位和触摸板事件，不绑定鼠标滚轮，保留其默认行为
;; (map! :n "j" #'custom-scroll-up
;;       :n "k" #'custom-scroll-down
;;       ;; 保持鼠标滚轮的默认滚动
;;       ;; 触摸板事件 - 使用平滑滚动
;;       "<wheel-up>" (lambda () (interactive) (custom-touchpad-scroll 'up))
;;       "<wheel-down>" (lambda () (interactive) (custom-touchpad-scroll 'down)))


;;--------------------------------------------
;; modeline 里的彩虹猫！
;;--------------------------------------------
;; modeline 里的彩虹猫！
(use-package nyan-mode
  :config
  (nyan-mode 1)
  (setq mode-line-format
        (list
         '(:eval (list (nyan-create)))
         ))
  )


;;
;;取消退出确认
(setq confirm-kill-emacs nil)

;;
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (julia . t)
   (python . t)
   (js . t)
   (jupyter . t)))


;; ispell
(setq ispell-program-name "/opt/homebrew/bin/ispell")
;;
;;auto-wrap
(global-visual-line-mode 1)  ;1 for on, 0 for off.

(global-auto-revert-mode t)  ;; Automatically show changes if the file has changed

;; 开启相对行号
;; (setq display-line-numbers-type 'relative)  ;;不起作用
;;
;;
;;;;-------------------------------------------------------------------------------------------
;; 显示图片
;; https://emacs.stackexchange.com/questions/3302/live-refresh-of-inline-images-with-org-display-inline-images
;;
;; (auto-image-file-mode t)
;; (add-hook 'org-mode-hook (lambda () (org-display-inline-images t)))

;; -- Display images in org mode
;;enable image mode first
;; (iimage-mode)
;; ;; add the org file link format to the iimage mode regex
;; (add-to-list 'iimage-mode-image-regex-alist
;;              (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex "\\)\\]")  1))
;; ;;  add a hook so we can display images on load
;; (autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
;; (autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)
;; ;; function to setup images for display on load

;; ;; function to toggle images in a org bugger
;; (defun org-toggle-iimage-in-org ()
;;   "display images in your org file"
;;   (interactive)
;;   (if (face-underline-p 'org-link)
;;       (set-face-underline-p 'org-link nil)
;;     (set-face-underline-p 'org-link t))
;;   (iimage-mode))

;; https://emacs-china.org/t/org-display-inline-images/25886/4
;;https://github.com/lujun9972/emacs-document/blob/master/org-mode/%E8%AE%BE%E7%BD%AEOrg%E4%B8%AD%E5%9B%BE%E7%89%87%E6%98%BE%E7%A4%BA%E7%9A%84%E5%B0%BA%E5%AF%B8.org
;; (setq org-image-actual-width '(400)) 要在(org-toggle-inline-images)命令之前
;; 或者在文档开头加上 #+ATTR_ORG: :width 600 ，并设置(setq org-image-actual-width nil)

(setq org-startup-with-inline-images t)

(add-hook 'org-mode-hook (lambda ()
                           (setq org-image-actual-width '(400))
                           (org-toggle-inline-images)
                           (when org-startup-with-inline-images
                             (org-display-inline-images t))))



;;------------------------------------------------
;;org-remoteimg
;;-----------------------------------------
;;https://github.com/gaoDean/org-remoteimg
;;
(use-package org-remoteimg
  :load-path "~/.config/doom/org-remoteimg"
  :config
  ;; Set the cache directory for remote images
  (setq url-cache-directory "~/.config/emacs/.local/cache/url"
        org-display-remote-inline-images 'skip) ;; Default to disabling the plugin

  ;; Toggle function for enabling or disabling org-remoteimg
  (defun toggle-org-remoteimg ()
    "Toggle the `org-remoteimg` package based on its current state."
    (interactive)
    (if (eq org-display-remote-inline-images 'skip)
        (progn
          (require 'org-remoteimg) ;; Ensure the plugin is loaded
          (setq org-display-remote-inline-images 'cache) ;; Enable with caching
          (message "org-remoteimg enabled."))
      (setq org-display-remote-inline-images 'skip) ;; Disable plugin
      (message "org-remoteimg disabled."))))

;; (use-package org-remoteimg
;;   :load-path "~/.config/doom/org-remoteimg"
;;   :config
;;   ;; optional: set this to wherever you want the cache to be stored
;;   (setq url-cache-directory "~/.config/emacs/.local/cache/url")

;;   (setq org-display-remote-inline-images 'cache) ;; enable caching

;;   ;; or this if you don't want caching
;;   ;; (setq org-display-remote-inline-images 'download)

;;   ;; or this if you want to disable this plugin
;;   (setq org-display-remote-inline-images 'skip)

;;   ;; 定义一个布尔变量用于跟踪插件状态
;;   (defvar org-remoteimg-enabled t
;;     "Whether `org-remoteimg` is enabled or not.")

;;   ;; 开关函数：启用或禁用 org-remoteimg 插件
;;   (defun toggle-org-remoteimg ()
;;     "Toggle the `org-remoteimg` package."
;;     (interactive)
;;     (if org-remoteimg-enabled
;;         (progn
;;           (setq org-display-remote-inline-images 'skip) ;; 禁用插件
;;           (message "org-remoteimg disabled."))
;;       (progn
;;         (require 'org-remoteimg) ;; 确保插件加载
;;         (setq org-display-remote-inline-images 'cache) ;; 启用并启用缓存
;;         (message "org-remoteimg enabled.")))
;;     (setq org-remoteimg-enabled (not org-remoteimg-enabled))))








;;-------------------------------------------------------------------------------------------
;;输入法 https://github.com/tumashu/pyim
(setq default-input-method "system")
(global-set-key (kbd "C-\\") 'toggle-input-method)
(use-package pyim
  :init
  :config
  (pyim-default-scheme 'xiaohe-shuangpin)
  (setq default-input-method "pyim")
  ;; 设置 pyim 探针
  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  ;; pyim-probe-program-mode
                  pyim-probe-org-structure-template
                  pyim-probe-evil-normal-mode
                  ))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))
  ;; (setq pyim-dicts
  ;;       '((:name "pyim-tsinghua-dict" :file "~/.config/emacs/pyim-tsinghua-dict.pyim")))
  (add-hook 'org-mode-hook
            (lambda ()
              (toggle-input-method)
              (setq default-input-method "pyim")))
  ;; (add-hook 'emacs-startup-hook
  ;;           (lambda () (pyim-restart-1 t)))
  )

(use-package pyim-basedict
  :config
  (pyim-basedict-enable))


(use-package pyim-tsinghua-dict
  :load-path "~/.config/doom/pyim-tsinghua-dict"

  :config
  (pyim-tsinghua-dict-enable)
  )





;; sis
;; https://github.com/laishulu/emacs-smart-input-source
;; (use-package sis
;;   :hook
;;   ;; enable the /context/ and /inline region/ mode for specific buffers
;;   (((text-mode prog-mode) . sis-context-mode)
;;    ((text-mode prog-mode) . sis-inline-mode))
;;   ;; :after evil
;;   :config
;;   ;; For MacOS
;;   (sis-ism-lazyman-config
;;    ;; English input source may be: "ABC", "US" or another one.
;;    ;; "com.apple.keylayout.ABC"
;;    "com.apple.keylayout.ABC"

;;    ;; Other language input source: "rime", "sogou" or another one.
;;    ;; "im.rime.inputmethod.Squirrel.Rime"
;;    "im.rime.inputmethod.Squirrel.Hans")

;;   ;; enable the /cursor color/ mode
;;   ;;(sis-global-cursor-color-mode t)
;;   ;; enable the /respect/ mode
;;   (sis-global-respect-mode t)
;;   ;; enable the /context/ mode for all buffers
;;   ;; (sis-global-context-mode t)
;;   ;; enable the /inline english/ mode for all buffers
;;   ;; (sis-global-inline-mode t)
;;   )





;;-------------------------------------------------------------------------------------------
;; 键位绑定，解绑，转换
;; 修改默认键位映射，取消command键位
;;(setq mac-option-modifier 'meta)

;;(setq mac-command-modifier 'none)
;;(global-set-key (kbd "M-z") nil)

;;(global-unset-key (kbd "super x"))
;; 连续输入空格切换输入法
;; (defun switch-input-method ()
;;   "Switch input method using Caps Lock key via AppleScript on macOS."
;;   (interactive)
;;   (let ((script "tell application \"System Events\" to key code 57"))
;;     (shell-command (concat "osascript -e '" script "'"))))

;; ;; 绑定单个空格到 self-insert-command
;; (define-key evil-normal-state-map " " 'self-insert-command)

;; ;; 绑定连续两个空格到 switch-input-method 函数
;; (define-key evil-normal-state-map [j k] 'switch-input-method)
;; window size
;;(pushnew! initial-frame-alist '(width . 180) '(height . 55))
;; (add-hook 'window-setup-hook #'toggle-frame-maximized)
;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen)
;;
;;
;;-------------------------------------------------------------------------------------------
;;字体
;;(setq doom-font (font-spec :family "霞鹜文楷等宽" :weight 'regular :size 14))
(setq doom-font (font-spec :family "Fira Code" :weight 'light :size 13))

;; ;; Plan A: 中文苹方, 英文Roboto Mono
;; (setq doom-font (font-spec :family "Roboto Mono" :size 22)
;;       doom-serif-font doom-font
;;       doom-symbol-font (font-spec :family "LXGWWenKaiMono")
;;       doom-variable-pitch-font (font-spec :family "LXGWWenKaiMono" :weight 'regular))

;; ;; 如果不把这玩意设置为 nil, 会默认去用 fontset-default 来展示, 配置无效
;; (setq use-default-font-for-symbols nil)

;; ;; Doom 的字体加载顺序问题, 如果不设定这个 hook, 配置会被覆盖失效
;; (add-hook! 'after-setting-font-hook
;;   (set-fontset-font t 'latin (font-spec :family "Roboto Mono"))
;;   (set-fontset-font t 'symbol (font-spec :family "Symbola"))
;;   (set-fontset-font t 'mathematical (font-spec :family "Symbola"))
;;   (set-fontset-font t 'emoji (font-spec :family "Symbola")))

;;-------------------------------------------------------------------------------------------
;; 窗口大小设定
;; 霞鹜文楷等宽窗口大小
;; (if (not (eq window-system nil))
;;     (progn
;;       ;; top, left ... must be integer
;;       (add-to-list 'default-frame-alist
;;                    (cons 'top  (/ (x-display-pixel-height) 15))) ;; 调整数字设置距离上下左右的距离
;;       (add-to-list 'default-frame-alist
;;                    (cons 'left (/ (x-display-pixel-width) 6)))
;;       (add-to-list 'default-frame-alist
;;                    (cons 'height (/ (* 4 (x-display-pixel-height))
;;                                     (* 6 (frame-char-height)))))
;;       (add-to-list 'default-frame-alist
;;                    (cons 'width (/ (* 4 (x-display-pixel-width))
;;                                    (* 6 (frame-char-width)))))))

(if (not (eq window-system nil))
    (progn
      ;; top, left ... must be integer
      (add-to-list 'default-frame-alist
                   (cons 'top  (/ (x-display-pixel-height) 11))) ;; 调整数字设置距离上下左右的距离，数字越大越靠上
      (add-to-list 'default-frame-alist
                   (cons 'left (/ (x-display-pixel-width) 6))) ;;数字越大越靠左
      (add-to-list 'default-frame-alist
                   (cons 'height (/ (* 5 (x-display-pixel-height))
                                    (* 8 (frame-char-height)))))
      (add-to-list 'default-frame-alist
                   (cons 'width (/ (* 7 (x-display-pixel-width))
                                   (* 12 (frame-char-width)))))))


;; project
;;
(setq projectile-project-search-path '("~/Vandee/project/"))


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/Vandee/org/notes/")



;; shell
;; (setq shell-file-name "/opt/homebrew/bin/bash")

(custom-set-faces!
  '(aw-leading-char-face
    :foreground "white" :background "red"
    :weight bold :height 1.5 :box (:line-width 10 :color "red")))


;;dashboard
;; logo修改
(setq fancy-splash-image (concat doom-private-dir "images/鸦.png"))
(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "Lust for life")))

;;快捷栏修改 https://discourse.doomemacs.org/t/how-to-change-your-splash-screen/57
;; ref: https://discourse.doomemacs.org/t/how-to-change-your-splash-screen/57
(assoc-delete-all "Recently opened files" +doom-dashboard-menu-sections)
(assoc-delete-all "Open documentation" +doom-dashboard-menu-sections)
(assoc-delete-all "Open org-agenda" +doom-dashboard-menu-sections)
(assoc-delete-all "Jump to bookmark" +doom-dashboard-menu-sections)
(assoc-delete-all "Reload last session" +doom-dashboard-menu-sections)




(setq-default
 window-combination-resize t
 x-stretch-cursor t
 yas-triggers-in-field t
 )

(setq
 undo-limit 80000000
 auto-save-default t
 scroll-preserve-screen-position 'always
 scroll-margin 2
 word-wrap-by-category t
 all-the-icons-scale-factor 1.0
 )
(global-subword-mode t) ;; 启用 global-subword-mode 后，Emacs 会在全局范围内使用 subword-mode，这意味着在所有的缓冲区中，你都可以进行子词的导航和编辑。这在处理代码或文本时非常有用，特别是当你需要对单个字符或字符组合进行精确编辑时。
;;
;;
;;







;; (defun my-markdown-to-org ()
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (re-search-forward "^\\(#+\\) \\(.*\\)" nil t)
;;       (let ((level (length (match-string 1)))
;;             (title (match-string 2)))
;;         (replace-match (concat (make-string level ?*) " " title))))
;;     (goto-char (point-min))
;;     (while (re-search-forward "\\[\\(.*?\\)\\](\\(.*?\\))" nil t)
;;       (replace-match "[[\\2][\\1]]"))))



;; (defun my-markdown-to-org ()
;;   (interactive)
;;   (save-excursion
;;     ;; 转换Markdown标题为Org-mode标题
;;     (goto-char (point-min))
;;     (while (re-search-forward "^# \\(.*\\)" nil t)
;;       (replace-match "* \\1"))
;;     (goto-char (point-min))
;;     (while (re-search-forward "^## \\(.*\\)" nil t)
;;       (replace-match "** \\1"))
;;     (goto-char (point-min))
;;     (while (re-search-forward "^### \\(.*\\)" nil t)
;;       (replace-match "*** \\1"))
;;     (goto-char (point-min))
;;     (while (re-search-forward "^#### \\(.*\\)" nil t)
;;       (replace-match "**** \\1"))
;;     (goto-char (point-min))
;;     (while (re-search-forward "^##### \\(.*\\)" nil t)
;;       (replace-match "***** \\1"))
;;     (goto-char (point-min))
;;     (while (re-search-forward "^###### \\(.*\\)" nil t)
;;       (replace-match "****** \\1"))
;;     ;; 转换Markdown链接为Org-mode链接,但是跳过图片链接
;;     (goto-char (point-min))
;;     (while (re-search-forward "\\[\\(.*?\\)\\](\\(.*?\\))" nil t)
;;       (replace-match "[[\\2][\\1]]"))

;;     ;; 转换Markdown代码块为Org-mode代码块
;;     (goto-char (point-min))
;;     (while (re-search-forward "```\\([^`]*\\)```" nil t)
;;       (replace-match "#+begin_src\n\\1\n#+end_src"))))



;;-------------------------------------------------------------------------------------------
;;
;; packages
;;
;;-------------------------------------------------------------------------------------------

;; 获取网页标题

;; https://emacs-china.org/t/emacs-firefox-org-link/23661/18
;; https://emacs-china.org/t/org-firefox/15100/4
;; (defun chinhant-grab-mac-link ()
;;   "获得并插入 Chrome 页面的 Markdown 链接."
;;   (interactive)
;;   (insert (grab-mac-link 'safari 'org)))

;; (global-set-key (kbd "C-c m") 'chinhant-grab-mac-link)



;;aider
;;
(use-package aider
  :config
  (setq aider-args '("--model" "ollama/llama3.1"))
  (setenv "OLLAMA_API_BASE" "http://127.0.0.1:11434")
  (global-set-key (kbd "C-c a") 'aider-transient-menu)
  )


;; gptel 设置默认ollama 模型
(use-package gptel
  :defer t
  :config
  (setq
   gptel-model "qwen2.5"
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '("qwen2.5")))

  (gptel-make-ollama "Ollama"             ;Any name of your choosing
    :host "localhost:11434"               ;Where it's running
    :stream t                             ;Stream responses
    :models '("qwen2.5:latest"))           ;List of models
  )


;; evil settings

(use-package evil
  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t  ;; This is optional since it's already set to t by default.
        evil-want-keybinding nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-undo-system 'undo-redo)  ;; Adds vim-like C-r redo functionality
  (evil-mode))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t) ;;如果您想在迷你缓冲区中启用 Evil，则必须通过将 evil-collection-setup-minibuffer 自定义为 t 来显式打开它。一些与迷你缓冲区相关的软件包（例如 Helm）依赖于此选项。
  :config
  ;; Do not uncomment this unless you want to specify each and every mode
  ;; that evil-collection should works with.  The following line is here
  ;; for documentation purposes in case you need it.
  ;; (setq evil-collection-mode-list '(calendar dashboard dired ediff info magit ibuffer))
  (add-to-list 'evil-collection-mode-list 'help) ;; evilify help mode
  (defvar my-intercept-mode-map (make-sparse-keymap)
    "High precedence keymap.")

  (define-minor-mode my-intercept-mode
    "Global minor mode for higher precedence evil keybindings."
    :global t)

  (my-intercept-mode)

  (dolist (state '(normal visual insert))
    (evil-make-intercept-map
     ;; NOTE: This requires an evil version from 2018-03-20 or later
     (evil-get-auxiliary-keymap my-intercept-mode-map state t t)
     state))

  (evil-define-key 'normal my-intercept-mode-map
    (kbd "SPC n f") 'org-roam-node-find)


  (evil-collection-init))




(use-package evil-tutor)

;; Using RETURN to follow links in Org/Evil
;; Unmap keys in 'evil-maps if not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
;; Setting RETURN key in org-mode to follow links
;;(setq org-return-follows-link  t)



;; buffer
;; 折叠buffer
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")
            (setq ibuffer-hidden-filter-groups (list "Helm" "*Internal*"))
            (ibuffer-update nil t)
            )
          )



;; lsp
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred)
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-inlay-hint-enable t)
  ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; Optional - provides fancier overlays.
(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil)
  (setq
                                        ; lsp-enable-symbol-highlighting nil
                                        ; lsp-lens-enable nil
   lsp-headerline-breadcrumb-enable nil
                                        ; lsp-diagnostics-provider :none
                                        ; lsp-completion-provider :none
   lsp-ui-doc-enable nil
   lsp-ui-doc-show-with-mouse nil
   lsp-ui-doc-show-with-cursor nil
   lsp-ui-doc-header nil
   lsp-ui-doc-include-signature nil
   lsp-ui-doc-position 'at-point ;; top, bottom, or at-point
   lsp-ui-doc-max-width 120
   lsp-ui-doc-max-height 30
   lsp-ui-doc-use-childframe t
   lsp-ui-doc-use-webkit t
   lsp-ui-sideline-enable nil
   lsp-ui-sideline-show-code-actions t
   lsp-ui-sideline-show-hover nil
   lsp-ui-sideline-ignore-duplicate t
   lsp-ui-sideline-show-symbol t
   lsp-ui-sideline-show-diagnostics t
   lsp-ui-peek-enable t
   lsp-ui-peek-fontify 'on-demand ;; never, on-demand, or always
   lsp-ui-imenu-enable t
   lsp-ui-imenu-kind-position 'top)
  :preface
  (defun +toggle-lsp-ui-doc ()
    (interactive)
    (if lsp-ui-doc-mode
        (progn
          (lsp-ui-doc-mode -1)
          (lsp-ui-doc-hide))
      (progn
        (lsp-ui-doc-mode 1)
        (lsp-ui-doc-show))
      ))
  )




(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode t)
  :config
  (remove-hook 'text-mode-hook 'flyspell-mode)
  (remove-hook 'org-mode-hook 'flyspell-mode)

  )


;; which-key  https://emacs-china.org/t/doom/13654/5
(use-package which-key
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-allow-imprecise-window-fit nil
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit nil
        which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.01
	which-key-separator " → " ))


;; ivy
;; (use-package counsel
;;   :after ivy
;;   :diminish
;;   :config
;;   (counsel-mode)
;;   (setq ivy-initial-inputs-alist nil)) ;; removes starting ^ regex in M-x

;; (use-package ivy
;;   :bind
;;   ;; ivy-resume resumes the last Ivy-based completion.
;;   (("C-c C-r" . ivy-resume)
;;    ("C-x B" . ivy-switch-buffer-other-window))
;;   :diminish
;;   :custom
;;   (setq ivy-use-virtual-buffers t)
;;   (setq ivy-count-format "(%d/%d) ")
;;   (setq enable-recursive-minibuffers t)
;;   :config
;;   (ivy-mode))



;;neotree
(use-package neotree
  :config
  (setq neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 55
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action)
  ;; truncate long file names in neotree
  (add-hook 'neo-after-create-hook
            #'(lambda (_)
                (with-current-buffer (get-buffer neo-buffer-name)
                  (setq truncate-lines t)
                  (setq word-wrap nil)
                  (make-local-variable 'auto-hscroll-mode)
                  (setq auto-hscroll-mode nil)))))


(use-package company
  :defer 0.1
  :config
  (global-company-mode t)
  (setq-default
   company-idle-delay 0.05
   company-require-match nil
   company-minimum-prefix-length 2

   ;; get only preview
   company-frontends '(company-preview-frontend)
   ;; also get a drop down
   ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   ))



;; (use-package! lsp-bridge
;;   :config
;;   (setq lsp-bridge-enable-log nil))


;;corfu
;;
(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-scroll-margin 7)        ;; Use scroll margin
  ;;:bind
  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode)
  ;; :custom
  ;; (orderless-define-completion-style orderless-fast
  ;;   (orderless-style-dispatchers '(orderless-fast-dispatch))
  ;;   (orderless-matching-styles '(orderless-literal orderless-regexp)))

  :config
  (setq corfu-count 10)
  (keymap-set corfu-map "RET" `( menu-item "" nil :filter
                                 ,(lambda (&optional _)
                                    (and (derived-mode-p 'eshell-mode 'comint-mode)
                                         #'corfu-send))))
  (add-hook 'eshell-mode-hook
            (lambda ()
              (setq-local corfu-auto nil)
              (corfu-mode)))

  (setq global-corfu-minibuffer
        (lambda ()
          (not (or (bound-and-true-p mct--active)
                   (bound-and-true-p vertico--input)
                   (eq (current-local-map) read-passwd-map)))))
  )

;;A few more useful configurations...
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)
  ;; Support opening new minibuffers from inside existing minibuffers.
  ;;(enable-recursive-minibuffers t)
  ;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
  ;; try `cape-dict'.
  ;;(text-mode-ispell-word-completion nil)

  ;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
  ;; mode.  Corfu commands are hidden, since they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  ;; (setq minibuffer-prompt-properties
  ;;       '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))
  )

(use-package orderless
  :demand t
  :custom
  (orderless-define-completion-style orderless-fast
    (orderless-style-dispatchers '(orderless-fast-dispatch))
    (orderless-matching-styles '(orderless-literal orderless-regexp)))
  :config
  (setq completion-styles '(orderless partial-completion)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion)))))

  (defun orderless-fast-dispatch (word index total)
    (and (= index 0) (= total 1) (length< word 4)
         (cons 'orderless-literal-prefix word)))

  (setq-local corfu-auto        t
              corfu-auto-delay  0 ;; TOO SMALL - NOT RECOMMENDED
              corfu-auto-prefix 1 ;; TOO SMALL - NOT RECOMMENDED
              completion-styles '(orderless-fast basic))

  )




;; (use-package! tabnine
;;   :hook ((prog-mode . tabnine-mode)
;; 	 (kill-emacs . tabnine-kill-process))
;;   :config
;;   (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
;;   (tabnine-start-process)
;;   :bind
;;   (:map  tabnine-completion-map
;; 	 ("<tab>" . tabnine-accept-completion)
;; 	 ("TAB" . tabnine-accept-completion)
;; 	 ("M-f" . tabnine-accept-completion-by-word)
;; 	 ("M-<return>" . tabnine-accept-completion-by-line)
;; 	 ("C-g" . tabnine-clear-overlay)
;; 	 ("M-[" . tabnine-previous-completion)
;; 	 ("M-]" . tabnine-next-completion)))


;; https://emacs-china.org/t/mini-buffer-buffer/24542/5
;;
;; (use-package marginalia
;;   :ensure t
;;   :config
;;   (marginalia-mode))

;; (use-package embark
;;   :ensure t

;;   :bind
;;   (("C-." . embark-act)         ;; pick some comfortable binding
;;    ("C-;" . embark-dwim)        ;; good alternative: M-.
;;    ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

;;   :init

;;   ;; Optionally replace the key help with a completing-read interface
;;   (setq prefix-help-command #'embark-prefix-help-command)

;;   ;; Show the Embark target at point via Eldoc. You may adjust the
;;   ;; Eldoc strategy, if you want to see the documentation from
;;   ;; multiple providers. Beware that using this can be a little
;;   ;; jarring since the message shown in the minibuffer can be more
;;   ;; than one line, causing the modeline to move up and down:

;;   ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
;;   ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

;;   :config

;;   ;; Hide the mode line of the Embark live/completions buffers
;;   (add-to-list 'display-buffer-alist
;;                '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
;;                  nil
;;                  (window-parameters (mode-line-format . none)))))

;; ;; Consult users will also want the embark-consult package.
;; (use-package embark-consult
;;   :ensure t ; only need to install it, embark loads it after consult if found
;;   :hook
;;   (embark-collect-mode . consult-preview-at-point-mode))


;; centaur-tab  https://github.com/ema2159/centaur-tabs
;; (use-package centaur-tabs
;;   :demand
;;   :config
;;   (setq centaur-tabs-style "chamfer")
;;   (setq centaur-tabs-set-icons t)
;;   (setq centaur-tabs-gray-out-icons 'buffer)
;;   ;;(setq centaur-tabs-set-bar 'left)
;;   (centaur-tabs-mode t)
;;   ;;(centaur-tabs-headline-match)
;;   :bind
;;   ("C-<prior>" . centaur-tabs-backward)
;;   ("C-<next>" . centaur-tabs-forward))


;; (defun centaur-tabs-buffer-groups ()
;;   "`centaur-tabs-buffer-groups' control buffers' group rules.

;; Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
;; All buffer name start with * will group to \"Emacs\".
;; Other buffer group by `centaur-tabs-get-group-name' with project name."
;;   (list
;;    (cond
;;     ((or (string-equal "*" (substring (buffer-name) 0 1))
;;          (memq major-mode '(magit-process-mode
;;                             magit-status-mode
;;                             magit-diff-mode
;;                             magit-log-mode
;;                             magit-file-mode
;;                             magit-blob-mode
;;                             magit-blame-mode
;;                             )))
;;      "Emacs")
;;     ((derived-mode-p 'prog-mode)
;;      "Editing")
;;     ((derived-mode-p 'dired-mode)
;;      "Dired")
;;     ((memq major-mode '(helpful-mode
;;                         help-mode))
;;      "Help")
;;     ((memq major-mode '(org-mode
;;                         org-agenda-clockreport-mode
;;                         org-src-mode
;;                         org-agenda-mode
;;                         org-beamer-mode
;;                         org-indent-mode
;;                         org-bullets-mode
;;                         org-cdlatex-mode
;;                         org-agenda-log-mode
;;                         diary-mode))
;;      "OrgMode")
;;     (t
;;      (centaur-tabs-get-group-name (current-buffer))))))


;; org-mode realtime editor
;;
(defvar my-org-preview-file (expand-file-name "org-preview.html" "~/.config/emacs/.local/cache/")
  "用于存放 Org 文件实时预览的固定 HTML 文件路径。")

(defvar my-org-preview-active nil
  "是否正在进行 Org 文件的实时预览。")

(defun my-org-generate-html ()
  "生成当前 Org 文件的 HTML 内容。"
  (org-export-string-as (buffer-string) 'html t))

(defun my-org-preview-in-browser ()
  "更新浏览器中的 Org 文件预览。"
  (let ((html (my-org-generate-html)))
    (with-temp-file my-org-preview-file
      (insert html))))

(defun my-org-toggle-preview ()
  "手动控制 Org 文件的 HTML 预览开关。"
  (interactive)
  (if my-org-preview-active
      (progn
        (setq my-org-preview-active nil)
        (remove-hook 'after-save-hook 'my-org-preview-in-browser)
        (message "Org 预览已停止。"))
    (setq my-org-preview-active t)
    (my-org-preview-in-browser)
    (browse-url "file:///tmp/org-preview.html")
    (add-hook 'after-save-hook 'my-org-preview-in-browser)
    (message "Org 预览已启动。")))

;; 绑定快捷键，例如 C-c p
(map! :leader
      :desc "Toggle Org Preview"
      "o p" #'my-org-toggle-preview)


;;----------------------------------------------
;; org-blog
;; ----------------------------------------------
;; org-static-blog config
(setq org-static-blog-publish-title "Vandee's Blog")
(setq org-static-blog-publish-url "https://www.vandee.art/")
(setq org-static-blog-publish-directory "~/vandee/org-blog/")
(setq org-static-blog-posts-directory "~/vandee/org-blog/posts/")
(setq org-static-blog-drafts-directory "~/vandee/org-blog/drafts/")
(setq org-static-blog-enable-tags t)
(setq org-export-with-toc t)
(setq org-export-with-section-numbers nil)
(setq org-static-blog-use-preview t)
(setq org-static-blog-enable-og-tags t)
;; (setq org-static-blog-rss-max-entries 30) ;; 设置 rss 获取文章的最大数量
;; (setq org-static-blog-index-length 8) ;; 首页包含了最近几篇博客文章，显示在同一个页面上。首页上的条目数量可以通过设置 org-static-blog-index-length 来自定义。
;;        <script src=\"https://lf26-cdn-tos.bytecdntp.com/cdn/expire-1-M/vanilla-lazyload/17.3.1/lazyload.min.js\" type=\"application/javascript\" defer></script>
;; <script src=\"https://testingcf.jsdelivr.net/gh/vandeefeng/gitbox@main/codes/blogsummary.js\"></script>
(setq org-static-blog-page-header
      "<meta name=\"author\" content=\"Vandee\">
       <meta name=\"referrer\" content=\"no-referrer\">
       <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">

       <link rel=\"stylesheet\" href=\"assets/css/style.css\" type=\"text/css\"/>
       <link rel=\"stylesheet\"
             href=\"https://lf26-cdn-tos.bytecdntp.com/cdn/expire-1-M/font-awesome/6.0.0/css/all.min.css\"/>
       <link rel=\"stylesheet\"
             href=\"https://testingcf.jsdelivr.net/npm/@fancyapps/ui@4.0.12/dist/fancybox.css\"/>
       <link rel=\"icon\" type=\"image/x-icon\" href=\"/static/favicon.ico\"/>

       <script src=\"https://lf6-cdn-tos.bytecdntp.com/cdn/expire-1-M/jquery/3.6.0/jquery.min.js\" defer></script>
       <script src=\"https://testingcf.jsdelivr.net/npm/@fancyapps/ui@4.0.12/dist/fancybox.umd.js\" defer></script>
       <script src=\"https://lf3-cdn-tos.bytecdntp.com/cdn/expire-1-M/pangu/4.0.7/pangu.min.js\" defer></script>
       <script defer>
         document.addEventListener(\"DOMContentLoaded\", function () {
           pangu.spacingPage();
         });
       </script>

       <script src=\"assets/js/app.js\" defer></script>
       <script src=\"assets/js/copyCode.js\" defer></script>
       <script src=\"assets/js/search.js\" defer></script>")


;; Preamble for every page (e.g., navigation)
(setq org-static-blog-page-preamble
      (format "
      <header>
      <h1><a href=\"%s\">Vandee's Blog</a></h1>
      <nav>
      <a href=\"%s\">Home</a>
      <a href=\"https://wiki.vandee.art\">Wiki</a>
      <a href=\"archive.html\">Archive</a>
      <a href=\"tags.html\">Tags</a>
      <div id=\"search-container\">
        <input type=\"text\" id=\"search-input\" placeholder=\"Search anywhere...\">
        <i class=\"fas fa-search search-icon\"></i>
      </div>
      </nav>
      </header>"
              org-static-blog-publish-url
              org-static-blog-publish-url))

;; Postamble for every page (e.g., footer)
(setq org-static-blog-page-postamble
      "<div id=\"search-results\"></div>
      <footer>
        <p>© 2022-2024 Vandee. Some rights reserved.</p>
        <div class=\"social-links\"></div>
      </footer>

      <a href=\"#top\" aria-label=\"go to top\" title=\"Go to Top (Alt + G)\"
         class=\"top-link\" id=\"top-link\" accesskey=\"g\">
         <i class=\"fa-solid fa-angle-up fa-2xl\"></i>
      </a>

      <script>
        var mybutton = document.getElementById('top-link');
        window.onscroll = function () {
            if (document.body.scrollTop > 800 || document.documentElement.scrollTop > 800) {
                mybutton.style.visibility = 'visible';
                mybutton.style.opacity = '1';
            } else {
                mybutton.style.visibility = 'hidden';
                mybutton.style.opacity = '0';
            }
        };
      </script>")



;; Content for the front page
(setq org-static-blog-index-front-matter
      "<h1>Vandee</h1>
      <p>搞点摄影，喜欢音乐和艺术，保持热爱。</p>
      <p>如果你也喜欢王小波、李志，我们就是朋友。</p>
      <p>Stay foolish, Stay simple.</p>"
      )

(after! org-static-blog
  (defun update-post-list (&rest _)
    "Update the post list in post-list.json."
    (let* ((post-list (mapcar 'org-static-blog-get-post-url
                              (org-static-blog-get-post-filenames)))
           (json-encoding-pretty-print t)
           (json-data (json-encode post-list)))
      (with-temp-file (concat org-static-blog-publish-directory "assets/post-list.json")
        (insert json-data))
      (message "Updated post-list.json")))

  (advice-add 'org-static-blog-publish :after #'update-post-list))
