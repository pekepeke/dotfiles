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
    (let* ((line-no             (flymake-current-line-no))
	   (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
	   (count               (length line-err-info-list)))
      (while (> count 0)
	(when line-err-info-list
	  (let* ((text       (flymake-ler-text (nth (1- count) line-err-info-list)))
		 (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
	    (message "[%s] %s" line text)))
	(setq count (1- count)))))

  ;; popup.el を使って tip として表示
  (defun my-flymake-display-err-popup.el-for-current-line ()
    "Display a menu with errors/warnings for current line if it has errors and/or warnings."
    (interactive)
    (let* ((line-no             (flymake-current-line-no))
	   (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
	   (menu-data           (flymake-make-err-menu-data line-no line-err-info-list)))
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

  (push '("\\.[cCmM]\\'" flymake-c-init) flymake-allowed-file-name-masks)
  (push '("\\.\\(?:cc\|cpp\|CC\|CPP\\)\\'" flymake-cc-init) flymake-allowed-file-name-masks)

  ;; Invoke ruby with '-c' to get syntax checking
  (when (executable-find "ruby")
    (defun flymake-ruby-init ()
      (flymake-simple-generic-init
       "ruby" '("-c")))

    (push '(".+\\.rb\\'" flymake-ruby-init) flymake-allowed-file-name-masks)
    (push '("Rakefile\\'" flymake-ruby-init) flymake-allowed-file-name-masks)

    (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
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

  )
