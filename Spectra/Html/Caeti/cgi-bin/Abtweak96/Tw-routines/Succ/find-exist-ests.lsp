; /Tw-routines/Succ/find-exist-ests.lsp

; written by steve woods and qiang yang, 1990
; modified by david pautler, 1/97, 3/97

; find existing establishers to create intermediate nodes.

(defun find-exist-ests (plan u p-) 
  "/Tw-routines/Succ/find-exist-ests.lsp
   returns a list of (establisher p-
   intermediate-plan flag), where establisher is an operator in
   intermediate-plan that is necessarily before u, and an effect of it 
   necessarily codesignates with p-.  flag=en if the before relation 
   is already in plan, ep otherwise."
  (declare (type plan plan) (type atom u) (type list p-))

  (case *exist-est-heuristic*
	(poss-then-nece
	 (append (find-pos-exist-ests plan u p-)
		 (find-nec-exist-ests plan u p-) ))
	(nece-then-poss ;dp 1/97
	 (append (find-nec-exist-ests plan u p-)
		 (find-pos-exist-ests plan u p-) ))
	(diff-stage-nece-and-poss ;dp 1/97
	 (diff-stage-nece-and-poss plan u p-) )
	))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun diff-stage-nece-and-poss (plan u p)
  "Tw-routines/Succ/find-exist-ests.lsp
   returns an ordered list of (opid plan2) pairs such that the opid's seem
   to be possible establishers for P of U; the ordering is based on an
   attempt to lead the planner to reuse op's when possible"
  (declare (array plan) (symbol u) (list p))

  ;; Each opid here has an effect which unifies with P
  (let* ((exist-est-triples
	  (matching-exist-effect-triples
	   (remove 'g (remove u (get-opids-from-plan plan)))
	   p
	   plan ))
	 (required-est-triples
	  (matching-new-effect-triples
	   (plan-required-ops plan) ;operators, not opids
	   p
	   plan
	   nil ))
	 (u-op (get-operator-from-opid u plan))
	 exist-est-triples-diff-users-stages
	 exist-est-triples-nece-before
	 exist-est-triples-poss-before
	 )

    ;;1st: Make sure that no est will be used to establish two ops of the
    ;;      same stage, but if they are of diff stages they must be on
    ;;      the same leg.  (Use for same stage ok in normal domains, not ours)

    (setq exist-est-triples-diff-users-stages
	  (remove
	   nil
	   (mapcar
	    #'(lambda (opid-eff-mapp &aux (opid (car opid-eff-mapp)))
		(and
		 ;; The check that locs of U and Est are the same is a side
		 ;; effect of the earlier call to poss-codesignates-p.
		 (no-user-from-same-stage opid u-op plan)
		 opid-eff-mapp ))
	    exist-est-triples ))
	  exist-est-triples-nece-before ;;ops req'd at this point to precede U
	  (remove nil
		  (mapcar #'(lambda (opid-eff-mapp)
			      (and (nece-before-p (first opid-eff-mapp) u plan)
				   opid-eff-mapp ))
			  exist-est-triples-diff-users-stages ))
	  exist-est-triples-poss-before ;;ops not req'd so far to precede U
	  (set-difference exist-est-triples-diff-users-stages
			  exist-est-triples-nece-before )
	  exist-est-triples-nece-before ;;limit further to those closest to U
	  (remove-redundant-est-triples plan
					exist-est-triples-nece-before )
	  ) ;setq

    ;2nd: we make 2 sets of (est-opid mod-plan) pairs:
    ; The first is for ops req'd to precede u but which satis another stage
    ; The second is for all other ops which currently satis some other stage
    ;(We assume that another other est candidates should be ops new to the plan
    (values
     (append
      (when *plan-debug-mode*
	    (format *output-stream* "~%~%Looking at preceding ops...") )
      ;;mostly equiv to 'find-nec-exist-ests'
      (make-intermediates exist-est-triples-nece-before u plan
			  #'cost-of-precedings )

      (when *plan-debug-mode*
	    (format *output-stream*
		    "~%~%Looking at possibly preceding ops..." ))
      ;;mostly equiv to 'find-pos-exist-ests'
      (make-intermediates exist-est-triples-poss-before u plan
			  #'cost-of-poss-precedings
			  :try-poss-precedings? t )

      (when *plan-debug-mode*
	    (format *output-stream* "~%~%Looking at required ops...~
                         ~% remaining: ~s"
		    (mapcar #'(lambda (r-op)
				(first (operator-name r-op)) )
			    (plan-required-ops plan) )))
      (make-intermediates required-est-triples u plan
			  #'cost-of-requireds
			  :try-requireds? t )
      ) ;append
     (mapcar #'(lambda (triple) ;used to prevent find-news from adding the same
		 (first (operator-name (caar triple))) ) ; op-templates to the
	     required-est-triples ))                     ; search space
    ) ;let
  ) ;defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun matching-exist-effect-triples (opids precond plan)
  (remove
   nil
   (mapcar
    #'(lambda (opid)
	(some
	 #'(lambda (effect &aux mapping)
	     (and (setq mapping (poss-codesignates-p precond effect plan))
		  (list* opid effect mapping) ))
	 (get-effects-of-opid opid plan) ))
    opids )))

