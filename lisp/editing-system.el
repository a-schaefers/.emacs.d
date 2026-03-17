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
(use-package eglot-autostart-when-on-path
  :load-path "lib"
  :ensure nil
  :defer t
  :commands (my/apply-eglot-autostart)
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
