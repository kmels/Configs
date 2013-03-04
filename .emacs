; ****************************************
; general 
; ****************************************
; If some program uses a cabal binary (maybe cabal-dev for haskell-mode)
(setenv "PATH" (concat "/home/kmels/.cabal/bin:" (getenv "PATH")))

(global-set-key "\M-n" 'next-buffer)
(global-set-key "\M-p" 'previous-buffer)
(global-set-key (kbd "<f2> RET") 'make-frame-command)

;navigation
(global-set-key (kbd "<S-s-iso-lefttab>") 'other-window)

;org-mode
(global-set-key (kbd "<s-f1>") 'org-mobile-push)

; FONT
;(set-default-font "-unknown-Inconsolata-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
;(set-default-font "-microsoft-Consolas-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")

; avoid backup (~) temp file
(setq make-backup-files nil)

; enable clipboard
(setq x-select-enable-clipboard t )

;; ***************************************
;; color-theme (make emacs look better)
;; ****************************************
(add-to-list 'load-path "~/.emacs.d/common/color-theme-6.6.0")
(load "~/.emacs.d/color-theme-tomorrow-night.el")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-kmels)))

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

;; ;****************************************
;; ; Nxhtml-mode (DEACTIVATED)
;; ;****************************************
; (load "~/.emacs.d/webdev/nxhtml/autostart.el")
 ;;(setq mumamo-background-colors nil) 
; (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))

;; ;****************************************
;; ; Espresso mode for javascript (DEACTIVATED)
;; ;****************************************
;(load "~/.emacs.d/webdev/espresso.el")
;(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
;(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
;(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;; ****************************************
;; haskell-mode
;; https://github.com/haskell/haskell-mode
;; ****************************************
(load "~/.emacs.d/prog-lang/haskell-mode/haskell-site-file")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(load "~/.emacs.haskell-mode.init.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

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
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(haskell-notify-p t)
 '(haskell-process-path-cabal-dev "/home/kmels/.cabal/bin/cabal-dev")
 '(haskell-process-type (quote cabal-dev))
 '(haskell-stylish-on-save nil)
 '(haskell-tags-on-save t)
 '(org-agenda-files (quote ("~/Dropbox/org/rezepte.org" "~/code/tautologer/doc/reduced-sentences-list.org" "~/Dropbox/org/dudas-aleman.org" "~/Dropbox/org/comprar.org" "~/Dropbox/org/kmels.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;****************************************(
;haskell-mode new stuff (TRUNK)
;****************************************
;(load "~/.emacs.d/prog-lang/haskell-mode/examples/init.el")

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

; email
(load "~/.emacs.mu4e.conf.el")
(put 'erase-buffer 'disabled nil)
