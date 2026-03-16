;;; better-shell-lite.el --- Better shell management (minimal, local only)
;; Copyright (C) 2016 Russell Black
;; Copyright (C) 2026 Adam Schaefers

;; Original Author: Russell Black (killdash9@github)
;; Maintainer: Adam Schaefers
;; Keywords: convenience
;; URL: https://github.com/killdash9/better-shell (original)
;; Version: 2.0.0
;; Package-Requires: ((emacs "27.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;;; Commentary:
;;
;; Stripped down to just `better-shell-for-current-dir', local shells only. Host / TRAMP awareness and other features are removed.

;; Bring up a shell in the same directory as the current buffer, choosing an existing shell if possible. The shell chosen is guaranteed to be idle (not currently running a command). It first looks for an idle shell that is already in the buffer's directory. If none is found, it looks for another idle shell on the same host as the buffer. If one is found, that shell is selected and automatically placed into the buffer's directory with a cd command. Otherwise, a new shell is created on the same host and in the same directory as the buffer.

;;; Code:
(require 'cl-lib)
(require 'shell)

(defun better-shell-idle-p (buf)
  "Return t if the shell in BUF is not running something."
  (with-current-buffer buf
    (let ((comint-says-idle
           (and (> (point) 1)
                (equal '(comint-highlight-prompt)
                       (get-text-property (1- (point)) 'font-lock-face)))))
      (condition-case nil
          (pcase (call-process "pgrep" nil nil nil "-P"
                               (number-to-string
                                (process-id (get-buffer-process buf))))
            (0 nil)
            (1 t)
            (_ comint-says-idle))
        (error comint-says-idle)))))

(defun better-shell-shells ()
  "Return a list of buffers running shells."
  (cl-remove-if-not
   (lambda (buf)
     (and (get-buffer-process buf)
          (with-current-buffer buf
            (derived-mode-p 'shell-mode))))
   (buffer-list)))

(defun better-shell-idle-shells ()
  "Return all idle shell buffers."
  (let ((current-buffer (current-buffer)))
    (cl-remove-if-not
     (lambda (buf)
       (and (better-shell-idle-p buf)
            (not (eq current-buffer buf))))
     (better-shell-shells))))

(defun better-shell-default-directory (buf)
  "Return the default directory for BUF."
  (with-current-buffer buf
    default-directory))

;;;###autoload
(defun better-shell-for-current-dir ()
  "Find or create a shell in the buffer's directory."
  (interactive)
  (better-shell-for-dir default-directory))

(defun better-shell-for-dir (dir)
  "Find or create a shell in DIR."
  (let* ((idle-shells (better-shell-idle-shells))
         (idle-shell
          (or (cl-find dir idle-shells
                       :key #'better-shell-default-directory
                       :test #'string-equal)
              (car idle-shells)
              (shell (generate-new-buffer-name "*shell*")))))
    (unless (string-equal dir (better-shell-default-directory idle-shell))
      (with-current-buffer idle-shell
        (comint-delete-input)
        (goto-char (point-max))
        (insert (format "cd %S" (expand-file-name dir)))
        (comint-send-input)))
    (pop-to-buffer idle-shell)))

(provide 'better-shell-lite)
;;; better-shell-lite.el ends here
