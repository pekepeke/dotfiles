;;; キーバインド
(global-set-key (kbd "M-ESC ESC") 'keyboard-quit)
(keyboard-translate ?\C-h ?\C-?)
;; (define-key global-map (kbd "C-h") 'delete-backward-char) ; 削除
(define-key global-map (kbd "C-x C-n") 'next-multiframe-window) ; next win
(define-key global-map (kbd "C-x C-p") 'previous-multiframe-window) ; prev win
(define-key global-map (kbd "M-h") 'backward-kill-word)
(define-key global-map (kbd "M-?") 'help-for-help)        ; ヘルプ
(define-key global-map (kbd "C-c h") 'help-command)
(define-key global-map (kbd "C-z") 'undo)                 ; undo
(define-key global-map (kbd "C-c i") 'indent-region)      ; インデント
(define-key global-map (kbd "C-c C-i") 'hippie-expand)    ; 補完
(define-key global-map (kbd "C-c ;") '(lambda (arg)
				       (interactive "*P")
				       (let ((transient-mark-mode t))
					 (comment-dwim arg))))
;; (define-key global-map (kbd "C-c ;") 'comment-dwim)       ; コメントアウト
(define-key global-map (kbd "C-o") 'toggle-input-method)  ; 日本語入力切替
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(define-key global-map (kbd "C-s") 'isearch-forward-regexp)
(define-key global-map (kbd "C-r") 'isearch-backward-regexp)
(define-key global-map (kbd "C-c rr") 'query-replace)
(define-key global-map (kbd "C-c re") 'query-replace-regexp)  ; 正規表現による置換
(define-key global-map (kbd "C-[ M-C-g") 'goto-line)      ; 指定行へ移動

(define-key global-map (kbd "C-m") 'newline-and-indent)   ; auto-indent
(define-key global-map (kbd "C-j") 'newline)
(define-key global-map (kbd "<home>") 'back-to-indentation-or-bol)
(define-key global-map (kbd "C-a") 'back-to-indentation-or-bol)
(define-key global-map (kbd "<S-home>") 'selection-beginning-of-line-or-bol)

(define-key global-map (kbd "C-w") 'kill-region-or-backward-kill-word)

(defun kill-region-or-backward-kill-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (point) (mark))
    (backward-kill-word 1)))

(defun kill-word-or-delete-horizontal-space (arg)
  (interactive "p")
  (let ((pos (point)))
    (if (and (not (eobp))
             (= (char-syntax (char-after pos)) 32)
             (= (char-syntax (char-after (1+ pos))) 32))
        (prog1 (delete-horizontal-space) 
          (unless (memq (char-after pos) '(?( ?) ?{ ?} ?[ ?]))
            (insert " ")))
      (kill-word arg))))

;; minibuffer で単語削除
(define-key minibuffer-local-completion-map (kbd "C-w") 'backward-kill-word)

(defun back-to-indentation-or-bol ()
  (interactive)
  (let ((current (point)))
    (back-to-indentation)
    (if (= current (point))
        (beginning-of-line))))

(defun selection-beginning-of-line-or-bol ()
  (interactive)
  (ensure-mark)
  (back-to-indentation-or-bol))

(defun toggle-truncate-lines ()
  "折り返し表示を切り替え."
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))

(defun trim-buffer ()
  "Delete excess white space."
  (interactive)
  (save-excursion
    ;; 行末の空白を削除する
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (replace-match "" nil nil))
    ;; ファイルの終わりにある空白行を削除する
    (goto-char (point-max))
    (delete-blank-lines)
    ;; タブに変換できる空白は変換する
    ;; (mark-whole-buffer)
    ;; (tabify (region-beginning) (region-end))
    ))
