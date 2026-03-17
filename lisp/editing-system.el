;;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; editing completion dropdown box while typing

(use-package corfu
  :defer t
  :ensure t
  :hook ((prog-mode . corfu-mode)
         (html-ts-mode . corfu-mode))
  :custom
  (corfu-auto t)          ;; auto-show popup
  (corfu-auto-delay 0)    ;; no delay
  (corfu-auto-prefix 3)   ;; start after 3 chars
  (corfu-quit-no-match 'separator)
  (corfu-quit-at-boundary 'separator))

;; Tree-sitter

(use-package treesit-auto
  :defer t
  :ensure t
  :hook (elpaca-after-init . global-treesit-auto-mode)
  :custom (treesit-auto-install 'prompt)
  :config (treesit-auto-add-to-auto-mode-alist 'all))

;; LSP / Diagnostics

(use-package flymake
  :defer t
  :preface
  (defun my/show-flymake-diagnostics ()
    (interactive)
    (flymake-mode 1)
    (flymake-show-buffer-diagnostics))
  :ensure nil ; prefer builtin
  :config
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))

;; Eglot (SLIME-aligned bindings)
(use-package eglot
  :defer t
  :ensure nil
  :init (setq eglot-ignored-server-capabilities '(:inlayHintProvider)) ; disable inlay hints
  :bind (:map eglot-mode-map
              ("M-."     . xref-find-definitions)
              ("M-,"     . xref-go-back)
              ("M-?"     . xref-find-references)

              ;; SLIME-consistent help
              ("C-c C-d d"   . eldoc-doc-buffer)
              ("C-c C-d C-d" . eldoc-doc-buffer)

              ;; Diagnostics = summon-only
              ("C-c !"   . my/show-flymake-diagnostics)

              ;; Rename stays a modern LSP verb
              ("C-c C-r" . eglot-rename)))

;; Lisp Tooling

(use-package paredit
  :defer t
  :ensure t
  :init
  ;; emacs lisp
  (add-hook 'emacs-lisp-mode-hook        #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook               #'enable-paredit-mode)
  ;; lisp
  (add-hook 'lisp-interaction-mode-hook   #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook               #'enable-paredit-mode)
  ;; scheme
  (add-hook 'scheme-mode-hook             #'enable-paredit-mode))

(use-package treesit-sexp
  :defer t
  :ensure (treesit-sexp
           :host github
           :repo "alexispurslane/treesit-sexp")
  :init (global-treesit-sexp-mode 1))

(use-package slime
  :defer t
  :ensure t
  :init (setq inferior-lisp-program "sbcl"))

;; Eglot autostart - start LSP server if executable found on PATH
(use-package emacs
  :defer t
  :ensure nil
  :preface
  (defvar my/eglot-autostart-langs nil
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

  ;; Modes that will autostart the corresponding LSP server if found on PATH
  (setq my/eglot-autostart-langs
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
          (csharp-ts-mode-hook     . "omnisharp")))

  :init
  (my/apply-eglot-autostart))

;; Editing / Convenience

(use-package crux
  :defer t
  :ensure t
  :bind (("C-g"     . crux-keyboard-quit-dwim)
         ("C-a"     . crux-move-beginning-of-line)

         ("C-o"     . crux-smart-open-line)

         ("C-<tab>" . crux-other-window-or-switch-buffer)
         ("C-x C-o" . crux-other-window-or-switch-buffer)
         ("C-c C-o" . crux-other-window-or-switch-buffer)

         ("C-c d"   . crux-duplicate-current-line-or-region)
         ("C-c D"   . crux-duplicate-and-comment-current-line-or-region)

         ("C-c k"   . crux-kill-whole-line)
         ("C-c C-k" . crux-kill-whole-line)))

(provide 'editing-system)
