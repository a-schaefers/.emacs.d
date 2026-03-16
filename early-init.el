;;; early-init.el --- Early Initialization file for Emacs -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;;
;; Disable package.el as early as possible for elpaca
;; Setup theme early
;;

;;; Code:

(setq package-enable-at-startup nil)

(use-package emacs
  :ensure nil
  :defer t
  :preface
  (setq my-font "Aporetic Sans Mono")
  (setq my-font-size "15")
  (setq my-projects "~/repos")
  (add-to-list 'default-frame-alist '(width . 150))
  (add-to-list 'default-frame-alist '(height . 40))
  (set-frame-parameter nil 'alpha-background 90)
  (add-to-list 'default-frame-alist '(alpha-background . 90))
  (load-theme 'modus-vivendi t)
  (global-hl-line-mode 1)
  (blink-cursor-mode 1)
  (scroll-bar-mode -1)
  (fringe-mode -1)
  (menu-bar-mode -1)
  (tool-bar-mode -1))

;;; early-init.el ends here
