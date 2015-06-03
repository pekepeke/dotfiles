;;; Localeに合わせた環境の設定
(set-locale-environment nil)
;; 起動時のメッセージを表示しない
(setq inhibit-startup-message t)
;;; 画像ファイルを表示
(auto-image-file-mode t)
;;; メニューバーを消す
(menu-bar-mode -1)
;;; ツールバーを消す
(if window-system (tool-bar-mode -1))

;; モードラインに時間を表示
(display-time)
;; 時刻の書式をAM/PMではなく24時間表示にする
(setq display-time-24hr-format t)
;; 時刻の書式に日付を追加する
(setq display-time-day-and-date t)

;; 行位置, 桁位置を表示する
(column-number-mode t)
(line-number-mode t)

;;; 現在行を目立たせる
(global-hl-line-mode)

;;; カーソルの点滅を止める
(blink-cursor-mode 0)

;;; 対応する括弧を光らせる。
(show-paren-mode 1)
;; colorize
(global-font-lock-mode t)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
;; (setq show-paren-style 'mixed)
(setq blink-matching-paren t)

;; マーク領域を色付けする
(setq transient-mark-mode t)

;; 検索文字をハイライト表示
(setq search-highlight t)

;; 対話置換でマッチした箇所をハイライト
(setq query-replace-highlight t)

;; 置換する文字列を優先する.
(setq case-replace nil)

;;; TAB
(setq-default default-tab-width 4)
;;; 行末の空白を表示
(setq-default show-trailing-whitespace t)
;;; 改行・タブ・スペースの色付け
(global-whitespace-mode 1)

;; スペースの定義は全角スペースとする。
(setq whitespace-space-regexp "\x3000+")

;; 改行の色を変更
(set-face-foreground 'whitespace-newline "gray40")

;; 半角スペースと改行を除外
(require 'cl)
(dolist (d '((space-mark ?\ ) (newline-mark ?\n)))
  (setq whitespace-display-mappings
        (delete-if
         '(lambda (e) (and (eq (car d) (car e))
                           (eq (cadr d) (cadr e))))
         whitespace-display-mappings)))

;; 全角スペースと改行を追加
(dolist (e '((space-mark   ?\x3000 [?\□])))
					;(newline-mark ?\n     [?\u21B5 ?\n] [?$ ?\n])))
  (add-to-list 'whitespace-display-mappings e))

;; 強調したくない要素を削除
(dolist (d '(face lines space-before-tab
                  indentation empty space-after-tab tab-mark))
  (setq whitespace-style (delq d whitespace-style)))

;;; カーソルの場所を保存する
(require 'saveplace)
(setq-default save-place t)

;; yes, no -> y, n
(fset 'yes-or-no-p 'y-or-n-p)

;;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)

;;; 最終行に必ず一行挿入する
(setq require-final-newline t)

;;; バッファの最後でnewlineで新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;; 長い行の折り返し表示をするかどうか (nil = する t = しない)
(setq-default truncate-lines nil)
;; 分割したウィンドウでも折り返し(C-x 3した時も折り返されるようになる)
(setq truncate-partial-width-windows nil)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;; 部分一致の補完機能を使う
;;; p-bでprint-bufferとか
;(partial-completion-mode t)

;;; 補完可能なものを随時表示
;;; 少しうるさい
(icomplete-mode 1)

;;; history
;; (setq savehist-file (local-tmp-filename "history"))
;; (setq auto-save-list-file-prefix (local-tmp-filename "auto-save-list"))
;;; 履歴数を大きくする
(setq history-length 10000)

;;; ミニバッファの履歴を保存する
(savehist-mode 1)

;;; 最近開いたファイルを保存する数を増やす
(setq recentf-max-saved-items 10000)

;;; gzファイルも編集できるようにする
(auto-compression-mode t)

;; マウスでリージョン選択した際の挙動
(setq mouse-drag-copy-region nil)

;;; ediffを1ウィンドウで実行
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;; diffのオプション
(setq diff-switches '("-u" "-p" "-N"))

;;; diredを便利にする
(require 'dired-x)

;;; diredから"r"でファイル名をインライン編集する
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;; ファイル名が重複していたらディレクトリ名を追加する。
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; 再帰的にgrep
(require 'grep)
(setq grep-command-before-query "grep -nH -r -e ")
(defun grep-default-command ()
  (if current-prefix-arg
      (let ((grep-command-before-target
             (concat grep-command-before-query
                     (shell-quote-argument (grep-tag-default)))))
        (cons (if buffer-file-name
                  (concat grep-command-before-target
                          " *."
                          (file-name-extension buffer-file-name))
                (concat grep-command-before-target " ."))
              (+ (length grep-command-before-target) 1)))
    (car grep-command)));; IME の ON/OFF でカーソルの色を変える
;; (cursor-type が box, bar の場合)
(add-hook 'mw32-ime-on-hook
	  (lambda () (set-cursor-color "brown"))) ; ON
(add-hook 'mw32-ime-off-hook
	  (lambda () (set-cursor-color "black"))) ; OFF

(setq grep-command (cons (concat grep-command-before-query " .")
                         (+ (length grep-command-before-query) 1)))

;;; emacsclient
(require 'server)
(unless (server-running-p)
  (server-start))

(cond
 (run-w32 
  (set-language-environment "Japanese")
  (mw32-ime-initialize)
  (setq default-input-method "MW32-IME")
  (setq-default mw32-ime-mode-line-state-indicator "[--]")
  (setq mw32-ime-mode-line-state-indicator "[--]")
  (setq mw32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]"))
  ;; IME の ON/OFF でカーソルの色を変える
  (add-hook 'mw32-ime-on-hook
	    (lambda () (set-cursor-color "brown"))) ; ON
  (add-hook 'mw32-ime-off-hook
	    (lambda () (set-cursor-color "black"))) ; OFF

  (w32-add-font
   "fontset-msgothic12"
   '((strict-spec
      ((:char-spec ascii :height any)
       (w32-logfont "ＭＳ ゴシック" 0 12 400 0 nil nil nil 0 1 3 49))
      ((:char-spec ascii :height any :weight bold)
       (w32-logfont "ＭＳ ゴシック" 0 12 700 0 nil nil nil 0 1 3 49))
      ((:char-spec ascii :height any :slant italic)
       (w32-logfont "ＭＳ ゴシック" 0 12 400 0    t nil nil 0 1 3 49))
      ((:char-spec ascii :height any :weight bold :slant italic)
       (w32-logfont "ＭＳ ゴシック" 0 12 700 0    t nil nil 0 1 3 49))
      ((:char-spec japanese-jisx0208 :height any)
       (w32-logfont "ＭＳ ゴシック" 0 12 400 0 nil nil nil 128 1 3 49))
      ((:char-spec japanese-jisx0208 :height any :weight bold)
       (w32-logfont "ＭＳ ゴシック" 0 12 700 0 nil nil nil 128 1 3 49)
       ((spacing . -1)))
      ((:char-spec japanese-jisx0208 :height any :slant italic)
       (w32-logfont "ＭＳ ゴシック" 0 12 400 0    t nil nil 128 1 3 49))
      ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
       (w32-logfont "ＭＳ ゴシック" 0 12 700 0    t nil nil 128 1 3 49)
       ((spacing . -1)))
      ((:char-spec katakana-jisx0201 :height any)
       (w32-logfont "ＭＳ ゴシック" 0 12 400 0 nil nil nil 128 1 3 49))
      ((:char-spec katakana-jisx0201 :height any :weight bold)
       (w32-logfont "ＭＳ ゴシック" 0 12 700 0 nil nil nil 128 1 3 49)
       ((spacing . -1)))
      ((:char-spec katakana-jisx0201 :height any :slant italic)
       (w32-logfont "ＭＳ ゴシック" 0 12 400 0    t nil nil 128 1 3 49))
      ((:char-spec katakana-jisx0201 :height any :weight bold :slant italic)
       (w32-logfont "ＭＳ ゴシック" 0 12 700 0    t nil nil 128 1 3 49)
       ((spacing . -1)))
      )))

  (w32-add-font
   "fontset-meiryo"
   '((strict-spec
      ((:char-spec ascii :height any)
       (w32-logfont "meiryo" 0 -13 400 0 nil nil nil 0 1 3 49))
      ((:char-spec ascii :height any :weight bold)
       (w32-logfont "meiryo" 0 -13 700 0 nil nil nil 0 1 3 49))
      ((:char-spec ascii :height any :slant italic)
       (w32-logfont "meiryo" 0 -13 400 0  t nil nil 0 1 3 49))
      ((:char-spec ascii :height any :weight bold :slant italic)
       (w32-logfont "meiryo" 0 -13 700 0  t nil nil 0 1 3 49))
      ((:char-spec japanese-jisx0208 :height any)
       (w32-logfont "meiryo" 0 -13 400 0 nil nil nil 128 1 3 49))
      ((:char-spec japanese-jisx0208 :height any :weight bold)
       (w32-logfont "meiryo" 0 -13 700 0 nil nil nil 128 1 3 49)
       ((spacing . -1)))
      ((:char-spec japanese-jisx0208 :height any :slant italic)
       (w32-logfont "meiryo" 0 -13 400 0  t nil nil 128 1 3 49))
      ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
       (w32-logfont "meiryo" 0 -13 700 0  t nil nil 128 1 3 49)
       ((spacing . -1)))
      ((:char-spec katakana-jisx0201 :height any)
       (w32-logfont "meiryo" 0 -13 400 0 nil nil nil 128 1 3 49))
      ((:char-spec katakana-jisx0201 :height any :weight bold)
       (w32-logfont "meiryo" 0 -13 700 0 nil nil nil 128 1 3 49)
       ((spacing . -1)))
      ((:char-spec katakana-jisx0201 :height any :slant italic)
       (w32-logfont "meiryo" 0 -13 400 0  t nil nil 128 1 3 49))
      ((:char-spec katakana-jisx0201 :height any :weight bold :slant italic)
       (w32-logfont "meiryo" 0 -13 700 0  t nil nil 128 1 3 49)
       ((spacing . -1)))
      )))
  (w32-add-font
   "fontset-msgothic-consolas"
   '((spec
      ((:char-spec ascii :height any)
       strict
       (w32-logfont "Consolas" 0 -12 400 0 nil nil nil 0 1 3 0))
      ((:char-spec ascii :height any :weight bold)
       strict
       (w32-logfont "Consolas" 0 -12 700 0 nil nil nil 0 1 3 0))
      ((:char-spec ascii :height any :slant italic)
       strict
       (w32-logfont "Consolas" 0 -12 400 0 t nil nil 0 1 3 0))
      ((:char-spec ascii :height any :weight bold :slant italic)
       strict
       (w32-logfont "Consolas" 0 -12 700 0 t nil nil 0 1 3 0))
      ((:char-spec japanese-jisx0208 :height any)
       strict
       (w32-logfont "ＭＳ ゴシック" 0 -12 400 0 nil nil nil 128 1 3 49)
       ((spacing . 1)))
      ((:char-spec japanese-jisx0208 :height any :slant italic)
       strict
       (w32-logfont "ＭＳ ゴシック" 0 -12 400 0 t nil nil 128 1 3 49)
       ((spacing . 1)))
      ((:char-spec japanese-jisx0208 :height any :weight bold)
       strict
       (w32-logfont "ＭＳ ゴシック" 0 -12 700 0 nil nil nil 128 1 3 49)
       ((spacing . 1)))
      ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
       strict
       (w32-logfont "ＭＳ ゴシック" 0 -12 700 0 t nil nil 128 1 3 49)
       ((spacing . 1))))))
  (add-to-list 'default-frame-alist '(font . "fontset-msgothic12"))
  (set-frame-font "fontset-msgothic-consolas")
  (set-frame-font "fontset-msgothic12")
  (let ((logfont '(w32-logfont "MS Gothic" 0 0 400 0 nil nil nil 128 1 3 49)))
    (modify-frame-parameters (selected-frame) (list (cons 'ime-font logfont)))
    (add-to-list 'default-frame-alist (cons 'ime-font logfont)))


  (defun ms-explorer-open ()
    (interactive)
    (shell-command "explorer /e,.")
    )
  (global-set-key "\C-x\C-@" 'ms-explorer-open)

  ;; cygwin 形式でパスアクセスを可能にする。
  (require 'cygwin-mount)
  (if run-cygwin
      (progn
	(cygwin-mount-activate)
	;; Cygwin の bash を使う場合
	(setq explicit-shell-file-name "bash.exe") ; シェルモード用
	(setq shell-file-name "sh.exe")   ; シェルコマンド用
	(setq shell-command-switch "-c")
	;; argument-editing の設定
	(require 'mw32script)
	(mw32script-init)
	;; coding-system の設定
	(add-hook 'shell-mode-hook
		  '(lambda ()
		     (set-buffer-process-coding-system
		      'undecided-dos 'sjis-unix)))
	;; ^M をとる
	(add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)
	;; shell-modeでの補完 (for drive letter)
	(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@'`.,;()-")))
  )
 (run-linux 
  (if (and run-emacs23 window-system)
      (set-default-font "-*-Inconsolata-normal-normal-normal-*-14-*-*-*-*-*-*"))
  )
 (run-darwin
  ;;(setq mac-command-key-is-meta t)
  ;;(setq mac-command-modifier-meta t)
  ;;(setq mac-option-modifier 'meta)
  ;;(setq ns-command-modifier 'meta)
  ;;(setq ns-alternate-modifier 'super)

  (setq grep-find-use-xargs 'bsd)
  (setq browse-url-generic-program "open")
  (when (eq window-system 'ns)
    (if (< (display-pixel-height) 900)
	(setq menlo-fontsize 12)
      (setq menlo-fontsize 12))
    (create-fontset-from-ascii-font
	 (concat "Menlo:size="
			 (number-to-string menlo-fontsize)
			 ":weight=normal:slant=normal") nil "menlokakugo")
    (set-fontset-font
	 "fontset-menlokakugo"
	 'unicode
	 (font-spec :family "Hiragino Kaku Gothic ProN" :size menlo-fontsize)
	 nil
	 'append)
    (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
		(set-frame-font "Ricty 16" nil t)
		(set-fontset-font
		 nil 'japanese-jisx0208
		 (font-spec :family "Ricty"))		
			 )

  ;; Ctrl/Cmd/Optionがシステムに渡されるのを防ぐ
  (setq mac-pass-control-to-system nil)
  (setq mac-pass-command-to-system nil)
  (setq mac-pass-option-to-system nil)
  ;; ¥ -> バックスラッシュに変換
  (define-key global-map [?¥] [?\\])
  ))
