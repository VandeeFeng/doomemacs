;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;
;;读取其他配置
(load! "CustomConfig/keybindings")
(load! "CustomConfig/misc")
(load! "CustomConfig/org")
(load! "CustomConfig/languages")
;;(load! "org-remoteimg.el") 容易引起一个报错，而且还没解决图片显示大小问题
;;(load! "CustomConfig/chinese")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Vandee")
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;;---------------------------------------------------------------------------------
;;
;;org settings
;;
;;---------------------------------------------------------------------------------

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; (after! org
;; (setq org-agenda-files '("~/Vandee/pkm/")) ;;这样不包括子文件夹
;; ;;这样会把目录下包括子文件夹的文件都添加进去https://emacs-china.org/t/org-txt-agenda/13506/5
;; ;;(setq org-agenda-files (directory-files-recursively "~/Vandee/pkm/" "\\.org$"))
;; (setq org-directory "~/Vandee/pkm/")
;; (global-set-key (kbd "C-c c") 'org-capture)
;; (setq org-default-notes-file "~/Vandee/pkm/inbox.org")
;; (setq org-capture-templates nil)
;; ;; 这里日志里链接单个日志文件路径选择相对路径，方便后面移动文件夹
;; (add-to-list 'org-capture-templates
;;              '("j" "Journal" entry (file+datetree  "~/Vandee/pkm/Journals/Journal.org")
;;                "* [[file:%<%Y>/%<%Y-%m-%d>.org][%<%Y-%m-%d>]] - %^{heading} %^g\n %?\n"))
;; (add-to-list 'org-capture-templates
;;              '("i" "Inbox" entry (file+datetree "~/Vandee/pkm/Inbox.org")
;;                "* %U - %^{heading} %^g\n %?\n"))
;; (add-to-list 'org-capture-templates '("c" "Collections"))
;; (add-to-list 'org-capture-templates
;;              '("cw" "Web Collections" item
;;                (file+headline "~/Vandee/pkm/websites.org" "实用")
;;                "%?"))
;; (add-to-list 'org-capture-templates
;;              '("ct" "Tool Collections" item
;;                (file+headline "~/Vandee/pkm/tools.org" "实用")
;;                "%?"))

;; (defun my-tags-view ()
;;   "Show all headlines for org files matching a TAGS criterion."
;;   (interactive)
;;   (let* ((org-agenda-files '("~/Vandee/pkm/"))
;;          (org-tags-match-list-sublevels nil))
;;     (call-interactively 'org-tags-view)))

;; )



;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
