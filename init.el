(package-initialize) ;; emacs 25.0 keeps adding this

(add-to-list 'load-path (concat user-emacs-directory "/mine"))

(require 'mine-builtin)
(require 'mine-defuns)
(require 'mine-advice)
(require 'mine-bindings)
(require 'mine-desktop)
(require 'mine-pretty)
(require 'mine-env)
(require 'mine-os)
(require 'mine-eshell)
(require 'mine-isearch)
(if (require 'mine-pkgmgt)
    (require 'mine-load-custom))

(cd (getenv "HOME"))
(mine-normal-display)
