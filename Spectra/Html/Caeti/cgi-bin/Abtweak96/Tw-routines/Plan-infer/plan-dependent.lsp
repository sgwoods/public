; Tw-routines/plan-infer/plan-dependent.lsp 

; note: the following functions are dependent upon how plan, and
; operators are implemented.

;******************** plan-dependent ****************************
;
;		(1) access functions
;
;****************************************************************

(defun get-plan-cost (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-cost plan))

(defun get_kval (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-kval plan))

(defun get_cr (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-cr plan))

(defun get_a (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-a plan))

(defun get_b (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-b plan))

(defun get_nc (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-nc plan))

(defun get_var (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-var plan))

(defun get_op-count (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-op-count plan))

(defun get_conflicts (plan)   
  "Tw-routines/Plan-infer/plan-dependent.lsp "
  (plan-conflicts plan))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;             co-designation 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun non-codesignate-p (ele1 ele2 plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   t ele1 ele2 are both constants and different.
   or if plan is not nil, and (ele1 ele2) in nc of plan"
  (declare (atom ele1) (atom ele2) (array plan))

  (or (and (constant-p ele1)
	   (constant-p ele2)
	   (not (equal ele1 ele2)) )

      ;; Nov 22/96 sgw see plan-inference.lsp poss-code defun
      (and  (listp ele1)
	    (equal (car ele1) 'options)
	    (constant-p ele2)
	    (not (find ele2 (cdr ele1))) )

      ;; Jun 23/97 dp see plan-inference.lsp poss-code defun
      (and  (listp ele1)
	    (equal (first ele1) 'range)
	    (not (var-p ele2))
	    (not (or (eq ele2 (second ele1))   ;avoid neg-infin = neg-infin
		     (eq ele2 (third ele1)) )) ;avoid pos-infin = pos-infin
	    (or (not (numberp ele2))
		(if (numberp (second ele1)) ;avoid 'neg-infin
		    (or (< ele2 (second ele1))
			(and (numberp (third ele1))  ;avoid 'pos-infin
			     (> ele2 (third ele1)) ))
		  (and (numberp (third ele1))  ;avoid 'pos-infin
		       (> ele2 (third ele1)) ))))

      (and plan 
	   (or (find (list ele1 ele2) (plan-nc plan) :test #'equal)
	       (find (list ele2 ele1) (plan-nc plan) :test #'equal) ))))
		    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           precedence
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun nece-before-p (op1 op2 plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   t iff op1 is necessarily before op2 in plan."
  (declare (type atom op1) (type atom op2) (type array plan))

  (transitive-test-before-p op1
			    op2
			    (plan-b plan) ;opid order pairs
			    ))

;;; precedence, leonard-1
;;; From leonard@nssdcs.gsfc.nasa.gov Sat Jul 25 07:27:27 1992
;;; NOTE three versions present in this directory - see notes in each

;;; Semi-understandable version: replaces mapcars with do-loops,
;;;  adds extra checks at start for 'I and 'G, and pushes check for
;;;  exact (op1 op2) link into the body of the function.

(defun transitive-test-before-p (op1 op2 pairs)
  "Tw-routines/Plan-infer/plan-dependent.lisp 
   returns t iff op1 precedes op2 (possibly transitively) in pairs"
 (declare (type atom op1) (type atom op2) (type list pairs))

 (cond ((null pairs) nil)
       ((eq op2 'i) nil)
       ((eq op1 'g) nil)
       (t
	(let ((imm-before-op2 nil)
	      (pairs-without-op2 nil) )
	  (declare (type list imm-before-op2) (type list pairs-without-op2))
	
	  (dolist (pair pairs)
		  (if (eq op2 (second pair))
		      (if (eq op1 (first pair))
			  (return-from transitive-test-before-p t)
			(push (first pair) imm-before-op2) )
		    (push pair pairs-without-op2) ))
	  (dolist (op imm-before-op2 nil)
		  (when (transitive-test-before-p op1 op pairs-without-op2)
			(return t) ))))))
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;               conflicts
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-conflicts-from-plan (plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a list of conflicts in plan."
  (declare
      (type array plan) )
  (plan-conflicts plan))

(defun get-conflict-pro (conflict)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the provider of conflict."
  (declare 
      (type list conflict) )
  (first conflict))

(defun get-conflict-u (conflict)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the user of conflict."
  (declare 
      (type list conflict) )
  (second conflict))

(defun get-conflict-n (conflict)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the clobberer of conflict."
  (declare 
      (type list conflict) )
  (third conflict))

(defun get-conflict-p (conflict)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the p of conflict."
  (declare 
      (type list conflict) )
  (fourth conflict))

(defun get-conflict-q (conflict)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the q of conflict."
  (declare 
      (type list conflict) )
  (fifth conflict))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;              access operator ids,               
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ********* get operator from plan

(defun get-operators-from-plan (plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns list of operator instances in plan"
  (declare (type array plan))
  (plan-a plan))

; ******** get-opids-from-plan

(defun get-opids-from-plan (plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a list of opids from plan."
  (declare (type array plan))
  (mapcar #'operator-opid (plan-a plan)))

; ******** get-partial-ordered-opids-from-plan

(defun get-partial-ordered-opids-from-plan (plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp
   Form a flattened partial ordering of the opids so we can determine which
   are closest to I."
  (declare (array plan))
  (flatten-partial-orderings (plan-b plan)) )

;; Assumes that there are no cycles, e.g. ((a b)(b g)(a g))
(defun flatten-partial-orderings (partial-orders)
  (let ((flattened-orders nil)
	flat-order )
    (dolist (partial-order partial-orders)
	    (push
	     (apply
	      #'append
	      (mapcar #'(lambda (ordered-item)
			  (cond ((setq flat-order
				       (find ordered-item flattened-orders
					     :test #'position ))
				 (setq flattened-orders
				       (remove flat-order flattened-orders) )
				 flat-order )
				(t
				 (list ordered-item) )))
		      partial-order ))
	     flattened-orders ))
    (first flattened-orders) )) ;always(?) a list of a single list

;; ((b j)(i f)(g h)(b g)(e f)(f c)(a b)(c d)(b c)) ->
;; ((b c)(a b g h)(i f)(b j)(e f c d))

;; ((a b)(c d)(e f)(d e)(b c)) -> ((a b c d e f))

(defun linearize-pairs (pairs orderings
			      &aux ordering1 (pair1 (car pairs)) )
  (if pairs
      (or (and (setq ordering1 (assoc (first (last pair1)) orderings))
	       (linearize-pairs
		(cdr pairs)
		(linearize-pairs
		 (cons (append (copy-list pair1) (rest ordering1))
		       (remove ordering1 orderings) )
		 nil )))
	  (and (setq ordering1
		     (find (first pair1) orderings
			   :key #'(lambda (x) (first (last x))) ))
	       (linearize-pairs
		(cdr pairs)
		(linearize-pairs
		 (cons (append ordering1 (copy-list (rest pair1)))
		       (remove ordering1 orderings) )
		 nil )))
	  (linearize-pairs
	   (cdr pairs)
	   (cons (copy-list pair1) orderings) ))
    orderings ))

; ******** get-opids-from-operator-list         Nov/96 CAETI 

(defun get-opids-from-oplist (oplist)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a list of opids from oplist."
  (mapcar #'operator-opid oplist) )

;****************** operator dependent **********************

(defun get-operator-from-opid (opid plan)
 "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the operator effects given opid, an operator instance in plan."
  (declare (type atom opid) (type array plan))

  (and plan
       (or (find opid (plan-a plan)            :key #'operator-opid)
	   (find opid (plan-required-ops plan) :key #'operator-opid) )))

(defun get-effects-of-opid (opid plan)
 "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a list of operator effects of opid, which is an operator instance."
  (declare (type atom opid) (type array plan))

  (operator-effects (get-operator-from-opid opid plan)) )

(defun get-preconditions-of-opid (opid plan)
 "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the preconditions of operator in plan."
  (declare (type atom opid) (type array plan))

  (operator-preconditions (get-operator-from-opid opid plan)) )

(defun get-cost-of-opid (opid plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the cost of opid in plan"
  (declare (type atom opid) (type array plan))

  (operator-cost (get-operator-from-opid opid plan)) )

;;;;;;;;;; access operator structure.

(defmacro get-operator-effects (operator)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the set of effects of operator"
  (declare (type array operator))
  `(operator-effects ,operator) )

(defmacro get-operator-primary-effects (operator)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns the set of effects of operator"
  (declare (type array operator))
  `(operator-primary-effects ,operator) )

(defmacro get-operator-params (operator)
 "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns parameters in operator name."
  (declare (type array operator))
  `(cdr (operator-name ,operator)) )

(defmacro get-operator-opid (operator)
 "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns parameters in operator name."
  (declare (type array operator))
  `(operator-opid ,operator) )

(defmacro get-operator-cost (operator)
  "returns the cost of the operator structure."
  (declare (type array operator))
  `(operator-cost ,operator) )


;*******************************************************************
;
;			(2) modification
;
;*******************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;    operator   ;;;;;;;;;;;;;;;;;;;


(defun create-new-op-instance (op-template)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a new operator instance, making sure that 
   variables names are differnet from the template."
  (declare (type array op-template))

  (let ((mapping ;;make a list of (old-var new-var) pairs
	 (clean-up-mapping 
	  nil 
          (get-operator-params op-template) ))
	temp-op )
    (declare (type list mapping))

    (setq temp-op 
	  (make-operator
	   :opid            (create-opid)
	   :name            (instantiate (operator-name op-template) 
					 mapping )
	   :preconditions   (instantiate (operator-preconditions op-template)
					 mapping )
	   :effects         (instantiate (operator-effects op-template)
					 mapping )
	   :primary-effects (instantiate (operator-primary-effects op-template)
					 mapping )
	   :cost            (operator-cost op-template)
	   :stage           (operator-stage op-template) ))

    temp-op ))


(defun apply-mapping-to-op-instance (operator mapping)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns op-instance with variables substituted by 
  subs specified in mapping."
  (declare (type array operator) (type list mapping))

  (unless (eq mapping t)
	  (setf (operator-name operator)
		(instantiate (operator-name operator)
			     mapping ))
	  (setf (operator-preconditions operator)
		(instantiate (operator-preconditions operator)
			     mapping ))
	  (setf (operator-effects operator)
		(instantiate (operator-effects operator)
			     mapping )))
  operator )


(defun make-copy-of-op-list (op-list)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a list of new copies of op-list: list of templates."
  (declare (list op-list))

  (mapcar #'make-copy-of-operator op-list) )

(defun make-copy-of-operator (operator)
  "returns a copy of operator, with all new stuff"
  (declare (type array operator))

  (make-operator ;primary-effects field not copied
   :opid          (operator-opid operator)
   :name          (operator-name operator)
   :preconditions (operator-preconditions operator)
   :cost          (operator-cost operator)
   :stage         (operator-stage operator)
   :effects       (operator-effects operator) ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; plan modification ;;;;;;;;;;;

;***************** make-copy-of-plan (plan)

(defun make-copy-of-plan (plan &key (plan-id nil))
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   returns a new plan structure."
  (declare (type array plan))
  (let ((new-plan
	 (remove-constant-nonco
	  (make-plan
	   :id           (or plan-id (create-planid))
	   :a            (make-copy-of-op-list (plan-a plan))
	   :b            (plan-b plan)
	   :nc           (plan-nc plan)
	   :cr           (plan-cr plan)
	   :cost         (plan-cost plan)
	   :kval         (plan-kval plan)
	   :conflicts    (plan-conflicts plan)
	   :op-count     (plan-op-count plan)
	   :invalid-p    (plan-invalid-p plan)
	   :required-ops (plan-required-ops plan)
	   ))))
    (when *debug-mode* 
	  (format *output-stream* 
		  "~&>>>~&>>>   Copy Plan ~S into Plan ~S"
		  (plan-id plan) (plan-id new-plan) )
	  )
    new-plan ))

;********** add-nc-to-plan (x y plan)

(defun add-nc-to-plan (x y plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   add to plan non-codesignation constraint that x /= y."
  (declare (atom x y) (array plan))

  (when *debug-mode*
	(format *output-stream*  
		"~& >>>                                        <<< ~&~
		 ~& >>>   Add NonCodes between ~S and ~S in Plan ~S    <<< ~&~
		 ~& >>>                                        <<< ~&"
		x y (plan-id plan) ))

  (cond ((nece-codesignates-p x y)
	 (when *plan-debug-mode*
	       (format *output-stream*
		       "~%Plan ~s invalid due to noncodes1 ~s ~s"
		       (plan-id plan) x y ))
	 (setf (plan-invalid-p plan) t) )
	((not (non-codesignate-p x y plan))      ; prevents addition of 
	 (setf (plan-nc plan)                    ;  duplicates ncs
	       (cons (list x y) (plan-nc plan)))
	 plan)))


(defun remove-constant-nonco (plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   remove pairs of noncodesignation constraint where 
   pair=(e1 e2), and both are constants"
  (declare (array plan))

  (let ((nc-list (plan-nc plan)))
    (declare (list nc-list))

    (setq nc-list
	  (remove nil
		  (mapcar #'(lambda (pair)
			      (if (and (constant-p (first pair))
				       (constant-p (second pair)))
				  nil
				pair))
			  nc-list)))
    (setf (plan-nc plan) nc-list)
    plan ))

	

;********** add-conflicts-to-plan (conflicts plan)

(defun add-conflicts-to-plan (conflicts plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   add conflicts list to plan."
   (declare (list conflicts) (array plan))

   (setf (plan-conflicts plan)
	 (append conflicts
		 (plan-conflicts plan) ))
   plan )


;********** add-cost-to-plan ( plan cost)

(defun add-cost-to-plan (cost plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   add to plan cost"
  (declare (type array plan) (type integer cost))

  (incf (plan-cost plan) cost)
  plan )

(defun replace-a (x y plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   x replaced by y in plan-a."
  (declare (type atom x) (type atom y) (type array plan))

  (when *debug-mode*
	(format *output-stream*  
	        "~& >>>                                        <<< ~&~
	         ~& >>>   Replace ~S by ~S in Plan ~S          <<< ~&~
	         ~& >>>                                        <<< ~&"
		x y (plan-id plan) ))

  (mapcar #'(lambda (operator &aux (mapping `((,x ,y))))
	      (setf (operator-preconditions operator)
		    (instantiate (operator-preconditions operator)
				 mapping ))
	      
	      (setf (operator-effects operator)
		     (instantiate (operator-effects operator)
				  mapping ))

	      (setf (operator-name operator)
		    (instantiate (operator-name operator)
				 mapping ))
	      )
	  (plan-a plan) )
  plan )


(defun replace-nc (x y plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   x replaced by y in plan-nc."
  (declare (type atom x) (type atom y) (type array plan))

  (setf (plan-nc plan)
        (clean-up-nc 
	 (instantiate (plan-nc plan)
		      (list (list x y)) )))
  plan )

(defun clean-up-nc (nc)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   remove any non codesignation duplicates that have crept in to nc via
   addition of codesignations"
  (declare (list nc))

  (if (eq nc nil)
      nil
    (remove-duplicates
     nc
     :test #'(lambda (pair1 pair2)
	       (or (equal pair1 pair2)
		   (equal (reverse pair1) pair2)))) ))

(defun replace-cr (x y plan)
 "Tw-routines/Plan-infer/plan-dependent.lsp 
  replace x by y in cr"
  (declare
      (type atom x) 
      (type atom y)
      (type array plan) )
  (if (var-p x)
      (setf (plan-cr plan)
	    (mapcar #'(lambda (cr-ele)
			(list
			 (get-user-in-cr cr-ele)
			 (substitute y x (get-condition-in-cr cr-ele))
			 (get-producer-list-in-cr cr-ele)))
		    (plan-cr plan))))
  plan)




(defun replace-conflicts (x y plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   x replaced by y in plan-conflicts."
  (declare
      (type atom x) 
      (type atom y)
      (type array plan) )  
  (setf (plan-conflicts plan)
	(mapcar 
	 #'(lambda (conflict)
	     (list (get-conflict-pro conflict)
		   (get-conflict-u conflict)
		   (get-conflict-n conflict)
		   (instantiate (get-conflict-p conflict)
				(list (list x y)))
		   (instantiate (get-conflict-q conflict)
				(list (list x y)))))
	 (plan-conflicts plan)))
  plan)


;***************** add-order-to-plan (opid1 opid2 plan)

(defun add-order-to-plan (opid1 opid2 plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   add opid1<opid2 in plan."
  (declare (type atom opid1) (type atom opid2) (type array plan))

  ;; repaired oct 9, 1990 - sgw
  ;; maintain transitive nature of orderings - ie 
  ;; if a < c & a < d , then adding c < d makes a < d redundant

  (when *debug-mode* 
	(format *output-stream* 
		"~&>>>~&>>>   Add Order ~S BEFORE ~S in Plan ~S"
		opid1 opid2 (plan-id plan) ))

  (let ((old-orderings (plan-b plan)))
    (declare (list old-orderings))

    (cond ((nece-before-p opid2 opid1 plan)
	   (when *plan-debug-mode*
		 (format *output-stream*
			 "~%Plan ~s invalid due to prev ordering ~s ~s"
			 (plan-id plan) opid2 opid1 ))
	   (setf (plan-invalid-p plan) t) )
	  (t
	   (if (nece-before-p opid1 opid2 plan)
	       plan
	     (progn
	       (setf (plan-b plan)
		     (remv-redun-orders 
		      (cons (list opid1 opid2) old-orderings)
		      old-orderings))
	       plan )
	     ))) ))

(defun remv-redun-orders (b candidates)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   remove any candidate orderings that hold without their sep assertion
   ie check each old ordering and see if it has become redundant"
   (declare (list b candidates))

   (if (or (null candidates) (null b))
       b
       (let* (
              (ck    (car   candidates))     ; get a possible redundancy
              (ckop1 (first ck))             ; ckop1 < ckop2
              (ckop2 (second ck)) )
         
             (declare
                 (type atom ck)
                 (type atom ckop1)
                 (type atom ckop2) )

                   ; is this constraint ck:: ckop1 < ckop2 redundant?
             (if (transitive-test-before-p ckop1 ckop2 (my-delete ck b))
                   ; ie the constraint holds without explicit ckop1 < ckop2
                 (remv-redun-orders (my-delete ck b) (cdr candidates)) 
                   ; get rid of it, check the rest
                 (remv-redun-orders b (cdr candidates))  
                   ; keep it, check the rest
              ))))



;**************** add-operator-to-plan (op-instance plan)

(defun add-operator-to-plan (op-instance plan)
  "Tw-routines/Plan-infer/plan-dependent.lsp 
   add an operator instance to plan.  note after adding
   operator to plan-a, also add ordering (i < op-instance)
   and (op-instance < g); and parameter noncodesignations"
  (declare (type array op-instance) (type array plan))

  (let* ((id       (get-operator-opid op-instance))
	 (neworder (cons (list 'i id) (cons (list id 'g) (plan-b plan)))) 
	 #|(op-params (get-operator-params op-instance))|# )
    (declare (atom id) (list neworder op-params))

    (setf (plan-a plan)  (cons op-instance (plan-a plan))
	  (plan-b plan)  (remv-redun-orders neworder neworder)
	  (plan-nc plan) nil #|(clean-up-nc ;what was the goal for this??
			  (plan-nc (add-para-ncodes op-params plan)) )|#
	  )
    plan ))

;; DP 7/24/97 This fn is no longer used.  It may have made sense for
;;  domains like blocks world in which you don't want ?x and ?y ever
;;  to corefer in (on ?x ?y), but it doesn't make sense for all domains,
;;  including caeti-world in which the propo
;;  (defend-against-popup-air-attack ?leg-start ?leg-end ?attack-pt)
;;  may have ?attack-pt corefering with one of the leg endpoints.

(defun add-para-ncodes (list-of-vars plan)
 "Tw-routines/Plan-infer/plan-dependent.lsp
  add into plan non-codesignation constraints so that everyone in 
  list-of-vars non-codesignate with the other."
 (declare (type list list-of-vars) (type array plan))

 (if (cdr list-of-vars)
     (let ((current-pairs 
	    (mapcar #'(lambda (x)
			(list (car list-of-vars) x) )
		    (cdr list-of-vars) )))
       (declare (list current-pairs))

       (dolist (pair current-pairs)
	       (add-nc-to-plan (first pair)
			       (second pair)
			       plan ))
       (add-para-ncodes (cdr list-of-vars) plan) )
   plan ))





