(require 'package)
(require 'cl)

;;; key-chord
(package-install 'emacswiki "key-chord.el" 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)
(key-chord-define-global "jk" 'view-mode)

;;; color-theme
(package-install 'archive "color-theme-6.6.0.zip" 'color-theme nil
				 "http://download.savannah.gnu.org/releases/color-theme/")
;;(package-install 'github "sellout/emacs-color-theme-solarized" 'color-theme-solarized)

(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     ;;(color-theme-arjen)
	 ;; (package-install
	 ;;  'file
	 ;;  "http://p3n9.kilu.de/color-theme-sunburst.el" nil)
	 ;; (load-library "color-theme-sunburst")
	 ;; (color-theme-tm)
	 ;; (package-install
	 ;;  'file
	 ;;  "http://jdhuntington.com/paste/color-theme-blackboard.el" nil)
	 (package-install 'github "crafterm/twilight-emacs"
					  'color-theme-twilight)
	 (color-theme-twilight)
	 ;(color-theme-solarized-dark)
	 ))

;;; linum
(package-install 'file "linum.el" 'linum nil
				 "http://stud4.tuwien.ac.at/~e0225855/linum/")
(global-linum-mode)

;;; grep-edit
;; *grep*で編集できるようにする
(package-install 'emacswiki "grep-edit.el" 'grep-edit)
(add-hook 'grep-setup-hook
          (lambda ()
            (define-key grep-mode-map (kbd "C-c C-c") 'grep-edit-finish-edit)))

;;; yasnippet
(package-install 'github "capitaomorte/yasnippet" 'yasnippet)
(setq yas/trigger-key (kbd "SPC"))
(setq yas/next-field-key (kbd "TAB"))

(defvar flymake-is-active-flag nil)

(defadvice yas/expand-snippet
  (before inhibit-flymake-syntax-checking-while-expanding-snippet activate)
  (setq flymake-is-active-flag
        (or flymake-is-active-flag
            (assoc-default 'flymake-mode (buffer-local-variables))))
  (when flymake-is-active-flag
    (flymake-mode-off)))

(add-hook 'yas/after-exit-snippet-hook
          '(lambda ()
             (when flymake-is-active-flag
               (flymake-mode-on)
               (setq flymake-is-active-flag nil))))

(yas/initialize)

;;; Auto Complete
;; 自動補完
(package-install 'github "m2ym/auto-complete" 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             (format "%s/auto-complete/dict" package-base-dir))

(add-to-list 'ac-sources 'ac-source-yasnippet)

(ac-config-default)
(setq ac-comphist-file (local-tmp-filename "ac-comphist.dat"))
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))

(package-install 'github "whitypig/auto-complete-etags"
				 'auto-complete-etags)
(add-hook 'c-mode-common-hook
		  '(lambda ()
			(add-to-list 'ac-sources 'ac-source-etags)
			(setq ac-etags-use-document t)
			))
;;; company
(package-install 'archive "company-0.5.tar.bz2" nil nil
				 "http://nschum.de/src/emacs/company-mode")
(package-install 'file "ac-company.el" 'ac-company nil
				 "http://github.com/buzztaiki/auto-complete/raw/master/")
(autoload 'company-mode "company" nil t)
(ac-company-define-source ac-source-company-xcode company-xcode)
(ac-company-define-source ac-source-company-xcode company-gtags)
(setq ac-modes (append ac-modes '(objc-mode)))
(setq ac-modes (append ac-modes '(c-mode)))
(setq ac-modes (append ac-modes '(c++-mode)))

;;; popwin
(package-install 'github "m2ym/popwin-el" 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)
(push '(dired-mode :position top) popwin:special-display-config)

;;; Anything
(package-install 'repo.or.cz
   '((files . ("anything-config"))
     (additional-paths . ("extensions" "contrib")))
   'anything-startup)
(package-install 'emacswiki "anything-gtags.el" 'anything-gtags)
(package-install
 'file
 "http://svn.coderepos.org/share/lang/elisp/anything-c-yasnippet/anything-c-yasnippet.el"
 'anything-c-yasnippet)

(defun anything-kill-buffers ()
  (interactive)
  (anything
   '(((name . "Kill Buffers")
	  (candidates . anything-c-buffer-list)
	  (action
	   ("Kill Buffer" . (lambda (candidate)
						  (kill-buffer candidate)
						  (anything-kill-buffers)
						  )))))
   nil nil))
;; iswitchbの代わり
(let ((original-browse-url-browser-function browse-url-browser-function))
  (setq anything-command-map-prefix-key "C-c C-c")
  (require 'anything-startup)

  (setq anything-c-yas-space-match-any-greedy)
  (global-set-key (kbd "C-c y") 'anything-c-yas-complete)

  (define-key global-map (kbd "M-l") 'anything)
  (define-key global-map (kbd "C-x b") 'anything-for-files)
  (define-key global-map (kbd "C-x C-b") 'anything-for-files)
  (define-key global-map (kbd "C-x y") 'anything-show-kill-ring)
  (define-key global-map (kbd "C-x k") 'anything-kill-buffers)
  (define-key global-map (kbd "C-c s")
	(lambda ()
	  (interactive)
	  (anything '(anything-c-source-occur))))
  (define-key global-map (kbd "C-x t")
	(lambda()
	  "Tag jump using anything"
	  (interactive)
	  (let* ((default (regexp-quote (or (thing-at-point 'symbol) ""))))
		(anything
		 '(anything-c-source-etags-select
		   anything-c-source-ctags
		   ;;anything-c-source-gtags-select
		   ))
		"Find Tag: " nil)))
  (define-key global-map (kbd "C-x c")
	(lambda()
	  "Exec emacs commands in anything"
	  (interactive)
	  (anything '(anything-c-source-emacs-commands))
	  ))
  (define-key anything-map (kbd "C-z") nil)
  (define-key anything-map (kbd "C-l") 'anything-execute-persistent-action)
  (define-key anything-map (kbd "C-o") nil)
  (define-key anything-map (kbd "M-l") 'anything-next-source)
  (define-key anything-map (kbd "C-M-n") 'anything-next-source)
  (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
  (setq browse-url-browser-function original-browse-url-browser-function))

;;; evil
;;(package-install 'git "git/undo-tree.git" 'undo-tree nil "http://www.dr-qubit.org")
;;(package-install 'git "evil/evil.git" 'evil nil "git://gitorious.org")
;;(evil-mode t)

;;; eshell
(package-install 'github "jwiegley/eshell" 'eshell)
(add-hook 'eshell-mode-hook
		  '(lambda()
			 (interactive)
			 (define-key eshell-map (kbd "C-a") 'eshell-bol)
			 ))

;;; run-test
;; テスト実行
(package-install 'github '((files . ("kou/run-test"))
                           (base-path . "lib"))
                 'run-test-setting)


;;; uim
;; 2011-06-27
; (load "config/packages/uim")

