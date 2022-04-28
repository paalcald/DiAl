;;;; pseudo.el --- major mode para codigo de DiAl
;; Copyright notice
;; Author: Pablo C. Alcalde
;; Keyword: extensions
;; Commentary:
;;; Code:
(defconst pseudo-symbols-alist '(("<=" . ?≤)
				 (">=" . ?≥)
				 ("!=" . ?≠)
				 (":=" . ?≔)
				 ("&&" . ?∧)
				 ("||" . ?∨)
				 ("=>" . ?⇒)
				 ("->" . ?→)
				 ("-->" . ?↛)
				 ("~>" . ?↝)
				 ("<==>" . ?⟺)
				 ("==>" . ?⟹)
				 ("<==" . ?⟸)
				 ("caso" . ?▯)
				 ("paratodo" . ?∀)
				 ("existe" . ?∃)
				 ("suma" . ?Σ)
				 ("cuenta" . ?#))
  "Symbols to prettify.")

(defconst pseudo-defuns
  '("reg" "fun" "proc"))

(defconst pseudo-font-lock-var-regexp "\\_<\\(\\sw\\(?:\\sw\\|\\s_\\)*\\)\\_>"
  "Regexp used to detect function names.")

(defconst pseudo-endfuns
  '("freg" "ffun" "fproc"))

(defconst pseudo-block-delimiters
  (append pseudo-defuns pseudo-endfuns))

(defconst pseudo-types
  '("nat" "ent" "real" "car"))

(defconst pseudo-keywords
  '("var" "fcasos" "fsi" "fmientras" "fpara" "casos" "si" "mientras" "para" "const" "de" "nada" "sino" "dev" "paso" "entonces" "hacer" "paratodo" "existe" "suma" "cuenta"))

(defconst pseudo-defuns-regexp
  (regexp-opt pseudo-defuns 'symbols))

(defconst pseudo-endfuns-regexp
  (regexp-opt pseudo-endfuns 'symbols))

(defconst pseudo-block-delimiters-regexp
  (regexp-opt pseudo-block-delimiters 'symbols))

(defconst pseudo-types-regexp
  (regexp-opt pseudo-types 'symbols))

(defconst pseudo-keywords-regexp
  (regexp-opt pseudo-keywords 'symbols))
  
(defvar pseudo-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [foo] 'pseudo-do-foo)
    map)
  "Keymap for `pseudo-mode'.")

(defvar pseudo-mode-var-name-regexp
  (concat "\\(?:\\_<var\\_>\\s-*\\)?"
	  "\\(?:"
	  pseudo-font-lock-var-regexp
	  "\\)"
	  "\\(?:\\s-*,\\s-*"
	  pseudo-font-lock-var-regexp
	  "\\)*\\s-*[:=]")
  "Regexp used to detect variable names.")

(defun pseudo-mark-font-lock-assignment-chain (limit)
  "Font lock matcher function (up to LIMIT) for multi-assignments."
  (when (re-search-forward pseudo-mode-var-name-regexp limit t)
    (goto-char (match-end 1))))

(defun pseudo-setup-prettify ()
  "Setup `prettify-symbols-mode' in the current buffer.
Loads symbols from `pseudo-symbols-alist'."
  (set (make-local-variable 'prettify-symbols-alist) pseudo-symbols-alist)
  (prettify-symbols-mode 1))

;; Syntax Highlighting

(defconst pseudo-font-lock-keywords
  (list
   (cons #'pseudo-mark-font-lock-assignment-chain
	 '(1 font-lock-variable-name-face))
   (cons (concat "\\(?:" pseudo-defuns-regexp "\\s-+\\)+" pseudo-font-lock-var-regexp)
	 '(2 font-lock-function-name-face))
   (cons pseudo-block-delimiters-regexp font-lock-builtin-face)
   (cons pseudo-keywords-regexp font-lock-keyword-face)
   (list "\\(\\_<paratodo\\)\\(\\_>\\|<[^>]>\\)?"
         '(1 (compose-region (match-beginning 1) (match-end 1) ?∀))
         '(1 font-lock-keyword-face append))
   (list "\\(\\_<suma\\)\\(\\_>\\|<[^>]>\\)?"
         '(1 (compose-region (match-beginning 1) (match-end 1) ?∑))
         '(1 font-lock-keyword-face append))
   (list "\\(\\_<cuenta\\)\\(\\_>\\|<[^>]>\\)?"
         '(1 (compose-region (match-beginning 1) (match-end 1) ?#))
         '(1 font-lock-keyword-face append))
   (list "\\(\\_<existe\\)\\(\\_>\\|<[^>]>\\)?"
         '(1 (compose-region (match-beginning 1) (match-end 1) ?∃))
         '(1 font-lock-keyword-face append)))
    "Minimal Highlighting for Pseudo Mode.")

;; Indentation
(defun pseudo-indent-line ()
  "Indent current line as Pseudo code"
  (interactive)
  (beginning-of-line)
  (if (bobp) ; beginning-of-buffer -> indent-line-to 0
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at (concat "^\\s-*f"
			      (regexp-opt '("para"
					    "proc"
					    "fun"
					    "mientras"
					    "si"
					    "casos"
					    "reg")
					  t)
			      "\\_>"))
	  (progn
	    (save-excursion
	      (forward-line -1)
	      (setq cur-indent (- (current-indentation) tab-width))
	    (if (< cur-indent 0)
		(setq cur-indent 0)))
	    (save-excursion
	      (while not-indented
		(forward-line -1)
		(if (looking-at (concat "^\\s-*"
					(regexp-opt '("para"
						      "proc"
						      "fun"
						      "mientras"
						      "si"
						      "casos"
						      "reg")
						    t)
					"\\_>"))
		    (progn
		      (setq cur-indent (+ (current-indentation) tab-width))
		      (setq not-indented nil))
		  (if (bobp)
		      (setq not-indented nil)))))))
      (if cur-indent
	  (indent-line-to cur-indent)
	(indent-line-to 0)))))

(defvar pseudo-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?? "_" st)
    (modify-syntax-entry ?{ "<" st)
    (modify-syntax-entry ?} ">" st)
    st)
  "Syntax table for pseudo-mode")

;; (defun pseudo-mode ()
;;   "Major mode for editing Workflow Process Description Language files"
;;   (interactive)
;;   (kill-all-local-variables)
;;   (set-syntax-table pseudo-mode-syntax-table)
;;   (use-local-map pseudo-mode-map)
;;   (set (make-local-variable 'font-lock-defaults) '(pseudo-font-lock-keywords))
;;   ;(set (make-local-variable 'indent-line-function) 'pseudo-indent-line)
;;   (setq major-mode 'pseudo-mode)
;;   (setq mode-name "PSEUDO")
;;   (run-hooks 'pseudo-mode-hook))
;; (provide 'pseudo-mode)
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.pseudo\\'" . pseudo-mode))

;;;###autoload
(define-derived-mode pseudo-mode prog-mode "Pseudo"
  "Major mode for editing Dafny programs.

\\{dafny-mode-map}"
  :syntax-table pseudo-mode-syntax-table
  (set (make-local-variable 'font-lock-defaults) '(pseudo-font-lock-keywords))
  (set (make-local-variable 'indent-region-function) nil)
  (set (make-local-variable 'prettify-symbols-alist) pseudo-symbols-alist)
  (prettify-symbols-mode 1))

(provide 'pseudo-mode)
