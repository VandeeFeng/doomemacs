;;; keybindings.el -*- lexical-binding: t; -*-

;; Customized key bindings
;;
;;
;;
;;
;;

;;----------------------------------------------------------------------------
;;自定义函数
;;----------------------------------------------------------------------------
;;

(defun move-to-end-of-line ()
  "Move the cursor to the end of the current line."
  (interactive)
  (end-of-line))

;; 在 normal 模式下将 9 键绑定到这个函数
(map! :n "9" #'move-to-end-of-line)

;; https://stackoverflow.com/questions/3669511/the-function-to-show-current-files-full-path-in-mini-buffer#3669681
(defun my-buffer-path ()
  "copy buffer's full path to kill ring"
  (interactive)
  (let ((file-path (buffer-file-name)))
    (when file-path
      (kill-new (file-name-directory file-path))
      (message "Copied parent directory path: %s" (file-name-directory file-path)))))



;; (defun my-copy-buffer-file-name (event &optional bufName)
;;   "Copy buffer file name to kill ring.
;; If no file is associated with buffer just get buffer name.
;; "
;;   (interactive "eP")
;;   (save-selected-window
;;     (message "bufName: %S" bufName)
;;     (select-window (posn-window (event-start event)))
;;     (let ((name (or (unless bufName (buffer-file-name)) (buffer-name))))
;;       (message "Saved file name \"%s\" in killring." name)
;;       (kill-new name)
;;       name)))
;; (define-key mode-line-buffer-identification-keymap [mode-line mouse-2] 'copy-buffer-file-name)
;; (define-key mode-line-buffer-identification-keymap [mode-line S-mouse-2] '(lambda (e) (interactive "e") (copy-buffer-file-name e 't)))
;;
;;在minibuffer里使用shell指令
;;https://stackoverflow.com/questions/10121944/passing-emacs-variables-to-minibuffer-shell-commands
(defun my-shell-command (command &optional output-buffer error-buffer)
  "Run a shell command with the current file (or marked dired files).
In the shell command, the file(s) will be substituted wherever a '%' is."
  (interactive (list (read-from-minibuffer "Shell command: "
                                           nil nil nil 'shell-command-history)
                     current-prefix-arg
                     shell-command-default-error-buffer))
  (cond ((buffer-file-name)
         (setq command (replace-regexp-in-string "%" (buffer-file-name) command nil t)))
        ((and (equal major-mode 'dired-mode) (save-excursion (dired-move-to-filename)))
         (setq command (replace-regexp-in-string "%" (mapconcat 'identity (dired-get-marked-files) " ") command nil t))))
  (shell-command command output-buffer error-buffer))

;;
;;
;;
;;
;; 显示当前 heading 内容并折叠其他
;; https://emacs-china.org/t/org-mode/23205
(defun my-org-show-current-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (save-excursion
      (outline-back-to-heading)
      (unless (and (bolp) (org-on-heading-p))
	(org-up-heading-safe)
	(hide-subtree)
	(error "Boundary reached"))
      (org-overview)
      (org-reveal t)
      (org-show-entry)
      (show-children))
    ))


(defun my-insert-timestamp ()
  "Insert a custom formatted timestamp."
  (interactive)
  (insert (format-time-string "<%Y-%m-%d %a %H:%M>")))

(defun my-tags-view ()
  "Show all headlines for org files matching a TAGS criterion."
  (interactive)
  (let* ((org-agenda-files '("~/Vandee/pkm"))
         (org-tags-match-list-sublevels nil))
    (call-interactively 'org-tags-view)))


;; 自定义搜索
(defun my-build-or-regexp-by-keywords (keywords)
  "构建or语法的正则"
  (let (wordlist tmp regexp)
    (setq wordlist (split-string keywords " "))
    (dolist (word wordlist)
      (setq tmp (format "(%s)" word))
      (if regexp (setq regexp (concat regexp "|")))
      (setq regexp (concat regexp tmp)))
    regexp
    ))

(defun my-build-and-regexp-by-keywords (keywords)
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

(defun my-search-or-by-rg ()
  "以空格分割关键词，以or条件搜索多个关键词的内容
  如果要搜索tag，可以输入`:tag1 :tag2 :tag3'
  "
  (interactive)
  (let* ((keywords (read-string "Or Search(rg): "))
	 (regexp (eye--build-or-regexp-by-keywords keywords)))
    (message "search regexp:%s" regexp)
    (color-rg-search-input regexp)
    ))


(defun my-search-and-by-rg ()
  "以空格分割关键词，以and条件搜索同时包含多个关键词的内容
  如果要搜索tag，可以输入`:tag1 :tag2 :tag3'
  "
  (interactive)
  (let* ((keywords (read-string "And Search(rg): "))
	 (regexp (eye--build-and-regexp-by-keywords keywords)))
    (message "search regexp:%s" regexp)
    (color-rg-search-input regexp)
    ))


;; 去除多余空格

;; (defun my-remove-extra-spaces ()
;;   "Remove extra spaces in the current buffer."
;;   (interactive)
;;   (replace-regexp "\\(\\s-\\)\\s-" "\\1" nil (point-min) (point-max)))

;; ;; 绑定到一个快捷键，例如 C-c s
;; (global-set-key (kbd "C-c s") 'my-remove-extra-spaces)

;;-------------------------------------------------------------------------------------------
;;
;; markdown to org
;;
;;-------------------------------------------------------------------------------------------

(defun my-markdown-to-org ()
  (interactive)
  (save-excursion
    ;; 转换Markdown标题为Org-mode标题
    (goto-char (point-min))
    (while (re-search-forward "^\s*\\(#+\\) \\(.*\\)" nil t)
      (let ((level (length (match-string 1)))
            (title1 (match-string 2)))
        (replace-match (concat (make-string level ?*) " " title1)))))
  ;; 转换Markdown链接为Org-mode链接,但是跳过图片链接
  (goto-char (point-min))
  (while (re-search-forward "\\[\\(.*?\\)\\](\\(.*?\\))" nil t)
    (let ((title (match-string 1))
          (url (match-string 2)))
      (unless (and (string-match "\\(jpeg\\|png\\|svg\\)" url)
                   (string-match "https" url))
        (replace-match (format "[[%s][%s]]" url title)))))
  ;; 转换Markdown代码块为Org-mode代码块
  (goto-char (point-min))
  (while (re-search-forward "^```" nil t)
    (if (looking-back "^```")
        (progn
          (replace-match "#+begin_src")
          (re-search-forward "^```" nil t)
          (if (looking-back "^```")
              (replace-match "#+end_src"))))))










;;----------------------------------------------------------------------------
;; general
;;----------------------------------------------------------------------------

(use-package general
  :init
  :config
  (general-evil-setup)

  ;; set up 'SPC' as the global leader key
  (general-create-definer vf/leader-keys
    :states '(normal  visual  emacs)
    :keymaps 'override-global-map
    :prefix "SPC") ;; set leader
  ;;:global-prefix "M-SPC") ;; access leader in insert mode

  (vf/leader-keys
    "SPC" '(counsel-M-x :wk "Counsel M-x")
    "." '(find-file :wk "Find file")
    "=" '(perspective-map :wk "Perspective") ;; Lists all the perspective keybindings
    "TAB TAB" '(comment-line :wk "Comment lines")
    "u" '(universal-argument :wk "Universal argument"))

  (vf/leader-keys
    "v" '(:ignore t :wk "Vandee")
    "v c" '(org-capture :wk "org-capture")
    "v r" '(org-roam-capture :wk "org-roam-capture")
    "v t" '(:ignore t :wk "TAGS")
    "v t s" '(org-set-tags-command :wk "插入TAGS")
    "v a" '(:ignore t :wk "agenda and TODO")
    "v a t" '(org-todo :wk "编辑TODO状态")
    "v a i" '(org-insert-todo-heading :wk "插入任务项")
    "v g" '(:ignore t :wk "gpt")
    "v g s" '(gptel-send :wk "gpt发送")
    "v g n" '(gptel :wk "gpt新buffer")
    "v g m" '(gptel-menu :wk "gpt-send-menu")
    "v f" '(org-roam-node-find :wk "org-roam-node-find")
    "v j" '((lambda () (interactive)
              (find-file "~/Vandee/pkm/org/journal.org"))
            :wk "go to Journals")
    "v v" '((lambda () (interactive)
              (find-file "~/Vandee/pkm/org/Vandee.org"))
            :wk "go to Vandee")

    "v T" '(my-tags-view :wk "my-tags-view")
    "v d" '(my-insert-timestamp :wk "insert-timestamp")
    ;;"v r" '(my-remove-extra-spaces :wk "my-remove-extra-spaces")
    "v h" '(my-org-show-current-heading-tidily :wk "折叠其他标题")
    "v p" '(my-buffer-path :wk "pwd")
    "v s" '(my-shell-command :wk "my-minibuffer-shell")

    ;; "v o n" '(org-roam-capture :wk "org-roam-capture")
    ;; "v o d" '(org-roam-dailies-capture-today :wk "org-roam-dailies-capture-today")

    )

  (vf/leader-keys
    "n" '(:ignore t :wk "notes")
    "n j" '(org-roam-dailies-capture-today :wk "org-roam-dailies-capture-today")
    "n i" '(org-roam-node-insert :wk "org-roam-node-insert")
    "n I" '(org-roam-node-insert-immediate :wk "org-roam-node-insert-immediate")
    "r n" '(org-roam-capture :wk "org-roam-capture")
    "n f" '(org-roam-node-find :wk "org-roam-node-find")
    "n e" '(org-export-dispatch :wk "org-export-dispatch")
    "n u" '(org-roam-ui-open :wk "org-roam-ui-open")
    "n c" '(org-capture :wk "org-capture")

    )

  (vf/leader-keys
    "b" '(:ignore t :wk "Bookmarks/Buffers")
    "b b" '(switch-to-buffer :wk "Switch to buffer")
    "b c" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
    "b C" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
    "b d" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-current-buffer :wk "Kill current buffer")
    "b D" '(kill-some-buffers :wk "Kill multiple buffers")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers")
    "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file"))


  (vf/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current")
    "d n" '(neotree-dir :wk "Open directory in neotree")
    "d p" '(peep-dired :wk "Peep-dired"))

  (vf/leader-keys
    "e" '(:ignore t :wk "Eshell/Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate and elisp expression")
    "e h" '(counsel-esh-history :which-key "Eshell history")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region")
    "e R" '(eww-reload :which-key "Reload current page in EWW")
    "e s" '(eshell :which-key "Eshell")
    "e w" '(eww :which-key "EWW emacs web wowser"))

  (vf/leader-keys
    "f" '(:ignore t :wk "Files")
    "f c" '((lambda () (interactive)
              (find-file "~/.config/emacs/config.org"))
            :wk "Open emacs config.org")
    "f e" '((lambda () (interactive)
              (dired "~/.config/emacs/"))
            :wk "Open user-emacs-directory in dired")
    "f d" '(find-grep-dired :wk "Search for string in files in DIR")
    "f g" '(counsel-grep-or-swiper :wk "Search for string current file")
    "f i" '((lambda () (interactive)
              (find-file "~/.config/emacs/init.el"))
            :wk "Open emacs init.el")
    "f j" '(counsel-file-jump :wk "Jump to a file below current directory")
    "f l" '(counsel-locate :wk "Locate a file")
    "f r" '(counsel-recentf :wk "Find recent files")
    "f u" '(sudo-edit-find-file :wk "Sudo find file")
    "f U" '(sudo-edit :wk "Sudo edit file"))

  (vf/leader-keys
    "h" '(:ignore t :wk "Help")
    "h a" '(counsel-apropos :wk "Apropos")
    "h b" '(describe-bindings :wk "Describe bindings")
    "h c" '(describe-char :wk "Describe character under cursor")
    "h d" '(:ignore t :wk "Emacs documentation")
    "h d a" '(about-emacs :wk "About Emacs")
    "h d d" '(view-emacs-debugging :wk "View Emacs debugging")
    "h d f" '(view-emacs-FAQ :wk "View Emacs FAQ")
    "h d m" '(info-emacs-manual :wk "The Emacs manual")
    "h d n" '(view-emacs-news :wk "View Emacs news")
    "h d o" '(describe-distribution :wk "How to obtain Emacs")
    "h d p" '(view-emacs-problems :wk "View Emacs problems")
    "h d t" '(view-emacs-todo :wk "View Emacs todo")
    "h d w" '(describe-no-warranty :wk "Describe no warranty")
    "h e" '(view-echo-area-messages :wk "View echo area messages")
    "h f" '(describe-function :wk "Describe function")
    "h F" '(describe-face :wk "Describe face")
    "h g" '(describe-gnu-project :wk "Describe GNU Project")
    "h i" '(info :wk "Info")
    "h I" '(describe-input-method :wk "Describe input method")
    "h k" '(describe-key :wk "Describe key")
    "h l" '(view-lossage :wk "Display recent keystrokes and the commands run")
    "h L" '(describe-language-environment :wk "Describe language environment")
    "h m" '(describe-mode :wk "Describe mode")
    "h r" '(:ignore t :wk "Reload")
    "h r r" '((lambda () (interactive)
                (load-file "~/.config/emacs/init.el")
                (ignore (elpaca-process-queues)))
              :wk "Reload emacs config")
    "h t" '(load-theme :wk "Load theme")
    "h v" '(describe-variable :wk "Describe variable")
    "h w" '(where-is :wk "Prints keybinding for command if set")
    "h x" '(describe-command :wk "Display full documentation for command"))


  (vf/leader-keys
    "o" '(:ignore t :wk "Open")
    "o d" '(dashboard-open :wk "Dashboard")
    "o e" '(elfeed :wk "Elfeed RSS")
    "o f" '(make-frame :wk "Open buffer in new frame")
    "o F" '(select-frame-by-name :wk "Select frame by name"))

  ;; projectile-command-map already has a ton of bindings
  ;; set for us, so no need to specify each individually.
  (vf/leader-keys
    "p" '(projectile-command-map :wk "Projectile"))

  (vf/leader-keys
    "s" '(:ignore t :wk "Search")
    "s d" '(dictionary-search :wk "Search dictionary")
    "s m" '(man :wk "Man pages")
    "s t" '(tldr :wk "Lookup TLDR docs for a command")
    "s w" '(woman :wk "Similar to man but doesn't require man"))

  (vf/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t e" '(eshell-toggle :wk "Toggle eshell")
    "t f" '(flycheck-mode :wk "Toggle flycheck")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t n" '(neotree-toggle :wk "Toggle neotree file viewer")
    "t o" '(org-mode :wk "Toggle org mode")
    "t r" '(rainbow-mode :wk "Toggle rainbow mode")
    "t t" '(visual-line-mode :wk "Toggle truncated lines")
    "t v" '(vterm-toggle :wk "Toggle vterm"))

  (vf/leader-keys
    "w" '(:ignore t :wk "Windows")
    ;; Window splits
    "w c" '(evil-window-delete :wk "Close window")
    "w n" '(evil-window-new :wk "New window")
    "w s" '(evil-window-split :wk "Horizontal split window")
    "w v" '(evil-window-vsplit :wk "Vertical split window")
    ;; Window motions
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w w" '(evil-window-next :wk "Goto next window")
    ;; Move Windows
    "w H" '(buf-move-left :wk "Buffer move left")
    "w J" '(buf-move-down :wk "Buffer move down")
    "w K" '(buf-move-up :wk "Buffer move up")
    "w L" '(buf-move-right :wk "Buffer move right"))
  )
