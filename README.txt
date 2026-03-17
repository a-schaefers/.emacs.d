                          .emacs.d
                          --------

  emacs-init-time 0.198643 seconds

  everything is use-package wrapped and deferred

  prefers builtins over external packages (eglot > lsp-mode, flymake > flycheck, etc.)

  tries to unify binds between non-lisps and lisps

  gives a "modern" experience albeit the Emacs-way of doing it

  does not frik with AI


STRUCTURE
---------

  early-init.el       disables package.el, sets theme/font/frame early
  init.el             boot macro loads modules from lisp/

  modules:

    use-package-manager     elpaca bootstrap
    set-env-path            env vars and PATH
    opinionated-defaults    font fallback, keybinds, server, defaults
    completion-minibuffer   vertico, vertico-directory, orderless, savehist
    project-tools           transient, magit, projectile, better-shell-lite, eat
    editing-system          corfu, treesit-auto, flymake, eglot, paredit, treesit-sexp, slime, crux
    lang-overrides          per-language style overrides


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
    C-c C-d C-d   eldoc snapshot in new frame (persists for extended reading sessions)
    C-c !         flymake diagnostics
    C-c C-r       eglot-rename

  C/C++ only (requires pacman -S man-pages):
    C-c C-d m     man page for symbol at point
    C-c C-d C-m   man page in new frame (persists for extended reading sessions)


EGLOT AUTOSTART
---------------

  Opening a file auto-starts eglot if the LSP server binary is on PATH.
  Currently configured:

    c-ts-mode           clangd
    c++-ts-mode         clangd
    lua-ts-mode         lua-language-server
    bash-ts-mode        bash-language-server
    python-ts-mode      pylsp
    go-ts-mode          gopls
    rust-ts-mode        rust-analyzer (+ clippy if cargo-clippy on PATH)
    ruby-ts-mode        solargraph
    elixir-ts-mode      elixir-ls
    html-ts-mode        vscode-html-language-server
    css-ts-mode         vscode-css-language-server
    typescript-ts-mode  typescript-language-server
    js-ts-mode          typescript-language-server
    yaml-ts-mode        yaml-language-server
    json-ts-mode        vscode-json-language-server
    java-ts-mode        jdtls
    csharp-ts-mode      omnisharp


SEXP EVERYWHERE
----------------

  Paredit gives structural editing for lisps. treesit-sexp extends
  the same navigation to all tree-sitter languages. The binds are
  the same -- C-M-f/b/u/d work whether you are in Common Lisp or C.

  Paredit enabled for:

    emacs-lisp  lisp  scheme

  treesit-auto installs grammars on demand and remaps all major modes
  to their -ts-mode variants.

  Shared binds (paredit in lisps, treesit-sexp elsewhere):
    C-M-f       forward-sexp
    C-M-b       backward-sexp
    C-M-u       up / backward-up
    C-M-d       down / forward-down
    C-M-SPC     mark-sexp
    C-M-a       beginning-of-defun
    C-M-e       end-of-defun

  Paredit-only (lisps):
    C-right     paredit-forward-slurp-sexp
    C-left      paredit-forward-barf-sexp
    M-(         paredit-wrap-round
    M-s         paredit-splice-sexp
    M-S         paredit-split-sexp
    M-J         paredit-join-sexps
    M-r         paredit-raise-sexp


KEYBINDS
--------

  C-c i           edit init.el
  F5              compile
  C-<return>      shell in current dir (better-shell-lite)
  C-S-<return>    eat terminal
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
