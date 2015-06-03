(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(let ((versioned-dir (locate-user-emacs-file "elisp/" (format "v%s" emacs-version))))
  (setq-default el-get-dir (expand-file-name "el-get" versioned-dir)
                package-user-dir (expand-file-name "elpa" versioned-dir)))

;;; define local vars
(defvar local-assets-directory (locate-user-emacs-file "assets/"))

(defvar local-data-directory (locate-user-emacs-file "cache/"))
(if (not (file-directory-p local-data-directory))
	(make-directory local-data-directory))
(defun locate-local-data-file (filename)
  (format "%s/%s" local-data-directory filename))

;; add load paths
(add-to-list 'load-path (locate-user-emacs-file "elisp/el-get/el-get/"))

(setq el-get-user-package-directory (locate-user-emacs-file "packages"))

;; url-cache
(setq url-cache-directory (locate-local-data-file "cache"))

;; recentf
(custom-set-variables
 '(recentf-save-file
   (locate-local-data-file (replace-regexp-in-string "\\." "_" system-configuration))))

;; eshell
(setq eshell-directory-name (locate-local-data-file "eshell/"))


(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))


(require 'package)

(setq package-user-dir (locate-user-emacs-file "elisp/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(load (locate-user-emacs-file "bundles.el"))

;; load init files
(el-get-bundle! emacs-jp/init-loader
  ;; load
  (setq-default init-loader-show-log-after-init nil
                init-loader-byte-compile t)
  (init-loader-load (locate-user-emacs-file "inits"))

  ;; hide compilation results
  (let ((win (get-buffer-window "*Compile-Log*")))
    (when win (delete-window win))))


