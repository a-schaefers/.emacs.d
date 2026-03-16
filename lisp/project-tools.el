;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(setq my/projects "~/repos")

(use-package transient
  :defer t
  :ensure (transient :host github :repo "magit/transient" :depth nil :main "lisp/transient.el"))

(use-package magit
  :defer t
  :ensure t
  :after transient
  :commands (magit-status)
  :init
  (setq magit-repository-directories `((,my/projects . 1))))

(use-package projectile
  :defer t
  :ensure t
  :init
  (setq projectile-project-search-path `((,my/projects . 1)))
  :hook (elpaca-after-init . projectile-mode)
  :bind (("C-c p" . projectile-command-map))
  :config
  (projectile-discover-projects-in-search-path)
  (projectile-save-known-projects))

;; Better shell - pop to shell in current dir
(use-package better-shell-lite
  :defer t
  :ensure nil
  :load-path "lib"
  :bind ("C-<return>" . better-shell-for-current-dir)
  :config
  (setq comint-scroll-to-bottom-on-output t
        comint-scroll-show-maximum-output t))

;; A fully featured elisp native and more performant terminal emulator
(use-package eat :defer t :ensure t
  :bind ("C-S-<return>" . eat))

(provide 'project-tools)
