;;; chinese.el -*- lexical-binding: t; -*-



;; smart-input https://github.com/laishulu/emacs-smart-input-source
(sis-ism-lazyman-config nil "rime" 'native)
(use-package sis
  ;; :hook
  ;; enable the /context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))

  :config
  ;; For MacOS
  (sis-ism-lazyman-config

   ;; English input source may be: "ABC", "US" or another one.
   ;; "com.apple.keylayout.ABC"
   "com.apple.keylayout.ABC"

   ;; Other language input source: "rime", "sogou" or another one.
   ;; "im.rime.inputmethod.Squirrel.Rime"
   "com.rime.inputmethod.Squirrel.Rime")

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
