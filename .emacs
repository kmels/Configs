;****************************************
;general tweaks
;****************************************
;(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")
(set-default-font "-unknown-Inconsolata-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")

;(setq password-cache-expiry nil)
;(setq make-backup-files nil)
;****************************************
;mercurial 
;****************************************
;(load-file "~/.emacs.d/common/dvc-snapshot/dvc-load.el")


;****************************************
;LustyExplorer
;****************************************
;(load-file "~/.emacs.d/common/lusty-explorer.el")
;(when (require 'lusty-explorer nil 'noerror)
  ;; overrride the normal file-opening, buffer switching
  ;(global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
  ;(global-set-key (kbd "C-x b")   'lusty-buffer-explorer))

;****************************************
;color-theme
;****************************************
(add-to-list 'load-path "~/.emacs.d/common/color-theme-6.6.0")
(load "~/.emacs.d/color-theme-tomorrow-night.el")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-kmels)))

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
;; ; yasnippet
;; ;****************************************
;; ;(add-to-list 'load-path "~/.emacs.d/common/yasnippet-0.6.1c")
;; ;(require 'yasnippet)
;; ;(yas/initialize)
;; ;(yas/load-directory "~/.emacs.d/common/yasnippet-0.6.1c/snippets")

;; ;scala-mode shipped snippets
;; ;(setq yas/scala-mode-snippets "~/.emacs.d/scala/scala-mode/contrib/yasnippet/snippets")
;; ;(yas/load-directory yas/scala-mode-snippets)

;; ;****************************************
;; ; ENSIME
;; ;****************************************
;; (require 'scala-mode)
;; (add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
;; (add-to-list 'load-path "/home/kmels/.emacs.d/scala/ensime_2.8.0-0.2.7/elisp/")
;; (require 'ensime)
;; (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; ; ****************************************
;; ; autocomplete-mode
;; ; ****************************************
;; (add-to-list 'load-path "/home/kmels/.emacs.d/common/auto-complete-1.3")
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "/home/kmels/.emacs.d/common/auto-complete-1.3/ac-dict")
;; (ac-config-default)

;; ;****************************************
;; ; php mode
;; ;****************************************

;(add-to-list 'load-path "/home/kmels/.emacs.d/prog-lang/php-mode-1.5.0")
;(load "php-mode")

;; ;****************************************
;; ; autopair
;; ;****************************************
;; (load "autopair.el")
;; (require 'autopair)
;; (autopair-global-mode) ;;enable autopair in all buffers

;; ;****************************************
;; ; eshell clear
;; ;****************************************
;; (defun eshell/clear ()
;;   "04Dec2001 - sailor, to clear the eshell buffer."
;;   (interactive)
;;   (let ((inhibit-read-only t))
;;     (erase-buffer)))

;; ;****************************************
;; ; sage mode
;; ;****************************************
;; ;(add-to-list 'load-path (expand-file-name "/home/kmels/bin/src/sage-4.4.4-linux-32bit-ubuntu_10.04_lts-i686-Linux/data/emacs"))
;; ;(require 'sage "sage")
;; ;(setq sage-command "/home/kmels/bin/src/sage-4.4.4-linux-32bit-ubuntu_10.04_lts-i686-Linux/sage")

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

;; ;****************************************
;; ; Typoscript mode
;; ;****************************************
;; ;(load "~/.emacs.d/webdev/typoscript-mode.el")
;; ;(autoload 'ts-mode "ts-mode")
;; ; (setq auto-mode-alist       
;; ;       (cons '("\\.ts\\'" . ts-mode) auto-mode-alist))

;; ****************************************
;; org-mode 7.5
;; ****************************************

(setq load-path (cons "~/.emacs.d/common/org-7.5/lisp/" load-path))
(setq load-path (cons "~/.emacs.d/common/org-7.5/contrib/lisp/" load-path))

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(transient-mark-mode 1)

;; org-mode personal settings

(setq org-mobile-directory "~/Dropbox/MobileOrg")
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")

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


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;; ****************************************
;; rainbow-delimeters
;; http://emacs-fu.blogspot.com/2011/05/toward-balanced-and-colorful-delimiters.html
;; ****************************************
(add-to-list 'load-path "~/.emacs.d/prog-lang/rainbow-delimiters.el")

(when (require 'rainbow-delimiters nil 'noerror) 
  (add-hook 'scala-mode-hook 'rainbow-delimiters-mode))

;; ****************************************
;; haskell-mode
;; http://www.haskell.org/haskellwiki/Haskell_mode_for_Emacs
;; ****************************************
(load "~/.emacs.d/prog-lang/haskell-mode/haskell-site-file.el")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; ****************************************
;; dired-single 
;(load "~/.emacs.d/common/dired-single.el")
;(require 'dired-single)

;; the following line takes away the pain from emacs
(global-unset-key [(control z)])

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
