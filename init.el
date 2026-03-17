;;; init.el --- Initialization file for Emacs -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;;
;; Just another Emacs config.
;;

;;; Code:

(defmacro boot (&rest modules)
  `(progn
     ,@(mapcar
        (lambda (m)
          `(use-package ,m :load-path "lisp" :ensure nil :demand t))
        modules)))

(boot use-package-manager
      theme
      set-env-path
      opinionated-defaults
      completion-minibuffer
      project-tools
      editing-system
      lang-overrides)

;;; init.el ends here
