(set $textwidth 80)
(set $clipboard 1)

;; mappings
(let ((amap (ViMap mapWithName:"arrowMap"))
      (gmap (ViMap mapWithName:"genericMap"))
      (imap (ViMap insertMap))
      (mmap (ViMap mapWithName:"motionMap"))
      (tmap (ViMap mapWithName:"textObjectsMap"))
      (wmap (ViMap mapWithName:"windowMap"))
      (nmap (ViMap normalMap))
      (omap (ViMap operatorMap))
      (vmap (ViMap visualMap))
      (webmap (ViMap mapWithName:"webMap"))
      (tabmap (ViMap mapWithName:"tableNavigationMap"))
      (sidemap (ViMap mapWithName:"sidebarMap"))
      (emap (ViMap explorerMap))
      (smap (ViMap symbolMap))
      (xmap (ViMap mapWithName:"exCommandMap"))
      (cmap (ViMap completionMap)))

	;;; imaps,vmaps
	; like replace.vim
	(nmap map:"_iw" to:"viwPyiw")
	(nmap map:"_aw" to:"vawPyiw")
	(vmap map:"_" to:"P")

	; comment/uncomment selection
	;;((ViMap visualMap) map:"<cmd-\\>" to:":\'<,\'>s/^/#/<ENTER>")
	;;((ViMap normalMap) map:"<cmd-\\>" to:"V:\'<,\'>s/^/#/<ENTER>" )
	;;((ViMap visualMap) map:"<cmd-|>" to:":\'<,\'>s/^#//<ENTER>")
	;;((ViMap normalMap) map:"<cmd-|>" to:"V:\'<,\'>s/^#//<ENTER>")
	(vmap map:"gc" to:"<cmd-/>")
	(nmap map:"gc" to:"<cmd-/>")

	; open current project root dir in explorer
	(nmap map:"<cmd-f>" toExpression:(do ()
		(let (
				(doc-url nil) (doc-path nil) (project-root nil)
				(has-file (do (parent name) 
					(NSFileManager defaultManager) 
						fileExistsAtPath:(parent stringByAppendingPathComponent:name)))
				(found-root nil)
			)
			(set doc-url ((current-document) fileURL))
			(set doc-path (if 
				(and doc-url (eq "file" (doc-url scheme)))
					(doc-url path)))
			(set project-root (if doc-path (doc-path stringByDeletingLastPathComponent)))
			(if project-root
				(set found-root t)
				(while t
					(case t
						((has-file project-root ".git") (break))
						((has-file project-root ".hg") (break))
						((has-file project-root ".svn") (break))
						((has-file project-root "Gemfile") (break))
						((has-file project-root "Makefile") (break))
					)
					(set doc-path project-root)
					(set project-root (project-root stringByDeletingLastPathComponent))
					(if (eq project-root doc-path)
						(progn
							(set found-root nil)
							(break))
					)
				)
				(if found-root
					((current-explorer) browseURL:(NSURL 
						fileURLWithPath:project-root
						)))
				)
			)
		))

	;;; imaps
	(imap setKey:"<c-f>" toMotion:"move_right:")
	(imap setKey:"<c-b>" toMotion:"move_left:")
	(imap setKey:"<c-a>" toMotion:"move_first_char:")
	(imap setKey:"<c-e>" toEditAction:"append_eol:")
	; don't work??
	(imap setKey:"<c-h>" toAction:"input_backspace:")

	;;; emaps
	(emap map:"H" to:"<cmd-up>" recursively:YES scope:nil)
	(emap map:"L" to:"<cr>")
	(emap map:"~" toExpression:(do ()
        ((current-explorer) browseURL:(NSURL fileURLWithPath:("~" stringByExpandingTildeInPath)))))
	(emap map:"<c-n>" toMotion:"show_menu:")
	)

;; commandMap not exists .... --;;;
; ((ViMap commandMap) map:"<c-x>" toExpression:(do ()
; 		(let ((url (current-document fileURL)))
; 			(if url (url path)))))

;; ex commands
(let ((ex (ExMap defaultMap)))
	; open finder
	(ex define:"here" syntax:"e" as:(do ()
	(let (
		(doc-url ((current-document) fileURL))
		(dir-path nil))
		(if (and doc-url (eq "file" (doc-url scheme)))
			(set dir-path ((doc-url path) stringByDeletingLastPathComponent))
			((NSWorkspace sharedWorkspace) openURL:(NSURL fileURLWithPath:dir-path))
		))))
	)

;; enable nu console
(load "console")
(global console ((NuConsoleWindowController alloc) init))

