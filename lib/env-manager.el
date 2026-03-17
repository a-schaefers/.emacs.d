;;; env-manager.el --- ENV/PATH management for Emacs -*- lexical-binding: t; no-byte-compile: t; -*-

;; Copyright (C) 2026 Adam Schaefers

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:
;;
;; Example
;; (use-package env-manager
;;   :load-path "lib"
;;   :ensure nil
;;   :demand t
;;   :init
;;   (setq my/env '((EDITOR . "emacsclient")
;;                  (VISUAL . "$EDITOR")
;;                  (PAGER  . "cat")))
;;   (setq my/path-insert '("~/bin"))
;;   (setq my/path-append '())
;;   :config
;;   (my/apply-env-and-path))
;;

;;; Code:

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

  (setenv "PATH" (string-trim-right (string-join exec-path ":") ":$")))

(provide 'env-manager)
