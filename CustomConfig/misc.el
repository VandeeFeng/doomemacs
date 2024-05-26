;;; misc.el -*- lexical-binding: t; -*-



;;-------------------------------------------------------------------------------------------
;;
;; globl settings
;;
;;-------------------------------------------------------------------------------------------

(global-auto-revert-mode t)  ;; Automatically show changes if the file has changed

;;键位绑定，解绑，转换
;; 修改默认键位映射，取消command键位
(setq mac-option-modifier 'meta)
;;(setq mac-command-modifier 'none)
;;(global-set-key (kbd "M-z") nil)

;;(global-unset-key (kbd "super x"))

;; window size
;;(pushnew! initial-frame-alist '(width . 180) '(height . 55))
;; (add-hook 'window-setup-hook #'toggle-frame-maximized)
;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen)
;;

(if (not (eq window-system nil))
    (progn
      ;; top, left ... must be integer
      (add-to-list 'default-frame-alist
                   (cons 'top  (/ (x-display-pixel-height) 15))) ;; 调整数字设置距离上下左右的距离
      (add-to-list 'default-frame-alist
                   (cons 'left (/ (x-display-pixel-width) 10)))
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


;;auto-wrap
(global-visual-line-mode 1)  ;1 for on, 0 for off.


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
;; 自定义搜索
(defun eye--build-or-regexp-by-keywords (keywords)
  "构建or语法的正则"
  (let (wordlist tmp regexp)
    (setq wordlist (split-string keywords " "))
    (dolist (word wordlist)
      (setq tmp (format "(%s)" word))
      (if regexp (setq regexp (concat regexp "|")))
      (setq regexp (concat regexp tmp)))
    regexp
    ))

(defun eye--build-and-regexp-by-keywords (keywords)
  "构建and语法的正则"
  (let (reg wlist fullreg reglist)
    (setq wlist (split-string keywords " "))
    (dolist (w1 wlist)
      (setq reg w1)
      (dolist (w2 wlist)
	(unless (string-equal w1 w2)
	  (setq reg (format "%s.*%s" reg w2))))
      (setq reg (format "(%s)" reg))
      (add-to-list 'reglist reg)
      )
    ;; 还要反过来一次
    (dolist (w1 wlist)
      (setq reg w1)
      (dolist (w2 (reverse wlist))
	(unless (string-equal w1 w2)
	  (setq reg (format "%s.*%s" reg w2))))
      (setq reg (format "(%s)" reg))
      (add-to-list 'reglist reg)
      )

    (dolist (r reglist)
      (if fullreg (setq fullreg (concat fullreg "|")))
      (setq fullreg (concat fullreg r)))

    fullreg
    ))

(defun eye/search-or-by-rg ()
  "以空格分割关键词，以or条件搜索多个关键词的内容
如果要搜索tag，可以输入`:tag1 :tag2 :tag3'
"
  (interactive)
  (let* ((keywords (read-string "Or Search(rg): "))
	 (regexp (eye--build-or-regexp-by-keywords keywords)))
    (message "search regexp:%s" regexp)
    (color-rg-search-input regexp)
    ))


(defun eye/search-and-by-rg ()
  "以空格分割关键词，以and条件搜索同时包含多个关键词的内容
如果要搜索tag，可以输入`:tag1 :tag2 :tag3'
"
  (interactive)
  (let* ((keywords (read-string "And Search(rg): "))
	 (regexp (eye--build-and-regexp-by-keywords keywords)))
    (message "search regexp:%s" regexp)
    (color-rg-search-input regexp)
    ))




;;-------------------------------------------------------------------------------------------
;;
;; markdown to org
;;
;;-------------------------------------------------------------------------------------------

;;-------------------------------------------------------------------------------------------
;;
;; packages
;;
;;-------------------------------------------------------------------------------------------

;; 获取网页标题

;; https://emacs-china.org/t/emacs-firefox-org-link/23661/18
;; https://emacs-china.org/t/org-firefox/15100/4
(defun chinhant-grab-mac-link ()
  "获得并插入 Chrome 页面的 Markdown 链接."
  (interactive)
  (insert (grab-mac-link 'safari 'org)))

(global-set-key (kbd "C-c m") 'chinhant-grab-mac-link)






;; gtpel 设置默认ollama 模型
(setq
 gptel-model "llama3:latest"
 gptel-backend (gptel-make-ollama "Ollama"
                 :host "localhost:11434"
                 :stream t
                 :models '("llama3:latest")))


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

;; rss
