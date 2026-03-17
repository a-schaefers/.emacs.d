;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package env-manager
  :load-path "lib"
  :ensure nil
  :demand t
  :init
  (setq my/env '((EDITOR . "emacsclient")
                 (VISUAL . "$EDITOR")
                 (PAGER  . "cat")))
  (setq my/path-insert '("~/bin"
                         "~/.local/bin"
                         "~/.cargo/bin"
                         "~/go/bin"))
  (setq my/path-append '()))

(provide 'set-env-path)
