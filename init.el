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
        themeit/font-size 130
        themeit/theme-builtin nil
        ;; themeit/theme 'modus-operandi
        themeit/alpha-background 95
        themeit/startup-screen nil
        themeit/kill-scratch t
        themeit/line-numbers nil
        themeit/hl-line t
        themeit/blink-cursor t
        themeit/context-menu nil
        themeit/minimal-ui t
        themeit/frame-size t
        themeit/frame-width 150
        themeit/frame-height 40
        themeit/scratch-mode 'fundamental-mode
        themeit/silent-bell t
        themeit/scroll-step 1)
  :config
  ;; 3rd party packages (requires elpaca + elpaca-use-package-mode)
  (themeit--elpaca-use-package

    ;; Some nice themes from creator of Aporetic fonts
    (ef-themes :config
               ((load-theme 'ef-dream t)))

    ;; An elegant modeline from creator of magit
    (moody :config
           ((moody-replace-mode-line-front-space)
            (moody-replace-mode-line-buffer-identification)
            (moody-replace-vc-mode)))

    ;; Unclutter the modeline
    (minions :config
             ((minions-mode 1)))

    ;; Nerd icons in dired
    nerd-icons ; M-x nerd-icons-install-fonts once
    (nerd-icons-dired :config
                      ((add-hook 'dired-mode-hook #'nerd-icons-dired-mode)))

    ;; Startup dashboard
    (dashboard :init
               ((setq dashboard-center-content t
                      dashboard-vertically-center-content t
                      dashboard-startup-banner (expand-file-name "banner.txt" user-emacs-directory)
                      dashboard-banner-logo-title "Emacs"
                      dashboard-items '((recents . 5)
                                        (projects . 5))
                      dashboard-startupify-list '(dashboard-insert-banner
                                                  dashboard-insert-newline
                                                  dashboard-insert-banner-title
                                                  dashboard-insert-newline
                                                  dashboard-insert-navigator
                                                  dashboard-insert-newline
                                                  dashboard-insert-init-info
                                                  dashboard-insert-items
                                                  dashboard-insert-newline
                                                  dashboard-insert-footer)
                      dashboard-projects-backend 'projectile
                      dashboard-footer-messages
                      '("The modern programmer does not love software too much; he loves it too little - for he no longer loves the making of it."
                        "The real danger isn't AGI replacing programmers. It's programmers turning themselves into NPCs."
                        "We need less software engineers. We need more software artisans."
                        "Donald Knuth called his magnum opus The Art of Computer Programming. This was no accident."
                        "A software engineer who will not defend his technical autonomy will soon discover he has none left to defend."
                        "Remaining hopeful when all hope is lost, is a beautiful thing."))
                (setq dashboard-navigator-buttons
                      `(((nil "Tutorial" "Official Interactive Emacs Tutorial"
                              (lambda (&rest _) (help-with-tutorial)))
                         (nil "Tour" "Official Emacs guided tour"
                              (lambda (&rest _) (browse-url "https://www.gnu.org/software/emacs/tour/")))
                         (nil "Manual" "Official Emacs Manual"
                              (lambda (&rest _) (info-emacs-manual)))
                         (nil "Elisp Intro" "Official elisp intro"
                              (lambda (&rest _) (browse-url "https://www.gnu.org/software/emacs/manual/html_node/eintr/index.html")))))))
               :config
               ((add-hook 'elpaca-after-init-hook #'dashboard-initialize)
                (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
                (add-hook 'elpaca-after-init-hook #'dashboard-setup-startup-hook)))))

;;; init.el ends here
