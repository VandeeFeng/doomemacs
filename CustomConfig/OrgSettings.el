;;; OrgSettings.el -*- lexical-binding: t; -*-
;;;
;;;
;;;

(use-package org-roam
  :ensure t
  ;;:demand t  ;; Ensure org-roam is loaded by default
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Vandee/org/roam/")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n p" . my/org-roam-find-project)
         ("C-c n t" . my/org-roam-capture-task)
         ("C-c n b" . my/org-roam-capture-inbox)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates
        `(("d" "default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "${title}\n#+tags:\n\n")
           :unnarrowed t)))
  (require 'org-roam-protocol))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))


;; 需要这个功能的 Org 笔记在 header 里加入下面一行即可（在笔记的前18行都可以）。 #+last_modified: [ ]

(after! org
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local time-stamp-active t
                          time-stamp-line-limit 18
                          time-stamp-start "^#\\+last_modified: [ \t]*"
                          time-stamp-end "$"
                          time-stamp-format "\[%Y-%m-%d %a %H:%M:%S\]")
              (add-hook 'before-save-hook 'time-stamp nil 'local))))
;; 这个知识网络的可视化会显示在浏览器中，通过 websocket 与 Emacs 通信。
(after! org-roam
  (use-package! websocket)
  (use-package! org-roam-ui
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
  )
