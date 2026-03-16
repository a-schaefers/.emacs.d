;;; init.el --- Initialization file for Emacs -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;;
;; Just another Emacs config.
;;

;;; Code:

(defmacro boot (&rest modules)
  `(progn
     ,@(mapcar
        (lambda (m)
          `(use-package ,m :load-path "lisp" :ensure nil :demand t))
        modules)))

(boot use-package-manager
      set-env-path
      opinionated-defaults
      completion-minibuffer
      project-tools
      editing-system
      lang-overrides)

(use-package themeit
  :load-path "lib"
  :ensure nil
  :demand t
  :init
  ;; builtin defaults
  (setq themeit/font "Aporetic Sans Mono"
        themeit/font-size 150
        themeit/theme-builtin nil
        ;; themeit/theme 'modus-operandi
        themeit/alpha-background 95
        themeit/startup-screen t
        themeit/kill-scratch t
        themeit/line-numbers nil
        themeit/hl-line t
        themeit/blink-cursor t
        themeit/context-menu nil
        themeit/minimal-ui t
        themeit/frame-size nil
        ;; themeit/frame-width 150
        ;; themeit/frame-height 40
        themeit/scratch-mode 'fundamental-mode
        themeit/silent-bell t
        themeit/scroll-step 1)
  :config
  ;; 3rd party packages (requires elpaca + elpaca-use-package-mode)

  ;; Some nice themes from creator of Aporetic fonts
  (themeit--elpaca-use-package
   (ef-themes :config
              ((load-theme 'ef-dream t)))

   ;; An elegant modeline from creator of magit
   (moody :config
          ((moody-replace-mode-line-front-space)
           (moody-replace-mode-line-buffer-identification)
           (moody-replace-vc-mode)))

   ;; To hide minor modes
   (minions :config
            ((minions-mode 1)))

   ;; Spacemacs Modeline
   ;; (spaceline :config
   ;;            ((require 'spaceline-config)
   ;;             (spaceline-toggle-minor-modes-on)
   ;;             (spaceline-emacs-theme)))

   ;; Doom Modeline, and the icons it needs
   ;; nerd-icons ; ++ M-x nerd-icons-install-fonts once
   ;; (doom-modeline :init
   ;;                ((setq doom-modeline-minor-modes t
   ;;                       doom-modeline-height 32
   ;;                       doom-modeline-bar-width 4))
   ;;                :config
   ;;                ((doom-modeline-mode 1)))
   ))

;;; init.el ends here
