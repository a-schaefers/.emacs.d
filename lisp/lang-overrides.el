;;; -*- lexical-binding: t; no-byte-compile: t; -*-

(use-package c-ts-mode
  :defer t
  :ensure nil
  :preface
  (defun my-c-ts-style ()
    ;; Use Linux kernel coding style in C (Tree-sitter)
    ;; https://www.kernel.org/doc/html/v4.10/process/coding-style.html
    (setq-local indent-tabs-mode t)     ; Use tabs
    (setq-local tab-width 8)            ; Display width of tab
    (setq-local c-ts-mode-indent-style 'linux)
    (setq-local c-ts-mode-indent-offset 8))
  :hook (c-ts-mode . my-c-ts-style))

(use-package c++-ts-mode
  :defer t
  :ensure nil
  :preface
  (defun my-cpp-ts-style ()
    ;; Linux kernel-like tabs/8 for C++ (Tree-sitter)
    (setq-local indent-tabs-mode t)
    (setq-local tab-width 8)
    (setq-local c++-ts-mode-indent-style 'linux)
    (setq-local c++-ts-mode-indent-offset 8))
  :hook (c++-ts-mode . my-cpp-ts-style))

(provide 'lang-overrides)
