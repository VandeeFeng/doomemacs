;;; languages.el -*- lexical-binding: t; -*-

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


;;Python
(setq python-shell-virtualenv-root "~/miniconda3/envs") ;;设置虚拟环境
;;(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)) ;; 默认使用 python-ts-mode，需要安装 python 的 treesitter
;;python black
(after! python
  :preface
  (defun +python-make-fstring ()
    "Change string to fstring"
    (interactive)
    (when (nth 3 (syntax-ppss))
      (let ((p (point)))
        (goto-char (nth 8 (syntax-ppss)))
        (insert "f")
        (goto-char p)
        (forward-char))))
  (defun +python-format-buffer ()
    "Format python buffer with black"
    (interactive)
    (python-black-buffer))
  :bind
  (map! :map python-mode-map
        "C-c x s" #'+python-make-fstring
        "C-c x f" #'+python-format-buffer))
;; pyright
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred
