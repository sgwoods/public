;; quil2-load.lsp

(defun load-all ()
  (load "../../Infer/coll-utils.fasl")
  (load "../../Infer/infer-utils.fasl")
  (load "quil2-utils.fasl")
  (load "quil2.fasl")
  (load "quil2-rules.lisp") )

(load-all)