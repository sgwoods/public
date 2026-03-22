;; Plan-routines/effects-usage.lsp

(let ((effects-usage (make-hash-table)))

  (defun effect-used-p (effect-prop)
    (gethash effect-prop effects-usage) )

  (defun mark-effect-used (effect-prop)
    (setf (gethash effect-prop effects-usage) t) )

  (defun mark-effect-unused (effect-prop)
    (setf (gethash effect-prop effects-usage) nil) )

  (defun clear-effects-usage ()
    (clrhash effects-usage) )
  )