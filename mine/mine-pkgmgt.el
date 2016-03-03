;; package.el
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ))

(package-initialize)

(unless (file-exists-p package-user-dir)
  (package-refresh-contents))

;; use-package
;; https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; to force package.el to read new pins
(advice-add 'use-package-pin-package
            :after #'(lambda (of &rest args) (package-read-all-archive-contents)))

(setq use-package-always-ensure t)

;; general

(use-package diminish
  :config
  (progn
    (eval-after-load 'eldoc '(diminish 'eldoc-mode))
    (eval-after-load 'flyspell '(diminish 'flyspell-mode))
    (diminish 'abbrev-mode)
    (diminish 'subword-mode)))

(use-package ag
  :bind ("C-M-s" . ag)
  :config (setq ag-highlight-search t))

(use-package switch-window
  :bind ("C-x o" . switch-window))

(use-package helm
  :pin melpa-stable
  :diminish helm-mode
  :bind  (("M-y" . helm-show-kill-ring)
          ("C-x b" . helm-mini)
          ("C-x C-b" . helm-mini)
          ("C-x C-f" . helm-find-files)
          ("C-x C-i" . helm-semantic-or-imenu)
          ("M-x" . helm-M-x)
          ("C-c h" . helm-command-prefix))
  :config (progn
            (require 'helm-config)
            (setq helm-quick-update t
                  helm-split-window-in-side-p t
                  helm-buffers-fuzzy-matching t
                  helm-move-to-line-cycle-in-source t
                  helm-ff-search-library-in-sexp t
                  helm-ff-file-name-history-use-recentf t)
            (define-key helm-map (kbd "C-z")  'helm-select-action)
            (add-hook 'eshell-mode-hook
                      #'(lambda ()
                          (define-key eshell-mode-map (kbd "TAB") 'helm-esh-pcomplete)
                          (define-key eshell-mode-map (kbd "M-r") 'helm-eshell-history)))
            (helm-mode t)))


(use-package helm-descbinds
  :bind (("C-M-? b" . helm-descbinds)))

(use-package wgrep-helm)

(use-package helm-swoop
  :bind (("M-i" . helm-swoop)
         ("M-I" . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop)
         ("C-x M-i" . helm-multi-swoop-all)))

(use-package helm-ag)

(use-package projectile
  :pin melpa-stable
  :diminish projectile-mode
  :config (progn
            (define-key projectile-command-map (kbd "a") 'projectile-ag)
            (setq projectile-completion-system 'helm)
            (projectile-global-mode)))

(use-package helm-projectile
  :config (progn
            (setq projectile-switch-project-action 'helm-projectile)
            (helm-projectile-on)
            (define-key projectile-command-map (kbd "a") 'projectile-ag)))

(use-package scratch)

(use-package edit-server
  :config (progn
            (add-to-list 'edit-server-url-major-mode-alist '("github\\.com" . gfm-mode))
            (add-to-list 'edit-server-url-major-mode-alist '("trello\\.com" . gfm-mode))
            (add-to-list 'edit-server-url-major-mode-alist '("reddit\\.com" . markdown-mode))
            (add-hook 'edit-server-edit-mode-hook
                      '(lambda () (set-frame-position (selected-frame) 360 200)))
            (add-hook 'edit-server-edit-mode-hook 'beginning-of-buffer)
            (add-hook 'edit-server-done-hook 'ns-raise-chrome)
            (edit-server-start)))

(use-package gmail-message-mode)

;; organiziation/presenation/sharing

(use-package org)
(use-package org-tree-slide
  :config (eval-after-load 'org '(progn
                                   (define-key org-mode-map (kbd "<f8>") 'org-tree-slide-mode)
                                   (define-key org-mode-map (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle))))
(use-package htmlize)
(use-package ox-reveal)

(use-package gist)

(use-package magit
  :pin melpa-stable
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)
         ("C-x G" . magit-blame))
  :config
  (progn (add-hook 'magit-log-edit-mode-hook '(lambda () (flyspell-mode t)))
         (autoload 'magit-blame-mode "magit-blame" nil t nil)
         (add-hook 'git-commit-mode-hook
                   '(lambda ()
                      (set (make-local-variable 'whitespace-style) '(face lines-tail))
                      (set (make-local-variable 'whitespace-line-column) 72)
                      (whitespace-mode t)))
         (setq magit-revert-buffers t)
         (setq magit-git-executable "hub")))

(use-package magit-gh-pulls
  :config (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

(use-package github-browse-file
  :bind (("C-x M-g" . github-browse-file))
  :config (setq github-browse-file-show-line-at-point t))

;; text editing

(use-package smartparens
  :diminish smartparens-mode
  :config (progn
            (require 'smartparens-config)
            (add-hook 'smartparens-enabled-hook '(lambda () (smartparens-strict-mode t)))
            (sp-use-smartparens-bindings)
            (define-key smartparens-mode-map (kbd "M-<backspace>") nil)
            (add-hook 'eshell-mode-hook 'smartparens-mode)
            (add-hook 'minibuffer-setup-hook 'smartparens-mode)
            (smartparens-global-mode t)))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-*" . mc/mark-all-like-this)))

(use-package expand-region
  :bind ("M-2" . er/expand-region))

(use-package move-text
  :bind (([M-up] . move-text-up)
         ([M-down] . move-text-down)))

(use-package ace-jump-mode
  :bind (("C-c C-SPC" . ace-jump-mode)))

(use-package ace-jump-zap
  :bind
  (("M-z" . ace-jump-zap-up-to-char-dwim)
   ("C-M-z" . ace-jump-zap-to-char-dwim)))

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (progn
    (setq yas-snippet-dirs (remove "~/.emacs.d/snippets" yas-snippet-dirs))
    (add-to-list 'yas-snippet-dirs "~/.emacs.d/custom/snippets")
    (add-hook 'term-mode-hook (lambda() (setq yas-dont-activate t)))
    (yas-global-mode t)))

;; colors

(use-package monokai-theme)

;; tools

(use-package docker-tramp)
(use-package docker
  :config (docker-global-mode t))

;; langs

(use-package flycheck
  :pin melpa-stable
  :config (progn
            (setq flycheck-standard-error-navigation nil)
            (global-flycheck-mode)))

(use-package markdown-mode
  :config (progn
            (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
            (add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
            (setq markdown-reference-location 'end)))

(use-package coffee-mode
  :config (setq coffee-tab-width 2))

(use-package yaml-mode)

(use-package dockerfile-mode)

(use-package scala-mode2
  :mode (("\\.scala\\'" . scala-mode)
         ("\\.sbt\\'" . scala-mode))
  :config
  (progn
    (add-hook 'scala-mode-hook '(lambda ()
                                  (c-subword-mode t)))
    (setq scala-indent:align-parameters t)
    (setq scala-indent:align-forms t)))

(use-package sbt-mode
  :config
  (add-hook 'sbt-mode-hook '(lambda ()
                              (setq compilation-skip-threshold 2)
                              (local-set-key (kbd "C-a") 'comint-bol)
                              (local-set-key (kbd "M-RET") 'comint-accumulate))))

;; haskell bits taken mostly from:
;;   https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
;;   https://github.com/chrisdone/emacs-haskell-config/tree/stack-mode
(use-package haskell-mode
  :config
  (progn
    (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
    (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
    (add-hook 'haskell-mode-hook 'subword-mode)
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
    (setq
     haskell-complete-module-preferred '("Data.ByteString"
                                         "Data.ByteString.Lazy"
                                         "Data.Conduit"
                                         "Data.Function"
                                         "Data.List"
                                         "Data.Map"
                                         "Data.Maybe"
                                         "Data.Monoid"
                                         "Data.Ord")

     haskell-interactive-mode-eval-mode 'haskell-mode
     haskell-interactive-mode-include-file-name nil

     haskell-process-type 'stack-ghci
     haskell-process-suggest-remove-import-lines t
     haskell-process-auto-import-loaded-modules t
     haskell-process-log t
     haskell-process-reload-with-fbytecode nil
     haskell-process-use-presentation-mode t
     haskell-process-suggest-haskell-docs-imports t
     haskell-process-suggest-remove-import-lines t

     haskell-stylish-on-save nil
     haskell-tags-on-save nil
     )
    (eval-after-load 'haskell-mode
      '(progn
         (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
         (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
         (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
         (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
         (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def-or-tag)
         (define-key haskell-mode-map (kbd "C-<return>") 'haskell-simple-indent-newline-indent)
         (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)
         (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
         (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)))))

(use-package hindent
  :config
  (progn
    (setq hindent-style "gibiansky")
    (eval-after-load 'haskell-mode
      '(progn
         (define-key haskell-mode-map (kbd "C-c i") 'hindent-reformat-decl)
         (define-key haskell-mode-map (kbd "C-c o") 'hindent-reformat-buffer)))))

;; (use-package flycheck-haskell
;;   :ensure t
;;   :config
;;   (eval-after-load
;;       'flycheck '(add-hook 'flycheck-hode-hook #'flycheck-haskell-setup)))

(use-package ruby-mode
  :mode (("Vagrantfile$" . ruby-mode)
         ("Rakefile$" . ruby-mode)
         ("Gemfile$" . ruby-mode)
         ("Berksfile$" . ruby-mode)))

(use-package go-mode
  :config (progn
            (add-hook 'before-save-hook 'gofmt-before-save)
            (add-hook 'go-mode-hook (lambda ()
                                      (local-set-key (kbd "M-.") #'godef-jump)))
            (let ((oracle-el-file (concat (getenv "GOPATH") "/src/golang.org/x/tools/cmd/oracle/oracle.el")))
              (if (file-exists-p oracle-el-file)
                  (load-file oracle-el-file)))))

(use-package terraform-mode
  :config (setq terraform-indent-level 2))


(provide 'mine-pkgmgt)
