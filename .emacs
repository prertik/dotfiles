;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; My .emacs file
; by Phil Hagelberg
;
; Much thanks to emacswiki.org and RMS.
;
; Last Modified 13 May 2005
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     loading modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; tabbar.el if in X
(when window-system
  (load "~/.emacs.d/tabbar.el")
  (tabbar-mode))


; PHP mode
(load "~/.emacs.d/php-mode.el")
(autoload 'php-mode "php-mode" "Mode for editing PHP files")
; .inc files load PHP-mode
 (add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

; .js (javascript) loads C mode (until I find something better)
 (add-to-list 'auto-mode-alist '("\\.js$" . c-mode))

; .rhtml loads ruby
 (add-to-list 'auto-mode-alist '("\\.rhtml$" . ruby-mode))

; CSS-mode
(load "~/.emacs.d/css-mode.el")
(autoload 'css-mode "css-mode")
 (setq auto-mode-alist       
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; help (so C-h is delete)
   (global-set-key "\C-x\C-h" 'help-command)
; delete
   (global-set-key "\C-h" 'backward-delete-char)
; go to line
   (global-set-key "\M-g" 'goto-line)
; C-x C-m is compile
  (global-set-key "\C-x\C-m" 'compile)
; tabbar switching
  (global-set-key [(control shift up)] 'tabbar-backward-group)
  (global-set-key [(control shift down)] 'tabbar-forward-group)
  (global-set-key [(control shift left)] 'tabbar-backward)
  (global-set-key [(control shift right)] 'tabbar-forward)
; console-friendly way
(global-set-key (kbd "C-:") 'tabbar-backward)
(global-set-key [(control shift q)] 'tabbar-forward)
(global-set-key (kbd "C-\"") 'tabbar-backward-group)
(global-set-key [(control shift a)] 'tabbar-forward-group)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     registers
; to load, C-x r j <register-name>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; remote .emacs
(set-register ?. '(file . "/phil@philisha.net:.emacs"))

; local .emacs
(set-register ?l '(file . "~/.emacs"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     misc things
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; quit yer yappin'
  (setq sgml-warn-about-undefined-entities nil)
; load .gz's automatically
  (auto-compression-mode 1)
; display images inline
  (auto-image-file-mode 1)
; syntax highlighting by default
  (global-font-lock-mode)

  (setq inhibit-startup-message t)
  (setq transient-mark-mode t)
  (setq show-paren-mode t)
; duh! this should be default.
  (mouse-wheel-mode 1)

; hide toolbar/menubar by default
(tool-bar-mode -1)
(menu-bar-mode -1)

; move the mouse when typing approaches it.
(mouse-avoidance-mode 'exile)

; use a real clipboard!
(setq x-select-enable-clipboard t)

; window title
(setq frame-title-format '(buffer-file-name "%f" ("%b")))

; don't clutter directories!
'(backup-directory-alist (quote (("." . "~/.emacs.baks"))))

; all buffer tabs on main or misc groups
(defun tabbar-buffer-groups (buffer)
  "Return the list of group names BUFFER belongs to.
Return only one group for each buffer."
  (with-current-buffer (get-buffer buffer)
    (cond
     ((or (get-buffer-process (current-buffer))
          (memq major-mode
                '(comint-mode compilation-mode)))
      '("Misc")
      )
     ((member (buffer-name)
              '("*scratch*"))
      '("Misc")
      )
     ((member (buffer-name)
              '("*Completions*"))
      '("Misc")
      )
     ((member (buffer-name)
              '("*tramp output*"))
      '("Misc")
      )
     ((member (buffer-name)
              '("*Messages*"))
      '("Misc")
      )
     ((eq major-mode 'dired-mode)
      '("Dired")
      )
     ((memq major-mode
            '(help-mode apropos-mode Info-mode Man-mode))
      '("Misc")
      )
     ((memq major-mode
            '(tex-mode latex-mode text-mode xml-mode php-mode ruby-mode term))
      '("Main")
      )
     (t
      '("Main")
      )
     )))

; cursor at the beginning of searches instead of the end!
    (add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)
    (defun my-goto-match-beginning ()
      (when isearch-forward (goto-char isearch-other-end)))

; compile works w/o a Makefile!
 (require 'compile)
 (add-hook 'c-mode-hook
   (lambda ()
     (unless (file-exists-p "Makefile")
       (set (make-local-variable 'compile-command)
	    (let ((file (file-name-nondirectory buffer-file-name)))
	      (concat "gcc -O2 -Wall -o " (file-name-sans-extension file)
		      " " file))))))


(defun symposium ()
  "Open the files needed for editing the Symposium via tramp"
  (interactive)
  (when t
    (find-file "/phil@philisha.net:/var/www/symposium/app/todo")
    (find-file "/phil@philisha.net:/var/www/symposium/app/")
    (find-file "/phil@philisha.net:/var/www/symposium/app/controllers")
    (find-file "/phil@philisha.net:/var/www/symposium/app/models")
    (find-file "/phil@philisha.net:/var/www/symposium/app/views")
    (find-file "/phil@philisha.net:/var/www/symposium/app/views/layouts/application.rhtml")
  )
)

(defun academy ()
  "Open a connection to theacademysite.org via tramp"
  (interactive)
  (when t
    (find-file "/academyadmin@theacademysite.org:theacademysite.org")
    (find-file "/academyadmin@theacademysite.org:theacademysite.org/ta")
    (find-file "/academyadmin@theacademysite.org:phil.timecard")
    (find-file "/academyadmin@theacademysite.org:theacademysite.org/project.schedule")
    )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    Nifty things to remember and hopefully use
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; M-z zap to char
; C-u C-SPC jump to previous edit
; M-/ autocomplete word 
; M-! insert output of shell command
; M-| replace region with shell output
; M-x thumbs

; Macros
; C-m C-r to begin
; name it, and do stuff
; C-s to save

; temp macros
; C-m C-m to start recording
; C-m C-s to stop
; C-m C-p to play

