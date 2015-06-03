;; auto-complete
(setq ac-comphist-file (locate-local-data-file ac-comphist.dat))

;; migemo
(setq migemo-pattern-alist-file (locate-local-data-file "migemo/migemo-pattern"))
(setq migemo-frequent-pattern-alist-file (locate-local-data-file "migemo/migemo-frequent"))

;; savehist
(setq savehist-file (locate-local-data-file "savehist-history"))

;; savehistのファイルに保存する履歴からfile-name-historyをのぞく
(setq savehist-ignored-variables '(file-name-history))

(setq auto-save-list-file-prefix (locate-local-data-file "auto-save-list"))

(require 'autoinsert)
(require 'cl)

(setq auto-insert-directory (locate-user-emacs-file "assets/"))
(setq auto-insert-alist
      (nconc
       (remove nil
	       (mapcar
		(lambda(filename)
		  (let ((extension (file-name-extension filename)))
		    (if extension
			(cons (format "\\.%s$" extension)
			      (vector filename 'template-render))
		      )))
		(directory-files auto-insert-directory nil "^[^\.]"))
	       )
       auto-insert-alist))


(defvar template-replacements-alists
  '(("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%include-guard%"    . (lambda () (format "__SCHEME_%s__" (upcase (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))))

(defun render-template ()
  (time-stamp)
  (mapc #'(lambda(c)
        (progn
          (goto-char (point-min))
          (replace-string (car c) (funcall (cdr c)) nil)))
    template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)


;;; バージョン管理システム
;; diredから適切なバージョン管理システムの*-statusを起動
(defun dired-vc-status (&rest args)
  (interactive)
  (cond ((file-exists-p (concat (dired-current-directory) ".svn"))
         (svn-status (dired-current-directory)))
        ((file-exists-p (concat (dired-current-directory) ".git"))
         (magit-status (dired-current-directory)))
        (t
         (message "version controlled?"))))
(define-key dired-mode-map "V" 'dired-vc-status)

;;; 警告
(require 'warnings)

;;; スペルチェック
(setq-default flyspell-mode t)
(setq ispell-dictionary "american")
