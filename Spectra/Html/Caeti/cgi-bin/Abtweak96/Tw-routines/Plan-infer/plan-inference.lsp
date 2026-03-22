; Tw-routines/Plan-infer/plan-inference.lsp

;************ note *****************
; the following functions are assumed plan-dependent.
;
; 1) (nece-before-p op1 op2 plan) done.
; 2) (non-codesignates-p x y plan), where x y are atoms. done
; 3) (get-opids-from-plan plan)  done
; 4) (get-operator-effects operator)  done.
;***********************************


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              routines for finding special operators.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;**************** find-establishers in plan, for precond of operator, opid.

(defun find_establishers (plan opid precond)
   "Tw-routines/Plan-infer/plan-inference.lsp
    returns a list of establishers of an operator precondition in plan so
   that 
   1 est->opid, and 
   2 an effect of est necessarily codesignates with precond and that 
   3 no other operator between operator and opid necessarily establishe
   precond."
   (declare (array plan) (atom opid) (list precond))

   (let ((candidates (all-nece-before opid plan)))  ; repaired to nece oct 9
     (declare (list candidates))

     (remove-redundant-establishers
      plan
      (remove nil
       (mapcar #'(lambda (opid2)
		   (and (poss-est-p opid2 precond plan) ;was nece-est-p < 1/97
			opid2 ))
	       candidates )))))

(defun remove-redundant-establishers (plan list-of-ops)
  "Tw-routines/Plan-infer/plan-inference.lsp
   returns a list of establishers such that any which would have preceded
   another have been removed."
  (declare (array plan) (list list-of-ops))

  (remove nil
	  (mapcar #'(lambda (opid1)
		      (unless
		       (some #'(lambda (opid2)
				 (nece-before-p opid1 opid2 plan) )
			     list-of-ops )
		       opid1 ))
		  list-of-ops )))

(defun nece-est-p (opid precond plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    t if an effect of  operator necessarily codesignates with precond."
  (declare (atom opid) (list precond) (array plan))

  (not (null
	(some #'(lambda (effect)
		  (nece-codesignates-p precond effect) )
	      (get-effects-of-opid opid plan) ))))

(defun poss-est-p (opid precond plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    t if an effect of  operator possibly codesignates with precond."
  (declare (atom opid) (list precond) (array plan))

  (not (null
	(some #'(lambda (effect)
		  (poss-codesignates-p precond effect plan) )
	      (get-effects-of-opid opid plan) ))))

