(require 'package)
(require 'cl)

;; (defvar emacswiki-packages 
;;   (list
;;    "grep-edit.el"
;;    "undo-tree.el"
;;    ))
;; (defvar git-packages
;;   (list
;;    "git://gitorious.org/evil/evil.git"
;;    ))
;; (defvar github-packages
;;   (list
;;    "my2m/auto-complete"
;;    "capitaomorte/yasnippet"
;;    "timcharper/evil-surround"
;;    ))
;; (defvar repo.or.cz-packages
;;   (list
;;    '((files . ("anything-config"))
;;      (additional-paths . ("extensions" "contrib")))
;;    ))
;; (defvar archive-packages
;;  (list 
;;   "http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz"
;;  ))

;; (dolist (source-list (list
;; 		   (cons 'emacswiki emacswiki-packages)
;; 		   (cons 'git git-packages)
;; 		   (cons 'github github-packages)
;; 		   (cons 'repo.or.cz repo.or.cz-packages)
;; 		   ))
;;   (let ((source-type (car source-list))
;; 	(packages (cdr source-list)))
;;     (dolist (package packages)
;;       (package-install source-type package))))
;;       ;; (message "%s %s" source-type package))))
;; ;;; TODO
;; (dolist (url archive-packages)
;;    )

;;; color-theme
;(require 'color-theme)
;(eval-after-load "color-theme"
;  '(progn
;     (color-theme-initialize)
;     (color-theme-arjen)))

;;; grep-edit
;; *grep*で編集できるようにする
(package-install 'emacswiki "grep-edit.el" 'grep-edit)
(add-hook 'grep-setup-hook
          (lambda ()
            (define-key grep-mode-map (kbd "C-c C-c") 'grep-edit-finish-edit)))

;;; Auto Complete
;; 自動補完
(package-install 'github "my2m/auto-complete" 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             (format "%s/auto-complete/dict" package-base-dir))
(ac-config-default)
(setq ac-comphist-file (local-tmp-filename "ac-comphist.dat"))
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))

;;; Anything
(package-install 'repo.or.cz
   '((files . ("anything-config"))
     (additional-paths . ("extensions" "contrib")))
   'anything-startup)

;; iswitchbの代わり
(let ((original-browse-url-browser-function browse-url-browser-function))
  (setq anything-command-map-prefix-key "C-c C-<SPC>")
  (require 'anything-startup)
  (define-key global-map (kbd "C-x b") 'anything-for-files)
  (define-key anything-map (kbd "C-z") nil)
  (define-key anything-map (kbd "C-l") 'anything-execute-persistent-action)
  (define-key anything-map (kbd "C-o") nil)
  (define-key anything-map (kbd "C-M-n") 'anything-next-source)
  (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
  (setq browse-url-browser-function original-browse-url-browser-function))

;;; evil
(package-install 'git "git/undo-tree.git" 'undo-tree nil "http://www.dr-qubit.org")
(package-install 'git "evil/evil.git" 'evil nil "git://gitorious.org")
(evil-mode t)

;; yasnippet
(package-install 'github "capitaomorte/yasnippet" 'yasnippet)


;;; run-test
;; テスト実行
(package-install 'github '((files . ("kou/run-test"))
                           (base-path . "lib"))
                 'run-test-setting)

;;; uim
;; 2011-06-27
; (load "config/packages/uim")
