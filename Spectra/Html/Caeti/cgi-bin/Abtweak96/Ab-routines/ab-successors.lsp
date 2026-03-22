;; Ab-routines/ab-successors.lsp

;;***************************************************************************
;;*  abtweak successor creation
;;***************************************************************************

(defun ab-successors (plan &aux level)
  "Ab-routines/ab-successors.lsp
   find successors of plan at level k of criticality:
   when level k plan completed, ie no prob exists, advance to
   level k-1, unless k=0, in which case there are no successors."
  (declare (array plan))
   
  (setq level (plan-kval plan))

  (cond ((ab-mtc plan)  ; plan correct at level k.
         ;; descend abstraction hier to level k-1
         ;; note op-count level indicators updated at this point
	 (let ((new-level-plan-list (list (add-a-level plan))))
	   (declare (list new-level-plan-list))

	   ;; count # ab exp nodes
	   (setq *abs-node-count* (1+ *abs-node-count*)
		 *first-time* t )
	   (when (and *drp-mode*     ;downward refinement property.
		      *open* )
		 (push *open* *drp-stack*)
		 (setq *open* nil) )
	   (setf *old-plan* plan
		 (aref *new-refinement-p* level) t )
	   (increment-abs-branching-count level)
	   (update-abs-ref-counts level)
	   (update-abs-succ-counts (1+ level))
	   (when (or *drp-debug-mode*
		     *plan-debug-mode* )
		 (format *output-stream* ;*solution* is still 'initial-plan'
			 "~% Solution (*sol*) found on level ~D ~&" level)
		 (show-ops (setq *sol* plan))
		 (when *debug-break-mode* (break)) )
	   (setq *curr-level* (1- level))
	   new-level-plan-list   ; return abstract plan in a list alone
	   ))

	;; if drp-mode is on, then check if *curr-level* is changed from
	;; i-1 to i.  If so, then an abstract level backtracking occured.
	;; Consequently, one should check *abs-branching-counts* at i,
	;; to see if it has exceeded the limit *abs-branching-limit*.
	;; If so, then *drp-stack* should be dumped till level i+1 plan
	;; appears.  

	;; Else normal tweak successors
	(t
	 (let* ((u-and-p (ab-determine-u-and-p plan))
		(u       (first u-and-p))  ; sel an op w unsat preconds at level k
		(p       (second u-and-p)) ; sel an unsat lev k pre p in this u
		(op-tags-of-reqds-included nil)
		precond-index intermediates successors estid-list ests )
	   (declare (list u-and-p p intermediates successors estid-list ests
			  op-tags-of-reqds-included )
		    (atom u) )

	   (setq *abs-backtracking-flag* nil
		 precond-index (precond-to-index p u plan)
		 *first-time* nil )

	   ;;if precond is abstract, and mp-mode on, then only resolving
	   ;; conflicts.  Modified by Qiang according to Josh's comments.  
	   ;; Oct 29, 91.

	   (cond ((and *mp-mode* 
		       (< (plan-kval plan) 
			  (find-crit p))
		       (setq estid-list 
			     (third (find p
					  (plan-cr plan)
					  :test
					  #'(lambda (p cr)
					      (eq p (second cr)))))))
		  (setq intermediates
			(mapcar #'(lambda (estid)
				    (list estid (copy-plan plan)))
				estid-list)))

		 ;; each intermediates is a list of pairs 
		 ;;(establisher-id new-plan)

		 (t
		  (when *plan-debug-mode*
			(format *output-stream*
				"~%AB-SUCC plan-id: ~s~
                                   ~%  Trying to satisfy precond~
                                   ~%     ~s~
                                   ~%  of ~s ~s"
				(plan-id plan)
				p u
				(operator-name
				 (get-operator-from-opid u plan) )))
		  #|(when (equal "360" (subseq (symbol-name (plan-id plan)) 4))
			(setq *plan* plan *precond* p *user* u)
			(break) )|#
		  (setq intermediates
			(remove-if
			 #'(lambda (pair)
			     (and (consp pair)
				  (plan-invalid-p (second pair)) ))
			 ;; remove pair when pair=(est-id invalid-plan)
			 (append 
			  (and (not (or *existing-only*
					(precond-reqs-new-est-p p) ))
			       (progn ;progn not really necessary
				 (multiple-value-setq
				  (ests op-tags-of-reqds-included)
				  (find-exist-ests plan u p) )
				 ests ))

			  (when *plan-debug-mode*
				(format *output-stream*
					"~%~%Looking at new nodes..." )
				nil )
			  (if (and *shortcut-news-with-requireds?*
				   op-tags-of-reqds-included )
			      (when *plan-debug-mode*
				    (format *output-stream*
					    "~%~%   Use of required ~
                                                      operators ~
                                                short-cuts use of new's." )
				    nil )
			    (find-new-ests plan u p op-tags-of-reqds-included) )
			  (when *plan-debug-mode*
				(format *output-stream*
					"~%~%---------------------~
                                               -----------------------")
				nil
				)
			  ) ;append
			 ) ;remove-if
			))) ;cond

	   (setq successors 
		 (declobber-all intermediates u precond-index) )

	   (check-all-precond-predicate-fns-p plan)

	   (when *plan-debug-mode*
		 (let ((vmp-plans (sift #'violates-mp successors))
		       (pi-plans (sift #'plan-invalid-p successors)) )
		   (format *output-stream*
			   "~%Plans violating MP:~{ ~a~}~
                              ~%     invalid plans:~{ ~a~}"
			   (mapcar #'plan-id vmp-plans)
			   (mapcar #'plan-id pi-plans) )))
	   ;; remove plans flagged as invalid 
	   ;;-ie conflicting constraints exist
	   ;;and any that violate the mp property
	   (setq successors  (remove-if 
			      #'violates-mp 
			      (remove-if 
			       #'plan-invalid-p successors)))

	   (when *debug-mode*
		 (format *output-stream*
			 "Ab-successors generation...~&~
		          ~&        Plan Id = ~S    ~&~
                          ~&        User Id = ~S    ~&~
		          ~&        User    = ~S    ~&~
		          ~&        Precond = ~S    ~&"
			 (plan-id plan) u
			 (get-operator-from-opid u plan) p ))

	   ;; check for current maximum successor size, 
	   ;;and update if nec.  
	   (when (< *max-succ-count* (length successors))
		 (setq *max-succ-count* (length successors)) )

	   successors ))))


; ---------- Determine User and Precond for Abtweak.

(defun ab-determine-u-and-p (plan)
  "Ab-routines/ab-successors.lsp
   returns (list u p) where u is an operator with precondition
   p possibly unsatisfied.
   note: the current implementation will find either a random up, a 
   tree up, or the first up in a list"
  (declare (type array plan))

  (case *subgoal-determine-mode*
	(random ;; random u and p
	 (ab-determine-random-u-and-p plan) )
	(closest-to-initial
	 (ab-determine-closest-u-and-p-to-initial plan) )
	(stack
	 (ab-determine-first-u-and-p plan) )
	(t
	 (format *output-stream*
		 "ab-determine-u-and-p subgoal mode not set, using 1st.~&" )
	 (ab-determine-first-u-and-p plan) )))

(defun ab-determine-closest-u-and-p-to-initial (plan)
  "Ab-routines/ab-successors.lsp  
   returns (list u p) where u is an operator with precondition
   p possibly unsatisfied, where p has a criticality = kval of plan
   note: the current implementation will find the u and p closest to I. "
  (declare (type array plan))

  (dolist (opid (get-partial-ordered-opids-from-plan plan) nil)
	  (dolist (precondition 
		   (adjust-pre-list
		    opid
		    (get-preconditions-of-opid opid plan)
		    (plan-kval plan)) )
		  (unless (hold-p plan opid precondition)
			  (return-from
			   ab-determine-closest-u-and-p-to-initial
			   (list opid precondition) )) ;unless
		  ) ;dolist
	  ) ;dolist
  )

(defun ab-determine-first-u-and-p (plan)
  "Ab-routines/ab-successors.lsp  
   returns (list u p) where u is an operator with precondition
   p possibly unsatisfied, where p has a criticality = kval of plan
   note: the current implementation will find the first u and p. "
  (declare (type array plan))

  (dolist (opid (get-opids-from-plan plan) nil)
	  (dolist (precondition
		   ;; find all preconditions of opid at level k
		   (adjust-pre-list opid
				    (get-preconditions-of-opid opid plan)
				    (plan-kval plan)) )
		  (unless (hold-p plan opid precondition)
			  (return-from ab-determine-first-u-and-p
				       (list opid precondition) ))
		  )
	  )
  )

(defun ab-determine-random-u-and-p (plan)
  "Ab-routines/ab-successors.lsp
   returns (list u p) where u is an operator with precondition
   p possibly unsatisfied.
   note: the current implementation will find a random u and p. "
  (declare (type array plan))
  (random-element1 (ab-unsat-up-pairs plan)))

(defun ab-unsat-up-pairs (plan)
 "Ab-routines/ab-successors.lsp 
  return a list of all unsatisfied (user precondition) pairs in plan"

  (declare (type array plan))

  (remove-if
   #'(lambda (pair)
       (hold-p plan (first pair) (second pair)) )
   (mapcan
    #'(lambda (opid)
	(mapcar
	 #'(lambda (pre) 
	     (list opid pre) )
	 (adjust-pre-list opid
			  (get-preconditions-of-opid opid plan)
			  (get_kval plan) )))
    (get-opids-from-plan plan) )))


