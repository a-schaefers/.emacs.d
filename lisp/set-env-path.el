;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package emacs :ensure nil :defer t
  :init
  (setq my/env '((EDITOR . "emacsclient")
                   (VISUAL . "$EDITOR")
                   (PAGER  . "cat")))

  (setq my/path-insert '("~/bin"))
  (setq my/path-append '())
  (my/apply-env-and-path)

  :preface
  (require 'subr-x)

  (defvar my/env nil
    "Alist of extra environment variables to set (SYMBOL|STRING . VALUE).")

  (defvar my/path-insert nil
    "List of directories to insert at the front of `exec-path`.")

  (defvar my/path-append nil
    "List of directories to append to the end of `exec-path`.")

  (defun my/apply-env-and-path ()
    "Apply ENV/PATH customization."

    ;; ENV
    (dolist (pair (and (boundp 'my/env) my/env))
      (let* ((var (if (symbolp (car pair)) (symbol-name (car pair)) (car pair)))
             (raw (cdr pair))
             (val (substitute-env-vars (if (stringp raw) raw (format "%s" raw)))))
        (setenv var val)))

    ;; PATH
    (dolist (item (and (boundp 'my/path-insert) my/path-insert))
      (add-to-list 'exec-path (expand-file-name item)))
    (dolist (item (and (boundp 'my/path-append) my/path-append))
      (add-to-list 'exec-path (expand-file-name item) t))

    (setenv "PATH" (string-trim-right (string-join exec-path ":") ":$"))))

(provide 'set-env-path)
