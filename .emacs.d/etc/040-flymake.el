;; -*- coding: utf-8 -*-

(when (locate-library "flymake")
  (require 'flymake)

  ;;シンタックスチェックは次のコマンドが呼ばれる
  ;;make -s -C . CHK_SOURCES=hoge.cpp SYNTAX_CHECK_MODE=1 check-syntax
  ;;
  ;; Makefile があれば、次のルールを追加
  ;;PHONY: check-syntax
  ;;#check-syntax:
  ;;#	$(CC) -Wall -Wextra -pedantic -fsyntax-only $(CHK_SOURCES)
  ;;
  ;;CHECKSYNTAX.c = $(CC) $(CFLAGS) $(CPPFLAGS) -Wall -Wextra -pedantic -fsyntax-only
  ;;CHECKSYNTAX.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) -Wall -Wextra -pedantic -fsyntax-only
  ;;
  ;;check-syntax: $(addsuffix -check-syntax,$(CHK_SOURCES))
  ;;%.c-check-syntax:  ; $(CHECKSYNTAX.c)  $*.c
  ;;%.cc-check-syntax: ; $(CHECKSYNTAX.cc) $*.cc

  (set-face-background 'flymake-errline "red4")
  (set-face-foreground 'flymake-errline "black")
  (set-face-background 'flymake-warnline "yellow")
  (set-face-foreground 'flymake-warnline "black")

  ;; GUIの警告は表示しない
  (setq flymake-gui-warnings-enabled nil)

  ;; 全てのファイルで flymakeを有効化
  (add-hook 'find-file-hook 'flymake-find-file-hook)

  ;; flymake を使えない場合をチェック
  (defadvice flymake-can-syntax-check-file
    (after my-flymake-can-syntax-check-file activate)
    (cond
     ((not ad-return-value))
     ;; tramp 経由であれば、無効
     ((and (fboundp 'tramp-list-remote-buffers)
	   (memq (current-buffer) (tramp-list-remote-buffers)))
      (setq ad-return-value nil))
     ;; 書き込み不可ならば、flymakeは無効
     ((not (file-writable-p buffer-file-name))
      (setq ad-return-value nil))
     ;; flymake で使われるコマンドが無ければ無効
     ((let ((cmd (nth 0 (prog1
			    (funcall (flymake-get-init-function buffer-file-name))
			  (funcall (flymake-get-cleanup-function buffer-file-name))))))
	(and cmd (not (executable-find cmd))))
      (setq ad-return-value nil))
     ))

  ;; M-p/M-n で警告/エラー行の移動
  (global-set-key "\M-p" 'flymake-goto-prev-error)
  (global-set-key "\M-n" 'flymake-goto-next-error)

  ;; 警告エラー行の表示
  ;;(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)
  (global-set-key "\C-cd"
		  '(lambda ()
		     (interactive)
		     ;;(my-flymake-display-err-minibuf-for-current-line)
		     (my-flymake-display-err-popup.el-for-current-line)
		     ))

  ;; Minibuf に出力
  (defun my-flymake-display-err-minibuf-for-current-line ()
    "Displays the error/warning for the current line in the minibuffer"
    (interactive)
    (let* ((line-no
			(flymake-current-line-no))
	   (line-err-info-list
		(nth 0 (flymake-find-err-info flymake-err-info line-no)))
	   (count
		(length line-err-info-list)))
      (while (> count 0)
	(when line-err-info-list
	  (let* ((text
			  (flymake-ler-text (nth (1- count) line-err-info-list)))
		 (line
		  (flymake-ler-line (nth (1- count) line-err-info-list))))
	    (message "[%s] %s" line text)))
	(setq count (1- count)))))

  ;; popup.el を使って tip として表示
  (defun my-flymake-display-err-popup.el-for-current-line ()
    "Display a menu with errors/warnings for current line if it has errors and/or warnings."
    (interactive)
    (let* ((line-no
			(flymake-current-line-no))
	   (line-err-info-list
		(nth 0 (flymake-find-err-info flymake-err-info line-no)))
	   (menu-data
		(flymake-make-err-menu-data line-no line-err-info-list)))
      (if menu-data
	  (popup-tip (mapconcat '(lambda (e) (nth 0 e))
				(nth 1 menu-data)
				"\n")))
      ))

  (defun flymake-simple-generic-init (cmd &optional opts)
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
			 'flymake-create-temp-inplace))
	   (local-file  (file-relative-name
			 temp-file
			 (file-name-directory buffer-file-name))))
      (list cmd (append opts (list local-file)))))

  ;; Makefile が無くてもC/C++のチェック
  (defun flymake-simple-make-or-generic-init (cmd &optional opts)
    (if (file-exists-p "Makefile")
	(flymake-simple-make-init)
      (flymake-simple-generic-init cmd opts)))

  (defun flymake-c-init ()
    (flymake-simple-make-or-generic-init
     "gcc" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

  (defun flymake-cc-init ()
    (flymake-simple-make-or-generic-init
     "g++" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

  (push '("\\.[cCmM]\\'" flymake-c-init)
		flymake-allowed-file-name-masks)
  (push '("\\.\\(?:cc\|cpp\|CC\|CPP\\)\\'" flymake-cc-init)
		flymake-allowed-file-name-masks)

  ;; Invoke ruby with '-c' to get syntax checking
  (when (executable-find "ruby")
    (defun flymake-ruby-init ()
      (flymake-simple-generic-init
       "ruby" '("-c")))

    (push '(".+\\.rb\\'" flymake-ruby-init)
		  flymake-allowed-file-name-masks)
    (push '("Rakefile\\'" flymake-ruby-init)
		  flymake-allowed-file-name-masks)

    (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)
		  flymake-err-line-patterns)
    )

  ;; bash チェック
  (defvar flymake-shell-of-choice
    "bash"
    "Path of shell.")

  (defvar flymake-shell-arguments
    (list "-n")
    "Shell arguments to invoke syntax checking.")

  (defun flymake-shell-init ()
    (flymake-simple-generic-init
     flymake-shell-of-choice flymake-shell-arguments))

  (push '(".+\\.sh\\'" flymake-shell-init) flymake-allowed-file-name-masks)
  (push '("^\\(.+\\): line \\([0-9]+\\): \\(.+\\)$" 1 2 nil 3) flymake-err-line-patterns)

  ;;;; HTML
  ;;(when (executable-find "tidy")
  ;;  (defun flymake-html-init ()
  ;;    (let* ((coding (coding-system-base buffer-file-coding-system))
  ;;	     (opt (cdr (assq coding
  ;;			     '((utf-8 . "-utf8")
  ;;			       (iso-2022-jp . "-iso2022")
  ;;			       (japanese-shift-jis . "-shiftjis"))))))
  ;;	(flymake-simple-generic-init
  ;;	 "tidy" (list "-e" opt))))
  ;;
  ;;  (push '("\\.html\\'\\|\\.ctp" flymake-html-init) flymake-allowed-file-name-masks)
  ;;  (push '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)" nil 1 2 4) flymake-err-line-patterns)
  ;;  )

  ;;;; XSL
  ;;(push '(".+\\.xsl\\'" flymake-xml-init) flymake-allowed-file-name-masks)

  ;;;; Python
  ;;(defun flymake-pep8-init ()
  ;;  (flymake-simple-generic-init
  ;;   "pep8"))
  ;;
  ;;(defun flymake-pylint-init ()
  ;;  (flymake-simple-generic-init
  ;;   "epylint"))
  ;;
  ;;(push '("\\.py\\'" flymake-pylint-init) flymake-allowed-file-name-masks)
  ;;(push '("\\.py\\'" flymake-pep8-init) flymake-allowed-file-name-masks)

  ;;;; Javascript
  ;;(defun flymake-js-init ()
  ;;  (flymake-simple-generic-init
  ;;   "js" '("-s")))
  ;;
  ;;(push '(".+\\.json\\'" flymake-js-init) flymake-allowed-file-name-masks)
  ;;(push '(".+\\.js\\'" flymake-js-init) flymake-allowed-file-name-masks)
  ;;
  ;;(push '("^\\(.+\\)\:\\([0-9]+\\)\: \\(strict warning: trailing comma.+\\)\:$" 1 2 nil 3)
  ;;	flymake-err-line-patterns)

  ;;; Perl
  (defvar flymake-perl-err-line-patterns
	'(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

  (defconst flymake-allowed-perl-file-name-masks
	'(("\\.pl$" flymake-perl-init)
	  ("\\.pm$" flymake-perl-init)
	  ("\\.t$" flymake-perl-init)))

  (defun flymake-perl-init ()
	(let* ((temp-file (flymake-init-create-temp-buffer-copy
					   'flymake-create-temp-inplace))
		   (local-file (file-relative-name
						temp-file
						(file-name-directory buffer-file-name))))
	  (list "perl" (list "-wc" local-file))))

  (defun flymake-perl-load ()
	(interactive)
	(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
	  (setq flymake-check-was-interrupted t))
	(ad-activate 'flymake-post-syntax-check)
	(setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
	(setq flymake-err-line-patterns flymake-perl-err-line-patterns)
	(package-install 'file "set-perl5lib.el" 'set-perl5lib nil
	 "http://svn.coderepos.org/share/lang/elisp/set-perl5lib/")
	(set-perl5lib)
	(flymake-mode t))

  (add-hook 'cperl-mode-hook 'flymake-perl-load)

  ;;; php
  (when (not (fboundp (quote flymake-php-init)))
    ;; flymake-php-initが未定義のバージョンだったら、自分で定義する
    (defun flymake-php-init ()
      (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                           (quote flymake-create-temp-inplace)))
             (local-file  (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
        (list "php" (list "-f" local-file "-l"))))
    (setq flymake-allowed-file-name-masks
          (append
           flymake-allowed-file-name-masks
           (quote (("\.php[345]?$" flymake-php-init)))))
    (setq flymake-err-line-patterns
          (cons
           (quote ("\(\(?:Parse error\|Fatal error\|Warning\): .*\) in \(.*\) on line \([0-9]+\)" 2 3 nil 1))
           flymake-err-line-patterns)))

  ;;; objc
  (defvar xcode:gccver "4.2.1")
  (defvar xcode:sdkver "5.0")
  (defvar xcode:sdkpath
	"/Developer/Platforms/iPhoneSimulator.platform/Developer")
  (defvar xcode:sdk
	(concat xcode:sdkpath "/SDKs/iPhoneSimulator" xcode:sdkver ".sdk"))
  (defvar flymake-objc-compiler
	(concat xcode:sdkpath "/usr/bin/gcc-" xcode:gccver))
  (defvar flymake-objc-compile-default-options
	(list "-Wall" "-Wextra" "-fsyntax-only"
		  "-ObjC" "-std=c99" "-isysroot" xcode:sdk))
  (defvar flymake-last-position nil)
  (defvar flymake-objc-compile-options '("-I."))
  (defun flymake-objc-init ()
	(let* ((temp-file (flymake-init-create-temp-buffer-copy
                    'flymake-create-temp-inplace))
         (local-file (file-relative-name
                     temp-file
                     (file-name-directory buffer-file-name))))
	  (list flymake-objc-compiler
			(append flymake-objc-compile-default-options
					flymake-objc-compile-options
					(list local-file)))))
  (add-hook 'objc-mode-hook
			(lambda ()
			  ;; 拡張子 m と h に対して flymake を有効にする設定 flymake-mode t の前に書く必要があります
			  (push '("\\.m$" flymake-objc-init)
					flymake-allowed-file-name-masks)
			  (push '("\\.h$" flymake-objc-init)
					flymake-allowed-file-name-masks)
			  ;; 存在するファイルかつ書き込み可能ファイル時のみ flymake-mode を有効にします
			  (if (and (not (null buffer-file-name))
					   (file-writable-p buffer-file-name))
				  (flymake-mode t))
			  ))
  )
