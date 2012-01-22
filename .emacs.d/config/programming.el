(package-install 'github "kiwanami/emacs-deferred" nil)
(package-install 'file "mode-compile.el" 'mode-compile nil
				 "http://perso.tls.cena.fr/boubaker/distrib/")

(package-install 'emacswiki "anything-match-plugin.el" nil)

(package-install 'github "rooney/zencoding" nil)
(autoload 'zencoding-mode "zencoding-mode" nil t)

;;; historyf
(package-install 'github "k1LoW/emacs-historyf" 'historyf)
(global-set-key (kbd "C->") 'historyf-forward)
(global-set-key (kbd "C-<") 'historyf-back)

;;; smartchr
(package-install 'github "imakado/emacs-smartchr" 'smartchr)
(defun smartchr-custom-keybindings ()
  (local-set-key (kbd "=") (smartchr '(" = " " == "  "=")))
  ;; !! がカーソルの位置
  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[ [`!!'] ]" "[")))
  (local-set-key (kbd "{") (smartchr '("{\n`!!'\n}" "{`!!'}" "{")))
  (local-set-key (kbd "`") (smartchr '("\``!!''" "\`")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
  (local-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
  )

(defun smartchr-custom-keybindings-objc ()
  (local-set-key (kbd "@") (smartchr '("@\"`!!'\"" "@")))
  )

(add-hook 'c-mode-common-hook
		  '(lambda ()
			('smartchr-custom-keybindings)
			(c-set-style "cc-mode")))
(add-hook 'objc-mode-hook 'smartchr-custom-keybindings-objc)

;;; ffap
(ffap-bindings)
(setq ffap-newfile-prompt nil)
(setq ffap-kpathsea-depth 5)
(setq ff-other-file-alist
     '(("\\.mm?$" (".h"))
       ("\\.cc$"  (".hh" ".h"))
       ("\\.hh$"  (".cc" ".C"))

       ("\\.c$"   (".h"))
       ("\\.h$"   (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))

       ("\\.C$"   (".H"  ".hh" ".h"))
       ("\\.H$"   (".C"  ".CC"))

       ("\\.CC$"  (".HH" ".H"  ".hh" ".h"))
       ("\\.HH$"  (".CC"))

       ("\\.cxx$" (".hh" ".h"))
       ("\\.cpp$" (".hpp" ".hh" ".h"))

       ("\\.hpp$" (".cpp" ".c"))))

;;; lisp
(add-hook 'lisp-mode-hook
		  '(lambda()
			 (define-key lisp-mode-map (kbd "C-c C-b") 'eval-current-buffer)
			 (define-key lisp-mode-map (kbd "C-c C-e") 'edebug-defun)
			 ))

;;; html
(package-install 'github "hober/html5-el" nil)
(eval-after-load "rng-loc"
  ; require make relaxng
  '(add-to-list 'rng-schema-locating-files
				(format "%s/%s"
						(package-directory '("html5-el"))
						"schemas.xml")))

(setq auto-mode-alist
	  (cons '("\\.\\(xml\\|xsl\\|rng\\|x?html?\\)\\'" . nxml-mode)
			auto-mode-alist))
(add-hook 'nxml-mode-hook
          (lambda ()
			(require 'whattf-dt)
            (setq auto-fill-mode -1)
            (setq nxml-slash-auto-complete-flag t)      ; スラッシュの入力で終了タグを自動補完
            (setq nxml-child-indent 2)                  ; タグのインデント幅
            (setq nxml-attribute-indent 4)              ; 属性のインデント幅
            (setq indent-tabs-mode t)
            (setq nxml-bind-meta-tab-to-complete-flag t) 
            (setq nxml-slash-auto-complete-flag t)      ; </の入力で閉じタグを補完する
            (setq nxml-sexp-element-flag t)             ; C-M-kで下位を含む要素全体をkillする
            (setq nxml-char-ref-display-glyph-flag nil) ; グリフは非表示
            (setq tab-width 4)
			(custom-set-faces
			 '(mode-line
			   ((((type x w32 mac)
				  (class color))
				 (:background "navy" :foreground "yellow"
							  :box (:line-width -1 :style released-button))
				 )))
			 '(nxml-comment-content-face ((t (:foreground "yellow4"))))
			 '(nxml-comment-delimiter-face ((t (:foreground "yellow4"))))
			 '(nxml-delimited-data-face ((t (:foreground "grey"))))
			 '(nxml-element-local-name-face
			   ((t (:inherit nxml-name-face
							 :foreground "medium turquoise"))))
			 '(nxml-tag-slash-face
			   ((t (:inherit nxml-name-face :foreground "grey")
				   ))))
			))

;;; Zen Coding Mode
(package-install 'emacswiki "zencoding-mode.el" nil)
(autoload 'zencoding-mode "zencoding-mode" nil t)
(defun zencoding-mode-init ()
  (zencoding-mode)
  (define-key zencoding-mode-keymap (kbd "C-l" 'zencoding-expand-line))
  )
(add-hook 'sgml-mode-hook 'zencoding-mode-init)
(add-hook 'html-mode-hook 'zencoding-mode-init)
(add-hook 'ngml-mode-hook 'zencoding-mode-init)
(add-hook 'text-mode-hook 'zencoding-mode-init)


;;; perl
(package-install 'emacswiki "perl-completion.el" nil)
(package-install 'github "yoshiki/tmt-mode" nil)

(defalias 'perl-mode 'cperl-mode)
(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))
;;(setq auto-mode-alist (cons '("\\t$" . cperl-mode) auto-mode-alist))
(add-hook 'cperl-mode-hook
           (lambda ()
             (require 'perl-completion)
			 (perl-completion-mode t)
			 (auto-complete-mode t)
			 (make-variable-buffer-local 'ac-sources)
             (add-to-list 'ac-sources 'ac-source-perl-completion)) )
(autoload 'tmt-mode "tmt-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.mt$" . tmt-mode))
(add-hook 'tmt-mode-hook
		  (lambda ()
			))

;;; yaml
(package-install 'github "yoshiki/yaml-mode" nil)
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-hook 'yaml-mode-hook
		  (lambda ()
			))

;; javascript
;; js2-mode
(package-install 'svn "js2-mode.el" nil nil
				 "http://js2-mode.googlecode.com/svn/trunk")

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
(package-install 'svn "ruby-mode.el" nil nil
				 "http://svn.ruby-lang.org/repos/ruby/trunk/misc/")
(package-install 'github "eschulte/rinari" nil nil)
(package-install 'github "eschulte/rhtml" nil nil)
(package-install 'file
				 "https://github.com/m2ym/rsense/raw/master/etc/rsense.el"
				 nil)

(setq rsense-home (getenv "RSENSE_HOME"))
(autoload 'ruby-mode "ruby-mode" "Ruby mode" t)
(autoload 'rhtml-mode "rhtml-mode" "rhtml mode" t)
(setq auto-mode-alist (cons
			   '("\\.\\(rb\\)$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons
			   '("Rakefile$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons
			   '("\\.erb$" . rhtml-mode) auto-mode-alist))
(add-hook 'ruby-mode-hook
		  '(lambda ()
			 (require 'ido)
			 (ido-mode t)
			 (require 'rinari)
			 (require 'rsense)
			 (make-local-variable 'ac-sources)
			 (add-to-list 'ac-sources 'ac-source-rsense-method)
			 (add-to-list 'ac-sources 'ac-source-rsense-constant)
			 ))
(add-hook 'rhtml-mode
		  '(lambda()
			 (rinari-launch)
			 (require 'rsense)
			 (make-local-variable 'ac-sources)
			 (add-to-list 'ac-sources 'ac-source-rsense-method)
			 (add-to-list 'ac-sources 'ac-source-rsense-constant)
			 ))

;;; objc
(defun xcode:buildandrun ()
  (interactive)
  (do-applescript
   (format
	(concat
	 "tell application \"Xcode\" to activate \r"
	 "tell application \"System Events\" \r"
	 "     tell process \"Xcode\" \r"
	 "          key code 36 using {command down} \r"
	 "    end tell \r"
	 "end tell \r"
	 ))))
(cond (run-darwin
	   (add-to-list 'auto-mode-alist '("\\.m$" . objc-mode))
	   ;;(add-to-list 'auto-mode-alist '("\\.h$" . objc-mode))
	   ))

(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

(add-hook 'objc-mode-hook
		  (lambda ()
			(define-key objc-mode-map (kbd "\t") 'ac-complete)
			;; XCode を利用した補完を有効にする
			(push 'ac-source-company-xcode ac-sources)
			;; C++ のキーワード補完をする
			;;(push 'ac-source-c++-keywords ac-sources)
			(define-key objc-mode-map (kbd "C-c C-r") 'xcode:buildandrun)
			))

;;; php
(package-install 'file "php-mode.el" nil nil
				 "http://php-mode.svn.sourceforge.net/svnroot/php-mode/tags/php-mode-1.5.0/")
(autoload 'php-mode "php-mode" "PHP mode" t)
(setq auto-mode-alist
      (cons '("\\.\\(php\\|php5\\|inc\\)$" . php-mode) auto-mode-alist))
(add-hook 'php-mode-hook
		  '(lambda ()
			 (setq php-intelligent-tab nil)
			 ;;(setq intelligent-tab nil)
			 (setq indent-tabs-mode t)
			 ;;(setq c-basic-offset 4)
			 ;;(setq tab-width 4)
			 
			 (package-install 'emacswiki "php-completion.el" 'php-completion)
			 (php-completion-mode t)
			 (make-variable-buffer-local 'ac-sources)
			 (add-to-list 'ac-sources 'ac-source-php-completion)
			 
			 ) t)

;;; titanium
(package-install 'github "k1LoW/emacs-titanium" 'titanium)
(global-titanium t)

;;; Apple script
(package-install 'github "ieure/applescript-mode" nil)
(autoload 'applescript-mode "applescript mode" nil t)
(add-to-list 'auto-mode-alist
			 '("\\.\\(applescri\\|sc\\)pt\\'" . applescript-mode))

;; httpd.conf用
(package-install 'emacswiki "apache-mode.el" nil)
(autoload 'apache-mode "apache mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist
			 '("sites-\\(available\\|enabled\\)/" . apache-mode))

;;; TODO slime settings
(package-install 'github "nablaone/slime" nil)
(package-install 'github "purcell/ac-slime" nil)

