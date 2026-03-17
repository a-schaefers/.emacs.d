;;; eglot-autostart-when-on-path.el --- Auto-start Eglot when LSP binary is on PATH -*- lexical-binding: t; no-byte-compile: t; -*-

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
;; Example:
;; (use-package eglot-autostart-when-on-path
;;   :load-path "lib"
;;   :ensure nil
;;   :demand t)

;;; Code:

(defvar my/eglot-autostart-langs
  '((c-ts-mode-hook          . "clangd")
    (c++-ts-mode-hook        . "clangd")
    (lua-ts-mode-hook        . "lua-language-server")
    (bash-ts-mode-hook       . "bash-language-server")
    (python-ts-mode-hook     . "pylsp")
    (go-ts-mode-hook         . "gopls")
    (rust-ts-mode-hook       . "rust-analyzer")
    (ruby-ts-mode-hook       . "solargraph")
    (elixir-ts-mode-hook     . (:override "elixir-ls"))
    (html-ts-mode-hook       . "vscode-html-language-server")
    (css-ts-mode-hook        . "vscode-css-language-server")
    (typescript-ts-mode-hook . "typescript-language-server")
    (js-ts-mode-hook         . "typescript-language-server")
    (yaml-ts-mode-hook       . "yaml-language-server")
    (json-ts-mode-hook       . "vscode-json-language-server")
    (java-ts-mode-hook       . "jdtls")
    (csharp-ts-mode-hook     . "omnisharp"))
  "Alist of (HOOK . SPEC) for automatic Eglot startup.
Each SPEC may be a string (command), a list of strings (command and args),
or (:override . CMD) to override `eglot-server-programs`.")

(defun my/apply-eglot-autostart (&optional table)
  "Register Eglot autostart hooks from TABLE (alist HOOK . SPEC).
Falls back to `my/eglot-autostart-langs` if TABLE is nil,
but only if that variable is bound."
  (dolist (pair (or table
                    (and (boundp 'my/eglot-autostart-langs)
                         my/eglot-autostart-langs)))
    (let* ((hook (car pair))
           (spec (cdr pair))
           (mode (intern (string-remove-suffix "-hook" (symbol-name hook))))
           (override nil)
           (cmd nil))
      (cond
       ((stringp spec)
        (setq cmd (list spec)))
       ((consp spec)
        (when (eq (car spec) :override)
          (setq override t
                spec (cdr spec)))
        (cond
         ((stringp spec)
          (setq cmd (list spec)))
         ((and (listp spec)
               (let ((all-strings t))
                 (dolist (s spec)
                   (unless (stringp s) (setq all-strings nil)))
                 all-strings))
          (setq cmd spec)))))
      (when (and override cmd)
        (with-eval-after-load 'eglot
          (add-to-list 'eglot-server-programs (cons mode cmd))))
      (when (and cmd (executable-find (car cmd)))
        (add-hook hook #'eglot-ensure)))))

(my/apply-eglot-autostart)

(provide 'eglot-autostart-when-on-path)
