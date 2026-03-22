; Tweak-routines/Plan-infer/show-plan.lsp

;***************************************************************************
; debug and output routines
;
;  (show  plan)      - show entire plan definition
;  (showa plan)      - show operators in plan
;  (showb plan)      - display ordering constraints
;  (shownc plan)     - show non codesignation constraints

(defun show-ops (plan &key show-cr)
  "returns a list of operator names, with order and non-codesignation."
  ;(setq *output-stream* t) ;this was here before DP updated streams 7/97
  (let ((orders (sort-orders '(i) (plan-b plan)))
	(crs (get-cr-in-plan plan))
	(operator-templates (plan-a plan))
	result )
    (setq result
	  (list 
	   (mapcar #'(lambda (order)
		       (let ((op1-id (first order))
			     (op2-id (second order)))
			 (list
			  (replace-by-op-name op1-id operator-templates)
			  (replace-by-op-name op2-id operator-templates))))
		   orders)
	   (if show-cr
	       (mapcar #'(lambda (cr)
			   (let ((op1-id (car (get-producer-list-in-cr cr)))
				 (condition (get-condition-in-cr cr))
				 (op2-id (get-user-in-cr cr)))
			     (list
			      (replace-by-op-name op2-id operator-templates)
			      condition
			      (replace-by-op-name op1-id operator-templates))))

		       crs)
	     nil)
	   
	   (plan-nc plan)))

	(dolist (order (first result))
		(format *output-stream* "~%--> ~a" order) )
	(cdr result)))


(defun replace-by-op-name (op-id op-templates)
  "relace opid by name from templates."
  (operator-name 
   (car (member op-id op-templates :test 
		#'(lambda (op-id op-temp)
		    (equal op-id (operator-opid op-temp)))))))


(defun sort-orders (op-list orders)
  "returns a list whose earliest elements are the orders pairs keyed by an
   op in the op-list; thereafter, the second ops in those pairs are used as
   an op-list; the overall effect is to sort order pairs from those starting
   with, say, I through those ending with, say, G."
  (and orders
       (let ((first-orders
	      (remove-if-not
	       #'(lambda (order)
		   (find (first order) op-list) )
	       orders )))
	 (append first-orders
		 (sort-orders 
		  (mapcar #'second first-orders)
		  (set-difference
		   orders first-orders :test #'equal ))))))



;************ write open to file ********************

(defvar *open-file* nil)

(defun write-open-to-file (file-name &key test-type show-cr)
  "pprint open list to file"
  
  (let ((plans (mapcar #'second
		       (apply #'append (mapcar #'second *open*)) )))

    (setq *open-file* (open file-name :direction :output))
    (format *open-file* "~&test type = ~a" test-type)
    (dolist (plan plans)
	    (format *open-file* "~&**********~&")
	    (write-one-plan-to-file plan 
				    *open-file*
				    :show-cr show-cr))
    (close *open-file*)))



(defun write-one-plan-to-file (plan stream &key show-cr)
  "write one plan to file"

  (let ((result (show-ops plan
			   :show-cr show-cr
			   :terminal nil)))

    (format stream "~& ~& ~& ")
    (mapcar #'(lambda (order)
		(format stream "~& ~& ~s" order) )
	    (first result) )
    (format stream "~& ~& ~s" (cdr result)) ))


; **** old show functions kept

(defun showa (plan)
  "/tweak/plan-infer/show-plan.lsp
   display the operators used in the plan"
   (declare (array plan))

   (princ "valid operators used in plan: ")
   (terpri)
   (pprint (plan-a plan))
   (terpri)(terpri) )

(defun showb (plan)
  "/tweak/plan-infer/show-plan.lsp
   display the ordering constraints of plan"
   (declare (array plan))
   (princ "order constraints  (a < b):")(terpri)
   (pprint (plan-b plan))
   (terpri) (terpri) )

(defun shownc (plan)
  "/tweak/plan-infer/show-plan.lsp
   show non codesignations in plan"
   (declare (array plan))
   (princ "non codesignations: ")(terpri)
   (pprint (plan-nc  plan)) (terpri)
   (terpri) )


