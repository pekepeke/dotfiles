;; Start In evil-mode with surround.vim emulation
(evil-mode 1)
(require 'surround)
(global-surround-mode 1)
(require 'evil-numbers)
(require 'evil-nerd-commenter)

;; normal mode
(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)
;; (define-key evil-normal-state-map " " 'dired-jump)
(define-key evil-normal-state-map "ff" 'evil-find-char)
(define-key evil-normal-state-map "fj" 'helm-buffers-list)
(define-key evil-normal-state-map "fk" 'helm-find-files)
;;(define-key evil-normal-state-map "fl" 'helm-find-files)
(define-key evil-normal-state-map "fm" 'helm-recentf)
(define-key evil-normal-state-map "fd" 'helm-dired-recent-dirs)
(define-key evil-normal-state-map "fgr" 'helm-ag)
(define-key evil-normal-state-map "fq" 'helm-flycheck)
(define-key evil-normal-state-map "fhk" 'helm-descbinds)
(define-key evil-normal-state-map "fhv" 'describe-variable)
(define-key evil-normal-state-map "fhf" 'describe-function)
(define-key evil-normal-state-map "fe" 'helm-M-x)
(define-key evil-normal-state-map "fhh" 'helm-help)
(define-key evil-normal-state-map "fr" 'helm-resume)
(define-key evil-normal-state-map " vp" 'eshell)

(define-key evil-normal-state-map "gcc" 'evilnc-comment-or-uncomment-lines)
;; visual mode
(define-key evil-visual-state-map "gcc" 'evilnc-comment-or-uncomment-lines)
;; (define-key evil-visual-state-map "gcc" 'comment-or-uncomment-region)

