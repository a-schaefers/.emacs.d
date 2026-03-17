;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package c-ts-mode
  :defer t
  :ensure nil
  :preface
  (defun my/c-ts-style ()
    ;; Use Linux kernel coding style in C (Tree-sitter)
    ;; https://www.kernel.org/doc/html/v4.10/process/coding-style.html
    (setq-local indent-tabs-mode t)     ; Use tabs
    (setq-local tab-width 8)            ; Display width of tab
    (setq-local c-ts-mode-indent-style 'linux)
    (setq-local c-ts-mode-indent-offset 8))
  :hook (c-ts-mode . my/c-ts-style)
  :preface
  (defun my/man-at-point ()
    "Look up man page for symbol at point, preferring section 3 (C library)."
    (interactive)
    (let ((sym (thing-at-point 'symbol t)))
      (when sym
        (man (format "3 %s" sym)))))
  (defun my/man-frame ()
    "Look up man page for symbol at point and display in a new frame."
    (interactive)
    (let ((sym (thing-at-point 'symbol t)))
      (when sym
        (man (format "3 %s" sym))
        (run-with-timer 0.5 nil #'delete-other-windows)
        (run-with-timer
         0.5 nil
         (lambda ()
           (let ((buf (get-buffer (format "*Man 3 %s*" sym))))
             (when buf
               (let ((frame (make-frame '((name . "man")))))
                 (select-frame-set-input-focus frame)
                 (set-window-buffer (frame-selected-window frame) buf)))))))))
  :bind (:map c-ts-mode-map
              ("C-c C-d m" . my/man-at-point)   ; requires pacman -S man-pages
              ("C-c C-d C-m" . my/man-frame)))

(use-package c++-ts-mode
  :defer t
  :ensure nil
  :preface
  (defun my/cpp-ts-style ()
    ;; Linux kernel-like tabs/8 for C++ (Tree-sitter)
    (setq-local indent-tabs-mode t)
    (setq-local tab-width 8)
    (setq-local c++-ts-mode-indent-style 'linux)
    (setq-local c++-ts-mode-indent-offset 8))
  :hook (c++-ts-mode . my/cpp-ts-style)
  :bind (:map c++-ts-mode-map
              ("C-c C-d m" . my/man-at-point)   ; requires pacman -S man-pages
              ("C-c C-d C-m" . my/man-frame)))

(provide 'lang-overrides)
