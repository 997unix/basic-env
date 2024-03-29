; .emacs


;; (> emacs-major-version 19)
;; (>= emacs-minor-version 14))

;; start a server for emacsclient to use.
(server-mode 1)

; commenting out for new home ubuntu vm
;; add all the emacs libs to this session - nothing works without it. 
;(progn (cd "/usr/local/share/emacs/23.2")
;       (normal-top-level-add-subdirs-to-load-path))

;; add all the emacs libs to this session - nothing works without it. 
;; (progn (cd "/usr/local/share/emacs/site-lisp")
;;        (normal-top-level-add-subdirs-to-load-path))


;; this does
;; works in emacs Sun Feb 28 10:45:47 2010
(global-unset-key [f1] )
(define-key global-map [f1] 'repeat-complex-command)

;;Mon Oct 22 09:14:16 2001
;; bind control-z to the very useful "undo" not minimize!
;; tony
;; todo - fix this bindiing 
(global-unset-key [C-z])
;; gold --  unsets "c-x backspace" which has caused me a lot of grief 
(global-unset-key "\C-x")
(global-set-key "\C-x" 'backward-delete-char-untabify)

;; gold - use ctrl-meta . and comma to goto beg and end of buffer
(global-unset-key [C-M-.])
(global-unset-key [C-M-,])
(global-set-key [C-M-.] 'end-of-buffer)
(global-set-key [C-M-,] 'beg-of-buffer)
(global-unset-key [C-next])
(global-set-key [C-next] 'end-of-buffer)
(global-set-key [ ] 'beg-of-buffer)
;; add all the emacs libs to this session - nothing works without it. 
(progn (cd "~/.emacs.d")
       (normal-top-level-add-subdirs-to-load-path))


(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-thansmann)
     ;; (color-theme-thansmann2)
     ;; (color-theme-zenburn) ;; sets gutter to black
 (color-theme-lawrence) ;; under lines key words, nice for learning a lang, has a 'notch' on the linun line that seems to indicate where classes and do/end start/stop

))


;; nice trick from http://emacswiki.org/emacs/ColorTheme
(setq my-color-themes (list
                       'color-theme-thansmann
                       'color-theme-thansmann2
                       'color-theme-zenburn 
                       'color-theme-simple-1 
                       'color-theme-billw  
                       'color-theme-taylor 
                       'color-theme-classic 
                       'color-theme-midnight 
                       'color-theme-hober 
                       'color-theme-oswald 
                       'color-theme-dark-laptop 
                       'color-theme-taming-mr-arneson 
                       'color-theme-jonadabian-slate  
                       'color-theme-ld-dark 
                       'color-theme-comidia  
                       'color-theme-arjen 
                       'color-theme-aliceblue 
                       'color-theme-clarity 
                       'color-theme-charcoal-black 
                       'color-theme-calm-forest 
                       'color-theme-lawrence 
                       'color-theme-matrix
                       'color-theme-railscasts
                       ))


(defun my-theme-set-default () ; Set the first row
      (interactive)
      (setq theme-current my-color-themes)
      (funcall (car theme-current)))
     
    (defun my-describe-theme () ; Show the current theme
      (interactive)
      (message "%s" (car theme-current)))
     
   ; Set the next theme (fixed by Chris Webber - tanks)
    (defun my-theme-cycle ()		
      (interactive)
      (setq theme-current (cdr theme-current))
      (if (null theme-current)
      (setq theme-current my-color-themes))
      (funcall (car theme-current))
      (message "%S" (car theme-current)))
    
    (setq theme-current my-color-themes)
    (setq color-theme-is-global nil) ; Initialization
    (my-theme-set-default)
    (global-set-key [f7] 'my-theme-cycle)
;; END color theme messing around 


;; set for the mac Wed May 30 12:09:44 2012
(set-face-attribute 'default nil :font "Monospace-11")
(set-default-font "Monospace-11")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(column-number-mode 4)
 '(cperl-close-paren-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-indent-level 4)
 '(cperl-indent-parens-as-block t)
 '(cperl-tab-always-indent t)
 '(current-language-environment "ASCII")
 '(debug-on-error t)
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(initial-buffer-choice "~/diary")
 '(line-number-mode 4)
 '(save-place t nil (saveplace))
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))


;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline t)
;; ensure we do this *after* default.el is loaded!
;; throws a lisp error - might be useful sometime tho -T Wed Mar  3 13:32:22 2010
;; (add-hook after-init-hook
;;           (lambda ()
;;             ;; (setq require-final-newline t)
;;             (global-unset-key "")
;;             (global-unset-key "")
;;             (define-key global-map "" 'undo)
;;             (define-key global-map "" 'undo)
            
;;             )
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tony .emacs stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Options Menu Settings
;; =====================
;; (whitespace-toggle-trailing-check)
(setq kill-ring-max 150)

(set-variable (quote bell-volume) 0)
(setq-default case-replace t)
(setq-default teach-extended-commands-p t)
(setq-default teach-extended-commands-timeout 7)
(setq-default debug-on-error nil) ;; moved this to true while debugging feb 2010
(setq-default debug-on-quit nil)
(setq-default get-frame-for-buffer-default-instance-limit nil)
;; breaks things -T Sun Feb 28 16:39:56 2010
;;  (setq-default temp-buffer-show-function 'show-temp-buffer-in-current-frame)
(require 'font-lock)
(setq-default font-lock-auto-fontify t)
(setq-default font-lock-use-fonts '(or (mono) (grayscale)))
(setq-default font-lock-use-colors '(color))
(setq-default font-lock-maximum-decoration t)
(setq-default font-lock-maximum-size 256000)
(setq-default font-lock-mode-enable-list t)
(setq-default font-lock-mode-disable-list nil)
;; (add-hook 'font-lock-mode-hook 'turn-on-fast-lock)
(remove-hook 'font-lock-mode-hook 'turn-on-lazy-lock)

(require 'paren)
;; db session 
;;  (paren-set-mode 'sexp)
(message "after paren mode")
(setq-default buffers-menu-sort-function 'sort-buffers-menu-alphabetically)
(setq-default buffers-menu-grouping-function nil)
(setq-default buffers-menu-submenus-for-groups-p nil)

;; fucntion for getting to the end of a line into the kill 
;; ring. 
(defun copy-line-as-kill (arg)
  "does a kill-line, then puts it back. this is for the side
effect of getting the line in kill ring."
  (interactive "*p")
  (kill-line arg)
  (yank)
  (exchange-point-and-mark )
  )			

;; fucntion for getting the files i like most
;; and it even works
;; works in emacs feb 2010
(defun tony-fav-files (arg)
  "load a list of the files i am always using."
  (interactive "*p")
  ;; (find-file "~/oratony")
  ;; (find-file "~/irritant")
  ;; (find-file "~/running.proj")
  (find-file "~/diary")
)

;; fucntion for getting the files i like most
;; and it even works
(defun rcs-head (arg)
  "insert file rcshead at point from the ~/vault dir into document"
  (interactive "*p")
  (insert-file-contents "~/vault/rcshead")
)
(message "after some of my defun's rcs-head")


(defun tony-perl-expect-pair (arg)
  "insert file perl-expect-pair at point from the ~/vault dir into document"
  (interactive "*p")
  (insert-file-contents "~/vault/perl-expect-pair.txt")
  	(goto-char (search-forward-regexp "FOO")
		   ) ;; end goto-char
	(delete-char -3)
)

(defun tony-perl-expect-prompt (arg)
  "insert file perl-expect-pair at point from the ~/vault dir into document"
  (interactive "*p")
  (insert-file-contents "~/vault/perl-expect-prompt.txt")
  	(goto-char (search-forward-regexp "BAR")
		   ) ;; end goto-char
	(delete-char -3)
)


;; (defun tony-work-files (arg)
;;   "load a list of the files i am always using."
;;   (interactive "*p")
;; (find-file "/u/tony/develop/web_ads_interface/bin/src/adsform/adsform_enhance.h")
;; (find-file "/u/tony/develop/web_ads_interface/bin/src/adsform/read_user_defined.c")
;; (find-file "/u/tony/develop/web_ads_interface/bin/src/adsform/Makefile")
;; ) ;; end tony-work-files


;; (defun tony-did-today (arg)
;;   "insert file did-today at point from the ~/vault dir into document"
;;   (interactive "*p")
;;   (insert-file-contents "~/vault/did-today")
;; )

;; ;; works in emacs feb 2010
;; (global-set-key [M-f2] 'tony-did-today)

(global-set-key [f4] 'tony-fav-files)



;; get a a MS style highlight thing
;;
(defun highlight-ms-eol (arg)
  "goto the end of line, whilst defining a region, MS behavior"
  (interactive "*p")
  (set-mark-command nil) 
  (end-of-line)  
					;  (exchange-point-and-mark)
  )

(defun highlight-ms-bol (arg)
  "goto the end of line, whilst defining a region, MS behavior"
  (interactive "*p")
  (set-mark-command nil) 
  (beginning-of-line)  
  )


;;(define-key global-map '(control-x end)  'highlight-ms-eol)
;;       (global-set-key 'Sh-end 'highlight-ms-eol)

	;(global-set-key (quote [#<keypress-event control-X> #<keypress-event end>]) (quote highlight-ms-eol))


	;;(global-set-key 'Sh-home 'highligh-ms-bol)

(message "before sub_head")

;; commenting out for debug emacs 24.1 startu
;; ;; put in my header stuff
;; ;; doesn't work on emacs Sun Feb 28 10:43:16 2010
;; (fset 'sub_head
;;       [ (control \3) (control \0) \# return (control \1) (control \0) \# return \# space (control f2) return \# return ])

;; (fset 'end-sub
;;       [ (control \1) (control \5) \# E N D  S U B (control \1) (control \5) \# return  ])


;; These work - Sun Feb 28 10:44:36 2010 
(global-set-key [f12] 'sub_head)
(define-key global-map [S-f12] 'end-sub)


;; ;; cool thing that works
;; (fset 'perl-html-table-start "print \"<TABLE>\\n\"; # start an HTML TABLE")
;; (global-set-key [f7] 'perl-html-table-start)

(setq shell-multiple-shells t)
(message "after sub_head")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; subject stuff
; Wed Jan  7 15:11:27 1998 
;; works in emacs Sun Feb 28 10:40:30 2010
(defun put-date (arg)
  "inserts the 'date' shell command output
   into the current buffer." 
  (interactive "*p")
  (insert (current-time-string)) ;; add utc here too
  (insert " // ")
  (insert   (format-time-string "%F %T %Z" (current-time)))
  (insert " // ")
  (insert   (format-time-string "%F %T %Z" (current-time)  'universal))
  ;;(insert (current-time-string))
  )


;; define f2 key to do the deed. -tony Wed May  7 10:20:51 MST 1997
;; works emacs Sun Feb 28 10:41:54 2010
(define-key global-map [f2] 'subject-break)


(define-key global-map [C-f2] 'put-date)
;;;;;;;;;;;;;;;;;;;;; end subject stuff

;; good to here Sun Feb 28 10:45:12 2010 





;; http://xahlee.org/emacs/keyboard_shortcuts.html
(global-set-key (kbd "C-z") 'undo) ;; works!
(global-set-key (kbd "C-x C-z") 'undo) ;; works! 
;; these dont work ;; (define-key global-map  [C-z] 'undo)
;; these dont work ;;  (define-key global-map  [C-x-C-z] 'undo)

;; looks like when i switched to 20.4 the binding for cntl-q changed, 
;; i really need this.....
;; works in emacs Sun Feb 28 10:47:34 2010
(define-key global-map [C-q] 'quoted-insert)

;; couple of function I wrote for this -T Wed Mar  3 16:49:08 2010
(define-key global-map [(shift end)]  'highlight-ms-eol)
(define-key global-map [(shift home)]  'highlight-ms-bol)
(global-set-key (kbd "C-;") 'goto-line) ;; works -t Thu Mar  4 15:40:59 2010
(global-set-key (kbd "C-:") 'goto-line) ;; works -t Thu Mar  4 15:40:59 2010
(global-set-key (kbd "ESC ;") 'goto-line)
(global-set-key (kbd "ESC :") 'goto-line)
;; weird thing i had to do make ubuntu work thru vnc
;;  maps alt-x to the meta-x command Tue Apr 10 11:56:21 2012
;; (global-set-key (kbd "A-x") 'execute-extended-command)
(setq x-alt-keysym 'meta)


;; loads- but doesn't really work Sun Feb 28 11:15:35 2010
(defun string-trim (arg)
  "trim the leading and trailing space from as many lines as you want"
  (interactive "*p")
  (query-replace-regexp " *$" "" nil)
  (query-replace-regexp "^ *" "" nil)
  
  )


;; bind it up to control end 
;; don't think i use this anymote Sun Feb 28 11:17:50 2010
(define-key global-map '[(control delete)]  'copy-line-as-kill)
(define-key global-map '[(control insert)]  'yank)

;; Make ^c-/ do query-replace-regexp 
;; works great in emacs Sun Feb 28 11:18:33 2010
(define-key global-map '[(control /)]  'query-replace-regexp)


(global-set-key [f11] 'rcs-head)
;; (global-set-key '[(control f11)] 'rcs-fix)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this sets my pref for cperl-mode over the perl mode
;; also sets the font-locks for it as well as the
;; cool hairy mode
(setq cperl-hairy t)


(load-library "cperl-mode")
(load-library "highlight-parentheses")
(add-hook 'cperl-mode-hook 'highlight-parentheses-mode)
(add-hook 'fundamental-mode-hook 'highlight-parentheses-mode)
;;  (add-hook 'cperl-mode-hook 'font-lock-mode)

;;(add-hook 'cperl-mode-hook 'set-hairy)
;; (setq font-lock-maximum-decoration t)
;; (add-hook 'cperl-mode-hook 'font-lock-maximum-decoration t)
;;
;;



;; in  emacs 24.1 things with a square brace seem to break
;; ;; from the cperl mode code, a recommendation:
;; (setq auto-mode-alist
;;       (append '(("\\.\\([pP][Llm]\\|al\\)$" . perl-mode))  auto-mode-alist ))

;; (setq interpreter-mode-alist (append interpreter-mode-alist
;; 				     '(("miniperl" . perl-mode))))


;(setq options-save-faces t)
;;(display-time)
;;(column-number-mode)
;; (setq line-number-mode t)
;; (setq column-number-mode t)
(setq 
 line-number-mode 4
 column-number-mode 4 
 display-column-mode 4
 ;;      display-time-day-and-date t
 ;; display-time t                      
 options-save-faces t
 )

(setq vc-mistrust-permissions t)

(require 'vc)

;; both work in emacs Sun Feb 28 12:49:25 2010
;; Make F5 be `rectangle-kill'
(global-set-key [f5] 'kill-rectangle)
;; Make F6 be `rectangle-yank' 
(global-set-key [f6] 'yank-rectangle)

;; adding the comment region stuff finially
(global-set-key '[C-f12] 'tony-perl-insert-sub)
(global-set-key [C-x-C-r] (quote eval-print-last-sexp))

;; f10 doesn't work on my thinkpad -t Sun Feb 28 11:42:14 2010
(global-set-key [f8] 'indent-region)
(global-set-key [f9] 'comment-region)
(global-set-key [f10] 'ruby-hash-var-region)


(global-set-key [C-tab] 'fixup-whitespace)
;; Make `C-x C-m' and `C-x RET' be different (since I tend to type
;; the latter by accident sometimes.)
;; db session 
;; (define-key global-map [C-l return] nil)



;;; ********************
;;; Load ange-ftp, which uses the FTP protocol as a pseudo-filesystem.
;;; When this is loaded, the pathname syntax /user@host:/remote/path
;;; refers to files accessible through ftp.
;;;
(require 'dired)


;; ok to here Sun Feb 28 12:50:37 2010(global-set-key '(control tab) 'fixup-whitespace)
;;; ********************
;;; Load the auto-save.el package, which lets you put all of your autosave
;;; files in one place, instead of scattering them around the file system.
;;;

;; db session 
;;(require 'auto-save)
;;(setq auto-save-directory (expand-file-name "~/autosaves/"))
;;(setq auto-save-interval 900)
;;(setq auto-save-hash-p nil)

(global-set-key [button3] 'popup-buffer-menu)

(setq next-screen-context-lines 3)
(global-set-key [button4] 'scroll-down-command)
(global-set-key [button5] 'scroll-up-command)

(define-key global-map [S-button4] 'scroll-down-one)
(define-key global-map [S-button5] 'scroll-up-one)


(global-unset-key '[(control $)])
(define-key global-map '[(control $)] 'shell-var-last-word)





;;; I invoke this from my .emacs file with the following incantation
(setq c-auto-newline t)
(add-hook 'c-mode-hook 'elec-c-mode)
(add-hook 'cc-mode-hook 'elec-c-mode)
(add-hook 'elec-c-mode-hook 'turn-on-auto-fill)
(autoload 'elec-c-mode "elec-c" "High powered C editing mode." t)


(setq explicit-sh-args '("--login" ))


;;; Mon Feb 22 11:54:59 1999 works Need these two setting together to get the
;;; buffer menus that i want which grouped within modes, then alpha with line
;;; breaks between the mode catagories. -anh
(setq buffers-menu-sort-function 'sort-buffers-menu-by-mode-then-alphabetically)
;;; 
(setq buffers-menu-grouping-function 'group-buffers-menu-by-mode-then-alphabetically)


;; i wrote this one
;; Thu Sep  2 11:24:21 1999 
;;(load-library "make-macroify")


(defun make-macroify ()
  "place $( and ) around the string preceeding the point"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
    (widen)
    (setq started_here (point))
    
    (while (char= (string-to-char(regexp-quote " ")) 
              (char-before (point)
                 ) ;; end char-before
        ) ;; end char=
      (goto-char (- (point) 1))
      ) ;; end while

    (insert ")")
    (goto-char (search-backward-regexp 
            (concat (regexp-quote " ") "\\|^") nil t)
           ) ;; end goto-char

    (while (char= (string-to-char(regexp-quote " ")) 
              (char-after (point)
                 ) ;; end char-before
        ) ;; end char=

      (goto-char (+ (point) 1))
      ) ;; end while

      (insert "$(")
      (goto-char (+ 4 started_here))
      ) ;; end save-match-data
    );; end save-restriction
      ) ;; end save-excursion
  (forward-char 1) ;; added Wed Jul 19 10:47:44 2000 does exactly what i want
  ;; places the cursor 
    (nil)
    )



;; Fri Oct  8 16:51:12 1999
(setq mouse-yank-at-point t)
;;
(setq-default ispell-program-name "aspell")


                                        ; for makefiles only, map this key
                                        ; Thu Sep  2 11:25:25 1999
(add-hook 'makefile-mode-hook '(lambda ()
                                 (define-key makefile-mode-map [(control x) (control m) ] 'make-macroify)))

                                        ; for perl mode only, map this key
                                        ; Thu Sep  2 11:25:25 1999
(add-hook 'cperl-mode-hook '(lambda ()
                              (define-key cperl-mode-map [(control x) (control e) ] 'tony-perl-expect-pair)))

(add-hook 'cperl-mode-hook '(lambda ()
                              (define-key cperl-mode-map [(control x) (control r) ] 'tony-perl-expect-prompt)))
;;; ********************
;;; Load a partial-completion mechanism, which makes minibuffer completion
;;; search multiple words instead of just prefixes; for example, the command
;;; `M-x byte-compile-and-load-file RET' can be abbreviated as `M-x b-c-a RET'
;;; because there are no other commands whose first three words begin with
;;; the letters `b', `c', and `a' respectively.
;;;
;; db session
;;(load-library "completer")

;;("mwheel" ("/usr/local/lib/xemacs-21.4.6/lisp/auto-autoloads.elc" . 69304) t nil)
(load-library "mwheel")
(load-library "uniquify")

;; this setq really fouls the editor.... Wed Mar 24 13:11:29 1999 tony
;; and i found this out again feb 2010
;;(setq uniquify-buffer-name-style "post-forward-angle-brackets")
;; (setq uniquify-buffer-name-style t)
;; (setq uniquify-min-dir-content t)
;; (setq case-fold-search t)
;; debug session
;; (require 'pending-del)


;; (custom-set-variables
;; '(c-electric-pound-behavior (quote (alignleft))))

;;(custom-set-faces)
(setq options-save-faces t)

;;;aspell is a replacement for ispell
                                        ;(setq-default ispell-program-name "aspell")
                                        ;(setq-default ispell-extra-args '("-reverse"))

;; debug session
;; (setq auto-mode-alist (append auto-mode-alist
;;                            (list '("\\.sql$" . sql-mode))))


;; end of the file Tony Hansmann (tony@Preceptconsulting.net) Mon May
;; 24 10:24:41 2004
;; works in emacs Sun Feb 28 12:44:27 2010
(defun unreturn-to-space-eof (arg)
  (interactive "*p")
  "replace returns with space to the end of the file"
  (replace-regexp "\n" " " nil)

  )

;; fucntion for replacing return char with a tab char through the end
;; of the file Tony Hansmann (tony@Preceptconsulting.net) Mon May 24
;; 10:24:41 2004
;; works in emacs Sun Feb 28 12:44:27 2010
(defun unreturn-to-tab-eof (arg)
  (interactive "*p")
  "replace returns with tabs  to the end of the file. Useful for pasting to spreadsheets "
  (replace-regexp "\n" "\t" nil)
  )


;; fucntion for replacing multiple spaces with one through the end of
;; the file Tony Hansmann (tony@Preceptconsulting.net) Thu Aug 23
;; 17:56:39 2007
;; doesn't work
(defun multi-spaces-or-newline-to-space-eof (arg)
  (interactive "*p")
  "replace multiple spaces with one space"
  (replace-regexp " +\\|\n" " " nil)
  )


;; bind the function to ctrl-f5
(define-key global-map [C-f5] 'nl2space)
;; bind the function to ctrl-f6
(define-key global-map [C-f6] 'unreturn-to-tab-eof)

(global-set-key [f3] 'multi-spaces-or-newline-to-space-eof)


(defun tony-perl-insert-sub (arg)
  "insert file perl sub definition into script"
  (interactive "*p")
  (insert-file-contents "~/vault/perl_sub")
  (goto-char (search-forward " ")
	     ) ;; end goto-char
  )

;############################################################################
;#   Emacs config (Recommended) from Appendix C of "Perl Best Practices"    #
;#     Copyright (c) O'Reilly & Associates, 2005. All Rights Reserved.      #
;#  See: http://www.oreilly.com/pub/a/oreilly/ask_tim/2001/codepolicy.html  #
;############################################################################

;; Use cperl mode instead of the default perl mode
(defalias 'perl-mode 'cperl-mode)

;; turn autoindenting on
(global-set-key "\r" 'newline-and-indent)

;; Use 4 space indents via cperl mode


;; Insert spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Set line width to 78 columns...
(setq fill-column 78)
(setq auto-fill-mode t)

;; Use % to match various kinds of brackets...
;; See: http://www.lifl.fr/~hodique/uploads/Perso/patches.el
;; (global-set-key "%" 'match-paren)
;; (defun match-paren (arg)
;;   "Go to the matching paren if on a paren; otherwise insert %."
;;   (interactive "p")
;;   (let ((prev-char (char-to-string (preceding-char)))
;;         (next-char (char-to-string (following-char))))
;;     (cond ((string-match "[[{(<]" next-char) (forward-sexp 1))
;;           ((string-match "[\]})>]" prev-char) (backward-sexp 1))
;;           (t (self-insert-command (or arg 1))))))

;; Load an applicationtemplate in a new unattached buffer...
(defun application-template-pm ()
  "Inserts the standard Perl application template"  ; For help and info.
  (interactive "*")                                 ; Make this user accessible.
  (switch-to-buffer "application-template-pm")
  (insert-file "~/.code_templates/perl_application.pl"))
;; Set to a specific key combination...
(global-set-key "\C-ca" 'application-template-pm)

;; Load a module template in a new unattached buffer...
(defun module-template-pm ()
  "Inserts the standard Perl module template"       ; For help and info.
  (interactive "*")                                 ; Make this user accessible.
  (switch-to-buffer "module-template-pm")
  (insert-file "~/.code_templates/perl_module.pl"))
;; Set to a specific key combination...
(global-set-key "\C-cm" 'module-template-pm)

;; Expand the following abbreviations while typing in text files...
(abbrev-mode 1)


;; change these to ruby
(define-abbrev-table 'global-abbrev-table '(
                                            ("pdbg"   "use Data::Dumper qw( Dumper );\nwarn Dumper[];"   nil 1)
                                            ("phbp"   "#!/usr/bin/perl -w"                              nil 1)
                                            ("pbmk"   "use Benchmark qw( cmpthese );\ncmpthese -10, {};" nil 1)
                                            ("pusc"   "use Smart::Comments;\n\n### "                     nil 1)
                                            ("putm"   "use Test::More 'no_plan';"                        nil 1)
                                            ("rbsh"   "#!/usr/bin/env ruby"                        nil 1)
                                            ("rbdef"   "
# Public|Private: zz
#
# args description: yy - some arg
#                   rr - other arg
#
# Examples
#
#   zz(yy, rr)
#   # => <return example>
#
# Returns the duplicated String.
def zz(yy, rr)
  yy * rr
end # end def zz

"                        nil 1)
                                            ("rbcase" "
case
when xx == 'aa'
  puts 'jj!'
when /\s?(\w*)/.match(zz)
  puts \"zz is %s\" % zz
else
  ff.mm
end
" nil 1)
                                            ("rbhash" "hash = { one: 1,\ntwo: 2,\nthree: 3\n}" nil 1 )
                                            ("rbARGV" "ARGV.each do |xx|\n  xx.split()\nend # end ARGV" nil 1)
                                            ("rbARGF" "ARGF.each do |xx|\n  xx.split()\nend # end ARGF" nil 1)
                                            )) ;; end snippet lines



(add-hook 'fundamental-mode-hook 'show-paren-mode )
;; (add-hook 'fundamental-mode-hook 'highlight-parentheses-mode)
(add-hook 'text-mode-hook (lambda () (abbrev-mode 1)))
;; works -T Thu Jul 21 16:08:27 2011


(add-hook 'ruby-mode-hook (lambda () 
			    (linum-mode 1)
			    (define-key ruby-mode-map '[(control \#)] 'ruby-hash-var-last-word)
)) ;; Thu Apr 26 08:23:33 2012

(add-hook 'cperl-mode-hook (lambda () (linum-mode 1)))
(add-hook 'Python-mode-hook (lambda () (linum-mode 1)))

(add-hook 'sh-mode-hook (lambda ()
                          (linum-mode 1)
                          )
          )

;; does not work - figure it out - t Sun Feb 28 12:56:43 2010
;; need to figure out how to quote the ';' to make this work. -t 
;; (global-set-key [C-;] 'goto-line) ; [Ctrl]-[L] 



;; Mon Mar  1 22:58:25 2010 turn off the button bar
(tool-bar-mode 0)
;; move the scroll bar to the right side
(set-scroll-bar-mode 'right)

;; Tue Mar  2 00:03:59 2010
(set-mouse-color "white") 
(set-cursor-color "white")
(blink-cursor-mode nil)



;; Tue Mar  2 00:55:27 2010
;; emacs - make shift-insert, disable overwrite, make insert
(global-unset-key [insert])
(global-set-key [insert] 'yank)

;; Tue Mar  2 14:49:52 2010
(global-unset-key [delete])
(global-set-key [delete] 'delete-char)


;; comment a region with a C-mouse click
;;; commenting out -t Thu May 13 13:41:39 2010
                                        ; (global-unset-key [C-down-mouse-1])
                                        ; (global-set-key [C-down-mouse-1] 'comment-region)
;; bind x pop-up buffer menu to 3rd button
(global-set-key [C-down-mouse-3] 'mouse-buffer-menu)
(global-set-key [down-mouse-3] 'mouse-buffer-menu)

(global-set-key [M-tab] 'buffer-menu)

;; @#---------
;; Tue Mar  2 15:26:38 2010

;; @#---------
;; Sun Feb 28 17:14:16 2010

(defun subject-break (arg)
  "insert a unique string and the date as a subject break"
  (setq subject-delimiter "@#---------\n")
  (interactive "*p")
  (move-beginning-of-line nil)
  (insert subject-delimiter)
  ;;(put-date)
  ;; (insert (current-time-string)) ;; add utc here too
  ;; (insert " // ")
  (insert   (format-time-string "%F %T %Z %a" (current-time)))
  (insert " // ")
  (insert   (format-time-string "%F %T %Z" (current-time)  'universal))
  )


;; tie in with temp file system - 
(define-key global-map [C-f3] 'tony-next-temp-file)
(define-key global-map [C-f4] 'tony-current-temp-file)


;; having some issue Tue Aug 17 13:49:39 2010
(defun tony-next-temp-file (arg)
  "Get a new temp file from perl script next_file_named and open it for edit"
  (interactive "*p")
  (find-file
   (chomp
    (shell-command-to-string "/home/thansmann/bin/next_file_named -d /home/thansmann/tmp/foo -f foo")
    )
   )
  )


(defun tony-current-temp-file (arg)
  "Get the current temp file from perl script current_file_named and open it for edit"
  (interactive "*p")
  (find-file
   (chomp
    (shell-command-to-string "/home/thansmann/bin/current_file_named -d /home/thansmann/tmp/foo -f foo")
    )
   )
  )

;; fucntion for replacing multiple spaces with one through the end of
;; the file Tony Hansmann (tony@Preceptconsulting.net) Thu Aug 23
;; 17:56:39 2007
;; doesn't work
;; (defun multi-spaces-or-newline-to-space-eof (arg)
;; (interactive "*p")
;;   "replace multiple spaces with one space"
;; (replace-regexp " +\\|\n" " " nil)
;; )


;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
;;   ;; Your init file should contain only one such instance.
;;  '(show-paren-match-face ((((class color)) (:background "turquoise")))))


;; nice func pulled from: http://www.emacswiki.org/emacs/ElispCookbook#toc5
;; Tony Mon Jun 28 12:12:40 2010
(defun chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (let ((s (if (symbolp str) (symbol-name str) str)))
    (replace-regexp-in-string "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" s)))

;; adding in factory emacs lib for git -T Mon May 28 12:09:30 2012
(add-to-list 'load-path "/usr/share/doc/git-core/contrib/emacs")
(require 'git)

;; trouble-shooting this Mon Jul 12 11:48:30 2010

(add-to-list 'load-path  "/usr/local/share/emacs/23.2/lisp/progmodes")

;; totally lame hard-code to make this work - don't know why. -T Mon Jul 12 12:10:09 2010
;;(if (load-library "/usr/local/src/emacs-23.2/lisp/progmodes/python.elc")
;;    (print "Info: Loadinsdfg python.el")
;;  (print "WARN: Can't find plsdjfysjdlfthon.el"))
;; working out a config for s1 - T Mon Jul 12 11:51:04 2010
;; (require 'auto-complete)
;; (require 'yasnippet)


;; yay for super auto complete!
;; http://cx4a.org/software/auto-complete/#Latest_Stable
;; Wed May 30 12:28:35 2012
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(put 'narrow-to-region 'disabled nil)

(defalias 'bash-mode 'shell-script-mode)

(defun replace-region-with-shell-output ()
  "Run pcut and get first space seperated field in region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/pcut -f 1 |/usr/local/bin/squeeze|/usr/local/bin/fstrip" nil t)))


(defun pvwin2pvnfs ()
  "convert a CIFS pv path to NFS pv path."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/home/thansmann/bin/pvwin2pvnfs" nil t)))

(defun perltidy ()
  "Run perltidy on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "perltidy -q -pbp" nil t)))

(defun perltidy-defun ()
  "Run perltidy on the current defun."
  (interactive)
  (save-excursion (mark-defun)
                  (perltidy-region)))


(defun pythontidy ()
  "Run pythontidy on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "~/bin/pythontidy" nil t)))

(defun nl2space ()
  "change newlines to a space in region - useful for making bash for i in loops"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/nl2space|/usr/local/bin/squeeze|/usr/local/bin/fstrip" nil t)))

(defun space2nl ()
  "change spaces to a newline in region - useful for making bash for i in loops"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/space2nl|/usr/local/bin/squeeze|/usr/local/bin/fstrip" nil t)))

(defun space2comma ()
  "change spaces to commas in region - useful for making jsh commandlines"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze|/usr/local/bin/space2comma" nil t)))


(defun nl2comma ()
  "change newlines to commas in region - useful for making jsh commandlines"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze|/usr/local/bin/nl2comma" nil t)))

(defun comma2nl ()
  "change commas to newlines in region"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze|/usr/local/bin/comma2nl" nil t) ))


(defun nl2vbar ()
  "change newlines to vertical bar in region - useful for making egrep commandlines"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze|/usr/local/bin/nl2vbar" nil t)))


(defun gen_treedelete ()
  "convert a block of dirs to the isilon treedelete command."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/home/thansmann/bin/gen_treedelete" nil t)))


(defun pcut_first ()
  "Run pcut and get first space seperated field in region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/pcut -f 1 |/usr/local/bin/squeeze|/usr/local/bin/fstrip" nil t)))


(defun pcut ()
  "Run pcut and get last space seperated field in region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/pcut|/usr/local/bin/squeeze|/usr/local/bin/fstrip" nil t)))


(defun squeeze ()
  "Run squeeze - remove extra spaces and newline from region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze|/usr/local/bin/fstrip" nil t)))

(defun rangify ()
  "Run rangify to convert the current region to range notation."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze|/usr/local/bin/rangify.pl" nil t)))

(defun range ()
  "Run range.pl to expand the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/home/thansmann/bin/range.pl" nil t)))

(defun beautify-bash ()
  "Run beautify_bash on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/beautify_bash.rb -" nil t)))
(defalias 'bashtidy 'beautify-bash)

(defun tweet_template ()
  "Insert status template into buffer"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark)  "/home/thansmann/bin/tweet_template " nil t)))
(defun nl2semi ()
  "nl2semi change nl to semi-colon"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/nl2semi | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))
(defun semi2nl ()
  "semi2nl change semi-colon to nl"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/semi2nl | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))


(defun commanl2comma ()
  "/usr/local/bin/commanl2comma change comma to comman newline"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/commanl2comma | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t))
  )

(defun comma2commanl ()
  "/usr/local/bin/comma2commanl change ',' to ',\n'"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/comma2commanl | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t))
  )
(defun nl2ampersand ()
  "nl2ampersand - newline to apersand for constructing urls"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/nl2ampersand | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))

(defun ampersand2nl ()
  "ampersand2nl change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/ampersand2nl | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))

(defun space2nlbackslash ()
  "space2nlbackslash change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/space2nlbackslash | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))


(defun commify ()
  "commify change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/commify | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))

(defun lstrip ()
  "lstrip change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/lstrip | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))
(defun rstrip ()
  "rstrip change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/rstrip | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))
(defun fstrip ()
  "fstrip change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/fstrip | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))
(defun squeeze ()
  "squeeze change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/squeeze | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))



;; (add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
;; (require 'yasnippet) ;; not yasnippet-bundle
;; (yas/initialize)
;; (yas/load-directory
;;                   "~/.emacs.d/yasnippet-0.6.1c/snippets")


(defun drag-word-left (arg)
  "Make the last word a shell variable (eg 'FOO' -> '${FOO}')"
  (interactive "*p")

  (backward-word)
  (transpose-words 0)

  )


(defun parens-last-word (arg)
  "Make the last word wrapped in parens (eg 'FOO' -> '(FOO)')"
  (interactive "*p")
  (set-mark-command nil)
  (backward-word)
  (insert-char ?( 1)
  (forward-word)
  (insert-char ?) 1)
)

(defun shell-var-last-word (arg)
  "Make the last word a shell variable (eg 'FOO' -> '${FOO}')"
  (interactive "*p")
  (set-mark-command nil)
  (backward-word)
  (insert-char ?$ 1)
  (insert-char ?{ 1)
  (forward-word)
  (insert-char ?} 1)
  (backward-char)
)


;; (defun ruby-hash-var-last-word (arg)
;;   "Make the last word a ruby variable for use in strings (eg 'BAR' -> '#{BAR}')"
;;   (interactive "*p")
;;   (set-mark-command nil)
;;   (backward-word)
;;   ;; (if (string-match-p "_" s)
;;   ;;     (backward-word))
;;   (insert-char ?# 1)
;;   (insert-char ?{ 1)
;;   (forward-word)
;;   (insert-char ?} 1)
;;   (backward-char)
;; )

(defun ruby-hash-var-last-word (arg)
  "Make the last word a ruby variable for use in strings (eg 'FOO_BAR' -> '#{FOO_BAR}')"
  (interactive "*p")
  (set-mark-command nil)
  (backward-word)
  (while
      (string= "_" (string (char-before (point))))
    (backward-word))
  (insert-char ?# 1)
  (insert-char ?{ 1)
  (forward-word)
  
  (while  (string= "_" (string (char-after (point))))
    (forward-word)
    )
  (insert-char ?} 1)
  (backward-char)
  )

(defun ruby-hash-var-region (arg)
  "Make the last word a ruby variable for use in strings (eg 'BAR' -> '#{BAR}')"
  (interactive "*p")
  (save-excursion)
  ;; we are at the end of region, insert close squiggle brace
  (let (our_point point)
    )
  (insert-char ?} 1)
  
  (goto-char (mark)) ;; mark is the beginning of the region
  (insert-char ?# 1)
  (insert-char ?{ 1)
  goto-char (out_point)
  )



(defun ruby-symbol-var-last-word (arg)
  "Make the last word a ruby symbol (eg 'BAZ' -> ':BAZ')"
  (interactive "*p")
  (set-mark-command nil)
  (backward-word)
  (insert-char ?: 1)
  (forward-word)
)


;; initial effort - required more work than i expected - full result below -T Fri Aug  6 10:36:57 2010
;; (global-unset-key (kbd "C-="))
;; (global-set-key (kbd "C-=") 'variable-brace-last-word)
;; ;; (define-key global-map [C-x =] 'variable-brace-last-word)
;; (defun variable-brace-last-word ()
;;   "place $( and ) around the string before the point"
;;   (interactive "*")
;;   (save-excursion
;;     (save-restriction
;;       (save-match-data
;; 	(widen)
;; 	(setq started_here (point))
;;         (backward-word nil)
;; 	(insert "${")
;;         (forward-word nil)
;;         (insert "}")
;;         ) ;; end save-match-data
;;       );; end save-restriction
;;     ) ;; end save-excursion
;;   (move-end-of-line nil) ;; works much better -T Sun Aug  1 18:56:45 2010
;;   )

;; not the right sytax -t Mon Aug  2 13:07:14 2010


;; (defun python-printf-last-word ()
;;   "place %()s around the string before the point"
;;   (interactive "*")
;;   (save-excursion
;;     (save-restriction
;;       (save-match-data
;; 	(widen)
;; 	(setq started_here (point))
;;         (backward-word nil)
;; 	(insert "%(")
;;         (forward-word nil)
;;         (insert ")s")
;; 	  ) ;; end save-match-data
;; 	);; end save-restriction
;;       ) ;; end save-excursion
;;   (move-end-of-line nil) ;; works much better -T Sun Aug  1 18:56:45 2010
;;   )






;; (global-unset-key (kbd "C-="))
;; (global-set-key (kbd "C-=") 'tt)

(defun python-printf-last-word () ;; works iff there is a space after the string to be wrapped -T Tue Aug  3 18:14:09 2010
   "place %()s around the string)s before the point"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
	(widen)
	(setq started_here (point))
        ;; get some boundries around our searching 
        (cond (
               (search-forward-regexp "\n" nil t )
               (backward-char)
               ;;(insert "-1-") ;; correct
               (setq this-eol (point))
              )
              (
               t (setq this-eol started_here)
                 ;;(insert "-1.1-") ;; good
                 )
              );; end cond
        ;; go backward to
        (goto-char started_here)
        (cond  ( (search-backward-regexp "\n" nil t) 
                  (forward-char) ;; step to front of this line
                 ;;(insert "-2-") ;; correct
                 (setq this-bol (point))
                )
              );; end cond
        (goto-char started_here)
        (cond
         (
          (search-backward-regexp " " this-bol t)
          (forward-char) ;; dont need this one
          ;;(insert "-3-") ;; the begin of the word i want to cast.
          )
         (
          t
          (goto-char this-bol)
          ;;(forward-char)
          ;; (insert "-4-")
          )
         );; end cond
        ;; at this point were at a space before a token, or the BOL 
        (setq begin-word (point))

        ;(forward-char)
        ;(insert "-4.1-")


        (cond
         (
               (search-forward-regexp " " (+ this-eol 2) t)
               (backward-char 1)
               )
         (
          t
          (goto-char (+ this-eol 2))
                     ) 
         );; end cond
        (setq end-word (point))
        (insert ")s")
        (goto-char begin-word)
        (insert "%(")        
        ) ;; end save-match-data
	);; end save-restriction
      ) ;; end save-excursion
  (goto-char (+ started_here 4))
  ;;(move-end-of-line nil) ;; works much better -T Sun Aug  1 18:56:45 2010
  ;;(return-from tt (list begin-word end-word))
  )


(defun right-space-boundry ()
"find the right edge of work under or before point"
(interactive "*")
  (cond
   (
    (search-forward-regexp "\\b" nil t )
    (backward-char)
    (insert "-1.1-") ;; correct
    (setq this-eol (point))
    )
   (
    (search-forward-regexp "\n" nil t )
    (backward-char)
    (insert "-1-") ;; correct
    (setq this-eol (point))
    )
   
   (
    t (setq this-eol started_here)
      (insert "-1.2-") ;; good
      )
   );; end cond
(print this-eol)
  ;; go backward to
  )



(defun left-space-boundry ()
"find the right edge of work under or before point"
(interactive "*")
  (cond (
         (search-backward-regexp "\n" nil t )
         (backward-char)
         (insert "-1-") ;; correct
         (setq this-bol (point))
         )
        (
         (search-forward-regexp " " nil t )
         (backward-char)
          (insert "-1.1-") ;; correct
         (setq this-eol (point))
         )
        (
         t (setq this-eol started_here)
            (insert "-1.2-") ;; good
           )
        );; end cond
(print this-eol)
  ;; go backward to
  )



(global-unset-key (kbd "C-="))
(global-set-key (kbd "C-=") 'variable-brace-last-word)
(defun variable-brace-last-word () ;; works iff there is a space after the string to be wrapped -T Tue Aug  3 18:14:09 2010
   "place ${} around the string)s before the point"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
	(widen)
	(setq started_here (point))
        (right-space-boundry)
        ;; get some boundries around our searching 
        ;; (cond (
        ;;        (search-forward-regexp "\n" nil t )
        ;;        (backward-char)
        ;;        ;; (insert "-1-") ;; correct
        ;;        (setq this-eol (point))
        ;;       )
        ;;       (
        ;;        (search-forward-regexp " " nil t )
        ;;        (backward-char)
        ;;        ;; (insert "-1.1-") ;; correct
        ;;        (setq this-eol (point))
        ;;       )
        ;;       (
        ;;        t (setq this-eol started_here)
        ;;          ;; (insert "-1.2-") ;; good
        ;;          )
        ;;       );; end cond
        ;; go backward to
        (goto-char started_here)
        (cond  ( (search-backward-regexp "\n" nil t) 
                  (forward-char) ;; step to front of this line
                 ;;(insert "-2-") ;; correct
                 (setq this-bol (point))
                )
              );; end cond
        (goto-char started_here)
        (cond
         (
          (search-backward-regexp "\\<" this-bol t)
          (forward-char) ;; dont need this one
          ;;(insert "-3-") ;; the begin of the word i want to cast.
          )
         (
          t
          (goto-char this-bol)
          ;;(forward-char)
          ;; (insert "-4-")
          )
         );; end cond
        ;; at this point were at a space before a token, or the BOL 
        (setq begin-word (point))

        ;(forward-char)
        ;(insert "-4.1-")


        (cond
         (
               (search-forward-regexp "\\>" (+ this-eol 2) t)
               (backward-char 1)
               )
         (
          t
          (goto-char (+ this-eol 2))
                     ) 
         );; end cond
        (setq end-word (point))
        (insert "}")
        (goto-char begin-word)
        (insert "${")        
        ) ;; end save-match-data
	);; end save-restriction
      ) ;; end save-excursion
  (goto-char (+ started_here 4))
  ;;(move-end-of-line nil) ;; works much better -T Sun Aug  1 18:56:45 2010
  ;;(return-from tt (list begin-word end-word))
  )



(defun rr ()
  (interactive "*")
  (setq loc-list (tt))
  )


(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "AntiqueWhite" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 106 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))




;; set 
;; (load-library "p4")
;; (p4-set-client-name "thansmann_sr")
;; (setenv "P4PASSWD" "th")


;; added Mon Dec 12 12:09:30 2011 for the regex Helper -T
(require 're-builder)
(setq reb-re-syntax 'string)



 (setq browse-url-browser-function 'w3m-browse-url)
 (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
 ;; optional keyboard short-cut
;; (global-set-key "\C-xm" 'browse-url-at-point)


;; http://www.emacswiki.org/emacs/Icicles_-_Libraries

;; Note: If you turn on Icicle mode in your init file, it’s generally
;; best to do so as late as possible – after you or any libraries that
;; you load do any key binding. This is because Icicles uses the
;; current global key bindings to determine which keys to bind for
;; minibuffer completion and cycling. To pick up the latest bindings
;; at any time, you can of course enter Icicle mode interactively
;; using command ‘icy-mode’ (if necessary, exit, then re-enter).

;; Wed May 30 16:15:12 2012 - trying this out
(require 'icicles)
(icy-mode 1)

;; a comment for git

;; (require 'tramp) ;; allows editing vis ssh on far machine and local
;;                  ;; sudo editing of root files -T Fri Jun 1 16:03:32
;;                  ;; 2012

;; ;; cool stuff from = http://emacswiki.org/emacs/TrampMode

;; (defvar find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
;;   "*The filename prefix used to open a file with `find-file-root'.")

;; (defvar find-file-root-history nil
;;   "History list for files found using `find-file-root'.")

;; (defvar find-file-root-hook nil
;;   "Normal hook for functions to run after finding a \"root\" file.")

;; (defun find-file-root ()
;;   "*Open a file as the root user.
;;    Prepends `find-file-root-prefix' to the selected file name so that it
;;    maybe accessed via the corresponding tramp method."

;;   (interactive)
;;   (require 'tramp)
;;   (let* ( ;; We bind the variable `file-name-history' locally so we can
;; 	 ;; use a separate history list for "root" files.
;; 	 (file-name-history find-file-root-history)
;; 	 (name (or buffer-file-name default-directory))
;; 	 (tramp (and (tramp-tramp-file-p name)
;; 		     (tramp-dissect-file-name name)))
;; 	 path dir file)

;;     ;; If called from a "root" file, we need to fix up the path.
;;     (when tramp
;;       (setq path (tramp-file-name-localname tramp)
;; 	    dir (file-name-directory path)))

;;     (when (setq file (read-file-name "Find file (UID = 0): " dir path))
;;       (find-file (concat find-file-root-prefix file))
;;       ;; If this all succeeded save our new history list.
;;       (setq find-file-root-history file-name-history)
;;       ;; allow some user customization
;;       (run-hooks 'find-file-root-hook))))

;; (global-set-key [(control x) (control r)] 'find-file-root)


;; (defface find-file-root-header-face
;;   '((t (:foreground "white" :background "red3")))
;;   "*Face use to display header-lines for files opened as root.")

;; (defun find-file-root-header-warning ()
;;   "*Display a warning in header line of the current buffer.
;;    This function is suitable to add to `find-file-root-hook'."
;;   (let* ((warning "WARNING: EDITING FILE AS ROOT!")
;; 	 (space (+ 6 (- (window-width) (length warning))))
;; 	 (bracket (make-string (/ space 2) ?-))
;; 	 (warning (concat bracket warning bracket)))
;;     (setq header-line-format
;; 	  (propertize  warning 'face 'find-file-root-header-face))))

;; (add-hook 'find-file-root-hook 'find-file-root-header-warning)


;; ;; more tricks from emacswiki

;; (defvar find-file-root-log "~/system/root-log"
;;   "*ChangeLog in which to log changes to system files.")

;; (defun find-file-root-log-do-it()
;;   "Add an entry for the current buffer to `find-file-root-log'."
;;   (let ((add-log-mailing-address "root@localhost")
;; 	(add-log-full-name "")
;; 	(add-log-file-name-function 'identity)
;; 	(add-log-buffer-file-name-function
;; 	 (lambda () ;; strip tramp prefix
;; 	   (tramp-file-name-localname
;; 	    (tramp-dissect-file-name
;; 	     (or buffer-file-name default-directory)))
;; 	   )))
;;     (add-change-log-entry nil find-file-root-log 'other-window)))

;; (defun find-file-root-log-on-save ()
;;   "*Prompt for a log entry in `find-file-root-log' after saving a root file.
;;    This function is suitable to add to `find-file-root-hook'."
;;   (add-hook 'after-save-hook 'find-file-root-log-do-it 'append 'local))w
;; (add-hook 'find-file-root-hook 'find-file-root-log-on-save)
;; ;; Or we may just have some personal preferences:

;; (defun my-find-file-root-hook ()
;;   "Some personal preferences."
;;   ;; Turn auto save off and simplify backups (my version of tramp
;;   ;; barfs unless I do this:-)
;;   (setq buffer-auto-save-file-name nil)
;;   (set (make-local-variable 'backup-by-copying) nil)
;;   (set (make-local-variable 'backup-directory-alist) '(("."))))

;; (add-hook 'find-file-root-hook 'my-find-file-root-hook)


;; more stuff in case i want to fool more
;; (defun find-alternative-file-with-sudo ()
;;   (interactive)
;;   (let ((fname (or buffer-file-name
;; 		   dired-directory)))
;;     (when fname
;;       (if (string-match "^/sudo:root@localhost:" fname)
;; 	  (setq fname (replace-regexp-in-string
;; 		       "^/sudo:root@localhost:" ""
;; 		       fname))
;; 	(setq fname (concat "/sudo:root@localhost:" fname)))
;;       (find-alternate-file fname))))

;; (global-set-key (kbd "C-x C-r") 'find-alternative-file-with-sudo)


;; (require 'ruby-block)
;; (ruby-block-mode t)

;; ;; ;; do overlay
;; (setq ruby-block-highlight-toggle 'overlay)
;; ;; ;; display to minibuffer
;; ;;(setq ruby-block-highlight-toggle 'minibuffer)
;; ;; ;; display to minibuffer and do overlay
;; (setq ruby-block-highlight-toggle t)



(global-set-key "" 'execute-extended-command)

;; since switching the mac the meta key is harder to use - switch to
;; the old ways and esc-esc to get a command prompt
;; also take advantage of vi thinking - bind ecs-... keys to
;; common things -t Mon Jun 11 20:53:23 2012
;; execute-extended-command aka meta-x

;; take advantage of vi thinking - bind Esc-Esc to execute-extended-command
;; aka meta-x -T Mon Jun 11 20:39:24 2012
(global-set-key "" 'execute-extended-command)
(global-set-key "/" 'query-replace-regexp)
(global-set-key "." 'icicle-repeat-complex-command) ;; would be nice just repeat last command without prompt


(add-to-list 'load-path
              "~/.emacs.d/plugins")
(require 'yasnippet)
(setq yas/snippet-dirs '(
                         "~/.emacs.d/snippets"
                         "~/.emacs.d/plugins/yasnippet/extras/imported"
                         "~/.emacs.d/plugins/yasnippet/snippets"
                         ))
(yas/global-mode 1)
(set yas/indent-line nil)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))


(message "made it to the end of the .emacs file")


