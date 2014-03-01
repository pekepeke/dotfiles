;; Start In evil-mode with surround.vim emulation
(evil-mode 1)
(global-surround-mode 1)

;; normal mode
;; (define-key evil-normal-state-map " " 'dired-jump)
(define-key evil-normal-state-map "ff" 'evil-find-char)
(define-key evil-normal-state-map "fj" 'helm-buffers-list)
(define-key evil-normal-state-map "fk" 'helm-find-files)
;;(define-key evil-normal-state-map "fl" 'helm-find-files)
(define-key evil-normal-state-map "fm" 'helm-recentf)
(define-key evil-normal-state-map "fgr" 'helm-grep)
(define-key evil-normal-state-map "fhk" 'helm-descbinds)
(define-key evil-normal-state-map "fe" 'helm-M-x)
(define-key evil-normal-state-map "fhh" 'helm-help)
(define-key evil-normal-state-map "fr" 'helm-resume)
(define-key evil-normal-state-map "gcc" 'comment-dwim)
(define-key evil-normal-state-map " vp" 'eshell)

;; visual mode
(define-key evil-visual-state-map "gcc" 'comment-or-uncomment-region)

