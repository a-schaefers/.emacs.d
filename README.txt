                          .emacs.d
                          --------

  emacs-init-time 0.229322 seconds

  Everything is use-package wrapped and deferred

  Prefers builtins over external packages

  Tries to unify binds between non-lisps and lisps

  Gives a "modern" experience albeit the Emacs-way of doing it


STRUCTURE
---------

  early-init.el       disables package.el, sets theme/font/frame early (setq)
  init.el             boot macro loads modules from lisp/

  Modules:

    use-package-manager     elpaca bootstrap
    set-env-path            env vars and PATH
    opinionated-defaults    font fallback, keybinds, server, defaults
    completion-minibuffer   vertico, vertico-directory, orderless, savehist
    project-tools           transient, magit, projectile, better-shell-lite, eat
    editing-system          corfu, treesit-auto, flymake, eglot, paredit, treesit-sexp, slime, crux
    lang-overrides          per-language style overrides


PACKAGES
--------

  elpaca                  async package manager
  vertico                 minibuffer completion
  orderless               fuzzy/regexp matching for completion
  savehist                persist minibuffer history (builtin)
  corfu                   in-buffer completion popup
  treesit-auto            auto-install and use tree-sitter grammars
  treesit-sexp            treat all code like lisp (sexp nav everywhere)
  eglot                   LSP client (builtin)
  flymake                 diagnostics (builtin)
  paredit                 structural editing for all lisps
  slime                   superior lisp interaction mode (sbcl)
  crux                    incredibly useful extensions
  magit, transient        git porcelain & newer transient (builtin currently is a no-go for magit)
  projectile              project management
  eat                     terminal emulator
  better-shell-lite       M-x shell wrapper to auto 'cd' to the emacs PWD


COMPLETION
----------

  Minibuffer:  vertico + orderless (basic first, then fuzzy fallback)
  In-buffer:   corfu (auto popup after 3 chars, no delay)


LSP / SLIME UNIFICATION
------------------------

  SLIME had LSP-like features 15 years before LSP existed. For
  non-Common-Lisp languages, eglot/flymake/eldoc are bound to
  feel like SLIME. Whatever language you are in, fingers do the same.

  SLIME keybinds:
    M-.           jump to definition
    M-,           jump back
    C-c C-d d     describe symbol
    C-c C-d C-d   describe symbol (alternate)

  Eglot binds imitate SLIME:
    M-.           xref-find-definitions
    M-,           xref-go-back
    M-?           xref-find-references
    C-c C-d d     eldoc-doc-buffer
    C-c C-d C-d   eldoc-doc-buffer
    C-c !         flymake diagnostics
    C-c C-r       eglot-rename


EGLOT AUTOSTART
---------------

  Opening a file auto-starts eglot if the LSP server binary is on PATH.
  Currently configured:

    c-ts-mode       clangd
    c++-ts-mode     clangd
    lua-ts-mode     lua-language-server


PAREDIT
-------

  Structural editing enabled for:

    emacs-lisp  lisp  scheme

  Default paredit binds:
    C-M-f       paredit-forward
    C-M-b       paredit-backward
    C-M-u       paredit-backward-up
    C-M-d       paredit-forward-down
    C-right     paredit-forward-slurp-sexp
    C-left      paredit-forward-barf-sexp
    M-(         paredit-wrap-round
    M-s         paredit-splice-sexp
    M-S         paredit-split-sexp
    M-J         paredit-join-sexps
    M-r         paredit-raise-sexp


TREE-SITTER
------------

  treesit-auto installs grammars on demand and remaps all major modes
  to their -ts-mode variants. treesit-sexp gives sexp-style navigation
  across all tree-sitter languages, not just lisps.

  treesit-sexp binds:
    C-M-f       forward-sexp
    C-M-b       backward-sexp
    C-M-u       up-list
    C-M-d       down-list
    C-M-SPC     mark-sexp
    C-M-a       beginning-of-defun
    C-M-e       end-of-defun


KEYBINDS
--------

  C-c i           edit init.el
  F5              compile
  C-<return>      shell in current dir (better-shell-lite)
  s-<return>      eat terminal
  C-c p           projectile prefix

  Window management:
    C-1             delete-other-windows
    C-2             split-window-below
    C-3             split-window-right
    C-0             delete-window
    C-<tab>         other-window / switch-buffer (crux)
    S-<right>       enlarge-window-horizontally
    S-<left>        shrink-window-horizontally
    S-<down>        shrink-window-vertically
    S-<up>          enlarge-window-vertically

  Editing (crux):
    C-g             keyboard-quit-dwim
    C-a             move-beginning-of-line-dwim
    C-o             smart-open-line
    C-c d           duplicate line or region
    C-c D           duplicate and comment
    C-c k / C-c C-k kill whole line


LANG OVERRIDES
--------------

  C and C++ indent linux kernel style (tabs, width 8)


DEFAULTS
--------

  font            Aporetic Sans Mono 15 (fallback: Monospace)
  theme           modus-vivendi
  projects dir    ~/repos
  indent          spaces, fill-column 79
  coding          utf-8 everywhere
  server          emacs server auto-starts
  save-place      remembers cursor position
  electric-pair   auto-close parens/brackets
  whitespace      cleaned on save
  scripts         auto-chmod +x on save

  kills *scratch*, keeps the startup screen.
