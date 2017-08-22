;****************************************
; key bindings
;****************************************

; Cycle through windows
(global-set-key (kbd "M-p") 'previous-multiframe-window)
(global-set-key (kbd "M-n") 'next-multiframe-window)

; Cycle through buffers
(global-set-key (kbd "C-<left>")  'previous-buffer)
(global-set-key (kbd "C-<right>") 'next-buffer)

(setq make-backup-files nil) ;; Don't create files with '#' appended at both ends
(defun sudo-edit (&optional arg) "Edit currently visited file as root.

; With a prefix ARG prompt for a file to visit.
; Will also prompt for a file to visit if current
; buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-x C-r") 'sudo-edit)

; ****************************************
; general 
; ****************************************
(setq tramp-default-method "ssh")
(setenv "LANG" "C.UTF-8")
(global-set-key (kbd "<f2> RET") 'make-frame-command)

;navigation
(global-set-key (kbd "<S-s-iso-lefttab>") 'other-window)

;org-mode
(global-set-key (kbd "<s-f1>") 'org-mobile-push)

; programming
(global-set-key (kbd "C-{") 'comment-region)
(global-set-key (kbd "C-}") 'uncomment-region)


; FONT
;(set-default-font "-unknown-Inconsolata-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
;(set-default-font "-microsoft-Consolas-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")

; avoid backup (~) temp file
(setq make-backup-files nil)

; enable clipboard
(setq x-select-enable-clipboard t )

; ***************************************
; theme
;; ****************************************
(load-file "~/.emacs.d/themes/cyberpunk-theme-20151215.953.el")

;; ****************************************
;; org-mode 
;; ****************************************
(setq load-path (cons "~/.emacs.d/common/org-7.8.03/lisp/" load-path))
(setq load-path (cons "~/.emacs.d/common/org-7.8.03/contrib/lisp/" load-path))
    
(require 'org)
(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(transient-mark-mode 1)

; automatically org-mobile-push on save of a file
(add-hook 
 'after-save-hook 
 (lambda ()
   (let (
         (org-filenames (mapcar 'file-name-nondirectory org-agenda-files)) ; list of org file names (not paths)
         (filename (file-name-nondirectory buffer-file-name)) ; list of the buffers filename (not path)
         )
     (if (find filename org-filenames :test #'string=)
         (org-mobile-push)        
       )
     )
   )
)


;; Location of org files
(setq org-directory "~/Dropbox/org")
;; MobileOrg, where to pull new notes
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; MobileOrg, what to push
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; ****************************************
;; ledger (accounting)
;; ****************************************
(defun ledger-add-entry (title in amount out)
      (interactive
       (let ((accounts (mapcar 'list (ledger-accounts))))
         (list (read-string "Entry: " (format-time-string "%Y-%m-%d " (current-time)))
               (let ((completion-regexp-list "^Ausgaben:"))
                 (completing-read "What did you pay for? " accounts))
               (read-string "How much did you pay? " "Q ")
               (let ((completion-regexp-list "^VermÃ¶gen:"))
                 (completing-read "Where did the money come from? " accounts)))))
      (insert title)
      (newline)
      (indent-to 4)
      (insert in "  " amount)
      (newline)
      (indent-to 4)
      (insert out))


; ****************************************
; scala-mode (DEACTIVATED)
; ****************************************
; (add-to-list 'load-path (expand-file-name "~/.emacs.d/prog-lang/scala-mode"))
; (load "scala-mode-auto.el")

; (require 'scala-mode-auto)

; (add-hook 'scala-mode-hook
;           '(lambda ()
;              (yas/minor-mode-on)))

;****************************************
; MELPA (Milkypostman’s Emacs Lisp Package Archive)
;****************************************
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; --------------------------------------------------
;; Haskell: haskell-mode, ghc-mod, stylish-haskell
;; https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md 
;; --------------------------------------------------
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(eval-after-load 'haskell-mode
          '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))
(setenv "PATH" (concat "~/.cabal/bin:" (getenv "PATH")))
(add-to-list 'exec-path "~/.cabal/bin")

(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))
(custom-set-variables '(haskell-tags-on-save t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (magit)))
 '(custom-safe-themes (quote ("3df3f258afcd48be4da5b55fda0dda928a3f2497c7c0b47922719fa3acc5c041" "f37d09076188b2e8d2a6847931deec17f640853aedd8ea4ef3ac57db01335008" default)))
 '(ensime-default-scala-version "2.11.5")
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote cabal-repl))
 '(haskell-tags-on-save t)
 '(org-agenda-files (quote ("~/Dropbox/org/rezepte.org" "~/code/tautologer/doc/reduced-sentences-list.org" "~/Dropbox/org/dudas-aleman.org" "~/Dropbox/org/comprar.org" "~/Dropbox/org/kmels.org"))))

(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-ode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))



;; initialize ghc-mod when opening haskell files
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
;(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; haskell autocompletion
;(require 'company)
;(add-hook 'haskell-mode-hook 'company-mode)
;(add-to-list 'company-backends 'company-ghc)
;(custom-set-variables '(company-ghc-show-info t))

;; The first one is rainbow-delimiters. Its goal is very simple: show each level of parenthesis or braces in a different color. In that way, you can easily spot until from point some expression scopes. Furthermore, if the delimiters do not match, the extra ones are shown in a warning, red col
;(require 'rainbow-delimiters)
;(global-rainbow-delimiters-mode)

;NOTE: the three indendation modules are mutually exclusive (at most 1 can be used).

; ****************************************
; r-mode, http://ess.r-project.org (DEACTIVATED)
; ****************************************
;(add-to-list 'load-path "~/.emacs.d/statistics/ess-5.14/lisp")
;(require 'ess-site)

;****************************************
; octave-mode (DEACTIVATED)
;****************************************
;(autoload 'octave-mode "octave-mod" nil t)
;(setq auto-mode-alist
;      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;****************************************
; Set 4 Space Indent http://stackoverflow.com/questions/69934/set-4-space-indent-in-emacs-in-text-mode
;****************************************
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;****************************************
; custom variables
;****************************************

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;****************************************
; tools
;****************************************
(defun count-words (start end)
    "Print number of words in the region."
    (interactive "r")
    (save-excursion
      (save-restriction
        (narrow-to-region start end)
        (goto-char (point-min))
        (count-matches "\\sw+"))))

;****************************************
;autocomplete
;****************************************
;(add-to-list 'load-path "~/.emacs.d/")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
;(ac-config-default)

;****************************************
; hamlet-mode
;****************************************
;(add-to-list 'load-path "~/.emacs.d/meta-lang/hamlet-mode.el")
;(require 'hamlet-mode)


;----------------------------------------
; markdown-mode - http://jblevins.org/projects/markdown-mode/markdown-mode.el
;----------------------------------------
(add-to-list 'load-path "~/.emacs.d/meta-lang/markdown-mode.el")
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;****************************************
;php
;****************************************
;(add-to-list 'load-path "/home/kmels/.emacs.d/prog-lang/")
;(require 'php-mode)

;----------------------------------------
; Stack exchange beta (https://github.com/vermiculus/sx.el/)
;----------------------------------------
;(add-to-list 'load-path "~/.emacs.d/sx.el")
;(require 'sx-load)


;----------------------------------------
; F#
;----------------------------------------
;;; Install fsharp-mode
(unless (package-installed-p 'fsharp-mode)
  (package-install 'fsharp-mode))

(require 'fsharp-mode)

(setq inferior-fsharp-program "/home/campesino/bin/fsharp/lib/release/fsharpi --readline-")
(setq fsharp-compiler "/home/campesino/bin/fsharp/lib/release/fsharpc")

(setenv "PATH" (concat "~/bin:" (getenv "PATH")))
(when (not package-archive-contents)
  (package-refresh-contents))
;;; scala 
;(require 'ensime)

(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

; ESS (R) mode 
;(require 'ess-site)
;(add-to-list 'load-path "~/.emacs.d/statistics/ess-15.03-1/lisp/")
;(load "ess-site")
 
(require 'whitespace)
(autoload 'whitespace-mode           "whitespace" "Toggle whitespace visualization."        t)

;; python autocomplete
;;(load-file "~/.emacs.d/prog-lang/emacs-for-python/epy-init.el")

;;(add-to-list 'load-path "path/to/emacs-for-python/") ;; tell where to load the various files

;(require 'epy-setup)      ;; It will setup other loads, it is required!

;(require 'epy-python)     ;; If you want the python facilities [optional]

;(require 'epy-completion) ;; If you want the autocompletion settings [optional]

;(require 'epy-editing)    ;; For configurations related to editing [optional]

;(require 'epy-bindings)   ;; For my suggested keybindings [optional]

;(require 'epy-nose)       ;; For nose integration

(put 'erase-buffer 'disabled nil)

(require 'iso-transl)


