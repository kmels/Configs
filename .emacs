; ****************************************
; general tweaks
; ****************************************

; FONT
(set-default-font "-unknown-Inconsolata-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")

; avoid backup (~) temp file
(setq make-backup-files nil)

; enable clipboard
(setq x-select-enable-clipboard t )

;; ***************************************
;; color-theme
;; ****************************************
(add-to-list 'load-path "~/.emacs.d/common/color-theme-6.6.0")
(load "~/.emacs.d/color-theme-tomorrow-night.el")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-kmels)))

;; ****************************************
;; org-mode 7.8
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

;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")

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
; scala-mode
; ****************************************
 (add-to-list 'load-path (expand-file-name "~/.emacs.d/prog-lang/scala-mode"))
 (load "scala-mode-auto.el")

 (require 'scala-mode-auto)

 (add-hook 'scala-mode-hook
           '(lambda ()
              (yas/minor-mode-on)))

;; ;****************************************
;; ; Nxhtml-mode
;; ;****************************************
 (load "~/.emacs.d/webdev/nxhtml/autostart.el")
 ;;(setq mumamo-background-colors nil) 
 (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))

;; ;****************************************
;; ; Espresso mode (javascript)
;; ;****************************************
(load "~/.emacs.d/webdev/espresso.el")
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;; ****************************************
;; haskell-mode
;; http://www.haskell.org/haskellwiki/Haskell_mode_for_Emacs
;; ****************************************
(load "~/.emacs.d/prog-lang/haskell-mode/haskell-site-file.el")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

; ****************************************
; r-mode, http://ess.r-project.org
; ****************************************
(add-to-list 'load-path "~/.emacs.d/statistics/ess-5.14/lisp")
(require 'ess-site)

;****************************************
; octave-mode
;****************************************
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;****************************************
;Set 4 Space Indent http://stackoverflow.com/questions/69934/set-4-space-indent-in-emacs-in-text-mode
;****************************************
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/code/tautologer/doc/reduced-sentences-list.org" "~/Dropbox/org/dudas-aleman.org" "~/Dropbox/org/comprar.org" "~/Dropbox/org/kmels.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

