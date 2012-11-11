;;; ロードパスの追加
(setq load-path (append
                 '(
				   "~/.emacs.d"
				   )
                 load-path))

;;; define local vars
(defvar local-tmp-directory "~/.emacs.d/tmp")
(if (not (file-directory-p local-tmp-directory))
		 (make-directory local-tmp-directory))


(defun local-tmp-filename (filename)
  (format "%s/%s" local-tmp-directory filename))

(load "lib/versions")

(load "config/common")
(load "config/keybind")
;;(load "config/view-mode")

;;; load packages
(load "config/packages")

(load "config/flymake")

(load "config/programming")

;;(load "config/builtins")