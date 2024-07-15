;;; languages.el -*- lexical-binding: t; -*-




;; debug
;; (setq gud-pdb-command-name "python -m pdb")

;;-------------------------------------------------------------------------
;;golang
(setq lsp-gopls-staticcheck t)
(setq lsp-eldoc-render-all t)
(setq lsp-gopls-complete-unimported t)
(setq lsp-gopls-codelens nil)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)


;;-------------------------------------------------------------------------
;;Python
;;(setq python-shell-virtualenv-root "~/miniconda3/envs") ;;设置虚拟环境

;; (add-hook 'python-mode-hook 'anaconda-mode)
;; (use-package conda
;;   :config
;;   (custom-set-variables
;;    '(conda-anaconda-home "~/miniconda3/"))
;;   ;; if you want interactive shell support, include:
;;   (conda-env-initialize-interactive-shells)
;;   ;; if you want eshell support, include:
;;   (conda-env-initialize-eshell)

;;   (setq conda-env-home-directory (expand-file-name "~/miniconda3/")))

;;(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)) ;; 默认使用 python-ts-mode，需要安装 python 的 treesitter
;; ;;python black
;; (after! python
;;   :preface
;;   (defun +python-make-fstring ()
;;     "Change string to fstring"
;;     (interactive)
;;     (when (nth 3 (syntax-ppss))
;;       (let ((p (point)))
;;         (goto-char (nth 8 (syntax-ppss)))
;;         (insert "f")
;;         (goto-char p)
;;         (forward-char))))
;;   (defun +python-format-buffer ()
;;     "Format python buffer with black"
;;     (interactive)
;;     (python-black-buffer))
;;   :bind
;;   (map! :map python-mode-map
;;         "C-c x s" #'+python-make-fstring
;;         "C-c x f" #'+python-format-buffer))
;; ;; pyright
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred


;; codeium.el 代码补全
;;https://github.com/Exafunction/codeium.el
;; ;; we recommend using use-package to organize your init.el
;; (use-package codeium
;;     ;; if you use straight
;;     ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
;;     ;; otherwise, make sure that the codeium.el file is on load-path

;;     :init
;;     ;; use globally
;;     (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;     ;; or on a hook
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

;;     ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions
;;     ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;     ;; an async company-backend is coming soon!

;;     ;; codeium-completion-at-point is autoloaded, but you can
;;     ;; optionally set a timer, which might speed up things as the
;;     ;; codeium local language server takes ~0.2s to start up
;;     ;; (add-hook 'emacs-startup-hook
;;     ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

;;     ;; :defer t ;; lazy loading, if you want
;;     :config
;;     (setq use-dialog-box nil) ;; do not use popup boxes

;;     ;; if you don't want to use customize to save the api-key
;;     ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

;;     ;; get codeium status in the modeline
;;     (setq codeium-mode-line-enable
;;         (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;     (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;     ;; alternatively for a more extensive mode-line
;;     ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

;;     ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;     (setq codeium-api-enabled
;;         (lambda (api)
;;             (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;     ;; you can also set a config for a single buffer like this:
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local codeium/editor_options/tab_size 4)))

;;     ;; You can overwrite all the codeium configs!
;;     ;; for example, we recommend limiting the string sent to codeium for better performance
;;     (defun my-codeium/document/text ()
;;         (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;     ;; if you change the text, you should also change the cursor_offset
;;     ;; warning: this is measured by UTF-8 encoded bytes
;;     (defun my-codeium/document/cursor_offset ()
;;         (codeium-utf8-byte-length
;;             (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;     (setq codeium/document/text 'my-codeium/document/text)
;;     (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

;; ;;elpy
;; (use-package elpy
;;   :ensure t
;;   :defer t
;;   :init
;;   (advice-add 'python-mode :before 'elpy-enable)
;;   :config
;;   (setq python-shell-interpreter "jupyter"
;;         python-shell-interpreter-args "console --simple-prompt"
;;         python-shell-prompt-detect-failure-warning nil)
;;   (add-to-list 'python-shell-completion-native-disabled-interpreters
;;                "jupyter")

;;   (when (load "flycheck" t t)
;;     (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;     (add-hook 'elpy-mode-hook 'flycheck-mode))

;;   (add-hook 'elpy-mode-hook (lambda () (elpy-shell-toggle-dedicated-shell 1)))

;;   )


;; tide
;;https://github.com/ananthakumaran/tide
;;
;;
;; (dolist (hook (list
;;                'js2-mode-hook
;;                'rjsx-mode-hook
;;                'typescript-mode-hook
;;                ))
;;   (add-hook hook (lambda ()
;;                    ;; 初始化 tide
;;                    (tide-setup)
;;                    ;; 当 tsserver 服务没有启动时自动重新启动
;;                    (unless (tide-current-server)
;;                      (tide-restart-server))
;;                    )))


;; ;;javascript
;; (add-hook 'js2-mode-hook #'setup-tide-mode)
;; ;; configure javascript-tide checker to run after your default javascript checker
;; (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)

;; (add-hook 'tsx-ts-mode-hook #'setup-tide-mode)
;; ;; if you use typescript-mode
;; (use-package tide
;;   :ensure t
;;   :after (typescript-mode company flycheck)
;;   :hook ((typescript-mode . tide-setup)
;;          (typescript-mode . tide-hl-identifier-mode)
;;          (before-save . tide-format-before-save)))


;;-----------------------------------------------------------------------------
;; ;; TypeScript
;; (defun setup-tide-mode ()
;;   (interactive)
;;   (tide-setup)
;;   (flycheck-mode +1)
;;   (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;   (eldoc-mode +1)
;;   (tide-hl-identifier-mode +1)
;;   ;; company is an optional dependency. You have to
;;   ;; install it separately via package-install
;;   ;; `M-x package-install [ret] company`
;;   (company-mode +1))

;; ;; aligns annotation to the right hand side
;; (setq company-tooltip-align-annotations t)

;; ;; formats the buffer before saving
;; (add-hook 'before-save-hook 'tide-format-before-save)

;; ;; if you use typescript-mode
;; (add-hook 'typescript-mode-hook #'setup-tide-mode)
;; ;; if you use treesitter based typescript-ts-mode (emacs 29+)
;; (add-hook 'typescript-ts-mode-hook #'setup-tide-mode)



;; ;;https://emacs-china.org/t/tide-javascript/7068

;; Javascript, Typescript and Flow support for lsp-mode
;;
;; Install:
;;
;; npm install -g typescript
;; npm install -g typescript-language-server
;;
;; Fixed error "[tsserver] /bin/sh: /usr/local/Cellar/node/10.5.0_1/bin/npm: No such file or directory" :
;;
;; sudo ln -s /usr/local/bin/npm /usr/local/Cellar/node/10.5.0_1/bin/npm
;;
;; (add-hook 'js-mode-hook #'lsp-typescript-enable)
;; (add-hook 'typescript-mode-hook #'lsp-typescript-enable) ;; for typescript support
;; (add-hook 'js3-mode-hook #'lsp-typescript-enable) ;; for js3-mode support
;; (add-hook 'rjsx-mode #'lsp-typescript-enable) ;; for rjsx-mode support

;; (defun lsp-company-transformer (candidates)
;;   (let ((completion-ignore-case t))
;;     (all-completions (company-grab-symbol) candidates)))

;; (defun lsp-js-hook nil
;;   (make-local-variable 'company-transformers)
;;   (push 'lsp-company-transformer company-transformers))

;; (add-hook 'js-mode-hook 'lsp-js-hook)



;; https://emacs.stackexchange.com/questions/29971/flycheck-eslint-for-javascript

(use-package
  js2-mode
  :ensure t
  :init
  (progn

    (add-to-list 'auto-mode-alist '("\\.js?\\'" . js-jsx-mode))
    )
  )

(use-package
  flycheck
  :ensure t
  :init
  (progn
    (add-hook 'after-init-hook #'global-flycheck-mode)
    (setq flycheck-highlighting-mode 'lines)

    ;; https://github.com/mooz/js2-mode/issues/292

    (defun setup-js2-mode ()
      (flycheck-select-checker 'javascript-eslint)
      (flycheck-mode))

    (add-hook 'js2-mode-hook #'setup-js2-mode)
    (add-hook 'js2-jsx-mode-hook #'setup-js2-mode)
    )
  )
