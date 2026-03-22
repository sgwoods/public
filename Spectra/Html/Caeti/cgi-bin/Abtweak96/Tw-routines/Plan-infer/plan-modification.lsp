; /tweak/plan-infer/plan-modification.lsp

; written by steve woods and qiang yang, 1990


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                 plan modification
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;**************************************************
;                non codesignation
;
;**************************************************
(defun add-prop-nc-to-plan (prop1 prop2 plan)
  "/tweak/plan-infer/plan-modification.lsp
   add to plan non codesignation of the parameters of
   prop1 prop2 to plan."
  (declare (list prop1 prop2) (type plan plan))

  (when *debug-mode* 
	(format *output-stream*  
		"~& >>>                                        <<< ~&~
		 ~& >>>   Add NonCodes of ~S and ~S in Plan ~S  <<< ~&~
		 ~& >>>                                        <<< ~&"
		prop1 prop2 (plan-id plan) ))

  (cond 
   ((null plan) nil)
   ((equal prop1 prop2)
    (when *plan-debug-mode*
	  (format *output-stream*
		  "~%Plan ~s invalid due to equality in noncodes ~s ~s"
		  (plan-id plan) prop1 prop2 ))
    (setf (plan-invalid-p plan) t) )
   (t ;what was the goal for this??
    #|(let ((params1 (get-proposition-params prop1))
	  (params2 (get-proposition-params prop2)) )
      (declare (list params1 params2))

      (mapcar #'(lambda (x y)
		  (add-nc-to-plan x y plan) )
	      params1 params2 )|#
    plan )))



;********** co-designation

(defun apply-mapping-to-plan (mapping plan)
  "/tweak/plan-infer/plan-modification.lsp
   apply mapping to each variable of plan."
  (declare (list mapping) (array plan))

  (and plan
       (if (eq mapping t)
	   plan
	 (dolist (pair mapping plan)
		 (cond ((non-codesignate-p (first pair)
					   (second pair)
					   plan )
			(when *plan-debug-mode*
			      (format *output-stream*
				      "~%Plan ~s invalid due to ~
                                           noncodes2 ~s ~s"
				      (plan-id plan)
				      (first pair)
				      (second pair) ))
			(setf (plan-invalid-p plan) t)
			(return plan) )
		       (t
			(add-co-to-plan (first pair)
					(second pair)
					plan )))))))


;******** add-co-to-plan (x y plan)

(defun add-co-to-plan (x y plan)
 "/tweak/plan-infer/plan-modification.lsp
   add to plan codesignation constraint that x = y."
 (declare (atom x y) (array plan))

 (when *debug-mode* 
       (format *output-stream*  
	       "~& >>>                                        <<< ~&~
		~& >>>   Add CoDes of ~S and ~S in Plan ~S    <<< ~&~
		~& >>>                                        <<< ~&"
	       x y (plan-id plan) ))

 (cond ((null plan) nil)
       ((non-codesignate-p x y plan)
	(when *plan-debug-mode*
	      (format *output-stream*
		      "~%Plan ~s invalid due to noncodes3 ~s ~s"
		      (plan-id plan) x y ))
	(setf (plan-invalid-p plan) t) )
       (t (cond ((and (constant-p x)
		      (constant-p y))
		 plan)
		((constant-p x)
		 (substitute-this-by-that y x plan))
		((constant-p y)
		 (substitute-this-by-that x y plan))
		(t (substitute-this-by-that x y plan)))
	  (remove-constant-nonco plan) )))

 
(defun substitute-this-by-that (x y plan)
  "/tweak/plan-infer/plan-modification.lsp
   y is a variable.  returns plan with all occurrences of 
   x replaced by y in plan."
 (declare (atom x y) (array plan))

 (if *debug-mode*
     (format *output-stream*  
	     "~& >>>                                        <<< ~&~
		 ~& >>>   Replace ~S by ~S in Plan ~S          <<< ~&~
		 ~& >>>                                        <<< ~&"
	     x y (plan-id plan) ))

 (cond
  ((null plan) nil)
  (t (replace-cr x y
		 (replace-a x y 
			    (replace-nc x y
					(replace-conflicts x y plan) ))))))

