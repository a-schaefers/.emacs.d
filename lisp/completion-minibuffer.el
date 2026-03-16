;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package vertico
  :defer t
  :preface
  (defun my/recentf-vertico ()
    "Pick a file from `recentf-list' using `completing-read'."
    (interactive)
    (unless (bound-and-true-p recentf-mode)
      (user-error "recentf-mode is not enabled"))
    (find-file
     (completing-read "Recent file: " recentf-list nil t)))
  :ensure t
  :init (vertico-mode 1))

(use-package vertico-directory
  :defer t
  :after vertico
  :ensure nil
  :bind (:map vertico-map
         ("RET"   . vertico-directory-enter)
         ("DEL"   . vertico-directory-delete-char)
         ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package savehist
  :defer t
  :ensure nil
  :init (savehist-mode 1))

(use-package orderless
  :defer t
  :ensure t
  :custom
  ;; Completion styles: try prefix/exact first, then fall back to Orderless.
  ;; This makes non-LSP languages (e.g. Emacs Lisp) feel more relevant,
  ;; but still gives you fuzzy rescue when you need it.
  (completion-styles '(basic orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))

  ;; When Orderless runs, allow literal, regexp, and flex (fuzzy) matching.
  (orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex)))

(provide 'completion-minibuffer)
