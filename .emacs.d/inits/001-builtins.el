(if (eq system-type 'windows-nt) ;; no user-full-name on windows emacs env.
    (custom-set-variables '(user-full-name (getenv "USERNAME"))))

;; trash
(when (not (functionp 'system-move-file-to-trash))
  ;; system-move-file-to-trashが環境で定義されていないときに使われる。
  (custom-set-variables '(trash-directory "~/.Trash"))
  (if (not (file-directory-p trash-directory)) (make-directory trash-directory)))

;; savehist
(setq savehist-file (locate-local-data-file "savehist"))

(setq auto-save-list-file-prefix (locate-local-data-file "auto-save-list/.saves-"))

(setq auto-save-file-name-transforms
      `((".*" ,(locate-local-data-file "auto-save-list/") t)))

(setq backup-directory-alist
      (cons (cons "\\.*$" (locate-local-data-file "backup/"))
            backup-directory-alist))

;; recentf
(custom-set-variables
 '(recentf-save-file
   (locate-local-data-file (replace-regexp-in-string "\\." "_" system-configuration))))

;; eshell
(setq eshell-directory-name (locate-local-data-file "eshell/"))

;; auto-complete
(setq ac-comphist-file (locate-local-data-file "ac-comphist.dat"))

;; migemo
(setq migemo-pattern-alist-file (locate-local-data-file "migemo/migemo-pattern"))
(setq migemo-frequent-pattern-alist-file (locate-local-data-file "migemo/migemo-frequent"))

;; bookmark
(setq bookmark-default-file (locate-local-data-file "bookmark-" user-full-name))

;; tramp
(setq tramp-persistency-file-name (locate-local-data-file "tramp-" user-full-name))

;; save-place
(setq save-place-file (locate-local-data-file "places"))

;; 外部拡張
;; save-kill
(setq save-kill-file-name (locate-local-data-file "kill-ring-saved"))

;; undohist
(setq undohist-directory (locate-local-data-file "undohist"))

;; multiple-cursors
(setq mc/list-file (locate-local-data-file "mc-lists.el"))

;; request
(setq request-storage-directory (locate-local-data-file "request-" user-full-name))

;; helm-github-stars
(setq helm-github-stars-cache-file (locate-local-data-file "helm-github-stars-cache"))

;; helm-recentd
(setq helm-recentd-file (locate-local-data-file "helm-recentd-" user-full-name))

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
