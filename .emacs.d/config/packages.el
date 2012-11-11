;; el-get インストール後のロードパスの用意
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; もし el-get がなければインストールを行う
(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
	 (let (el-get-master-branch)
	   (end-of-buffer)
	   (eval-print-last-sexp)))))

(require 'cl)
(require 'el-get)

(setq el-get-sources
      '(
		(:name undo-tree
			   :type http
			   :url "http://www.dr-qubit.org/undo-tree/undo-tree.el")
		(:name evil
			   :website "http://gitorious.org/evil/pages/Home"
			   :type git
			   :url "git://gitorious.org/evil/evil.git"
			   :features evil
			   :depends undo-tree
			   )
		(:name tmt-mode
			   :type http
			   :url "https://github.com/yoshiki/tmt-mode/raw/master/tmt-mode.el"
			   )
		(:name rsense
			   :type http
			   :url "https://github.com/m2ym/rsense/raw/master/etc/rsense.el"
			   )
		(:name run-test
			   :type git
			   :url "https://github.com/kou/run-test.git"
			   :load-path ("lib")
			   :features (run-test-setting)
               )
		))
(setq my-el-get-packages
      (append
       '(
		 popup
		 auto-complete
		 grep-edit smartchr
		 anything anything-config
		 anything-kyr anything-kyr-config
		 anything-match-plugin
		 yasnippet yasnippet-config
		 evil
		 eshell-manual
		 mode-compile
		 color-theme color-theme-almost-monokai
		 highlight-parentheses
		 historyf
		 perl-completion tmt-mode
		 ruby-mode rinari rhtml-mode rsense
		 python-mode
		 html5 haml-mode js2-mode
		 coffee-mode sass-mode zencoding-mode
		 haskell-mode clojure-mode
		 rst-mode textile-mode markdown-mode
		 yaml-mode
		 apache-mode
		 applescript-mode
		 run-test
		 )
       (mapcar 'el-get-source-name el-get-sources)))

;; load
(el-get 'sync my-el-get-packages)

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (highlight-parentheses-mode)
             (setq autopair-handle-action-fns
                   (list 'autopair-default-handle-action
                         '(lambda (action pair pos-before)
                            (hl-paren-color-update))))
			 ))

;;; key-chord
(eval-after-load "key-chord"
  '(progn
	 (setq key-chord-two-keys-delay 0.04)
	 (key-chord-mode 1)
	 (key-chord-define-global "jk" 'view-mode)))

;;; color-theme
(eval-after-load "color-theme"
  '(progn
	 (color-theme-initialize)
	 (color-theme-almost-monokai)
	 ;;(color-theme-twilight)
	 ))

;;; grep-edit
(add-hook 'grep-setup-hook
          (lambda ()
            (define-key grep-mode-map (kbd "C-c C-c") 'grep-edit-finish-edit)))

;;; linum
(require 'linum)
(global-linum-mode)

;;; yasnippet
(require 'yasnippet)
(eval-after-load "yasnippet"
  '(progn
	 (yas--initialize)
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
	 ))


(require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories
;;  		 (format "%s/auto-complete/dict" package-base-dir))

(add-to-list 'ac-sources 'ac-source-yasnippet)

(ac-config-default)
(setq ac-comphist-file (local-tmp-filename "ac-comphist.dat"))
(add-hook 'auto-complete-mode-hook
		  (lambda ()
			(define-key ac-completing-map (kbd "C-n") 'ac-next)
			(define-key ac-completing-map (kbd "C-p") 'ac-previous)))

;;; anything
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
  ;; (require 'anything-startup)

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
(evil-mode t)

;;; eshell
(eval-after-load "eshell"
  '(progn
	 (define-key eshell-map (kbd "C-a") 'eshell-bol)
	 ))

;;; historyf
(global-set-key (kbd "C->") 'historyf-forward)
(global-set-key (kbd "C-<") 'historyf-back)

;;; smartchr
(global-set-key (kbd ",") (smartchr '(", " ",,")))
(defun smartchr-custom-keybindings ()
  (local-set-key (kbd "=") (smartchr '(" = " " == "  "=")))
  ;; !! がカーソルの位置
  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[ [`!!'] ]" "[")))
  (local-set-key (kbd "{") (smartchr '("{\n`!!'\n}" "{`!!'}" "{")))
  (local-set-key (kbd "`") (smartchr '("\``!!''" "\`")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
  (local-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
  )

(defun smartchr-custom-keybindings-objc ()
  (local-set-key (kbd "@") (smartchr '("@\"`!!'\"" "@")))
  )
