;;; chinese.el -*- lexical-binding: t; -*-

;; https://github.com/DogLooksGood/emacs-rime
(setq rime-user-data-dir "~/.config/rime/")
(use-package rime
  :ensure t
  :custom
  (default-input-method "rime")
  :bind
  (:map rime-mode-map
        ("C-`" . 'rime-send-keybinding)))


(defun rime-evil-escape-advice (orig-fun key)
  "advice for `rime-input-method' to make it work together with `evil-escape'.
        Mainly modified from `evil-escape-pre-command-hook'"
  (if rime--preedit-overlay
      ;; if `rime--preedit-overlay' is non-nil, then we are editing something, do not abort
      (apply orig-fun (list key))
    (when (featurep 'evil-escape)
      (let (
            (fkey (elt evil-escape-key-sequence 0))
            (skey (elt evil-escape-key-sequence 1))
            )
        (if (or (char-equal key fkey)
                (and evil-escape-unordered-key-sequence
                     (char-equal key skey)))
            (let ((evt (read-event nil nil evil-escape-delay)))
              (cond
               ((and (characterp evt)
                     (or (and (char-equal key fkey) (char-equal evt skey))
                         (and evil-escape-unordered-key-sequence
                              (char-equal key skey) (char-equal evt fkey))))
                (evil-repeat-stop)
                (evil-normal-state))
               ((null evt) (apply orig-fun (list key)))
               (t
                (apply orig-fun (list key))
                (if (numberp evt)
                    (apply orig-fun (list evt))
                  (setq unread-command-events (append unread-command-events (list evt))))))
              )
          (apply orig-fun (list key)))))))

(advice-add 'rime-input-method :around #'rime-evil-escape-advice)


;; 在切换输入法时首项自动上屏，这是 fcitx5-rime 等所支持的功能。 这里就以在 emacs-rime 中实现相同功能为例，说明如何使用 rime-commit1 函数。基本思路是，先自定义一个函数，功能是先使得首项自动上屏，再切换输入法； 再将这个函数绑定到某个按键组合上，来替代原本 toggle-input-method 的功能。示例配置如下：

(defun rime-commit1-and-toggle-input-method ()
  "Commit the 1st item if exists, then toggle input method."
  (interactive)
  (ignore-errors (rime-commit1))
  (toggle-input-method))

(global-set-key (kbd "C-;") #'rime-commit1-and-toggle-input-method)

;; 如果使用模式编辑，或是在一些特定的场景下需要自动使用英文，可以设 置~rime-disable-predicates~ ， rime-disable-predicates 的值是一个断言列表， 当其中有任何一个断言的值 **不是** nil 时，会自动使用英文。一个在 evil-normal-state 中、在英文字母后面以及代码中自动使用英文的例子。
(setq rime-disable-predicates
      '(rime-predicate-evil-mode-p
        rime-predicate-after-alphabet-char-p
        rime-predicate-prog-in-code-p))

;;-rime


;; smart-input https://github.com/laishulu/emacs-smart-input-source
;;(sis-ism-lazyman-config nil "rime" 'native)
;; Your English input source MAY NOT be the default one. Use command sis-get in Emacs to get the correct one.您的英文输入源可能不是默认输入源。在 Emacs 中使用命令 sis-get 来获取正确的值。
(use-package sis
  ;; :hook
  ;; enable the /context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))

  :init
  (progn
    (setq smart-input-source-english nil)
    (setq-default smart-input-source-other "rime")
    (setq smart-input-source-do-get (lambda() current-input-method))
    (setq smart-input-source-do-set (lambda(source) (set-input-method source))))

  :config
  (sis-ism-lazyman-config nil "rime" 'native)
  ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
  )


;; https://whatacold.io/zh-cn/blog/2022-09-11-emacs-smart-input-source-rime/
;;  对功能的影响就是，如果 w/sis--guess-context-by-prev-chars 出错了，会导致自动中英文切换功能失效。遇到这种情况不要慌，执行 M-x sis-global-context-mode 两次 来让 sis 把 hook 重新加上就好了。
(defun w/sis--guess-context-by-prev-chars (backward-chars forward-chars)
  "Detect the context based on the 2 chars before the point.

It has a side effect of deleting the previous whitespace if
there is a whitespace/newline and a comma before the point."
  (when (and (>= (point) 3)
             sis-context-mode
             (memq major-mode '(org-mode)))
    (let ((prev (preceding-char))
          (pprev (char-before (1- (point)))))
      (cond
       ((and (or (char-equal ?  pprev) (char-equal 10 pprev)) ; a whitespace or newline
             (char-equal ?, prev))
        (delete-char -1)                ; side effect: delete the second whitespace
        'other)
       ((string-match-p "[[:ascii:]]" (char-to-string (preceding-char)))
        'english)
       (t 'other)))))

(setq sis-context-detectors '(w/sis--guess-context-by-prev-chars))

(setq sis-context-hooks '(post-command-hook)) ; may hurt performance
