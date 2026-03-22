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
			  (not predicate $x)
			  )
	 :effects '(
		    (predicate $x)
		    )	 ))

(setq d (make-operator
	 :opid 'deny
	 :name '(deny $x)
	 :cost 1
	 :preconditions '(
			  (predicate $x)
			  )
	 :effects '(
		    (not predicate $x)
		    )	 ))

(setq i (make-operator
	 :opid 'infer
	 :name '(infer-c)
	 :cost 1
	 :preconditions '(
			  (predicate a)
			  (predicate b)
			  )
	 :effects '(
		    (predicate c)
		    )	 ))

(setq k (make-operator
	 :opid 'kludge
	 :name '(kludge $a)
	 :cost 1
	 :preconditions '(
			  (predicate $a)
			  (filter1 X)
			  )
	 :effects '(
		    (kludge $a)
		    )	 ))

(setq *operators* (list a d i k))

; initial state
;
(setq initial '(
		(predicate a) 
		(not predicate b)
		(predicate d)
		(filter1 $a)
		))
;goal state
;
(setq goal '(
	     (not predicate a) 
	     (predicate b) 
	     (predicate c)
	     (kludge d)
	     ))

;;	     (filter1 $a)

;; ---------------------------------------------------------------------------
;; Testing below
;; ---------------------------------------------------------------------------

(defun ls () (load "Domains/simple"))

(defun pm () (plan initial goal :planner-mode 'mr))

(defun pcr () (plan-cr *solution*))