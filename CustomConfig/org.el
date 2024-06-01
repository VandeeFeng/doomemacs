;;; org.el -*- lexical-binding: t; -*-
;;;
;;;
;;;
;;;

;;-------------------------------------------------------------------------------
;;
;; global
;;
;;-------------------------------------------------------------------------------

;; 折叠标题层级
;; https://emacs-china.org/t/org-startup-show2levels/16499
;; 可单独配置 #+STARTUP: show2levels
;;(setq org-startup-folded 'show2levels)


;;-------------------------------------------------------------------------------
;;
;; org-roam
;;
;;-------------------------------------------------------------------------------
(setq org-roam-dailies-directory "~/Vandee/pkm/Journals/")
(setq org-export-with-toc nil) ;;禁止生成toc
(use-package org-roam
  :ensure t
  :demand t  ;; Ensure org-roam is loaded by default
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-dailies-capture-templates
   '(("d" "daily" plain "* %<%Y-%m-%d>\n** TODO\n- \n** Inbox\n- %?"
      :if-new (file+head "%<%Y>/%<%Y-%m-%d>.org" "#+TITLE: %<%Y-%m-%d>\n"))))
  (org-roam-directory "~/Vandee/pkm/roam/")
  (org-roam-capture-templates
   `(("n" "note" plain "%?"
      :if-new (file+head "${slug}.org"
                         "#+TITLE: ${title}\n#+UID: %<%Y%m%d%H%M%S>\n#+FILETAGS: \n#+TYPE: \n#+SOURCE: \n#+DATE: %<%Y-%m-%d>\n")
      :unnarrowed t))
   )
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n n" . my/org-roam-find-notes)
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
  (require 'org-roam-protocol))



(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))


(defun my/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "* %?"
                                   :if-new (file+head "Inbox.org" "#+TITLE: Inbox\n")))))



;; For users that prefer using a side-window for the org-roam buffer, the following example configuration should provide a good starting point:对于喜欢使用侧窗口作为 org-roam 缓冲区的用户，以下示例配置应该提供一个很好的起点：
(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-side-window)
               (side . right)
               (slot . 0)
               (window-width . 0.33)
               (window-parameters . ((no-other-window . t)
                                     (no-delete-other-windows . t)))))


;;-------------------------------------------------------------------------------
;;
;; org
;;
;;-------------------------------------------------------------------------------
;;https://www.zmonster.me/2018/02/28/org-mode-capture.html
;;一部分已经在config.el里设置，因为要在一开始加载目录,可以添加 (after! package) 又写回来了

;; (after! org
;;   (setq org-agenda-files '("~/Vandee/pkm"))
;;   (setq org-directory "~/Vandee/pkm/")
;;   (global-set-key (kbd "C-c c") 'org-capture)
;;   (setq org-default-notes-file "~/Vandee/pkm/inbox.org")
;;   (setq org-capture-templates nil)

;;   (add-to-list 'org-capture-templates
;;                '("j" "Journal" entry (file+datetree  "~/Vandee/pkm/Journals/Journal.org")
;;                  "* [[file:%<%Y>/%<%Y-%m-%d>.org][%<%Y-%m-%d>]] - %^{heading} %^g\n %?\n"))
;;   (add-to-list 'org-capture-templates
;;                '("i" "Inbox" entry (file+datetree "~/Vandee/pkm/Inbox.org")
;;                  "* %U - %^{heading} %^g\n %?\n"))
;;   (add-to-list 'org-capture-templates '("c" "Collections"))
;;   (add-to-list 'org-capture-templates
;;                '("cw" "Web Collections" item
;;                  (file+headline "~/Vandee/pkm/websites.org" "实用")
;;                  "%?"))
;;   (add-to-list 'org-capture-templates
;;                '("ct" "Tool Collections" item
;;                  (file+headline "~/Vandee/pkm/tools.org" "实用")
;;                  "%?"))

;;   (defun my-tags-view ()
;;     "Show all headlines for org files matching a TAGS criterion."
;;     (interactive)
;;     (let* ((org-agenda-files '("~/Vandee/pkm"))
;;            (org-tags-match-list-sublevels nil))
;;       (call-interactively 'org-tags-view)))
;;   )

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

;; 显示当前 heading 内容并折叠其他
;; https://emacs-china.org/t/org-mode/23205
(defun my/org-show-current-heading-tidily ()
  (interactive)
  "Show next entry, keeping other entries closed."
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
