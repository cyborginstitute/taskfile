(provide 'taskfile)

(setq taskfile-location "/path/to/todo.mdwn")
(setq taskfile-flow-location "/path/to/flow.mdwn")
(setq taskfile-compile-command "make -k -C /path/to/projects; make -k -C /path/to/notes")

(defun taskfile-mark-done ()
  (interactive)
  (beginning-of-line)
  (re-search-forward "^[A-Z]+\\(-*.*\\) \\(.*\\)$" nil nil)
    (replace-match "- DONE\\1\\2"))

(defun taskfile-open ()
  (interactive)
  (find-file-read-only taskfile-location)
  (visual-line-mode 1)
  (revbufs))

(defun taskfile-flow ()
  (interactive)
  (find-file taskfile-flow-location)
  (visual-line-mode 0))

(defun taskfile-compile ()
  (interactive)
  (compile taskfile-compile-command)
  (revbufs))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Deft related Functions, see "taskfile/third-party/deft.el"
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'deft)

(setq deft-extension "mdwn")
(setq deft-directory "~/notes/")
(setq deft-text-mode 'markdown-mode)
(setq deft-use-filename-as-title t)
(setq deft-auto-save-interval nil)

(defun deft-file-make-slug (s)
  "Turn a string into a slug."
  (replace-regexp-in-string
   " " "-" (downcase
            (replace-regexp-in-string
             "[^A-Za-z0-9 ]" "" s))))

(defun tychoish-deft-create (title)
  "Create a new rhizome post."
  (interactive "sNote Title: ")
  (let ((draft-file (concat deft-directory
                            (deft-file-make-slug title)
                            "."
                            deft-extension)))
    (if (file-exists-p draft-file)
        (find-file draft-file)
      (find-file draft-file)
      (insert (title)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Keybindings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(global-set-key (kbd "C-c d o") 'deft)
(global-set-key (kbd "C-c d n") 'tychoish-deft-create)
(global-set-key (kbd "C-c d d") (lambda ()
                                   (interactive)
                                   (find-file deft-directory)))
(global-set-key (kbd "C-c t d") 'taskfile-mark-done)
(global-set-key (kbd "C-c t t") 'taskfile-open)
(global-set-key (kbd "C-c t c") 'taskfile-compile)
(global-set-key (kbd "C-c t f") 'taskfile-flow)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Occur Mode Customizations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun occur-procede-accordingly ()
  "Switch to occur buffer or prevent opening of the occur window if no matches occured."
  (interactive "P")
  (if (not(get-buffer "*Occur*"))
      (message "There are no results.")
    (switch-to-buffer "*Occur*")))

(defun occur-check-existence()
  "Signal the existance of an occur buffer depending on the number of matches."
  (interactive)
  (if (not (get-buffer "*Occur*")) nil t))

(defun occur-mode-quit ()
  "Quit and close occur window. I want to press 'q' and leave things as they were before in regard of the split of windows in the frame.
This is the equivalent of pressing C-x 0 and reset windows in the frame, in whatever way they were,
plus jumping to the latest position of the cursor which might have been changed by using the links out
of any of the matches found in occur."
  (interactive)
  (switch-to-buffer "*Occur*")
  ;; in order to know where we put the cursor thay might have jumped from qoccur
  (other-window 1)                  ;; go to the main window
  (point-to-register ?1)            ;; store the latest cursor position
  (switch-to-buffer "*Occur*")      ;; go back to the occur window
  (kill-buffer "*Occur*")           ;; delete it
  (jump-to-register ?y)             ;; reset the original frame state
  (register-to-point ?1))           ;; re-position cursor

;; some key bindings defined below. Use "p" ans "n" as in dired mode (without Cntrl key) for previous and next line; just show occurrence without leaving the "occur" buffer; use RET to display the line of the given occurrence, instead of jumping to i,t which you do clicking instead;  also quit mode with Ctrl-g.

(define-key occur-mode-map (kbd "q") 'occur-mode-quit)
(define-key occur-mode-map (kbd "C-q") 'occur-mode-quit)
(define-key occur-mode-map (kbd "C-g") 'occur-mode-quit)
(define-key occur-mode-map (kbd "C-RET") 'occur-mode-goto-occurrence-other-window)
(define-key occur-mode-map (kbd "C-<up>") 'occur-mode-goto-occurrence-other-window)
(define-key occur-mode-map (kbd "RET") 'occur-mode-display-occurrence)
(define-key occur-mode-map (kbd "p") 'previous-line)
(define-key occur-mode-map (kbd "n") 'next-line)

(global-set-key (kbd "C-c o") 'occur)

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
