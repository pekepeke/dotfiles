;;; ロードパスの追加
(add-to-list 'load-path "~/.emacs.d/elisp/")

;; setup package.el
(require 'package)
(setq package-user-dir "~/.emacs.d/elisp.d/elpa/")
;; (setq package-archives (list '("melpa" . "http://melpa.milkbox.net/packages/")))
(add-to-list 'package-archives
			 '("melpa" . "http://melpa.milkbox.net/packages/") t)
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
    ;; write some package
    popwin
	ac-emmet
	ac-etags ac-inf-ruby ac-ispell ac-js2 ac-math
	color-moccur
	company
	recentf-ext
    quickrun
    yasnippet
    helm
    helm-descbinds
	helm-projectile helm-dired-recent-dirs
	helm-ag helm-flycheck
	helm-perldoc helm-pydoc helm-rails helm-rb
	helm-git helm-git-grep helm-git-files
	helm-css-scss helm-dash
	ac-helm
	projectile
	undo-tree
    evil
	evil-numbers evil-nerd-commenter evil-leader
    ;; yasnippet-config
    ;; evil-surround
    ;; mode-compile
	flycheck
	expand-region
	ido-ubiquitous
	paredit
	smartparens
	ace-jump-mode
	rainbow-delimiters
	diminish
	exec-path-from-shell
	ack-and-a-half
	dired+
	hlinum
	undohist
	point-undo
	sequential-command
	zlc
	;; -- lang
	color-theme
	highlight-parentheses
	bash-completion
	web-mode mmm-mode
	plenv perl-completion
	jedi
	ruby-mode rinari rhtml-mode rsense inf-ruby
	ruby-block ruby-end
	rbenv
	;; -- html5
	haml-mode js2-mode
	emmet-mode
	tern tern-auto-complete
	coffee-mode sass-mode
	clojure-mode cider
	haskell-mode
	go-mode go-autocomplete go-eldoc
	textile-mode markdown-mode
	yaml-mode
	apache-mode
	applescript-mode
	;; run-test
	google-translate
	;; -- git
	magit
	gitconfig-mode
	git-commit-mode
	git-rebase-mode
	gitignore-mode
	git-gutter-fringe
	gh
	gist
	;; --loader
	init-loader
    ) "A list of packages to install")

(defvar my/el-get-packages
  '(
    auto-complete
	auto-complete-css
	auto-complete-emacs-lisp
    yasnippet-config
    grep-edit
    smartchr
	color-theme-molokai
	evil-surround
	evil-rails
	evil-plugins
	mode-compile
	historyf
	tmt-mode
	rcodetools
	python-mode
	php-mode-improved
	php-completion
	php-eldoc
	rst-mode
	run-test
    ) "A list of packages to install by el-get")

;; install packages by package.el
(dolist (package my/packages)
  (when (or (not (package-installed-p package)))
    (package-install package)))


;; install packages by el-get
(setq el-get-sources
	  '(
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
		(:name python-mode
			   :description "Major mode for editing Python programs"
			   :type bzr
			   :url "lp:python-mode"
			   :load-path ("." "test")
			   :compile nil
			   :prepare (progn
						  (autoload 'python-mode "python-mode"
							"Python editing mode." t)
						  (autoload 'doctest-mode "doctest-mode"
							"Doctest unittest editing mode." t)
						  (setq py-install-directory
								(el-get-package-directory "python-mode"))
						  (add-to-list 'auto-mode-alist
									   '("\\.py$" . python-mode))
						  (add-to-list 'interpreter-mode-alist
									   '("python" . python-mode))))
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
        (:name evil-plugins
               :type github
               :pkgname "tarao/evil-plugins")
        (:name set-perl5lib
               :type http
               :url "https://gist.github.com/syohex/1333926/raw/cabc5569d82971dc9fedf3198c4ae1dd858381c3/set-perl5lib.el")
        (:name set-perl5lib-glob-from-git-root
               :type http
               :url "https://gist.github.com/hitode909/617915/raw/a1cd2f87282830c34ca98afddda0c1376f00c2cf/set-perl5lib-glob-from-git-root.el")
        (:name direx-project
               :type http
               :url "https://raw.github.com/m2ym/direx-el/master/direx-project.el")
        (:name key-combo
               :type github
               :pkgname "uk-ar/key-combo")
        (:name helm-perldoc
               :type github
               :pkgname "syohex/emacs-helm-perldoc")
        (:name auto-highlight-symbol
               :type github
               :pkgname "emacsmirror/auto-highlight-symbol")
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
