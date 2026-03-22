; Tw-routines/mtc.lsp

; written by steve woods and qiang yang, 1990.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mtc---modal truth criterion.
; note: none of the functions here depends on how the plan and operators are 
; implemented.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;******** mtc ******************

(defun mtc (plan)
   "Tw-routines/mtc.lsp
    modal truth criterion - true if plan correct, nil if incorrect."
  (declare (type plan plan))

  (all_preconds_hold-p plan (get-opids-from-plan plan)) )

; subroutines for mtc.

(defun all_preconds_hold-p (plan opids)
   "Tw-routines/mtc.lsp
    return true if all of the operators in opids have preconds that nec. hold"
  (declare (type plan plan))

  (or (null opids)
      (and 
       (this_opid_ok-p      plan (car opids))
       (all_preconds_hold-p plan (cdr opids)) )))

(defun this_opid_ok-p (plan opid)
   "Tw-routines/mtc.lsp
    return true if all of this operator's preconditions necessarily hold"
  (declare (type plan plan) (type atom opid))

  (preconds_hold-p plan opid (get-preconditions-of-opid opid plan)) )

(defun preconds_hold-p (plan opid preconds)
   "Tw-routines/mtc.lsp
    return true if all of the preconditions hold for this opid"
   (declare (type plan plan) (type atom opid) (type list preconds))

   (or (null preconds)
       (and (hold-p plan opid (car preconds))
	    (preconds_hold-p plan opid (cdr preconds)) )))

(defun hold-p (plan opid precond &aux candidates)
  "Tw-routines/mtc.lsp
    does this precondition necessarily hold for opid?"
  (declare (type plan plan) (atom opid) (list precond candidates))

  ;;(format *output-stream* "~%  precond: ~a~%     opid: ~a" precond opid)
  (dolist (opid2 (all-nece-before opid plan))
	  (when (some
		 #'(lambda (effect)
		     #|(when (eq (car precond) (car effect))
			   (format *output-stream*
                                   "~%   effect: ~a~%     opid: ~a"
				   effect opid2 ))|#
		     ;;Mappings are applied to the whole plan when a node
		     ;; is expanded, so using nece-codes here is equivalent
		     ;; to checking for a causal relation between an E and P
		     (nece-codesignates-p precond effect) )
		 (get-effects-of-opid opid2 plan) )
		(push opid2 candidates) ))

  (let ((foo
	 (or (some
	      #'(lambda (opid2)
		  (not (clobberer-exists-p plan opid2 opid precond)) )
	      (remove-redundant-establishers plan candidates) )
	     (predicate-fn-p precond plan) )
	 ))
    ;;(format *output-stream* "~%  satisfied? ~a" foo)
    foo )
  )

#| ;;sgwoods version pre-1/97
(defun hold-p (plan opid precond)
  "Tw-routines/mtc.lsp
    does this precondition necessarily hold for opid?"
  (declare (type plan plan) (type atom opid) (type list precond))

  (or (one-of-establishers-ok-p plan
				(find_establishers plan opid precond)
				opid
				precond )
      (predicate-fn-p precond plan) ))

(defun one-of-establishers-ok-p (plan establishers opid precond)
  "Tw-routines/mtc.lsp
    t if no clobberers exist for at least one of these establishers."
  (declare (type plan plan) (type list establishers) (type atom opid)
	   (type list precond) )   

  (and establishers
       (or
	;; no clobberer exists for first establisher ?
	(not (clobberer-exists-p plan (car establishers) opid precond))
	;; maybe no clobberer exists for other establishers ?
	(one-of-establishers-ok-p plan (cdr establishers) opid precond) )))
|#
;************ clobberer-exists-p

(defun clobberer-exists-p(plan est user precond)
   "Tw-routines/mtc.lsp
    t if there is clobberer for (est user precond).  nil if not."
   (declare
      (type plan plan)
      (type atom est)
      (type atom user)
      (type list precond))
   (let (
          (candidates (all-poss-between est user plan)))
     (declare 
        (type list candidates))
     (dolist (operator candidates nil)   ;if no operator is a true
	                               ;clobberer, return nil.

	     (if   ;return t if this operator is a true clobberer.
		 (let (
                        (effects (get-effects-of-opid operator plan)))
                   (declare 
                      (type list effects))
		   (dolist (effect effects nil)
			   (if (poss-codesignates-p (negate-condition precond)
						    effect
						    plan )
				 (return t))))
		 (return t)))))
