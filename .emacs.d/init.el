;;; ロードパスの追加
(add-to-list 'load-path "~/.emacs.d/elisp/")

;; setup package.el
(require 'package)
(setq package-user-dir "~/.emacs.d/elisp.d/elpa/")
(setq package-archives (list '("melpa" . "http://melpa.milkbox.net/packages/")))
;; (add-to-list 'package-archives
;; 			 '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives
;; 			 '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; setup el-get
(setq el-get-dir "~/.emacs.d/elisp.d/el-get/")
(add-to-list 'load-path "~/.emacs.d/elisp.d/el-get/el-get/")
(setq el-get-generate-autoloads nil)

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(defvar my/packages
  '(

   ;;; write some package
          popwin
          auto-complete
   quickrun
   helm
   helm-descbinds
		  grep-edit
		  smartchr
   yasnippet
   evil
   ;; grep-edit
   ;; smartchr
   ;; yasnippet-config
   ;; evil-surround
   ;; mode-compile
   color-theme
   color-theme-molokai
   highlight-parentheses
   ;; historyf
   perl-completion
   ;; tmt-mode
   ruby-mode rinari rhtml-mode rsense
   python-mode
										; html5
   haml-mode js2-mode
   coffee-mode sass-mode zencoding-mode
   ;; haskell-mode
   clojure-mode
   ;; rst-mode
   textile-mode markdown-mode
   yaml-mode
   apache-mode
   applescript-mode
   ;; run-test
   google-translate
   init-loader
    ) "A list of packages to install")
(defvar my/el-get-packages
  '(
		  ;; popup
		  ;; yasnippet
		  ;; yasnippet-config
		  ;; evil
		  evil-surround
		  ;; ;; eshell-manual
		  mode-compile
		  ;; color-theme
		  ;; color-theme-molokai
		  ;; highlight-parentheses
		  historyf
		  ;; perl-completion
		  tmt-mode
		  ;; ruby-mode rinari rhtml-mode rsense
		  ;; python-mode
		  ;; ; html5
		  ;; haml-mode js2-mode
		  ;; coffee-mode sass-mode zencoding-mode
		  ;; ;; haskell-mode
		  ;; clojure-mode
		  rst-mode
		  ;; textile-mode markdown-mode
		  ;; yaml-mode
		  ;; apache-mode
		  ;; applescript-mode
		  run-test
		  ;; google-translate
		  ;; init-loader
    ) "A list of packages to install by el-get")

;; install packages by package.el
(dolist (package my/packages)
  (when (or (not (package-installed-p package)))
    (package-install package)))


;; install packages by el-get
(setq el-get-sources '(
		  (:name undo-tree
			 :type github
			 :pkgname "emacsmirror/undo-tree")
		  (:name evil
			 :website "http://gitorious.org/evil/pages/Home"
			 :type git
			 :url "git://gitorious.org/evil/evil.git"
			 :features evil
			 :depends undo-tree
			 )
		  (:name helm-descbinds
				 :type github
				 :pkgname "emacs-helm/helm-descbinds"
				 :description "Yet Another `describe-bindings' with `helm'."
				 :depends (helm))
		  (:name grep-edit
				 :type emacswiki
				 :features (grep-edit))
		  (:name tmt-mode
			 :type http
			 :url "https://github.com/yoshiki/tmt-mode/raw/master/tmt-mode.el"
			 )
		  (:name color-theme-molokai
				 :type github
				 :pkgname "alloy-d/color-theme-molokai"
				 :depends color-theme
				 :prepare (autoload 'color-theme-molokai "color-theme-molokai"
							"color-theme: molokai" t))
		  (:name rsense
				 :type http
				 :url "https://github.com/m2ym/rsense/raw/master/etc/rsense.el"
				 )
		  (:name ruby-mode
				 :type http
				 :description "Major mode for editing Ruby files. (trunk-head)"
				 :url "http://bugs.ruby-lang.org/projects/ruby-trunk/repository/raw/misc/ruby-mode.el")
		  (:name php-mode
				 :type github
				 :website "https://github.com/ejmr/php-mode"
				 :description "Major mode for editing PHP files. (on Github based on SourceForge version))"
				 :pkgname "ejmr/php-mode")
		  (:name multi-web-mode
				 :type git
				 :website "https://github.com/fgallina/multi-web-mode"
				 :description "Multi Web Mode is a minor mode wich makes web editing in Emacs much easier."
				 :url "git://github.com/fgallina/multi-web-mode.git")
		  (:name run-test
				 :type git
				 :url "https://github.com/kou/run-test.git"
				 :load-path ("lib")
				 :features (run-test-setting)
				 )
		  (:name mode-compile
			 :website "https://github.com/emacs-jp/init-loader"
			 :description "A loader of configuration files."
			 :type github
			 :pkgname "emacs-jp/init-loader")
		  (:name google-translate
				 :description "Use google translate api to perform translations"
				 :type github
				 :pkgname "manzyuk/google-translate"
				 :load "google-translate.el")
		  (:name init-loader
			 :website "https://github.com/emacsmirror/mode-compile"
			 :description "Compile files according to major-mode."
			 :type github
			 :pkgname "emacsmirror/mode-compile")
		       ))
(el-get 'sync my/el-get-packages)

;;; define local vars
(defvar local-assets-directory "~/.emacs.d/assets")

(defvar local-tmp-directory "~/.emacs.d/cache/")
(if (not (file-directory-p local-tmp-directory))
		 (make-directory local-tmp-directory))
(defun local-tmp-filename (filename)
  (format "%s/%s" local-tmp-directory filename))

;;; load settings
(require 'init-loader)
(init-loader-load "~/.emacs.d/etc/")


;(load "lib/versions")

;(load "config/common")
;(load "config/keybind")
;;(load "config/view-mode")

;;; load packages
;; (load "config/packages")

;(load "config/flymake")

;(load "config/programming")

;;(load "config/builtins")
