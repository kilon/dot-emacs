;; configurations

(defcustom cabbage-latex-enable-flymake
  t
  "Enable flymake. Uses texify by default."
  :type 'boolean
  :group 'cabbage)

(defcustom cabbage-latex-flymake-use-chktex
  t
  "If t, flymake uses chktext instead of texify in latex mode."
  :type 'boolean
  :group 'cabbage)


;;;; -------------------------------------
;;;; Bundle


;; bindings

(eval-after-load 'tex-mode
  '(progn
     (define-key latex-mode-map (kbd "C-c C-1")
       'cabbage-latex-pdflatex-build-nonstop)
     (define-key latex-mode-map (kbd "C-c 1") 'cabbage-latex-pdflatex-build)
     (define-key latex-mode-map (kbd "C-c 2") 'cabbage-latex-open-pdf)
     (define-key latex-mode-map (kbd "C-c 3") 'cabbage-latex-cleanup)))


;; flymake

(when (and cabbage-latex-enable-flymake (cabbage-flymake-active-p))
  (cabbage-load-bundle-dependencies "latex" '("flymake.el")))


;; funs

(defun cabbage-latex-pdflatex-build (&optional nonstop)
  "Builds a PDF using pdflatex."
  (interactive)
  (let* ((file (tex-main-file))
         (command (concat "pdflatex "
                          (if nonstop "\\\\nonstopmode" "")
                          "\\\\input "
                          file)))
    (if (tex-shell-running)
        (tex-kill-job)
      (tex-start-shell))
    (tex-send-tex-command command default-directory)))

(defun cabbage-latex-pdflatex-build-nonstop ()
  "Builds a PDF in nonstop mode."
  (interactive)
  (cabbage-latex-pdflatex-build 1))

(defun cabbage-latex-open-pdf ()
  "Opens the PDF."
  (interactive)
  (let* ((basename (file-name-sans-extension (tex-main-file)))
         (path (concat default-directory basename ".pdf"))
         (command (concat "open " path)))
    (shell-command command)))

(defun cabbage-latex-cleanup ()
  "Removes some temporary files and the result PDF."
  (interactive)
  (let ((basename (file-name-sans-extension (tex-main-file))))
    (mapcar (lambda (x) (shell-command (concat "rm " basename x)))
            (list ".aux" ".lof" ".log" ".lot" ".pdf" ".toc")))
  (message "Deleted temp files and pdf"))
