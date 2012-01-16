
(package-install 'file "mode-compile.el" 'mode-compile nil
				 "http://perso.tls.cena.fr/boubaker/distrib/")

(package-install 'emacswiki "apache-mode.el" nil)
(package-install 'github "ieure/applescript-mode" nil)
(package-install 'emacswiki "perl-completion.el" nil)
(package-install 'svn "js2-mode.el" nil nil
				 "http://js2-mode.googlecode.com/svn/trunk")
(package-install 'svn "ruby-mode.el" nil nil
				 "http://svn.ruby-lang.org/repos/ruby/trunk/misc/")
(package-install 'github "eschulte/rinari" nil nil)
(package-install 'github "eschulte/rhtml" nil nil)
(package-install 'file "php-mode.el" nil nil
				 "http://php-mode.svn.sourceforge.net/svnroot/php-mode/tags/php-mode-1.5.0/")

;;; perl
(add-hook 'cperl-mode-hook
           (lambda ()
             (require 'perl-completion)
             (add-to-list 'ac-sources 'ac-source-perl-completion)))

;; javascript
;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook
 'js2-mode-hook
 '(lambda()
	(interactive)
	(require 'js)
	(setq js-indent-level 4
		  js-expr-indent-offset 4
		  indent-tabs-mode nil)
	(set (make-local-variable 'indent-line-function) 'js-indent-line)
	(defun indent-and-back-to-indentation ()
	  (interactive)
	  (indent-for-tab-command)
	  (let ((point-of-indentation
			 (save-excursion
			   (back-to-indentation)
			   (point))))
		(skip-chars-forward "\s " point-of-indentation)))
	(define-key js2-mode-map (kbd "C-i") 'indent-and-back-to-indentation)
	(define-key js2-mode-map (kbd "C-m") nil)
	))

;; ruby
(autoload 'ruby-mode "ruby-mode" "Ruby mode" t)
(autoload 'rhtml-mode "rhtml-mode" "rhtml mode" t)
(setq auto-mode-alist (cons
			   '("\\.\\(rb\\)$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons
			   '("Rakefile$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons
			   '("\\.erb$" . rhtml-mode) auto-mode-alist))
(add-hook 'ruby-mode-hook '(lambda ()
							 (require 'ido)
							 (ido-mode t)
							 (require 'rinari)
							 ))
(add-hook 'rhtml-mode '(lambda()
						 (rinari-launch)
						 ))

;; php
(autoload 'php-mode "php-mode" "PHP mode" t)
(setq auto-mode-alist
      (cons '("\\.\\(php\\|php5\\|inc\\)$" . php-mode) auto-mode-alist))
(add-hook 'php-mode-hook '(lambda ()
							(setq php-intelligent-tab nil)
							;;(setq intelligent-tab nil)
							(setq indent-tabs-mode t)
							;;(setq c-basic-offset 4)
							;;(setq tab-width 4)
							) t)


;;; apple script
(autoload 'applescript-mode "applescript mode" nil t)
(add-to-list 'auto-mode-alist
			 '("\\.\\(applescri\\|sc\\)pt\\'" . applescript-mode))

;; httpd.conf用
(autoload 'apache-mode "apache mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist
			 '("sites-\\(available\\|enabled\\)/" . apache-mode))
