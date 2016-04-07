;; Temporary files cluttering up the space:
;; creates a directory to store ~files
(defvar user-temporary-file-directory "~/.emacs-autosaves/")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; set the el-get path, and  create it if it doesn't exist
(setq elget-path  "~/.emacs.d/el-get/")
(unless (file-exists-p elget-path)
  (make-directory elget-path))

; add el-get to the load path, and install it if it doesn't exist
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; packages to install
(setq my-packages '(auctex
                    helm
                    expand-region
                    goto-last-change
                    magit
                    helm-ag
                    exec-path-from-shell
                    markdown-mode
                    auto-complete
                    web-mode
                    julia-mode
                    evil
                    powerline-evil
                    ;; anaconda-mode
                    ))   
(setq el-get-git-shallow-clone t) ;; We don't need to clone the entire
(el-get 'sync my-packages) ;; then intsall!

(exec-path-from-shell-initialize) ;; load PATH from shell
(add-to-list 'load-path "~/.emacs.d/elfiles/")

;; general appearence
(menu-bar-mode 0)
(setq inhibit-startup-screen 1)
(global-hl-line-mode 1) ;; highlight current line
(show-paren-mode 1) ;; highlite pair of parenthesis
(setq show-paren-style 'mixed)
(require 'zenburn-theme) ;; set color-theme (in elfiles)
(powerline-evil-center-color-theme)

;; default values 
(setq-default fill-column 79) ; number of characters until the fill
(setq-default indent-tabs-mode nil) ; use spaces, not tabs
(setq comment-style 'indent)
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "english")
(setq-default ispell-list-command "list")
(setq python-shell-interpreter "ipython")
(setq org-log-done t) ;; show time in org-log
(defalias 'yes-or-no-p 'y-or-n-p) ;; Simplify typing
(winner-mode 1) ; winner-mode provides C-left: get back to previous window

;; latex
(require 'my-auctex)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;; hotkeys for emacs builtin
(global-set-key (kbd "C-q")     'backward-kill-word)
(global-set-key (kbd "C-w")     'delete-backward-char)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key [f1]            'eshell)
(global-set-key (kbd "C-c a")   'org-agenda)
(global-set-key (kbd "C-c f")   'windmove-right)
(global-set-key (kbd "C-c b")   'windmove-left)
(global-set-key (kbd "C-c p")   'windmove-up)
(global-set-key (kbd "C-c n")   'windmove-down)
(global-set-key (kbd "M-/")     'hippie-expand)
(global-set-key (kbd "M-o")     'other-window)
(global-set-key (kbd "C-s")     'isearch-forward-regexp)
(global-set-key (kbd "C-r")     'isearch-backward-regexp)

;; hotkeys for custom function
(require 'my-functions) ;; functions stored in elfiles/my-functions.el
(global-set-key (kbd "C-v")     'scroll-up-half)
(global-set-key (kbd "M-v")     'scroll-down-half)
(global-set-key [f6]            'revert-this-buffer)

;; keys for package dependent functions
(global-set-key (kbd "C-c g")   'goto-last-change)
(global-set-key (kbd "C-c [")   'er/expand-region)
(global-set-key [f10]           'magit-status)

;; window system special
(if window-system (tool-bar-mode 0))
(if window-system (scroll-bar-mode 0))
(when window-system (global-set-key (kbd "C-x C-c") 'ask-before-closing))
(when window-system (global-set-key (kbd "C-=")     'text-scale-increase))
(when window-system (global-set-key (kbd "C--")     'text-scale-decrease))

;; helm setup
(require 'helm-config)
(require 'helm)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i")   'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")   'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-x")        'helm-M-x)
(global-set-key (kbd "M-y")        'helm-show-kill-ring)
(global-set-key (kbd "C-x b")      'helm-mini)
(global-set-key (kbd "C-x C-f")    'helm-find-files)
(global-set-key (kbd "C-c h")      'helm-command-prefix)

(setq helm-buffers-fuzzy-matching           t ;
      helm-recentf-fuzzy-match              t ;
      helm-M-x-fuzzy-match                  t ;
      helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

