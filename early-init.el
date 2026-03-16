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
  (setq my/font "Aporetic Sans Mono"
        my/font-size "15"
        my/projects "~/repos")

  ;; a wider Emacs window by default
  (add-to-list 'default-frame-alist '(width . 150))
  (add-to-list 'default-frame-alist '(height . 40))

  ;; hint of background transparency (warning: gives problems if not using wayland/pgtk Emacs builds)
  (set-frame-parameter nil 'alpha-background 90)
  (add-to-list 'default-frame-alist '(alpha-background . 90))

  ;; Load a default theme
  (load-theme 'modus-vivendi t)

  ;; Disable all the bells and whistles
  (global-hl-line-mode 1)
  (blink-cursor-mode 1)
  (scroll-bar-mode -1)
  (fringe-mode -1)
  (menu-bar-mode -1)
  (tool-bar-mode -1)

  :config
  (setq inhibit-startup-screen nil) ; I like the startup screen

  (when (get-buffer "*scratch*") ; I don't like the scratch buffer
    (kill-buffer "*scratch*")))

;;; early-init.el ends here
