;; Tw-routines/Succ/select-ops.lsp

;; selects operator templates that can possibly co-designate with precond

(defun select-ops (templates precond)
  "Tw-routines/Succ/select-ops.lsp
   select applicable operator templates, instantiate with new vars, opids"
  (declare (type (list operator) templates) (type list precond))

  (apply #'append 
	 (mapcar #'(lambda (op-template) 
		     (find-list-of-op-instances op-template
						precond ))
		 templates )))

(defun find-list-of-op-instances (op-template precond)
  "Tw-routines/Succ/select-ops.lsp
   returns a list of operator instances of op-template that can possibly 
   assert precond"
  (declare (array op-template) (list precond))

  (let ((effects 
	 (if *use-primary-effect-p* 
	     (get-operator-primary-effects op-template)
	   (get-operator-effects op-template) )))
    (declare (type (list list) effects))

    (do ((rem-effects effects (cdr rem-effects))
	 (index 0 (1+ index))
	 (results nil))
	((null rem-effects) results) 
	(let ((effect (car rem-effects)))
          (declare (list effect))

	  (when (poss-codesignates-p precond effect)
		(let* ((new-op (create-new-op-instance op-template))
		       ;; Caution:  don't use (copy-operator ..),
		       ;; Because, it won't change var names!
		     
		       (new-effect 
			(get-ith-op-effect new-op index 
					   :primary *use-primary-effect-p* ))
		       (new-mapping (poss-codesignates-p precond new-effect)) )
		  (declare (type operator new-op) (type list new-effect)
			   (type list new-mapping) )

		  (push (list (apply-mapping-to-op-instance new-op
							    new-mapping )
			      new-mapping )
			results )))))))

(defun precond-reqs-new-est-p (precond)
  (find-if #'(lambda (element)
	       (same-precond-p precond element) )
	   *precond-new-est-only-list*	))

(defun same-precond-p ( pre1 lp1 )
  (if (and (eq (first pre1) 'not)
	   (eq (first lp1)  'not) )
      (same-precond-p (second pre1) (second lp1))
    (eq (first pre1) (first lp1)) ))
    