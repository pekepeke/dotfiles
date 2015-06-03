;; elisp
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

(add-hook 'c-mode-common-hook
		  '(lambda ()
			 ('smartchr-custom-keybindings)
			 (c-set-style "cc-mode")))
(add-hook 'objc-mode-hook 'smartchr-custom-keybindings-objc)

;;; company-mode
(autoload 'company-mode "company" nil t)
(eval-after-load "company"
  '(progn
	; (ac-company-define-source ac-source-company-xcode company-xcode)
	; (ac-company-define-source ac-source-company-xcode company-gtags)
	(setq ac-modes (append ac-modes '(objc-mode)))
	(setq ac-modes (append ac-modes '(c-mode)))
	(setq ac-modes (append ac-modes '(c++-mode)))
	))


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

;;; web-mode
(require 'web-mode)
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook-init ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   4)
  (setq web-mode-css-offset    4)
  (setq web-mode-script-offset 4)
  (setq web-mode-php-offset    4)
  (setq web-mode-java-offset   4)
  (setq web-mode-asp-offset    4))
(add-hook 'web-mode-hook 'web-mode-hook-init)
;;; nxml-mode
(setq auto-mode-alist
	  (cons '("\\.\\(xml\\|xsl\\|rng\\)\\'" . nxml-mode)
			auto-mode-alist))

(add-hook 'nxml-mode-hook
  '(lambda ()
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

;;; Zen Coding
(autoload 'emmet-mode "emmet-mode" nil t)
(defun emmet-mode-init ()
  (emmet-mode)
  (setq emmet-indentation 4)
  (define-key emmet-mode-keymap (kbd "C-l" 'emmet-expand-line)))
(add-hook 'sgml-mode-hook 'emmet-mode-init)
(add-hook 'html-mode-hook 'emmet-mode-init)
(add-hook 'css-mode-hook 'emmet-mode-init)
(add-hook 'ngml-mode-hook 'emmet-mode-init)
(add-hook 'text-mode-hook 'emmet-mode-init)


;;; perl

(defalias 'perl-mode 'cperl-mode)
(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))
;;(setq auto-mode-alist (cons '("\\t$" . cperl-mode) auto-mode-alist))
(add-hook 'cperl-mode-hook
  '(lambda ()
	 (require 'perl-completion)
	 (perl-completion-mode t)
	 (auto-complete-mode t)
	 ;(make-variable-buffer-local 'ac-sources)
	 ;(add-to-list 'ac-sources 'ac-source-perl-completion))
	 ))

(autoload 'tmt-mode "tmt-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.mt$" . tmt-mode))

;;; yaml
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; javascript
;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook
  '(lambda ()
	 (require 'tern)
	 (require 'tern-auto-complete)
	 (setq js2-indent-level 4
		   js2-expr-indent-offset 4
		   indent-tabs-mode nil)

	 (setq-default js2-allow-rhino-new-expr-initializer nil)
	 (setq-default js2-auto-indent-p nil)
	 (setq-default js2-enter-indents-newline nil)
	 (setq-default js2-global-externs '("module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON"))
	 (setq-default js2-idle-timer-delay 0.1)
	 (setq-default js2-indent-on-enter-key nil)
	 (setq-default js2-mirror-mode nil)
	 (setq-default js2-strict-inconsistent-return-warning nil)
	 (setq-default js2-auto-indent-p t)
	 (setq-default js2-include-rhino-externs nil)
	 (setq-default js2-include-gears-externs nil)
	 (setq-default js2-concat-multiline-strings 'eol)
	 (setq-default js2-rebind-eol-bol-keys nil)

	 ;; Let flycheck handle parse errors
	 (setq-default js2-show-parse-errors nil)
	 (setq-default js2-strict-missing-semi-warning nil)
	 (setq-default js2-strict-trailing-comma-warning t) ;; jshint does not warn about this now for some reason

	 ;; (require 'js2-refactor)
	 ))

;; markdown
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(setq rsense-home (getenv "RSENSE_HOME"))
(autoload 'ruby-mode "ruby-mode" "Ruby mode" t)
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
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

	 (require 'ruby-block)
	 (ruby-block-mode t)
	 ;; ミニバッファに表示し, かつ, オーバレイする.
	 (setq ruby-block-highlight-toggle t)

	 (setq tab-width 2)
	 (setq ruby-indent-level tab-width)
	 (setq ruby-deep-indent-paren-style nil)
	 (define-key ruby-mode-map [return] 'ruby-reindent-then-newline-and-indent)
	 (setq ruby-deep-indent-paren-style nil)
	 (make-local-variable 'ac-omni-completion-sources)
	 (make-local-variable 'ac-ignore-case)
	 (setq ac-ignore-case nil)
	 (setq ac-omni-completion-sources '(("\\.\\=" . (ac-source-rcodetools))))
	 ;(make-local-variable 'ac-sources)
	 ;(add-to-list 'ac-sources 'ac-source-rsense-method)
	 ;(add-to-list 'ac-sources 'ac-source-rsense-constant)
	 ))

(add-hook 'rhtml-mode-hook
  '(lambda ()
	 (rinari-launch)
	 (require 'rsense)
	 ;(make-local-variable 'ac-sources)
	 ;(add-to-list 'ac-sources 'ac-source-rsense-method)
	 ;(add-to-list 'ac-sources 'ac-source-rsense-constant)
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
			; (push 'ac-source-company-xcode ac-sources)
			;; C++ のキーワード補完をする
			;;(push 'ac-source-c++-keywords ac-sources)
			(define-key objc-mode-map (kbd "C-c C-r") 'xcode:buildandrun)
			))

;;; php
(autoload 'php-mode "php-mode" "PHP mode" t)
(setq auto-mode-alist
      (cons '("\\.\\(php\\|php5\\|inc\\)$" . php-mode) auto-mode-alist))
(add-hook 'php-mode-hook
  '(lambda ()
	 (setq php-intelligent-tab nil)
	 (when (require 'php-completion)
	   (php-completion-mode t))
	 (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
	 (define-key php-mode-map (kbd "[") (smartchr "[]" "array()" "[[]]"))
	 (define-key php-mode-map (kbd "]") (smartchr "array " "]" "]]"))
	 (make-local-variable 'ac-sources)
	 (setq ac-sources
		   '(
			 ac-source-words-in-same-mode-buffers
			 ac-source-php-completion
			 ac-source-filename
			 ac-source-etags
			 ))
	 (let ((my/php-offset 4))
	   (setq tab-width my/php-offset
			 c-basic-offset my/php-offset
			 indent-tabs-mode nil)
	   (c-set-offset 'case-label' my/php-offset)
	   (c-set-offset 'arglist-intro' my/php-offset)
	   (c-set-offset 'arglist-cont-nonempty' my/php-offset)
	   (c-set-offset 'arglist-close' 0))
	 ; (make-variable-buffer-local 'ac-sources)
	 ; (add-to-list 'ac-sources 'ac-source-php-completion)
	 ))

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

(add-hook 'csharp-mode-hook
  '(lambda ()
	 (turn-on-auto-revert-mode)
	 (setq indent-tabs-mode nil)
	 (yas/minor-mode-on)
	 (require 'rfringe))
	 )

;;; markdown
(autoload 'markdown-mode "markdown mode" nil t)
(add-to-list 'auto-mode-alist
			 '("\\.\\(md\\|markdown\\|mkd\\)\\'" . markdown-mode))

;;; Apple script
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

