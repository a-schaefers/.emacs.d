;;; comms.el --- M-x jellyfin -*- lexical-binding: t; no-byte-compile: t; -*-

;; Music/Video (EMMS + mpv)
(use-package emms
  :ensure t
  :defer t
  :config
  (require 'emms-setup)
  (emms-all)
  (setq emms-player-list '(emms-player-mpv))
  (setq emms-player-mpv-parameters '("--no-video")))

;; Jellyfin
(use-package jellyfin-emms-mpv
  ;; ~/.authinfo
  ;; machine blackpearl.tilapia-koi.ts.net login USERNAME password PASSWORD
  :ensure (:host github :repo "emacs-os/jellyfin-emms-mpv.el")
  :defer t
  :config
  (setq jellyfin-preview t)
  (setq jellyfin-server-url "https://blackpearl.tilapia-koi.ts.net")
  (setq jellyfin-preferred-language "eng")
  (setq jellyfin-subtitles t)
  (setq jellyfin-elcava-emms-experimental t))

;; Elcava
(use-package elcava
  :ensure (:host github :repo "emacs-os/elcava")
  :defer t
  :config
  (setq elcava-style 'spectrum))

(provide 'media)
