(require 'autoinsert)
(require 'cl)

(setq auto-insert-directory "~/.emacs.d/templates/")
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
;; 2011-03-01
(require 'warnings)

;;; スペルチェック
;; 2011-03-09
(setq-default flyspell-mode t)
(setq ispell-dictionary "american")