(defun np-est-p (opid precond plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    t if an effect of  operator 
     necessarily codesignates with (1st param) of precond
     possibly    codesignates with (rest params) of precond"
  (declare (atom opid) (list precond) (array plan))

  (not (null
	(some #'(lambda (effect)
		  (np-codesignates-p precond effect plan) )
	      (get-effects-of-opid opid plan) ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		codesignation routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;**** necessarily codesignates    

(defun nece-codesignates-p (prop1 prop2)
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns t iff prop1 necessarily codesignates with prop2."
  (declare (list prop1 prop2))

  (cond ((and (atom prop1) (atom prop2))
	 (equal prop1 prop2) )
	; Nov 26/96 sgw
	((and (listp prop1) (equal (car prop1) 'options) (constant-p prop2))
         (not (null (find prop2 (cdr prop1)))) )         ; see dfn poss-codes
	((or (atom prop1) (atom prop2))
	 nil )
	(t
	 (and (nece-codesignates-p (car prop1) (car prop2))
	      (nece-codesignates-p (cdr prop1) (cdr prop2)) ))))

; ** necessarily codes 1st params , possibly codes rest params

(defun np-codesignates-p (prop1 prop2 plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns t iff prop1 nec codes 1st param, pos codes rest params"
  (declare (list prop1 prop2) (array plan))
  (let* ((strip-prop1 (strip-negate prop1))
         (strip-prop2 (strip-negate prop2))
         (nec-prop1   (list (first strip-prop1) (second strip-prop1)))
         (nec-prop2   (list (first strip-prop2) (second strip-prop2))) )
    (not (null (and (nots-do-not-match   prop1     prop2)
		    (nece-codesignates-p nec-prop1 nec-prop2)
		    (poss-codesignates-p prop1     prop2     plan) )))))

;;
;; HERE I AM - poss sucks ;; not no more!!
;;

;; This is an entirely new version of poss-codes based on standard
;;  unification, written by DP 7/24/97.  One change is that poss-codes
;;  now does a not-contained-within check.

(defun poss-codesignates-p (prop1 prop2 &optional (plan nil))
   "Tw-routines/Plan-infer/plan-inference.lsp
    t if prop1 prop2 necessarily codesignate.
    returns a mapping between prop1 prop2 if they poss codesignate.
    else return nil."
   (declare (list prop1 prop2) (array plan))

   (multiple-value-bind (success? mapping)
			(unify prop1 prop2 nil plan)
			(or mapping success?) ))

(defun unify (item1 item2 binds plan)
  (declare (list binds) (array plan))

  (cond ((equalp item1 item2) (values t binds))
	((and (listp item1)
	      (listp item2) )
	 (and (= (length item1) (length item2))
	      (multiple-value-bind
	       (success? mapping)
	       (unify (first item1) (first item2) binds plan)
	       (and success?
		    (unify (rest item1) (rest item2)
			   (append mapping binds) plan )))))
	((non-codesignate-p item1 item2 plan) nil)
	((var-p item1)
	 (and (not (contained-within-p item1 item2 binds)) ;item2 may be fn-app
	      (not (and (var-p item2)
			(binds-path-between-p item2 item1 binds) ))
	      (values t (append `((,item1 ,item2)) binds)) ))
	((var-p item2)
	 (and (not (contained-within-p item2 item1 binds)) ;item1 may be fn-app
	      (values t (append `((,item2 ,item1)) binds)) ))

	;; These are nonstandard additional functionalities (for preconds)
	((and (listp item1)
	      (eq (car item1) 'OPTIONS) 
	      (some #'var-p (cdr item1)) )
	 (error
	  "The OPTIONS precond ~s contains a variable, which is not ~
           allowable.  Please revise your domain knowledge."
	  item1 ))
	((and (listp item1)
	      (equal (car item1) 'OPTIONS) )
	 (values (not (null (find item2 (cdr item1))))
		 binds ))
	((and (listp item1)
	      (eq (car item1) 'RANGE)
	      (some #'var-p (cdr item1)) )
	 (error
	  "The RANGE precond ~s contains a variable, which is not ~
           allowable.  Please revise your domain knowledge."
	  item1 ))
	((and (listp item1)
	      (eq (first item1) 'RANGE) )
	 (values
	  (or (eq item2 (second item1)) ;perhaps item2 = neg-infin = lower-lmt
	      (eq item2 (third item1))  ;perhaps item2 = pos-infin = upper-lmt
	      (and (or (eq 'neg-infin (second item1))
		       (and (numberp (second item1))
			    (> item2 (second item1)) ))
		   (or (eq 'pos-infin (third item1))
		       (and (numberp (third item1))
			    (< item2 (third item1)) ))))
	  binds ))
	(t nil) ))

(defun contained-within-p (item1 item2 binds)
  (declare (atom item1) (list binds))

  (cond ((equalp item1 item2) t)
	((binds-path-between-p item1 item2 binds) t)
	((listp item2)
	 (some #'(lambda (item2-elem)
		   (contained-within-p item1 item2-elem binds) )
	       item2 ))
	(t nil) ))

(defun binds-path-between-p (a1 a2 binds &aux val)
  (declare (atom a1 a2) (list binds))

  (and (setq val (second (assoc a1 binds :test #'equalp)))
       (or (equalp val a2)
	   (binds-path-between-p val a2 binds) )))



(defun nots-do-not-match (p1 p2)
  "Tw-routines/Plan-infer/plan-inference.lsp
    true if the 'nots' of each item fail to match"
  (declare (atom p1 p2))

  (or (and (eq p1 'not) (not (eq p2 'not)) )
      (and (not (eq p1 'not)) (eq p2 'not) ) ))

(defun negate (p1)
  "Tw-routines/Plan-infer/plan-inference.lsp"
  (declare (list p1))

  (if (eq (car p1) 'not)
      (cdr p1)
    (cons 'not p1) ))

(defun strip-negate (p1)
  "Tw-routines/Plan-infer/plan-inference.lsp"
  (declare (list p1))

  (if (eq (car p1) 'not)
      (cdr p1)
    p1 ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            routines for precedence queries
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


(defun all-poss-before (op plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns the set of operator ids possibly before op.
    returns all opids currently in the plan which have not already been
    placed before op in the plan."
  (declare (atom op) (array plan))

  (remove nil (mapcar
	       #'(lambda (operator) 
		   (and (poss-before-p operator op plan)
			operator ))
	       (remove op (get-opids-from-plan plan)) )))

(defun all-nece-before (op plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns the set of operator ids necessarily before op."
  (declare (atom op) (array plan))

  (remove nil (mapcar
	       #'(lambda (operator) 
		   (if (nece-before-p operator op plan)
		       operator nil ))
	       (remove op (get-opids-from-plan plan)) )))

(defun all-poss-between (op1 op2 plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns list of operators possibly between op1 and op2 in plan."
  (declare (atom op1 op2) (array plan))

  (set-difference (all-poss-before op2 plan)
		  (cons op1 (all-nece-before op1 plan)) ))

(defun all-nece-between (op1 op2 plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns list of operators necessarily between op1 and op2 in plan."
  (declare (atom op1 op2) (array plan))

  (set-difference (all-nece-before op2 plan)
		  (cons op1 (all-poss-before op1 plan)) ))

(defun poss-before-p (op1 op2 plan)
  "Tw-routines/Plan-infer/plan-inference.lsp
    t iff op1 is possibly before op2 in plan.
    t iff op1 has not already been placed somewhere before op2."
  (declare (atom op1 op2) (array plan))

  (not (nece-before-p op2 op1 plan)) )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;			operator effects
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-ith-op-effect (op-template index &key primary )
  "Tw-routines/Plan-infer/plan-inference.lsp
    returns the ith effect of op-template, where i=index."
  (declare (type operator op-template) (integer index))

  (ith index (if primary
		 (operator-primary-effects op-template)
	       (operator-effects op-template) )))


(defun ith (i a-list)
  "Tw-routines/Plan-infer/plan-inference.lsp
   returns the ith element of a-list"
  (declare (integer i) (list a-list))

  (dotimes (index i (car a-list))
	   (setq a-list (cdr a-list)) ))

#| ;old version of poss-codes-p (with old version of atom-codes-p)
(defun poss-codesignates-p (prop1 prop2 &optional (plan nil))
   "Tw-routines/Plan-infer/plan-inference.lsp
    t if prop1 prop2 necessarily codesignate.
    returns a mapping between prop1 prop2 if they poss codesignate.
    else return nil."
   (declare (list prop1 prop2) (array plan))

   (cond  ((equal prop1 prop2) t)   ;nece codesignate.

          ;; both are atoms (highly unlikely that either is):

	  ((and (atom prop1) (atom prop2))
	   (atom-poss-codesignates-p prop1 prop2 plan) )

          ;; both are lists

	  ((and (listp prop1)
		(listp prop2) 
		(= (length prop1) (length prop2)) )
           ; build mapping.
	   (do ((rem-prop1 prop1 (cdr rem-prop1))
		(rem-prop2 prop2 (cdr rem-prop2))
		(result nil) )
	       ((null rem-prop1) (if result result t))
	       (let* ((ele1 (car rem-prop1))
		      (ele2 (car rem-prop2))
		      (mapping
		       (atom-poss-codesignates-p ele1 ele2 plan result) ))
		 (declare (atom ele1 ele2) (list mapping))
		 (cond ((and mapping (not (equal mapping t)))
			(setq result (append mapping result)))
		       ((null mapping) (return nil))
		       (t 'diddly) ))))))

;************ poss-codesignates function.  q. yang.

(defun atom-poss-codesignates-p (a1 a2 &optional plan current-mapping)
  "Tw-routines/Plan-infer/plan-inference.lsp
   returns substitution ((ai aj)) if ai=var,
   and poss codesignate in plan. t if a1=a2.
   else return nil."
  (declare (atom a1 a2) (type plan plan) (list current-mapping))

  (cond 
   ((equalp a1 a2) t)
   ((non-codesignate-p a1 a2 plan) nil)

   ;Nov 26/96 extension to handle sets of constants in the precondition
   ; parameter list prop1 MUST contain a list of constants and prop2 MUST
   ; be a single constant
   ;
   ; ie (p (1 2) $4) can bind with (p 2 $6) or (p 1 $6) thus allowing us
   ; to define slightly more flexible operator effects ... optionally could
   ; have defined more than one operator with nearly identical effect
   ; structures.

   ((and (listp a1)
	 (eq (car a1) 'options) 
	 (some #'var-p (cdr a1)) )
    (error
     "Element ~S of an OPTIONS precond contains a variable, which is not ~
      allowable.  Please revise your domain knowledge."
     a1))
   
   ((and (listp a1)
	 (equal (car a1) 'options)
	 (not (var-p a2)) )
    (not (null (find a2 (cdr a1)))) )

   ;;Jun 23/97 extension: (range neg-infin 5.0) can unify with 3.0
   ((and (listp a1)
	 (eq (car a1) 'range)
	 (some #'var-p (cdr a1)) )
    (error
     "Element ~S of a RANGE precond contains a variable, which is not ~
      allowable.  Please revise your domain knowledge."
     a1))

   ((and (listp a1)
	 (eq (first a1) 'range)
	 (not (var-p a2)) )
    (or (eq a2 (second a1)) ;perhaps a2 = neg-infin = lower-limit
	(eq a2 (third a1))  ;perhaps a2 = pos-infin = upper-limit
	(and (or (eq 'neg-infin (second a1))
		 (and (numberp (second a1))
		      (> a2 (second a1)) ))
	     (or (eq 'pos-infin (third a1))
		 (and (numberp (third a1))
		      (< a2 (third a1)) )))))

   ((and (listp a1)
	 (listp a2)
	 (= (length a1) (length a2)) )
    (poss-codesignates-p a1 a2 plan) )
   ((var-p a1)
    (or (binds-path-between-p a1 a2 current-mapping)
	(and (var-p a2)
	     (binds-path-between-p a2 a1 current-mapping) )
	(list (list a1 a2)) ))

   ((var-p a2)
    (or (binds-path-between-p a2 a1 current-mapping)
	(list (list a2 a1)) ))
   (t nil) ))
|#
