;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package env-manager
  :load-path "lib"
  :ensure nil
  :demand t
  :init
  (setq my/env '((EDITOR . "emacsclient")
                 (VISUAL . "$EDITOR")
                 (PAGER  . "cat")))
  (setq my/path-insert '("~/bin"))
  (setq my/path-append '())
  :config
  (my/apply-env-and-path))

(provide 'set-env-path)
