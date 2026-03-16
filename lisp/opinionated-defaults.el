;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package emacs
  :ensure nil
  :defer t
  :preface
  (defun my/edit-init-file ()
    "Open init.el."
    (interactive)
    (find-file (expand-file-name "init.el" user-emacs-directory)))

  ;; projects dir
  (defvar my/projects "~/repos")

  :init

  ;; standard recommendations from the Vertico README
  (setq enable-recursive-minibuffers t
        read-extended-command-predicate #'command-completion-default-include-p
        minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; OPINIONATED DEFAULTS
  (setq load-prefer-newer t
        gc-cons-threshold 100000000
        read-process-output-max (* 1024 1024)
        comp-deferred-compilation t
        package-native-compile t)

  ;; don't pop-up compilation warnings during native compiles / confuse the user
  (setq native-comp-async-report-warnings-errors nil
        comp-async-report-warnings-errors nil
        native-comp-jit-compilation-deny-list '("tramp-loaddefs"))
  (add-to-list 'warning-suppress-types '(native-compiler))
  (add-to-list 'display-buffer-alist '("\\*Warnings\\*" (display-buffer-no-window) (allow-no-window . t)))

  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  (setq-default gnutls-verify-error t
                gnutls-min-prime-bits 2048
                password-cache-expiry nil
                mouse-yank-at-point t
                save-interprogram-paste-before-kill t
                apropos-do-all t
                require-final-newline t
                ediff-window-setup-function 'ediff-setup-windows-plain
                ediff-split-window-function 'split-window-horizontally
                tramp-default-method "ssh"
                tramp-copy-size-limit nil
                vc-follow-symlinks t
                tab-always-indent 'complete
                browse-url-browser-function 'eww-browse-url)

  (setq backup-directory-alist `((".*" . ,temporary-file-directory))
        auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
        delete-old-versions t)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))

  ;; Python friendly
  (setq-default indent-tabs-mode nil
                fill-column 79)

  ;; Set default compile command, for M-x cc
  (setq compile-command "make -k ")

  :custom
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
  (read-extended-command-predicate #'command-completion-default-include-p)

  ;; Some global binds
  :bind (("C-c i"     . my/edit-init-file)
         :map global-map
         ;; Some window shortcuts
         ("C-1" . delete-other-windows) ; C-x 1
         ("C-2" . split-window-below)   ; C-x 2
         ("C-3" . split-window-right)   ; C-x 3
         ("C-0" . delete-window)        ; C-x 0
         ;; Shift + arrow keys
         ("S-<right>" . enlarge-window-horizontally)
         ("S-<left>"  . shrink-window-horizontally)
         ("S-<down>"  . shrink-window-vertically)
         ("S-<up>"    . enlarge-window-vertically)

         ;; Misc
         ("<f5>"      . compile))

  :hook ((before-save . whitespace-cleanup)
         (after-save  . executable-make-buffer-file-executable-if-script-p))

  :config
  (setq dired-guess-shell-alist-user '(("" "xdg-open &")))
  (when (file-exists-p custom-file) (load-file custom-file))
  (save-place-mode 1)
  (electric-pair-mode 1)
  (global-eldoc-mode 1)
  (delete-selection-mode 1)
  (global-goto-address-mode 1)

  ;; Start Emacs server
  (require 'server)
  (unless (server-running-p) (server-start)))

(provide 'opinionated-defaults)
