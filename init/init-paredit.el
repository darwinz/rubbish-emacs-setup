(add-hook 'lisp-mode-hook (lambda () (paredit-mode t)))
(add-hook 'emacs-lisp-mode-hook (lambda () (paredit-mode t)))
(eval-after-load "paredit" '(diminish 'paredit-mode))
