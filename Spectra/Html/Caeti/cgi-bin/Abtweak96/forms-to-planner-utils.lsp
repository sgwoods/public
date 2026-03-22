;; forms-to-planner-utils.lsp

(defun plan-scenario (leg-i-state leg-g-state leg-required-opids
				  &key (debug-stream nil) )
  (declare (list leg-i-state leg-g-state leg-required-opids)
	   (atom debug-stream)) ;strings are atoms

  (plan leg-i-state
	leg-g-state
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:required-ops (create-requireds-list leg-required-opids)
	:print-output-p debug-stream
	:plan-debug-stream debug-stream )
  (if *solution*
      (let ((plan1-op-props
	     (mapcar #'operator-name (linearize-ops *solution*)) ))
	;;(setq *solution* nil) used in forms-to-planner.lsp
	(values (exercise-props plan1-op-props)
		(order-filter-props plan1-op-props)
		(constraint-filter-props plan1-op-props) ))
    (prog1 (values nil nil nil)
      (format debug-stream
	      "~%~
               ~% ...the planner failed to find a solution." ))
    ) ;if
  ) ;defun

(defun create-requireds-list (required-opids)
  (mapcar #'(lambda (reqd-opid)
	      ;(print reqd-opid)
	      (create-new-op-instance
	       (find reqd-opid *operators*
		     :key #'operator-opid )))
	  required-opids ))

(let ((constraint-f-names
       '(angle-formed
	 <
	 minimize
	 enemy-unit
	 NOT-enemy-unit
	 leg-clear
	 leg-lateral-space
	 overwatching
	 separation
	 point-on-segment
	 terrain-type
	 collective-travel-time
	 same-segment-space
	 NOT-same-segment-space
	 loc-empty
	 precedes
	 loc-radial-space )))
  (defun constraint-filter-props (props)
    (select-props-using-preds props constraint-f-names) )
  )

(let ((order-f-names
       '(move-order-given-to
	 change-of-direction-order-given-to
	 contact-report-given-to
	 fire-order-given-to
	 stop-order-given-to )))
  (defun order-filter-props (props)
    (select-props-using-preds props order-f-names) )
  )

(let ((exercise-names
       '(;; Move-from-leg-start
	 Change-of-direction-drill
	 Change-of-direction-to-assault-enemy
	 Change-of-direction-to-avoid-obstacle
	 Change-of-direction-to-avoid-impact-area
	 Move-out-from-stationary-formation
	 Move-out-from-halted-traveling-formation
	 Move-out-from-halted-bounding-overwatch
	 React-to-indirect-fire-drill-Stationary-formation
	 React-to-indirect-fire-drill-Halted-traveling-formation
	 React-to-indirect-fire-drill-Halted-bounding-overwatch

	 Travel-in-wedge-formation
	 Travel-in-staggered-column-formation
	 Travel-in-echelon-formation
	 Travel-in-vee-formation
	 Travel-in-line-formation
	 Travel-in-column-formation

	 Normal-travel-method
	 Travel-with-overwatch
	 Travel-with-bounding-overwatch
	 Tactical-road-march

	 ;; No-battle-drill
	 Pass-land-based-enemy-unit
	 Contact-with-small-arms-fire-drill
	 Passive-air-defense
	 Defend-against-moving-air-attack
	 Defend-against-popup-air-attack

	 ;; Move-to-leg-end-following-non-bounding-overwatch
	 ;; Move-to-leg-end-following-bounding-overwatch
	 Halt-traveling-formation
	 Halt-bounding-overwatch

	 Stop-in-herringbone-formation
	 Stop-in-coil-formation
	 )))
  (defun exercise-props (props)
    (select-props-using-preds props exercise-names) )
  ) ;let

(defun select-props-using-preds (props pred-set)
  (apply #'append
	 (mapcar #'(lambda (prop1)
		     (and (find (first prop1)
				pred-set )
			  (list prop1) ))
		 props )))

;; --------------------------------------------------------------------------
;;
;; Linearization of ops in plan-a
;;
;;  used in prettifying the actions, orders, and constraints shown to user

(defun linearize-ops (plan) ;There will still be multiple I's
  (mapcar #'(lambda (opid1)
	      (find opid1 (plan-a plan) :key #'operator-opid) )
	  (car (linearize-op-pairs (plan-b plan))) )) ;should be list of 1 list

(defun linearize-op-pairs (op-pairs &aux pairs-len)
  (incorporate-subsequences
   (incorporate-subsequences
    (sort
     (loop
      (setq pairs-len (length op-pairs)
	    op-pairs (linearize-pairs op-pairs nil) )
      (when (= pairs-len (length op-pairs))
	    (return op-pairs) ))
     #'<
     :key #'length )
    :goal-or-initial-end? 'G )
   :goal-or-initial-end? 'I ))

;; for 'linearize-pairs', see Tw-routines/Plan-infer/plan-dependent.lsp

;; The longest ordering is the 'backbone'
;; G : ((e f c)(a b c d)) -> ((a b e f c d))
;; I : ((b e f)(a b c d)) -> ((a b e f c d))
;; G then I: ((b j)(i f)(b g h)(e f c)(a b c d))) -> ((a b j g h e i f c d))

(defun incorporate-subsequences (sorted-orderings1 &key goal-or-initial-end?
						   (old-so-len nil) )
  (do ((subsegs sorted-orderings1 (cdr subsegs))
       (index-fn (if (eq 'G goal-or-initial-end?)
		     #'(lambda (subseg2) (first (last subseg2)))
		   #'first ) ;assume goal-or-initial-end=I
		 index-fn )
       (new-so-len (length sorted-orderings1) new-so-len)
       (pos0 0 (1+ pos0)) )
      ((or (and old-so-len
		(= new-so-len old-so-len) )
	   (null subsegs) )
       sorted-orderings1 )
      (do* ((subseg1 (car subsegs) subseg1)
	    (index1 (funcall index-fn subseg1) index1)
	    (sub-pos1 'foo sub-pos1)
	    (cands (remove subseg1 sorted-orderings1) (cdr cands))
	    (cand1 (car cands) (car cands))
	    (pos1 0 (1+ pos1)) )
	   ((null cands) nil)
	   (when (setq sub-pos1 (position index1 cand1))
		 (when (>= pos1 pos0) (incf pos1))
		 (return-from
		  incorporate-subsequences
		  (incorporate-subsequences
		   (if (< pos1 pos0)
		       (append ;loss of << sort order doesn't matter
			(subseq sorted-orderings1 0 pos1)
			(list
			 (append (subseq cand1 0 sub-pos1)
				 subseg1
				 (and (> (1- (length cand1)) sub-pos1)
				      (subseq cand1 (1+ sub-pos1)) )))
			(subseq sorted-orderings1 (1+ pos1) pos0)
			(and (> (1- new-so-len) pos0)
			     (subseq sorted-orderings1 (1+ pos0)) ))
		     (append ;loss of << sort order doesn't matter
		      (subseq sorted-orderings1 0 pos0)
		      (subseq sorted-orderings1 (1+ pos0) pos1)
		      (list
		       (append (subseq cand1 0 sub-pos1)
			       subseg1
			       (and (> (1- (length cand1)) sub-pos1)
				    (subseq cand1 (1+ sub-pos1)) )))
		      (and (> (1- new-so-len) pos1)
			   (subseq sorted-orderings1 (1+ pos1)) )))
		   :goal-or-initial-end? goal-or-initial-end?
		   :old-so-len new-so-len ))))))