(defun matching-new-effect-triples (operators precond plan
					      op-tags-of-reqds-included )
  (remove
   nil
   (mapcar
    #'(lambda (operator)
	(do* ((rem-effects (operator-effects operator) (cdr rem-effects))
	      (effect (car rem-effects) (car rem-effects))
	      (eff-index 0 (1+ eff-index))
	      (new-op nil nil)
	      (new-effect nil nil)
	      (new-mapping nil nil) )
	     ((null rem-effects) nil)
	     (when (poss-codesignates-p precond effect plan)
		   (setq new-op      (create-new-op-instance operator)
			 new-effect  (get-ith-op-effect new-op eff-index)
			 new-mapping (poss-codesignates-p precond
							  new-effect
							  plan ))
		   (return (list* (cons new-op operator) ;neither is an opid!!
				  new-effect
				  new-mapping )))))
    (remove-if #'(lambda (operator)
		   (find (first (operator-name operator))
			 op-tags-of-reqds-included ))
	       operators )
    )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun no-user-from-same-stage (est-opid u-op plan)
  (let ((u-stage (operator-stage u-op)))
    (or (null u-stage)
	(eq 'i est-opid)
	(every #'(lambda (order-pair &aux other-u-op)
		   (if (eq est-opid (first order-pair))
		       (progn
			 (setq other-u-op
			       (get-operator-from-opid (second order-pair)
						       plan ))
			 (or (eq u-op other-u-op)
			     (eq 'g (operator-opid other-u-op))
			     (not (= u-stage
				     (operator-stage other-u-op) ))))
		     t ))
	       (plan-b plan) ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun remove-redundant-est-triples (plan est-triples)
  "Tw-routines/Succ/find-exist-ests.lsp
   returns a list of establishers such that any which would have preceded
   another have been removed."
  (declare (type plan plan) (list est-triples))

  (remove nil
	  (mapcar #'(lambda (triple1)
		      (unless
		       (some #'(lambda (triple2)
				 (nece-before-p (first triple1)
						(first triple2)
						plan ))
			     est-triples )
		       triple1 ))
		  est-triples )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; See also #'cost-of-news, which actually does use "operator"

(defun cost-of-precedings (operator)
  (declare (ignore operator))
  1 )

(defun cost-of-poss-precedings (operator)
  (declare (ignore operator))
  2 )

(defun cost-of-requireds (operator)
  (declare (ignore operator))
  3 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun make-intermediates (triples u plan cost-fn
				   &key (try-poss-precedings? nil)
				   (try-requireds? nil)
				   (try-news? nil) )
  (mapcar
   #'(lambda (triple
	      &aux (op (first triple)) ;ambiguous: op/opid/(op . op)
	      (effect (second triple))
	      (mapping (cddr triple))
	      (child-plan (make-copy-of-plan plan))
	      opid operator old-reqd-operator )
       (when (or try-requireds?
		 try-news? ) ;old-reqd-operator is just ignored for this case
	     (setq old-reqd-operator (cdr op)
		   op (car op) ))
       (if (operator-p op)
	   (setq operator op
		 opid (operator-opid op) )
	 (setq operator (get-operator-from-opid op child-plan)
	       opid op ))
       (setq child-plan
	     (add-cost-to-plan (funcall cost-fn operator)
			       child-plan ))

       (when try-requireds?
	     (setf (plan-required-ops child-plan)
		   (remove-if
		    #'(lambda (op1)
			(and (eq old-reqd-operator op1)
			     (prog1 t
			       (when *plan-debug-mode*
				     (format *output-stream*
					     "~% dequeuing: ~s"
					     (first (operator-name op1)) )))))
		    (plan-required-ops child-plan) )))
       (when (or try-requireds?
		 try-news? )
	     (add-operator-to-plan operator child-plan) )
       (when (or try-poss-precedings?
		 try-requireds?
		 try-news? )
	     ;; conflicts are not added
	     (add-order-to-plan opid u child-plan) )    ;destructive to c-p

       (when *plan-debug-mode*
	     (format *output-stream*
		     "~%~%> Child plan ~s Cost ~s~
                          ~%> Considering effect ~s~
                          ~%>  from op ~s ~s"
		     (plan-id child-plan)
		     (plan-cost child-plan)
		     effect
		     (operator-opid operator)
		     (operator-name operator) ))
       (list opid (apply-mapping-to-plan mapping child-plan)) )
   triples ))
