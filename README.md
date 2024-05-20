#    A doomemacs config
边学习，边记录的一个doomemacs 配置库。

体验了spacemacs、LunarVim之后还是选择了doomemacs。

神的编辑器还是得上手体验体验。

官方文档：

-  [GitHub - doomemacs/doomemacs: An Emacs framework for the stubborn martian hacker](https://github.com/doomemacs/doomemacs/tree/master)  
-  [doomemacs/docs/getting_started.org at master · doomemacs/doomemacs · GitHub](https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org#on-windows) 
-  [GNU Emacs Manuals Online](https://www.gnu.org/software/emacs/manual/)

[Emacs China](https://emacs-china.org/)  论坛

**TIP**：`spc-h rr`  reload doomemac，热重启，每次更新完package，config，不重启改动不生效。

# Installation

To install, make a backup then clone this repo to ~/.config/doom
`git clone https://github.com/VandeeFeng/EmacsSettings.git ~/.config/doom`



# Settings

## tips

### emacs-plus option 

https://github.com/d12frosted/homebrew-emacs-plus

```
$ brew tap d12frosted/emacs-plus
$ brew install emacs-plus    [options] # install the latest release (Emacs 29)
$ brew install emacs-plus@30 [options] # install Emacs 30 (master)
$ brew install emacs-plus@29 [options] # install Emacs 29
$ brew install emacs-plus@28 [options] # install Emacs 28
$ brew install emacs-plus@27 [options] # install Emacs 27
$ brew install emacs-plus@26 [options] # install Emacs 26
```



  --with-native-comp

### doom emacs 

- The `package!` macro possesses a `:disable` property:
   `package!` 宏拥有 `:disable` 属性：

  ```
  (package! irony :disable t)
  (package! rtags :disable t)
  ```

  ​    

  Once a package is disabled, `use-package!` and `after!` blocks for it will be  ignored, and the package is removed the next time you run `bin/doom sync`. Use  this to disable Doom’s packages that you don’t want or need.
  一旦禁用某个包，它的 `use-package!` 和 `after!` 块将被忽略，并且该包将在您下次运行 `bin/doom sync` 时被删除。使用它来禁用您不想要或不需要的 Doom 软件包。

  There is also the `disable-packages!` macro for conveniently disabling multiple  packages:
  还有 `disable-packages!` 宏可以方便地禁用多个包：

  ```
  (disable-packages! irony rtags)
  ```

  ​    

  > **IMPORTANT:** Run `bin/doom sync` whenever you modify packages.el files to    ensure your changes take effect.
  > 重要提示：每当您修改packages.el 文件时，请运行 `bin/doom sync` 以确保更改生效。

### 输入法

- rime配置
  - https://emacs-china.org/t/emacs-rime/14654
  - https://emacs-china.org/t/rime-el/11939/4
  - https://emacs-china.org/t/doom-emacs-rime/26094
  - https://manateelazycat.github.io/2023/09/11/fcitx-best-config/

## Language

### Go

- https://go.dev/doc/ go官方文档

- 安装GoLang,Go安装可以通过以下两种方式：

  - brew install go

  - 官网下载Go dmg

- 安装完成之后，创建一个Go Project目录，以后所有的Go项目目录都放在这里即可,进入目录并安装一些非常有用的组件。比如：~/xxx/go。在.profile设置如下：

    ```
    #csutom go project path
    export GOPATH=${HOME}/xxx/go
    #go install path
    export GOROOT=/usr/local/go
    export PATH=$PATH:${GOPATH}/bin:${GOROOT}/bin
    ```
    执行 source ~/.zshrc
- 安装依赖包
   ```go
    go install github.com/motemen/gore/cmd/gore@latest
    go install github.com/stamblerre/gocode@latest
    go install golang.org/x/tools/cmd/godoc@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/cmd/gorename@latest
    go install golang.org/x/tools/cmd/guru@latest
    go install github.com/cweill/gotests/...@latest
    go install github.com/fatih/gomodifytags@latest
    
    # gopls for (+lsp)
    go install golang.org/x/tools/gopls@latest
    
    # golangci
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
   ```

- 找到~/doom.d/xxx.el,添加配置：

    ```lisp
    ;;golang
    (setq lsp-gopls-staticcheck t)
    (setq lsp-eldoc-render-all t)
    (setq lsp-gopls-complete-unimported t)
    (setq lsp-gopls-codelens nil)
    (use-package lsp-mode
      :ensure t
      :commands (lsp lsp-deferred)
      :hook (go-mode . lsp-deferred))
    
    ;; Set up before-save hooks to format buffer and add/delete imports.
    ;; Make sure you don't have other gofmt/goimports hooks enabled.
    (defun lsp-go-install-save-hooks ()
      (add-hook 'before-save-hook #'lsp-format-buffer t t)
      (add-hook 'before-save-hook #'lsp-organize-imports t t))
    (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
    ```


- 修改 ~/doom.d/init.el, 可用（SPC f P）找到该文件

  在 (doom! 下面找到：

  > :lang (go +lsp)

  > :tools (lsp)

-  执行~/.emacs.d/bin/doom sync 或者 (SPC h r r) 
### Python
配置init.el 

```
:lang
(python +lsp +conda +pyright) 
```
配置环境

`(setq python-shell-virtualenv-root "~/miniconda3/envs") ;;set env, conda or else`

packages.el  add `(package! python-black)`

# Reference

- [Derek Taylor / Configuring Emacs · GitLab](https://gitlab.com/dwt1/configuring-emacs) 

- [The Absolute Beginner's Guide to Emacs - YouTube](https://www.youtube.com/watch?v=48JlgiBpw_I)

- [5 Org Roam Hacks for Better Productivity in Emacs - System Crafters](https://systemcrafters.net/build-a-second-brain-in-emacs/5-org-roam-hacks/)

- [.config/doom · master · Derek Taylor / Dotfiles · GitLab](https://gitlab.com/dwt1/dotfiles/-/tree/master/.config/doom)

    https://www.youtube.com/watch?v=ADVCHpdmA5M&list=PL5--8gKSku15uYCnmxWPO17Dq6hVabAB4&index=17

- [GitHub - purcell/emacs.d: An Emacs configuration bundle with batteries included](https://github.com/purcell/emacs.d)  

- [Doom Emacs On Day One (Learn These Things FIRST!)](https://www.youtube.com/watch?v=37H7bD-G7nE)

- [GitHub - redguardtoo/emacs.d: Fast and robust Emacs setup.](https://github.com/redguardtoo/emacs.d)  ⭐️

- [GitHub - MatthewZMD/.emacs.d: M-EMACS, a full-featured GNU Emacs configuration distribution](https://github.com/MatthewZMD/.emacs.d)  ⭐️

- [技巧分享：在 emacs 中获取 firefox 当前标签页并生成 org link](https://emacs-china.org/t/emacs-firefox-org-link/23661)

- [史上最全Vim快捷键键位图（入门到进阶） | 菜鸟教程](https://www.runoob.com/w3cnote/all-vim-cheatsheat.html)

- [Doom Emacs 配置 - Paradigm X](https://soulhacker.me/posts/doom-emacs-config/)

    
