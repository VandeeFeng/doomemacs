;;; misc.el -*- lexical-binding: t; -*-




;;-------------------------------------------------------------------------------------------
;;
;; globl settings
;;
;;-------------------------------------------------------------------------------------------
;;
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

;; (add-hook 'org-mode-hook (lambda ()
;;                            (setq org-image-actual-width '(400))
;;                            (org-toggle-inline-images)
;;                            (when org-startup-with-inline-images
;;                              (org-display-inline-images t))))


;;https://github.com/gaoDean/org-remoteimg

;; optional: set this to wherever you want the cache to be stored
(setq url-cache-directory "~/.config/emacs/.local/cache/url")

(setq org-display-remote-inline-images 'cache) ;; enable caching

;; or this if you don't want caching
;; (setq org-display-remote-inline-images 'download)

;; or this if you want to disable this plugin
;; (setq org-display-remote-inline-images 'skip)





;;-------------------------------------------------------------------------------------------
;;输入法 https://github.com/tumashu/pyim
;;(setq default-input-method "system")
(global-set-key (kbd "C-\\") 'toggle-input-method)
(use-package pyim
  :init
  :config
  (setq pyim-dicts
        '((:name "dict1" :file "~/.config/doom/pyim-tsinghua-dict.pyim")))
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

  (add-hook 'org-mode-hook
            (lambda ()
              (toggle-input-method)
              (setq default-input-method "pyim")))
  (add-hook 'emacs-startup-hook
            (lambda () (pyim-restart-1 t)))
  )

(use-package pyim-basedict
  :config
  (pyim-basedict-enable))




;;-------------------------------------------------------------------------------------------
;; 键位绑定，解绑，转换
;; 修改默认键位映射，取消command键位
(setq mac-option-modifier 'meta)

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
(setq doom-font (font-spec :family "霞鹜文楷等宽" :weight 'regular :size 14))

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
(if (not (eq window-system nil))
    (progn
      ;; top, left ... must be integer
      (add-to-list 'default-frame-alist
                   (cons 'top  (/ (x-display-pixel-height) 15))) ;; 调整数字设置距离上下左右的距离
      (add-to-list 'default-frame-alist
                   (cons 'left (/ (x-display-pixel-width) 6)))
      (add-to-list 'default-frame-alist
                   (cons 'height (/ (* 4 (x-display-pixel-height))
                                    (* 6 (frame-char-height)))))
      (add-to-list 'default-frame-alist
                   (cons 'width (/ (* 4 (x-display-pixel-width))
                                   (* 6 (frame-char-width)))))))



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






;; gptel 设置默认ollama 模型
(use-package gptel
  :defer t
  :config
  (setq
   gptel-model "qwen2:7b"
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '("qwen2:7b")))

  (gptel-make-ollama "Ollama"             ;Any name of your choosing
    :host "localhost:11434"               ;Where it's running
    :stream t                             ;Stream responses
    :models '("llama3:latest"))           ;List of models
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
  :init (global-flycheck-mode))


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
(use-package counsel
  :after ivy
  :diminish
  :config
  (counsel-mode)
  (setq ivy-initial-inputs-alist nil)) ;; removes starting ^ regex in M-x

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))



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
  ;;(corfu-scroll-margin 8)        ;; Use scroll margin
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
  :custom
  (orderless-define-completion-style orderless-fast
    (orderless-style-dispatchers '(orderless-fast-dispatch))
    (orderless-matching-styles '(orderless-literal orderless-regexp)))

  :config
  (add-hook 'eshell-mode-hook
            (lambda ()
              (setq-local corfu-auto nil)
              (corfu-mode)))
  )

;;A few more useful configurations...
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
  ;; try `cape-dict'.
  ;;(text-mode-ispell-word-completion nil)

  ;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
  ;; mode.  Corfu commands are hidden, since they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package orderless
  :demand t
  :config
  (setq completion-styles '(orderless partial-completion)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion)))))

  (defun orderless-fast-dispatch (word index total)
    (and (= index 0) (= total 1) (length< word 4)
         (cons 'orderless-literal-prefix word)))

  (orderless-define-completion-style orderless-fast
    (orderless-style-dispatchers '(orderless-fast-dispatch))
    (orderless-matching-styles '(orderless-literal orderless-regexp)))

  (setq-local corfu-auto        t
              corfu-auto-delay  0 ;; TOO SMALL - NOT RECOMMENDED
              corfu-auto-prefix 1 ;; TOO SMALL - NOT RECOMMENDED
              completion-styles '(orderless-fast basic))

  )


;; ;; sis
;; ;;
;; (use-package sis
;;   ;; :hook
;;   ;; enable the /context/ and /inline region/ mode for specific buffers
;;   ;; (((text-mode prog-mode) . sis-context-mode)
;;   ;;  ((text-mode prog-mode) . sis-inline-mode))

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
;;   (sis-global-cursor-color-mode t)
;;   ;; enable the /respect/ mode
;;   (sis-global-respect-mode t)
;;   ;; enable the /context/ mode for all buffers
;;   (sis-global-context-mode t)
;;   ;; enable the /inline english/ mode for all buffers
;;   (sis-global-inline-mode t)
;;   )


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
