;;; chinese.el -*- lexical-binding: t; -*
;;;





;; https://github.com/tumashu/pyim
(require 'pyim)
(require 'pyim-basedict)
(require 'pyim-cregexp-utils)

;; 如果使用 popup page tooltip, 就需要加载 popup 包。
;; (require 'popup nil t)
;; (setq pyim-page-tooltip 'popup)

;; 如果使用 pyim-dregcache dcache 后端，就需要加载 pyim-dregcache 包。
;; (require 'pyim-dregcache)
;; (setq pyim-dcache-backend 'pyim-dregcache)

;; 加载 basedict 拼音词库。
(pyim-basedict-enable)

;; 将 Emacs 默认输入法设置为 pyim.
(setq default-input-method "pyim")

;; 显示 5 个候选词。
(setq pyim-page-length 5)

;; 金手指设置，可以将光标处的编码（比如：拼音字符串）转换为中文。
(global-set-key (kbd "M-j") 'pyim-convert-string-at-point)

;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp.
(define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)

;; 设置 pyim 默认使用的输入法策略，我使用全拼。
(pyim-default-scheme 'xiaohe-shuangpin)

;;(pyim-default-scheme 'quanpin)
;; (pyim-default-scheme 'wubi)
;; (pyim-default-scheme 'cangjie)

;; 设置 pyim 是否使用云拼音
;; (setq pyim-cloudim 'baidu)

;; 设置 pyim 探针
;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
;; 我自己使用的中英文动态切换规则是：
;; 1. 光标只有在注释里面时，才可以输入中文。
;; 2. 光标前是汉字字符时，才能输入中文。
;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
;; (setq-default pyim-english-input-switch-functions
;;               '(pyim-probe-dynamic-english
;;                 pyim-probe-isearch-mode
;;                 pyim-probe-program-mode
;;                 pyim-probe-org-structure-template))

;; (setq-default pyim-punctuation-half-width-functions
;;               '(pyim-probe-punctuation-line-beginning
;;                 pyim-probe-punctuation-after-punctuation))



;; 开启代码搜索中文功能（比如拼音，五笔码等）
(pyim-isearch-mode 1)


;; 让 ivy 支持拼音搜索候选项功能
(require 'pyim-cregexp-utils)

(setq ivy-re-builders-alist
      '((t . pyim-cregexp-ivy)))

;; 让 avy 支持拼音搜索
(with-eval-after-load 'avy
  (defun my-avy--regex-candidates (fun regex &optional beg end pred group)
    (let ((regex (pyim-cregexp-build regex)))
      (funcall fun regex beg end pred group)))
  (advice-add 'avy--regex-candidates :around #'my-avy--regex-candidates))

;; 让 vertico, selectrum 等补全框架，通过 orderless 支持拼音搜索候选项功能。
(defun my-orderless-regexp (orig-func component)
  (let ((result (funcall orig-func component)))
    (pyim-cregexp-build result)))

(advice-add 'orderless-regexp :around #'my-orderless-regexp)
