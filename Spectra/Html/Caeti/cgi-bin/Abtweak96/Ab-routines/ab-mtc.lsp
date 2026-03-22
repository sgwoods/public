; Ab-routines/ab-mtc.lsp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ab-mtc---modal truth criterion for abtweak
;  based on tweak mtc in /tweak/mtc.lsp
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;******** ab-mtc ******************

(defun ab-mtc (plan)
 "Ab-routines/ab-mtc.lsp
  modal truth criterion -true if plan correct @ ab level k, nil if incorrect."
  (declare (type plan plan))

  (ab-all_preconds_hold-p plan (get-opids-from-plan plan)) )

; subroutines for ab-mtc.

(defun ab-all_preconds_hold-p (plan opids)
   "Ab-routines/ab-mtc.lsp
    return true if all of the operators in opids have preconds at current
    abstraction level k that nec. hold"
  (declare (type plan plan))

  (or (null opids)
      (and 
       (ab-this_opid_ok-p      plan (car opids))
       (ab-all_preconds_hold-p plan (cdr opids)) )))

(defun ab-this_opid_ok-p (plan opid)
   "Ab-routines/ab-mtc.lsp
    return true if all of this operator's preconditions at the
    current level of abstraction k necessarily hold"
  (declare (type array plan) (type atom opid))

  (let ((preconds (remove-if 
		   #'(lambda (precond)
		       (< (find-crit precond) (plan-kval plan)))
		   (get-preconditions-of-opid opid plan) ))
	)
    (declare (type (list list) preconds))

    (preconds_hold-p plan opid preconds) ))

;; junk below

(defun junk1 ( plan opid )
  (remove-if  #'(lambda (precond)  
		  (< (find-crit precond) (plan-kval plan))) 
	      (get-preconditions-of-opid opid plan)
  ))