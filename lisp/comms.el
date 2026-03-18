;;; comms.el --- M-x wl, M-x irc -*- lexical-binding: t; no-byte-compile: t; -*-

;; Email (Wanderlust) setup for apple mail with custom reply-to
(use-package wl
  ;; ~/.authinfo
  ;; machine imap.mail.me.com login USERNAME port 993 password PASSWORD
  ;; machine smtp.mail.me.com login USERNAME@icloud.com port 587 password PASSWORD
  :ensure wanderlust
  :defer t
  :init
  (setq elmo-imap4-default-server "imap.mail.me.com"
        elmo-imap4-default-port 993
        elmo-imap4-default-stream-type 'ssl
        elmo-imap4-default-authenticate-type 'clear
        elmo-imap4-default-user "adam.schaefers"
        elmo-passwd-storage-type 'auth-source

        wl-smtp-connection-type 'starttls
        wl-smtp-posting-server "smtp.mail.me.com"
        wl-smtp-posting-port 587
        wl-smtp-authenticate-type "plain"
        wl-smtp-posting-user "adam.schaefers@icloud.com"
        smtp-fqdn "obsidian.local"

        wl-from "Adam Schaefers <adam.schaefers@icloud.com>"
        wl-reply-to "Adam Schaefers <aschaefers@enchant.games>"
        wl-default-folder "%INBOX"
        wl-draft-folder "%Drafts"
        wl-trash-folder "%Deleted Messages"
        wl-fcc-force-as-read t
        wl-fcc "%Sent Messages"
        wl-default-folder "%INBOX"
        wl-stay-folder-window nil
        wl-auto-select-first t
        mime-view-type-subtype-score-alist '(((text . plain) . 4)
                                             ((text . html) . 0))

        elmo-message-fetch-confirm nil
        elmo-message-fetch-threshold nil
        wl-prefetch-confirm nil
        wl-prefetch-threshold nil))

;; IRC (rcirc)
(use-package rcirc
  ;; ~/.authinfo
  ;; machine irc.libera.chat login USERNAME port 6697 password PASSWORD
  :defer t
  :ensure nil
  :custom
  (rcirc-server-alist '(("irc.libera.chat"
                         :nick "aschaefers"
                         :port 6697
                         :encryption tls
                         :channels ("#kisslinux"))))
  (rcirc-default-nick "aschaefers")
  (rcirc-default-user-name "aschaefers")
  (rcirc-default-full-name "Adam Schaefers")
  :config
  (setq rcirc-authinfo
        `(("libera\\.chat" nickserv "aschaefers"
           ,(auth-source-pick-first-password
             :host "irc.libera.chat" :user "aschaefers")))))

(provide 'comms)
