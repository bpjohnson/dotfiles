;;; init.el --- Emacs main configuration file -*- lexical-binding: t; -*-
;;;
;;; Commentary:
;;; Emacs config by Andrey Orst.
;;; This file was automatically generated by `org-babel-tangle'.
;;; Do not change this file.  Main config is located in .emacs.d/config.org
;;;
;;; Code:

(defvar my--gc-cons-threshold gc-cons-threshold)
(defvar my--gc-cons-percentage gc-cons-percentage)
(defvar my--file-name-handler-alist file-name-handler-alist)

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      message-log-max 16384
      auto-window-vscroll nil
      package-enable-at-startup nil
      file-name-handler-alist nil)

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold my--gc-cons-threshold
                  gc-cons-percentage my--gc-cons-percentage
                  file-name-handler-alist my--file-name-handler-alist)))

(setq package-enable-at-startup nil
      package--init-file-ensured t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(setq ring-bell-function 'ignore)

(setq backup-by-copying t
      create-lockfiles nil
      backup-directory-alist '(("." . "~/.cache/emacs-backups"))
      auto-save-file-name-transforms '((".*" "~/.cache/emacs-backups" t)))

(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'after-init-hook (lambda () (setq echo-keystrokes 5)))

(global-unset-key (kbd "S-<down-mouse-1>"))
(global-unset-key (kbd "<mouse-3>"))
(global-unset-key (kbd "S-<mouse-3>"))

(setq-default indent-tabs-mode nil
              scroll-step 1
              scroll-conservatively 10000
              auto-window-vscroll nil)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file :noerror)

(defadvice en/disable-command (around put-in-custom-file activate)
  "Put declarations in `custom-file'."
  (let ((user-init-file custom-file))
    ad-do-it))

(savehist-mode 1)

