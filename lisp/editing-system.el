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
  (corfu-quit-at-boundary 'separator)

  ;; A few more useful configurations...
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

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
(use-package eglot-autostart-when-on-path
  :load-path "lib"
  :ensure nil
  :demand t)

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
