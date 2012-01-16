;;; ロードパスの追加
(setq load-path (append
                 '("~/.emacs.d"
                   ; "~/.emacs.d/bundler"
                   "~/.emacs.d/packages")
                 load-path))

; (load "emacs-bundle/bundle")
; (load "emacs-deferred/deferred")

;;; define local vars
(defvar local-tmp-directory "~/.emacs.d/tmp")
(if (not (file-directory-p local-tmp-directory))
		 (make-directory local-tmp-directory))

(defun local-tmp-filename (filename)
  (format "%s/%s" local-tmp-directory filename))

;;;(bundle-install 

(load "libs/versions")

(load "config/commons")
(load "config/keybinds")
;;; 標準Elispの設定
(load "config/builtins")

;;; 非標準Elispの設定
(load "config/packages")

(load "config/programming")

(load "config/flymake")