(setq default-input-method 'russian-computer)

(setq column-number-mode nil
      line-number-mode nil
      size-indication-mode nil
      mode-line-position nil)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; suppress byte-compiler warnings
(declare-function minibuffer-keyboard-quit "delsel" (&optional ARGS))

(defun my/escape ()
  "Quit in current context.

When there is an active minibuffer and we are not inside it close
it.  When we are inside the minibuffer use the regular
`minibuffer-keyboard-quit' which quits any active region before
exiting.  When there is no minibuffer `keyboard-quit' unless we
are defining or executing a macro."
  (interactive)
  (cond ((active-minibuffer-window)
         (if (minibufferp)
             (minibuffer-keyboard-quit)
           (abort-recursive-edit)))
        ((when (bound-and-true-p iedit-mode)
           (iedit-mode)))
        (t
         ;; ignore top level quits for macros
         (unless (or defining-kbd-macro executing-kbd-macro)
           (keyboard-quit)))))

(global-set-key [remap keyboard-quit] #'my/escape)

(defun my/ensure-installed (package)
  "Ensure that PACKAGE is installed."
  (when (not (package-installed-p package))
    (package-install package)))

(my/ensure-installed 'use-package)
(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-splash-screen t
      initial-major-mode 'org-mode
      initial-scratch-message "")

(tooltip-mode -1)
(menu-bar-mode -1)
(fset 'menu-bar-open nil)

(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

(when window-system
  (setq-default cursor-type 'bar
                cursor-in-non-selected-windows nil))

(setq-default frame-title-format '("%b — Emacs"))

(when window-system
  (set-frame-size (selected-frame) 190 52))

(set-face-attribute 'default nil :font "Source Code Pro-10")

(when window-system
  (fringe-mode 0))

(when window-system
  (or standard-display-table
      (setq standard-display-table (make-display-table)))
  (set-display-table-slot standard-display-table 0 ?\ ))

(setq mode-line-in-non-selected-windows nil)

(use-package all-the-icons)

(use-package doom-themes
  :commands (doom-themes-org-config
             doom-themes-treemacs-config)
  :functions (all-the-icons-octicon)
  :defines (treemacs-icon-root-png
            doom-treemacs-use-generic-icons
            treemacs-icon-open-png
            treemacs-icon-closed-png
            treemacs-icon-fallback
            treemacs-icons-hash
            treemacs-icon-text)
  :init
  (load-theme 'doom-one t)
  (doom-themes-org-config)
  (doom-themes-treemacs-config)
  (eval-after-load 'treemacs
    (lambda ()
      "Adjust DOOM Themes settings for Treemacs.

This lambda function sets root icon to be regular folder icon,
and adds `chevron' icons to directories in order to display
opened and closed states.  Also it indents all file icons with
two spaces to match new directory icon indentation."
      (unless (require 'all-the-icons nil t)
        (error "`all-the-icons' isn't installed"))
      (when doom-treemacs-use-generic-icons
        (let ((all-the-icons-default-adjust 0))
          (setq treemacs-icon-root-png
                (concat " " (all-the-icons-octicon
                             "file-directory"
                             :v-adjust 0
                             :face '(:inherit font-lock-doc-face :slant normal))
                        " ")
                treemacs-icon-open-png
                (concat (all-the-icons-octicon
                         "chevron-down"
                         :height 0.75
                         :face '(:inherit font-lock-doc-face :slant normal))
                        " "
                        (all-the-icons-octicon
                         "file-directory"
                         :v-adjust 0
                         :face '(:inherit font-lock-doc-face :slant normal))
                        " ")
                treemacs-icon-closed-png
                (concat (all-the-icons-octicon
                         "chevron-right"
                         :height 0.9
                         :face '(:inherit font-lock-doc-face :slant normal))
                        " "
                        (all-the-icons-octicon
                         "file-directory"
                         :v-adjust 0
                         :face '(:inherit font-lock-doc-face :slant normal))
                        " "))
          (setq treemacs-icons-hash (make-hash-table :size 200 :test #'equal)
                treemacs-icon-fallback (concat "  " (all-the-icons-octicon "file-code" :v-adjust 0) " ")
                treemacs-icon-text treemacs-icon-fallback)))
      (treemacs-define-custom-icon (concat "  " (all-the-icons-octicon "file-media" :v-adjust 0))
                                   "png" "jpg" "jpeg" "gif" "ico" "tif" "tiff" "svg" "bmp"
                                   "psd" "ai" "eps" "indd" "mov" "avi" "mp4" "webm" "mkv"
                                   "wav" "mp3" "ogg" "midi")
      (treemacs-define-custom-icon (concat "  " (all-the-icons-octicon "file-text" :v-adjust 0))
                                   "md" "markdown" "rst" "log" "org" "txt"
                                   "CONTRIBUTE" "LICENSE" "README" "CHANGELOG")
      (treemacs-define-custom-icon (concat "  " (all-the-icons-octicon "file-code" :v-adjust 0))
                                   "yaml" "yml" "json" "xml" "toml" "cson" "ini"
                                   "tpl" "erb" "mustache" "twig" "ejs" "mk" "haml" "pug" "jade")))
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(defun my/set-frame-dark (&optional frame)
  "Set FRAME titlebar colorscheme to dark variant."
  (with-selected-frame (or frame (selected-frame))
    (call-process-shell-command
     (concat "xprop -f _GTK_THEME_VARIANT 8u -set"
             " _GTK_THEME_VARIANT \"dark\" -name \""
             (frame-parameter frame 'name)
             "\""))))

(when window-system
  (my/set-frame-dark)
  (add-hook 'after-make-frame-functions 'my/set-frame-dark :after))

(defun my/real-buffer-p ()
  "Determines whether buffer is real."
  (or (and (not (minibufferp))
           (buffer-file-name))
      (string-equal (buffer-name) "*scratch*")))

(use-package solaire-mode
  :commands (solaire-global-mode
             solaire-mode-swap-bg
             turn-on-solaire-mode
             solaire-mode-in-minibuffer
             solaire-mode-reset)
  :config
  (add-hook 'focus-in-hook #'solaire-mode-reset)
  (add-hook 'after-revert-hook #'turn-on-solaire-mode)
  (add-hook 'change-major-mode-hook #'turn-on-solaire-mode)
  (add-hook 'org-capture-mode-hook #'turn-on-solaire-mode :after)
  (add-hook 'org-src-mode-hook #'turn-on-solaire-mode :after)
  :init
  (setq solaire-mode-real-buffer-fn #'my/real-buffer-p)
  (solaire-global-mode +1)
  (solaire-mode-swap-bg))

(defun my/real-buffer-setup (&rest _)
  "Wrapper around `set-window-fringes' function."
  (when (my/real-buffer-p)
    (set-window-fringes nil 8 8 nil)
    (setq-local scroll-margin 3)))

(add-hook 'window-configuration-change-hook 'my/real-buffer-setup)
(add-hook 'org-capture-mode-hook 'my/real-buffer-setup)
(add-hook 'org-src-mode-hook 'my/real-buffer-setup)

(use-package doom-modeline
  :commands (doom-modeline-mode
             doom-modeline-set-selected-window)
  :init (doom-modeline-mode 1)
  (set-face-attribute 'doom-modeline-buffer-path nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-buffer-file nil :foreground (doom-color 'fg) :weight 'semi-bold)
  (set-face-attribute 'doom-modeline-buffer-modified nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-buffer-major-mode nil :foreground (doom-color 'fg) :weight 'semi-bold)
  (set-face-attribute 'doom-modeline-buffer-minor-mode nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-project-parent-dir nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-project-dir nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-project-root-dir nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-highlight nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-panel nil :foreground (doom-color 'fg) :background (doom-color 'bg-alt))
  (set-face-attribute 'doom-modeline-debug nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-info nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-warning nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-urgent nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-unread-number nil :foreground (doom-color 'fg) :weight 'normal)
  (set-face-attribute 'doom-modeline-bar nil :foreground (doom-color 'fg) :background (doom-color 'bg-alt) :weight 'normal)
  :config
  (advice-add #'select-window :after #'doom-modeline-set-selected-window)
  (setq doom-modeline-bar-width 3
        doom-modeline-major-mode-color-icon nil
        doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-minor-modes t
        doom-modeline-lsp nil
        find-file-visit-truename t))

(use-package treemacs
  :commands (treemacs
             treemacs-follow-mode
             treemacs-filewatch-mode
             treemacs-fringe-indicator-mode
             doom-color
             doom-modeline-focus
             treemacs-TAB-action)
  :bind (("<f8>" . treemacs)
         ("<f9>" . treemacs-select-window))
  :config
  (set-face-attribute 'treemacs-root-face nil
                      :foreground (doom-color 'fg)
                      :height 1.0
                      :weight 'normal)
  :init
  (defun treemacs-expand-all-projects (&optional _)
    "Expand all projects."
    (save-excursion
      (treemacs--forget-last-highlight)
      (dolist (project (treemacs-workspace->projects (treemacs-current-workspace)))
        (-when-let (pos (treemacs-project->position project))
          (when (eq 'root-node-closed (treemacs-button-get pos :state))
            (goto-char pos)
            (treemacs--expand-root-node pos)))))
    (treemacs--maybe-recenter 'on-distance))
  (add-hook 'treemacs-mode-hook
            (lambda ()
              (setq line-spacing 4)))
  (setq treemacs-width 27
        treemacs-is-never-other-window t
        treemacs-space-between-root-nodes nil)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode nil)
  (when window-system
    (treemacs)
    (treemacs-expand-all-projects)))

(use-package treemacs-projectile)

(use-package treemacs-magit)

(use-package eyebrowse
  :commands eyebrowse-mode
  :init
  (eyebrowse-mode t))

(use-package diff-hl
  :commands global-diff-hl-mode
  :init
  (add-hook 'diff-hl-mode-hook #'my/setup-fringe-bitmaps)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode 1))

(defun my/setup-fringe-bitmaps ()
  "Set fringe bitmaps."
  (define-fringe-bitmap 'diff-hl-bmp-top [224] nil nil '(center repeated))
  (define-fringe-bitmap 'diff-hl-bmp-middle [224] nil nil '(center repeated))
  (define-fringe-bitmap 'diff-hl-bmp-bottom [224] nil nil '(center repeated))
  (define-fringe-bitmap 'diff-hl-bmp-insert [224] nil nil '(center repeated))
  (define-fringe-bitmap 'diff-hl-bmp-single [224] nil nil '(center repeated))
  (define-fringe-bitmap 'diff-hl-bmp-delete [240 224 192 128] nil nil 'top))

(use-package org-bullets
  :commands org-bullets-mode
  :config
  (setq-default org-bullets-bullet-list
                '("◉" "○" "•" "◦" "◦" "◦" "◦" "◦" "◦" "◦" "◦"))
  :init
  (when window-system
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))))

(use-package minions
  :commands minions-mode
  :config (setq minions-direct '(multiple-cursors-mode
                                 flycheck-mode
                                 flyspell-mode
                                 parinfer-mode))
  :init (minions-mode 1))

(use-package eldoc-box
  :commands eldoc-box-hover-mode
  :config
  (set-face-attribute 'eldoc-box-border nil :background "#191B20")
  :init
  (advice-add 'eldoc-box-hover-mode :after 'eldoc-box-hover-at-point-mode)
  (add-hook 'eglot--managed-mode-hook #'eldoc-box-hover-mode t)
  (setq eldoc-box-max-pixel-width 1920
        eldoc-box-max-pixel-height 1080))

(when window-system
  (setq window-divider-default-right-width 1)
  (window-divider-mode 1))

(require 'org)
(add-hook 'org-mode-hook
          (lambda()
            (flyspell-mode)
            (setq default-justification 'full
                  org-startup-with-inline-images t
                  org-startup-folded 'content
                  org-hide-emphasis-markers t
                  org-adapt-indentation nil
                  org-hide-leading-stars t
                  org-highlight-latex-and-related '(latex)
                  revert-without-query '(".*\.pdf"))
            (auto-fill-mode)
            (set-face-attribute 'org-document-title nil :height 1.6)
            (set-face-attribute 'org-level-1        nil :height 1.4)
            (set-face-attribute 'org-level-2        nil :height 1.2)
            (set-face-attribute 'org-level-3        nil :height 1.0)))

(setq org-src-fontify-natively t)

(defvar flycheck-disabled-checkers)

(defun my/disable-flycheck-in-org-src-block ()
  "Disable checkdoc in emacs-lisp buffers."
  (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(add-hook 'org-src-mode-hook 'my/disable-flycheck-in-org-src-block)

(defun my/org-tangle-on-config-save ()
  "Tangle source code blocks when configuration file is saved."
  (when (string= buffer-file-name (file-truename "~/.emacs.d/config.org"))
    (org-babel-tangle)
    (byte-compile-file "~/.emacs.d/init.el")))

(add-hook 'after-save-hook 'my/org-tangle-on-config-save)

(defvar org-inline-image-overlays)

(defun my/org-update-inline-images ()
  "Update inline images in Org-mode."
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))

(add-hook 'org-babel-after-execute-hook 'my/org-update-inline-images)

(setq org-preview-latex-image-directory ".ltximg/")

(define-key org-mode-map [backtab] nil)
(define-key org-mode-map [S-iso-lefttab] nil)
(define-key org-mode-map [C-tab] nil)
(define-key org-mode-map [C-tab] 'org-shifttab)

(require 'ox-latex)
(setq org-latex-listings 'minted)

(defvar minted-cache-dir
  (file-name-as-directory
   (expand-file-name ".minted/\\jombname"
                     temporary-file-directory)))

(add-to-list 'org-latex-packages-alist
             `(,(concat "cachedir=" minted-cache-dir)
               "minted" nil))

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(eval-after-load 'org
  '(add-to-list 'org-latex-logfiles-extensions "tex"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((gnuplot . t)
   (scheme . t)))

(setq org-confirm-babel-evaluate nil)

(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(require 'ox-md nil t)

(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

(setq-default doc-view-resolution 192)

(setq-default display-line-numbers-grow-only t
              display-line-numbers-width-start t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(add-hook 'prog-mode-hook 'show-paren-mode)

(defvar c-basic-offset)
(defvar c-default-style)

(add-hook 'c-mode-common-hook
          (lambda ()
            (yas-minor-mode)
            (electric-pair-mode)
            (setq c-basic-offset 4
                  c-default-style "linux"
                  indent-tabs-mode t
                  tab-width 4)))

(mapc (lambda (mode)
        (progn
          (font-lock-add-keywords
           mode
           '(("\\<\\(\\sw+\\) *(" 1 'font-lock-function-name-face)
             ("\\(->\\|\\.\\) *\\<\\([_a-zA-Z]\\w+\\)" 2 'error)
             ("\\<-?\\(0x[0-9a-fA-F]+\\|[0-9]+\\(\\.[0-9]+\\)?\\)\\([uU][lL]\\{0,2\\}\\|[lL]\\{1,2\\}[uU]?\\|[fFdDiI]\\|\\([eE][-+]?\\d+\\)\\)?\\|'\\(\\.?\\|[^'\\]\\)'" 0 'all-the-icons-lorange)
             ("->\\|\\.\\|*\\|+\\|/\\|-\\|<\\|>\\|&\\||\\|=\\|\\[\\|\\]" 0 'font-lock-constant-face))
           t)))
      '(c-mode c++-mode))

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (defvar markdown-command "multimarkdown"))

(add-hook 'markdown-mode-hook
          '(lambda()
             (flyspell-mode)
             (setq fill-column 80
                   default-justification 'left)
             (auto-fill-mode)))

(use-package rust-mode
  :config (add-hook 'rust-mode-hook
                    '(lambda()
                       (racer-mode)
                       (yas-minor-mode)
                       (electric-pair-mode)
                       (setq company-tooltip-align-annotations t))))

(use-package racer
  :config (add-hook 'racer-mode-hook #'eldoc-mode))

(use-package cargo
  :config
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

(modify-syntax-entry ?_ "w" rust-mode-syntax-table)
(font-lock-add-keywords
 'rust-mode
 '(("\\<\\(\\sw+\\) *(" 1 'font-lock-function-name-face)
   ("\\. *\\<\\([_a-zA-Z]\\w+\\)" 1 'error)
   ("\\<-?\\(0x[0-9a-fA-F]+\\|[0-9]+\\(\\.[0-9]+\\)?\\)\\([uU][lL]\\{0,2\\}\\|[lL]\\{1,2\\}[uU]?\\|[fFdDiI]\\|\\([eE][-+]?\\d+\\)\\)?\\|'\\(\\.?\\|[^'\\]\\)'" 0 'all-the-icons-lorange)
   ("->\\|\\.\\|*\\|+\\|/\\|-\\|<\\|>\\|&\\||\\|=\\|\\[\\|\\]\\|\\^" 0 'font-lock-constant-face))
 t)

(use-package toml-mode)

(use-package editorconfig
  :commands editorconfig-mode
  :config
  (editorconfig-mode 1))

(use-package nov
  :commands nov-mode
  :functions solaire-mode
  :mode "\\.epub$"
  :init
  (setq nov-text-width 80)
  (add-hook 'nov-mode-hook #'visual-line-mode)
  (add-hook 'nov-mode-hook #'solaire-mode))

(defun my/ansi-term-toggle ()
  "Toggle ansi-term window on and off with the same command."
  (interactive)
  (cond ((get-buffer-window "*ansi-term*")
         (ignore-errors (delete-window
                         (get-buffer-window "*ansi-term*"))))
        (t (split-window-below)
           (other-window 1)
           (cond ((get-buffer "*ansi-term*")
                  (switch-to-buffer "*ansi-term*"))
                 (t (ansi-term "bash"))))))

(global-set-key (kbd "C-`") 'my/ansi-term-toggle)

(defun my/autokill-when-no-processes (&rest _)
  "Kill buffer and its window when there's no processes left."
  (when (null (get-buffer-process (current-buffer)))
      (kill-buffer (current-buffer))
      (delete-window)))

(advice-add 'term-handle-exit :after 'my/autokill-when-no-processes)

(use-package hydra
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map)
  :bind (("<f5>" . hydra-zoom/body))
  :config
  (defhydra hydra-zoom (:hint nil)
    "Scale text"
    ("+" text-scale-increase "in")
    ("-" text-scale-decrease "out")
    ("0" (text-scale-set 0) "reset")))

(use-package geiser
  :config
  (add-hook 'scheme-mode-hook 'geiser-mode)
  :init
  (setq-default geiser-active-implementations '(guile)
                geiser-default-implementation 'guile))

(use-package parinfer
  :commands parinfer-mode
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults
             pretty-parens
             smart-tab
             smart-yank))
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package flx)

(use-package ivy
  :commands ivy-mode
  :init
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t)
  :bind (("C-x C-b" . ivy-switch-buffer)
         ("C-x b" . ivy-switch-buffer))
  :config
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy))
        ivy-count-format ""
        ivy-display-style nil
        ivy-minibuffer-faces nil)
  (ivy-mode 1))

(when (executable-find "fd")
  (setq find-program "fd"))

(use-package counsel
  :init
  (when (executable-find "fd")
    (setq counsel-file-jump-args "-L --type f --hidden"))
  (setq counsel-rg-base-command
        "rg -S --no-heading --hidden --line-number --color never %s .")
  (setenv "FZF_DEFAULT_COMMAND"
          "rg --files --hidden --follow --no-ignore --no-messages --glob '!.git/*' --glob '!.svn/*'")
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x f" . counsel-fzf)
         ("C-x p" . counsel-file-jump)
         ("C-x C-r" . counsel-recentf)
         ("C-c g" . counsel-git-grep)
         ("C-c r" . counsel-rg)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("C-h l" . counsel-find-library)))

(use-package flycheck)

(use-package flycheck-rust
  :commands (flycheck-rust-setup)
  :init (with-eval-after-load 'rust-mode
          (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package company
  :bind (:map company-active-map
              ("TAB" . company-complete-common-or-cycle)
              ("<tab>" . company-complete-common-or-cycle)
              ("<S-Tab>" . company-select-previous)
              ("<backtab>" . company-select-previous))
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-require-match 'never
        company-minimum-prefix-length 3
        company-tooltip-align-annotations t
        company-frontends
        '(company-pseudo-tooltip-unless-just-one-frontend
          company-preview-frontend
          company-echo-metadata-frontend))
  :config
  (setq company-backends (remove 'company-clang company-backends)
        company-backends (remove 'company-xcode company-backends)
        company-backends (remove 'company-cmake company-backends)
        company-backends (remove 'company-gtags company-backends)))

(use-package company-flx
 :commands company-flx-mode
 :init (with-eval-after-load 'company
         (company-flx-mode +1)))

(use-package undo-tree
  :commands global-undo-tree-mode
  :init
  (global-undo-tree-mode 1))

(use-package yasnippet
  :commands yas-reload-all
  :init (yas-reload-all))

(use-package yasnippet-snippets)

(use-package projectile
  :commands (projectile-mode
             projectile-find-file
             projectile-project-root)
  :defines (my/projectile-project-find-function)
  :bind (("C-c p" . projectile-command-map))
  :init
  (with-eval-after-load 'project
    (defvar project-find-functions)
    (add-to-list 'project-find-functions
                 #'my/projectile-project-find-function))
  (projectile-mode +1)
  (setq projectile-svn-command "fd -L --type f --print0"
        projectile-generic-command "fd -L --type f --print0"
        projectile-require-project-root t
        projectile-enable-caching t
        projectile-completion-system 'ivy))

(defun my/projectile-project-find-function (dir)
  "Handle root search in DIR with Projectile."
  (unless (require 'projectile nil t)
    (error "`projectile' isn't installed"))
  (let ((root (projectile-project-root dir)))
    (and root (cons 'transient root))))

(use-package counsel-projectile
  :commands counsel-projectile-mode
  :config (counsel-projectile-mode))

(use-package magit)

(use-package vdiff
  :init (setq vdiff-lock-scrolling t
              vdiff-diff-algorithm 'diff
              vdiff-disable-folding nil
              vdiff-min-fold-size 4
              vdiff-subtraction-style 'full
              vdiff-subtraction-fill-char ?\ )
  :config
  (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map)
  (set-face-attribute 'vdiff-subtraction-face nil :background "#4F343A" :foreground "#F36868")
  (set-face-attribute 'vdiff-addition-face nil :background "#3E493D" :foreground "#98BE65")
  (set-face-attribute 'vdiff-change-face nil :background "#293239" :foreground "#4f97d7")
  (add-hook 'vdiff-mode-hook #'outline-show-all))

(use-package vdiff-magit
  :commands (vdiff-magit-dwim vdiff-magit)
  :functions (transient-suffix-put)
  :bind (:map magit-mode-map
              ("e" . 'vdiff-magit-dwim)
              ("E" . 'vdiff-magit))
  :init
  (setq vdiff-magit-stage-is-2way t)
  (transient-suffix-put 'magit-dispatch "e" :description "vdiff (dwim)")
  (transient-suffix-put 'magit-dispatch "e" :command 'vdiff-magit-dwim)
  (transient-suffix-put 'magit-dispatch "E" :description "vdiff")
  (transient-suffix-put 'magit-dispatch "E" :command 'vdiff-magit)
  (advice-add 'vdiff-magit-dwim :before 'eyebrowse-create-window-config))

(use-package which-key
  :commands which-key-mode
  :init
  (which-key-mode))

(use-package multiple-cursors
  :commands (mc/cycle-backward
             mc/cycle-forward)
  :bind (("S-<mouse-1>" . mc/add-cursor-on-click)
         ("C-c m" . hydra-mc/body))
  :config (defhydra hydra-mc (:hint nil)
            "
^Select^                ^Discard^                    ^Move^
^──────^────────────────^───────^────────────────────^────^────────────
_M-s_: split lines      _M-SPC_: discard current     _&_: align
_s_:   select regexp    _b_:     discard blank lines _(_: cycle backward
_n_:   select next      _d_:     remove duplicated   _)_: cycle forward
_p_:   select previous  _q_:     exit                ^ ^
_C_:   select next line"
            ("M-s" mc/edit-ends-of-lines)
            ("s" mc/mark-all-in-region-regexp)
            ("n" mc/mark-next-like-this-word)
            ("p" mc/mark-previous-like-this-word)
            ("&" mc/vertical-align-with-space)
            ("(" mc/cycle-backward)
            (")" mc/cycle-forward)
            ("M-SPC" mc/remove-current-cursor)
            ("b" mc/remove-cursors-on-blank-lines)
            ("d" mc/remove-duplicated-cursors)
            ("C" mc/mark-next-lines)
            ("q" mc/remove-duplicated-cursors :exit t)))

(use-package mc-extras
  :config
  (advice-add 'phi-search :after 'mc/remove-duplicated-cursors))

(use-package iedit
  :commands (iedit-mode
             iedit-expand-down-to-occurrence)
  :init
  (setq iedit-toggle-key-default nil)
  (defun my/iedit-select-current-or-add ()
    "Select only current occurrence with `iedit-mode'.  Expand to
next occurrence if `iedit-mode' is already active."
    (interactive)
    (if (bound-and-true-p iedit-mode)
        (iedit-expand-down-to-occurrence)
      (iedit-mode 1)))
  (global-set-key (kbd "C-d") #'my/iedit-select-current-or-add))

(use-package expand-region
  :commands (er/expand-region
             er/mark-paragraph
             er/mark-inside-pairs
             er/mark-outside-pairs
             er/mark-inside-quotes
             er/mark-outside-quotes
             er/contract-region)
  :bind (("C-c e" . hydra-er/body))
  :config (defhydra hydra-er (:hint nil)
            "
^Expand^           ^Mark^
^──────^───────────^────^─────────────────
_e_: expand region _(_: inside pairs
_-_: reduce region _)_: around pairs
^ ^                _q_: inside quotes
^ ^                _Q_: around quotes
^ ^                _p_: paragraph"
            ("e" er/expand-region :post hydra-er/body)
            ("-" er/contract-region :post hydra-er/body)
            ("p" er/mark-paragraph)
            ("(" er/mark-inside-pairs)
            (")" er/mark-outside-pairs)
            ("q" er/mark-inside-quotes)
            ("Q" er/mark-outside-quotes)))

(use-package phi-search
  :bind (("C-s" . phi-search)
         ("C-r" . phi-search-backward)))

(use-package eglot
  :commands (eglot eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '((c-mode c++-mode) "clangd"))
  (add-to-list 'eglot-ignored-server-capabilites :documentHighlightProvider)
  :init
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure))

(use-package clang-format)

(use-package gcmh
  :commands gcmh-mode
  :init (gcmh-mode 1))

(use-package gnuplot)

(use-package vlf-setup
  :ensure vlf
  :config (setq vlf-application 'dont-ask))

(use-package imenu-list
  :defines imenu-list-idle-update-delay-time
  :bind (("<f7>" . imenu-list-smart-toggle))
  :config
  (advice-add 'imenu-list-smart-toggle :after-while
              (lambda()
                (setq window-size-fixed 'width
                      mode-line-format nil)))
  :init (setq imenu-list-idle-update-delay-time 0.1
              imenu-list-size 27
              imenu-list-focus-after-activation t))

(provide 'init)
;;; init.el ends here
