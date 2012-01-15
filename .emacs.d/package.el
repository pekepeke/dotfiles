;;; パッケージ管理システム
;; 2011-04-02

(require 'cl)

(defvar package-base-dir "~/.emacs.d/packages")

(defun byte-compile-directory (name &optional force)
	 (loop for f in (directory-files name t)
		   do (cond
			   ((string-match "el$" f)
				(if (or force (file-exists-p (format "%sc")))
						(progn
						  (load-file f)
						  (byte-compile-file f))))
			   ((and (file-directory-p f)
					 (not (member (file-name-nondirectory f) '("." ".."))))
				(byte-compile-directory f)
				))
		   ))

(defun package-path-basename (path)
  (file-name-sans-extension (file-name-nondirectory path)))

(defun package-directory (files)
  (concat package-base-dir "/"
          (package-path-basename (car files))))

(defun package-run-shell-command (command)
  (message (format "running...: %s" command))
  (shell-command command))

(defun package-install-from-emacswiki (files)
  (shell-command
   (format "mkdir -p %s" (package-directory files)))
  (package-run-shell-command
   (format "wget --directory-prefix %s %s"
           (package-directory files)
           (mapconcat (lambda (name)
                        (concat
						 "http://www.emacswiki.org/emacs/download/"
						 name))
                      files
                      " ")))
  (byte-compile-directory (package-directory files))
  )

(defun package-install-from-github (files)
  (package-run-shell-command
   (format (concat "git clone https://github.com/%s.git %s")
           (car files)
           (package-directory files)))
  (byte-compile-directory (package-directory files))
  )

(defun package-install-from-git (files &optional base-url)
  (package-run-shell-command
   (format (concat "git clone %s %s")
           (if base-url (format "%s/%s" base-url (car files)) (car files))
           (package-directory files)))
  (byte-compile-directory (package-directory files))
  )

(defun package-install-from-svn (files &optional base-url)
  (package-run-shell-command
   (format (concat "svn checkout %s %s")
           (if base-url base-url (car files))
           (package-directory files)))
  (byte-compile-directory (package-directory files))
  )

(defun package-install-from-file (files &optional base-url)
  (shell-command
   (format "mkdir -p %s" (package-directory files)))
  (package-run-shell-command
   (format "wget --directory-prefix %s %s"
           (package-directory files)
	   (if base-url (format "%s/%s" base-url (car files)) (car files))
	   ))
  (byte-compile-directory (package-directory files))
  )

(defun package-install-from-repo.or.cz (files)
  (package-run-shell-command
   (format (concat "git clone git://repo.or.cz/%s.git %s")
           (car files)
           (package-directory files)))
  (byte-compile-directory (package-directory files))
  )

(defun package-alist-value (alist key default-value)
  (if (listp alist)
      (let ((alist-item (assoc key alist)))
        (if alist-item
            (cdr alist-item)
          default-value))
    default-value))



;; (defun package-install (type package-spec &optional require-name &optional force)
(defun package-install
  (type package-spec require-name &optional force &optional repo-base-url)
  (let ((files (package-alist-value
		package-spec 'files
		(if (listp package-spec)
		    package-spec
		  (list package-spec))))
        (base-path (package-alist-value package-spec 'base-path "."))
        (additional-paths (package-alist-value package-spec 'additional-paths
                                               nil))
	(package-local nil)
        (install-proc (case type
                        (emacswiki
                         'package-install-from-emacswiki)
                        (github
                         'package-install-from-github)
                        (repo.or.cz
                         'package-install-from-repo.or.cz)
			(git
			 'package-install-from-git)
			(svn
			 'package-install-from-svn)
			(file
			 'package-install-from-file)
                        (t
                         (error "unknown package type: <%s>(%s)"
                                type package)))))
    (add-to-list 'load-path
                 (format "%s/%s"
                         (package-directory files)
                         base-path))
    (dolist (additional-path additional-paths)
      (add-to-list 'load-path (format "%s/%s"
                                      (package-directory files)
                                      additional-path)))
    (setq package-local
	  (format "%s/%s"(package-directory files) base-path))
    (cond (require-name
	   (condition-case err
	       (require require-name)
	     (error
	      (message (format "installing %s..." files))
	      (if repo-base-url (funcall install-proc files repo-base-url)
		(funcall install-proc files))))
	   (require require-name))
	  ((not (file-exists-p package-local))
	   (if repo-base-url (funcall install-proc files repo-base-url)
	     (funcall install-proc files)))
	  ))
  )


(provide 'package)
