;; Start In evil-mode with surround.vim emulation
(evil-mode 1)
(global-surround-mode 1)

;; (define-key evil-normal-state-map " " 'dired-jump)
(define-key evil-normal-state-map " f" 'helm-find-files)
(define-key evil-normal-state-map " r" 'helm-resume)
(define-key evil-normal-state-map "gcc" 'comment-dwim)
(define-key evil-visual-state-map "gcc" 'comment-or-uncomment-region)

