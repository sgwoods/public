;***************************************************************************
; simple domain for testing
;***************************************************************************
(setq *domain* 'testing-filters)

; operators

(setq a (make-operator
	 :opid 'assert
	 :name '(assert $x)
	 :cost 1
	 :preconditions '(
			  (not prop $x)
			  )
	 :effects '(
		    (prop $x)
		    )	 ))

(setq d (make-operator
	 :opid 'deny
	 :name '(deny $x)
	 :cost 1
	 :preconditions '(
			  (prop $x)
			  )
	 :effects '(
		    (not prop $x)
		    )	 ))

(setq i (make-operator
	 :opid 'infer-c
	 :name '(infer-c)
	 :cost 1
	 :preconditions '(
			  (prop a)
			  (prop b)
			  )
	 :effects '(
		    (prop c)
		    )	 ))

(setq k (make-operator
	 :opid 'mk-kludge
	 :name '(mk-kludge $a)
	 :cost 1
	 :preconditions '(
			  (prop $a)
			  (filter1 X)
			  )
	 :effects '(
		    (kludge $a)
		    )	 ))

(setq *operators* (list a d i k))

; initial state
;
(setq initial '(
		(prop a) 
		(not prop b)
		(prop d)
		(filter1 $a)
		(filter2 $b)
		))
;goal state
;
(setq goal '(
	     (not prop a) 
	     (prop b) 
	     (prop c)
	     (kludge d)
	     (filter2 $f)
	     ))

;; ---------------------------------------------------------------------------
;; Testing below
;; ---------------------------------------------------------------------------

(defun ls () (load "Domains/simple"))
(defun pm () (plan initial goal :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))

;; added sgw oct/96
(setq *precond-new-est-only-list* '())