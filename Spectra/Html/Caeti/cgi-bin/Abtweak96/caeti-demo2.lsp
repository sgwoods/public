;;; caeti-demo2.lsp

(defun foo (required-opids)
  (plan *initial*
	*goal*
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:required-ops (foo-sub required-opids)
	:print-output-p t
	:plan-debug-mode t ))

(defun foo1 ()
  (foo '(sicoil mtle-nbo ttm mofsf wltf)) )

(defun foo2 ()
  (foo '(sicoil mtle-nbo ttm mofsf wltf cfcr)) )

(defun foo3 ()
  (foo '(ttm totm)) )

(defun foo-sub (required-opids)
  (mapcar #'(lambda (reqd-opid)
	      (create-new-op-instance
	       (find reqd-opid *operators*
		     :key #'operator-opid )))
	  required-opids ))



(defun caeti-demo2 (&optional (print-output? nil) (plan-debug? nil)
			      (i *initial*) (g *goal*) )
  (format t "~%~
             ~% Start condition for new exercise:~{~%~%    ~a~}~
             ~%~
             ~% End condition for new exercise:~{~%~%    ~a~}"
	  (cdr i) (cdr g) )
  (wait-for-user "Ready to start planning the new exercise?")
  (planner-demo i g
		:print-output? print-output?
		:plan-debug? plan-debug?
		:succ-continuation #'csp-demo
		:fail-continuation #'csp-failure-stmt ))

(defun wait-for-user (prompt-string)
  (clear-input)
  (format t "~%~
             ~% ~a (hit ENTER)" prompt-string )
  (read-char)
  (values) )

(defun planner-demo (i g &key print-output? plan-debug?
		       succ-continuation fail-continuation )
  (format t "~%~
             ~% Planning the new exercise..." )
  (plan i g
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:print-output-p print-output?
	:plan-debug-mode plan-debug? )
  (if *solution*
      (let* ((plan1-op-props
	      (mapcar #'operator-name (plan-a *solution*)) )
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
                   ~% Testing terrain with the new constraints..." )
	;(translate-terrain-ops-to-constraints plan1-terrain-f-op-props i)
	(tcsp)

	(if *solution-set*
	    (funcall succ-continuation) 
	  (funcall fail-continuation) )
	) ;let
    (format t "~%~
               ~% ...the planner failed to find a solution." )
    ) ;if
  ) ;defun
#|
(defun translate-terrain-filters-to-constraints (plan-terrain-filters
						 initial-state)
  (let ((i-terrain-filters ;the csp needs constrs on the initial spot also
	 (terrain-filter-props    ;a] assume only 1 op, not a plan, is adequate
	  (operator-preconditions ;b] assume 1st op found is adequate
	   (caar (select-ops
		  (remove 'wisf
			  (remove 'wihtf *operators* :key #'operator-opid)
			  :key #'operator-opid )
		  (or (assoc 'in-stat-form (cdr initial-state))
		      (assoc 'stopped-at (cdr initial-state)) ))))))
	(node-constraints nil)
	(arc-constraints nil)
	(empty-terrain-types '(Plain Forest))
	filter-name key node-c arc-c )
    (setq *ptfs* plan-terrain-filters ;for testing
	  *itfs* i-terrain-filters )
    (goo)
    (dolist (filter1 (append i-terrain-filters plan-terrain-filters))
	    (setq key (second filter1) ;gridpoint of constraint
		  filter-name (first filter1) )
	    (case filter-name
		  ;viewable, none-viewable, oriented-from, item, subsegment,
		  ;separation, terrain-type, same-segment-space,
		  ;vector-intersects, angle-formed, collective-travel-time
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
		   (if (setq arc-c (assoc key arc-constraints :key #'caadr))
		       (format t "~%~%Duplicate filters A: ~s~
                                    ~%                  B: ~s"
			       arc-c filter1 )
		     (push (list filter-name
				 (list (second filter1) (third filter1))
				 (cdr (fourth filter1)) )
			   arc-constraints )))
		  (leg-clear
		   (if (setq arc-c (assoc key arc-constraints :key #'caadr))
		       (format t "~%~%Duplicate filters A: ~s~
                                    ~%                  B: ~s"
			       arc-c filter1 )
		     (push (list filter-name
				 (list (second filter1) (third filter1)) )
			   arc-constraints )))
		  ) ;case
	    ) ;dolist
    (push (list "users-terrain-template" node-constraints arc-constraints nil)
	  *template-object-list* ) ;purge this global list periodically!!!!!!
    ) ;let
  ) ;defun

(defun goo ()
  (pprint *pt-ops*) (terpri)
  (pprint *i-ops*) (terpri)
  (pprint (cdr (fourth *template-object-list*)))
  )
|#
(defun csp-failure-stmt ()
  (format t "~%~
             ~% ...failure to map the planned exercise ~
                          to the terrain." ))

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
  (total-ordering-from-pairs ;eg '(($cp3 $cp4) ($cp1 $cp2) ($cp2 $cp3))
   (mapcar                   ;   '($cp1 $cp2 $cp3 $cp4)
    #'cdr ;peel off 'precedes and leave the cp pairings
    (select-props-using-preds
     (mapcar #'operator-name (plan-a *solution*))
     '(precedes) ))))

(defun total-ordering-from-pairs (pairs)
  (let ((orderings (flat-orderings-from-pairs pairs)))
    (and orderings
	 (if (cdr orderings)
	     (format t "~%Cannot derive a total ordering from:~
                        ~%     ~s~
                        ~%   A best partial ordering is:~
                        ~%     ~s"
		     pairs orderings )
	   (car orderings) ))))

(defun flat-orderings-from-pairs (order-pairs &key (test #'eq))
  (setq order-pairs    ;eg '((3 4)(1 2)(2 3)(11 12)(9 10)(6 7)(4 5)(5 6)(8 9))
	(my-copy-alist order-pairs) ) ; to '((1 2 3 4 5 6 7) (11 12) (8 9 10))
  (let (pairs tail-index skipped-any-before-succ?
	      succ? success?)
    (dotimes
     (count1 (1- (length order-pairs)) order-pairs)
     (setf pairs (nthcdr count1 order-pairs)
	   tail-index (cdr pairs)
	   skipped-any-before-succ? nil
	   succ? nil
	   success? nil )
     (when (null tail-index)
	   (return-from flat-orderings-from-pairs order-pairs) )
     (loop
      (cond ((funcall test
		      (first (car tail-index)) ;eg h=(... a b) t=(b c ...)
		      (first (last (car pairs))) )
	     (nconc (car pairs)
		    (rest (car tail-index)) )
	     (setf order-pairs (delete (car tail-index) order-pairs)
		   succ? t
		   success? t ))
	    ((funcall test
		      (first (last (car tail-index))) ;eg t=(...b c) h=(c d...)
		      (first (car pairs)) )
	     (setf (car pairs) (append (car tail-index)
				       (cdar pairs) )
		   order-pairs (delete (car tail-index) order-pairs)
		   succ? t
		   success? t ))
	    (t
	     (setf skipped-any-before-succ? (or skipped-any-before-succ?
						(not succ?) )
		   succ? nil )))
      (setf tail-index (cdr tail-index))
      (unless tail-index
	      (if (and success? skipped-any-before-succ?)
		  (setf success? nil
			skipped-any-before-succ? nil
			tail-index (nthcdr (1+ count1) order-pairs) )
		(return) )))))) ;return only from the loop, not the dotimes
#|
(defsetf my-position (old-val1 list1) (new-val1) ;; 'my-position' need not be defined itself
  `(let ((index1 (position ,old-val1 ,list1)))
     (if index1
	 (setf (car (nthcdr index1 ,list1)) ,new-val1)
       (error "setf position - ~a does not appear in ~a" ,old-val1 ,list1) )))
|#
(defun my-copy-alist (a-list) ;'copy-alist' reuses the cdr of each pair,
  (mapcar #'copy-list a-list) ) ; making it useless

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
    (sort
     (select-props-using-preds props order-f-names)
     #'string-lessp ;just places 'move's before 'stop's
     :key #'(lambda (prop1) (symbol-name (car prop1)))
     ))
  )

(let ((exercise-names
       '(Wait-in-halted-trav-formation
	 Wait-in-stat-formation
	 ;Move-from-leg-start
	 Action-drill-left
	 Action-drill-right
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
