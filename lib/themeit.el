;;; themeit.el --- Declarative Emacs UI configuration -*- lexical-binding: t; no-byte-compile: t; -*-

;; Copyright (C) 2026 Adam Schaefers

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:
;;
;; Example
;; (use-package themeit
;;   :load-path "lib"
;;   :ensure nil
;;   :demand t
;;   :init
;;   (setq themeit/font "Aporetic Sans Mono"
;;         themeit/font-size 130
;;         themeit/theme-builtin nil
;;         ;; themeit/theme 'modus-operandi
;;         themeit/alpha-background 95
;;         themeit/startup-screen nil
;;         themeit/kill-scratch t
;;         themeit/line-numbers nil
;;         themeit/hl-line t
;;         themeit/blink-cursor t
;;         themeit/context-menu nil
;;         themeit/minimal-ui t
;;         themeit/frame-size t
;;         themeit/frame-width 150
;;         themeit/frame-height 40
;;         themeit/scratch-mode 'fundamental-mode
;;         themeit/silent-bell t
;;         themeit/scroll-step 1))
;;

;;; Code:

;; Defaults
(defvar themeit/font "Source Code Pro"
  "Font family name. Falls back to Monospace if unavailable.")
(defvar themeit/font-size 150
  "Font height (e.g. 150 = 15pt).")
(defvar themeit/context-menu nil
  "When non-nil, enable right-click context menu.")
(defvar themeit/startup-screen t
  "When non-nil, show the startup screen.")
(defvar themeit/kill-scratch t
  "When non-nil, kill the *scratch* buffer on startup.")
(defvar themeit/alpha-background 95
  "Frame background opacity (0-100). Nil to disable.")
(defvar themeit/line-numbers t
  "Enable line numbers in prog-mode. t for absolute, 'relative or 'visual.")
(defvar themeit/theme-builtin t
  "When non-nil, load the builtin theme specified by `themeit/theme'.")
(defvar themeit/theme 'modus-operandi
  "Builtin theme to load on startup.")
(defvar themeit/hl-line t
  "When non-nil, highlight the current line.")
(defvar themeit/blink-cursor t
  "When non-nil, enable cursor blinking.")
(defvar themeit/minimal-ui nil
  "When non-nil, disable scroll-bar, fringe, menu-bar, tool-bar, and tooltips.")
(defvar themeit/frame-size nil
  "When non-nil, set initial frame dimensions via `themeit/frame-width' and `themeit/frame-height'.")
(defvar themeit/frame-width 150
  "Initial frame width in columns. Only used when `themeit/frame-size' is non-nil.")
(defvar themeit/frame-height 40
  "Initial frame height in lines. Only used when `themeit/frame-size' is non-nil.")
(defvar themeit/scratch-mode 'lisp-interaction-mode
  "Major mode for the *scratch* buffer.")
(defvar themeit/silent-bell t
  "When non-nil, silence the audible bell.")
(defvar themeit/scroll-step 1
  "Lines to scroll when point moves off-screen. Nil to disable.")

(add-hook 'window-setup-hook
          (lambda ()
            (let ((height themeit/font-size))
              (if (find-font (font-spec :name themeit/font))
                  (set-face-attribute 'default nil :family themeit/font :height height)
                (set-face-attribute 'default nil :family "Monospace" :height height)
                (message "%s unavailable, falling back to Monospace" themeit/font)))))

(context-menu-mode (if themeit/context-menu 1 -1))

(setq inhibit-startup-screen (not themeit/startup-screen))

(when themeit/kill-scratch
  (add-hook 'window-setup-hook
            (lambda () (when (get-buffer "*scratch*")
                         (kill-buffer "*scratch*")))))

(when themeit/alpha-background
  (set-frame-parameter nil 'alpha-background themeit/alpha-background)
  (add-to-list 'default-frame-alist `(alpha-background . ,themeit/alpha-background)))

(when themeit/line-numbers
  (setq display-line-numbers-type themeit/line-numbers)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode))

(when (and themeit/theme-builtin themeit/theme)
  (load-theme themeit/theme t))

(global-hl-line-mode (if themeit/hl-line 1 -1))

(blink-cursor-mode (if themeit/blink-cursor 1 -1))

(when themeit/minimal-ui
  (scroll-bar-mode -1)
  (fringe-mode -1)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1))

(when themeit/frame-size
  (set-frame-size nil themeit/frame-width themeit/frame-height))

(setq initial-major-mode themeit/scratch-mode)

(when themeit/silent-bell
  (setq ring-bell-function 'ignore))

(when themeit/scroll-step
  (setq scroll-step themeit/scroll-step))

(provide 'themeit)
