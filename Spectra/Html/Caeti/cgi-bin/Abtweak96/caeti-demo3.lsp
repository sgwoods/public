;;; caeti-demo3.lsp

(defun foo (required-opids plan-debug-mode?)
  (plan *initial*
	*goal*
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:required-ops (create-requireds-list required-opids)
	:print-output-p t
	:plan-debug-mode plan-debug-mode? ))

(defun foo1 (&optional (plan-debug-mode nil))
  (foo '(sicoil mtle-nbo ttm mofsf wltf) plan-debug-mode) )

(defun foo2 (&optional (plan-debug-mode nil))
  (foo '(sicoil mtle-nbo ttm mofsf wltf cfcr) plan-debug-mode) )

(defun foo3 (&optional (plan-debug-mode nil))
  (foo '(ttm totm) plan-debug-mode) )

(defun manual-demo ()
  (load "../DemoDir/demo"))

(defun caeti-demo3 (&optional (print-output? nil) (plan-debug? nil)
			      (i *initial*) (g *goal*)
			      &aux opids-of-requireds )
  (format t "~%~
             ~% Start condition for new exercise:~{~%~%    ~a~}~
             ~%~
             ~% End condition for new exercise:~{~%~%    ~a~}~
             ~%~
             ~% Enter any required operators [NIL or (opid ...)]: "
	  (cdr i) (cdr g) )
  (setq opids-of-requireds (read))
  (planner-demo i g opids-of-requireds
		:print-output? print-output?
		:plan-debug? plan-debug?
		:succ-continuation #'csp-demo
		:fail-continuation #'csp-failure-stmt 
		:load-real-terrain-db t            ; req explict force to load
		))

; CURRENT : May 20, 1997
(defun planner-demo (i g opids-of-requireds 
		       &key 
		       (print-output?        nil)
		       (plan-debug?          nil)
		       (succ-continuation    nil)
		       (fail-continuation    nil)
		       (load-real-terrain-db nil)
		       )
  (format t "~%~
             ~% Planning the new exercise..." )
  (plan i g
	:required-ops (create-requireds-list opids-of-requireds)
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:print-output-p print-output?
	:drp-debug-mode plan-debug?
	:plan-debug-mode plan-debug? )
  (if *success*
      (let* ((plan1-op-props
	      (mapcar #'operator-name (linearize-ops *solution*)) )
	     (plan1-exercise-op-props
	      (exercise-props plan1-op-props) )
	     (plan1-order-f-op-props
	      (order-filter-props plan1-op-props) )
	     (plan1-terrain-f-op-props
	      (terrain-filter-props plan1-op-props) )
	     )
	(format t "~%~
                   ~% SOLUTION FOUND!~
                   ~%~
                   ~% The new exercise contains these actions:~{~%~%    ~a~}~
	           ~%~
                   ~% The training table for the new exercise ~
                             is:~{~%~%    ~a~}~
	           ~%~
                   ~% The new exercise also places some constraints ~
                             on the terrain:~{~%~%    ~a~}"
		plan1-exercise-op-props
		plan1-order-f-op-props
		plan1-terrain-f-op-props )
	(wait-for-user "Ready to look for an appropriate terrain?")
	(format t "~%~
                   ~% Formatting a template from planner spatial constraints..." )
	(translate-terrain-filters-to-constraints plan1-terrain-f-op-props i)

	(format t "~%~
                   ~% Testing terrain with the new constraints..." )

	;; ***************************************************************
	;; note large situation-id is "real-terrain-db"      May 21/97 sgw
	;; prev test  situation-id (default) is "terrain-1" 
	;; ***************************************************************
	(if load-real-terrain-db                             
	    (tcsp :template-id "users-terrain-template"
		  :situation-id "real-terrain-db"              
		  :load-real-terrain-db load-real-terrain-db 
		  )
	  (tcsp :template-id "users-terrain-template"
		:situation-id "terrain-1"                      
		:load-real-terrain-db nil
	      ))

	(if *solution-set*
	    (funcall succ-continuation) 
	  (funcall fail-continuation) )
	) ;let
    (format t "~%~
               ~% ...the planner failed to find a solution." )
    ) ;if
  ) ;defun

(defun create-requireds-list (required-opids)
  (mapcar #'(lambda (reqd-opid)
	      (create-new-op-instance
	       (find reqd-opid *operators*
		     :key #'operator-opid )))
	  required-opids ))

(defun wait-for-user (prompt-string)
  (clear-input)
  (format t "~%~
             ~% ~a [hit ENTER]" prompt-string )
  (read-char)
  (values) )

(defun translate-terrain-filters-to-constraints (plan-terrain-filters
						 initial-state)
  (let* (
	 (initial-movement-state
	  (or (assoc 'in-stat-formation (cdr initial-state))
	      (assoc 'stopped-at (cdr initial-state)) ))
	 (i-terrain-filters ;the csp needs constrs on the initial spot also
	  (and initial-movement-state
	       (terrain-filter-props    ;a] assume 1 op, not a plan, is adequate
		(operator-preconditions ;b] assume 1st op found is adequate
		 (caar (select-ops
			(remove 'wisf
				(remove 'wihtf *operators* :key #'operator-opid)
				:key #'operator-opid )
			(append (butlast initial-movement-state)
				(list (create-var)) ))))))) ;replaces 0.0 time
	 (node-constraints nil)
	 (arc-constraints  nil)
	 (empty-terrain-types '(Plain Forest))
	 filter-name     key node-c      arc-c 
	 )
    (flet (
	   (same-as-previous-arc-con-p (arc-con1)
				       (and (eq filter-name (car arc-con1))
					    (equalp key (caadr arc-con1)) ))
	   )
	  (setq *ptfs* plan-terrain-filters *itfs* i-terrain-filters) ;; testing
	  ;; (goo)
	  (dolist (filter1 (append i-terrain-filters plan-terrain-filters))
		  (setq key (second filter1) ;gridpoint of constraint
			filter-name (first filter1) )
		  (format t "~%     node cs: ~a~
                             ~%      arc cs: ~a"
			  node-constraints arc-constraints )
		  (case filter-name
			(loc-empty
			 (if (setq node-c (assoc key node-constraints))
			     (setf (second node-c) empty-terrain-types)
			   (push (list key empty-terrain-types nil '*)
				 node-constraints )))
			(loc-radial-space
			 (if (setq node-c (assoc key node-constraints))
			     (setf (third node-c) (cdr (third filter1)))
			   (push (list key nil (cdr (third filter1)) '*)
				 node-constraints )))
			(leg-lateral-space
			 (if (setq arc-c
				   (some #'same-as-previous-arc-con-p
					 arc-constraints ))
			     (format t "~%~%Duplicate filters A: ~s~
                                          ~%                  B: ~s"
				     arc-c filter1 )
			   (push (list filter-name
				       (list (second filter1) (third filter1))
				       (cdr (fourth filter1)) )
				 arc-constraints )))
			(leg-clear
			 (if (setq arc-c
				   (some #'same-as-previous-arc-con-p
					 arc-constraints ))
			     (format t "~%~%Duplicate filters A: ~s~
                                          ~%                  B: ~s"
				     arc-c filter1 )
			   (push (list filter-name
				       (list (second filter1) (third filter1)) )
				 arc-constraints )))
			;;viewable, none-viewable, oriented-from, item,
			;;subsegment, separation, terrain-type,
			;;same-segment-space, vector-intersects, angle-formed,
			;;collective-travel-time
			(otherwise 'diddly)
			) ;case
		  ) ;dolist
	  ;; (comment "Here I am")
	  ) ;flet
    ;; (comment1 "Dbg node-constraints" node-constraints)
    ;; (comment1 "Dbg arc-constraints"  arc-constraints)
    ;; (comment1 "Dbg *template-object-list*" *template-object-list*)
    (setq *template-object-list* ;replaces values def'd in QCSP/terrain-setup-dp
	  (list
	   (list "users-terrain-template" node-constraints arc-constraints nil)
	   ))
    ) ;let
  ) ;defun

(defun goo ()
  (pprint *pt-ops*) (terpri)
  (pprint *i-ops*) (terpri)
  (pprint (cdr (fourth *template-object-list*)))
  )

(defun csp-failure-stmt ()
  (format t "~%~
             ~% ...failure to map the planned exercise ~
                          to the terrain." ))

;; succ-continuation from demo here ...
(defun csp-demo ()
  "Generate the terrain map using the FIRST located route in the solution set."
  (let* ((pos-ordering (induced-cp-order)) ;; eg (cp1 cp2 cp3 cp4 ...)
	 (solution                         ;; get first route solution from CSP set
	  (first *solution-set*) )         ;; eg ((cp1 sitobj1) (cp2 sitobj2) ...)
	 xy-alist )
    #| ;this seems as though it might cause the plan to become insensible
    ;reverse pos-ordering if 1st cp is higher than the last
    (when (< (get-sit-obj-y (second (assoc (first (last pos-ordering)) solution)))
	     (get-sit-obj-y (second (assoc (first pos-ordering)        solution))) )
	  (setq pos-ordering (reverse pos-ordering)) )
    |#
    (setq xy-alist                         ;; eg ((3 1) (4 5) (6 9))
	  (mapcar #'(lambda (pos1
			     &aux (sitobj (second (assoc pos1 solution))) )
		      (list (get-sit-obj-x sitobj)
			    (get-sit-obj-y sitobj) ))
		  pos-ordering ))
    (format t "~%~
               ~% TERRAIN MAPPING FOUND!~
               ~{~%~%    Place checkpoint ~s at: ~s~}"
	    (interleave-lists (make-ascending-numbers-list (length xy-alist))
			      xy-alist ))
    ;(print 'we-might-want-to-describe-constraints-satisfied)
    (wait-for-user "Ready to show display of exercise route?")
    (format t "~%~
               ~% Creating display of exercise route...~
               ~%" )
    (save-gnuplot xy-alist)

    (run-shell-command
     "/usr/local/bin/gnuplot QCSP/TSit/terrain-gnuplot.gp"
     :wait nil )
    (run-shell-command
     "/usr/local/bin/ghostview -background white -landscape QCSP/TSit/Terrain-Map1.ps"
     :wait nil )
    (values)
    ) ;let*
  ) ;defun

(defun induced-cp-order ()
  (let* ((cp-pairs ;eg '(($cp3 $cp4) ($cp1 $cp2) ($cp2 $cp3))
	  (mapcar
	   #'cdr ;peel off 'precedes and leave the cp pairings
	   (select-props-using-preds
	    (mapcar #'operator-name (plan-a *solution*))
	    '(precedes) )))
	 (ordering (pop cp-pairs)) ;eg '($cp1 $cp2 $cp3 $cp4)
	 (pairs-index cp-pairs)
	 (loopmax (length cp-pairs))
	 (count 0) )
    (loop
     (when (or (null cp-pairs)
	       (>= count loopmax) )
	   (return) )
     (cond ((equal (second (car pairs-index))
		   (first ordering) )
	    (push (first (car pairs-index)) ordering)
	    (decf count)
	    (setq cp-pairs
		  (append (ldiff cp-pairs pairs-index)
			  (cdr pairs-index) )))
	   ((equal (first (car pairs-index))
		   (first (last ordering)) )
	    (nconc ordering (rest (car pairs-index)))
	    (decf count)
	    (setq cp-pairs
		  (append (ldiff cp-pairs pairs-index)
			  (cdr pairs-index) )))
	   (t
	    (setq pairs-index
		  (if (cdr pairs-index)
		      (cdr pairs-index)
		    cp-pairs ))
	    (incf count) )))
    ordering ))

(defun induced-cp-ordering ()
  (linearize-pairs           ;eg '(($cp3 $cp4) ($cp1 $cp2) ($cp2 $cp3))
   (mapcar                   ;   '($cp1 $cp2 $cp3 $cp4)
    #'cdr ;peel off 'precedes and leave the cp pairings
    (select-props-using-preds
     (mapcar #'operator-name (plan-a *solution*))
     '(precedes) ))
   nil
   ))

(defun make-ascending-numbers-list (len &aux (count 0))
  (mapcar #'(lambda (foo) (declare (ignore foo)) (incf count))
	  (make-list len) ))

(defun interleave-lists (list1 list2)
  (apply #'append
	 (mapcar #'(lambda (e1 e2)
		     (list e1 e2) )
		 list1
		 list2 )))

(let ((terrain-f-names
       '(viewable
	 none-viewable
	 oriented-from
	 leg-clear
	 leg-lateral-space
	 item
	 subsegment
	 separation
	 terrain-type
	 same-segment-space
	 vector-intersects
	 angle-formed
	 loc-empty
	 loc-radial-space
	 collective-travel-time )))
  (defun terrain-filter-props (props)
    (select-props-using-preds props terrain-f-names) )
  )

(let ((order-f-names
       '(move-order-given-to
	 overwatching
	 contact-report-given-to
	 fire-order-given-to
	 cease-fire-order-given-to
	 stop-order-given-to )))
  (defun order-filter-props (props)
    (select-props-using-preds props order-f-names) )
  )

(let ((exercise-names
       '(Wait-in-halted-trav-formation
	 Wait-in-stat-formation
	 ;Move-from-leg-start
	 Action-drill
	 Move-out-from-stat-form
	 Move-out-from-halted-trav-formation
	 Column-traveling-formation
	 Staggered-column-traveling-formation
	 Wedge-left-traveling-formation
	 Wedge-right-traveling-formation
	 Echelon-left-traveling-formation
	 Echelon-right-traveling-formation
	 Vee-traveling-formation
	 Line-traveling-formation
	 Traveling-technique-of-movement
	 Traveling-overwatch-technique-of-movement
	 Bounding-overwatch-technique-of-movement
	 ;No-battle-drill
	 Contact-from-contact-report
	 Contact-from-sighting
	 Fire-toward-ground
	 End-fire
	 Fire-into-air
	 Veer-from-air-attack
	 ;Move-to-leg-end-nbo
	 ;Move-to-leg-end-bo
	 Halt-traveling-formation
	 Stop-in-coil
	 Stop-in-herringbone
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
