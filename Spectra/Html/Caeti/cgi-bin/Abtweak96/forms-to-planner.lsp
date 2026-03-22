;;; forms-to-planner.lsp

(defun demo (&key theStartForm 
		  (theStartCoords nil)
		  (theEndCoords nil)
		  (one-leg? nil) 
		  Leg1Tform 
		  Leg1TravT 
		  Leg1BDrill 
		  Leg1StopForm
		  (two-legs? nil) 
		  Leg2Tform Leg2TravT 
		  Leg2BDrill 
		  Leg2StopForm
		  (three-legs? nil) 
		  Leg3Tform 
		  Leg3TravT 
		  Leg3BDrill 
		  Leg3StopForm
		  (MinDuration nil)
		  (MaxDuration nil)
		  )
  (let* ((min-dur (and MinDuration (parse-integer MinDuration)))
	 (max-dur (and MaxDuration (parse-integer MaxDuration)))
	 (halting-battle-actions '(pad damaa dapaa))
	 (halt-actions '(htf hbo))
	 i-state-x
	 i-state-y
	 (i-state-xy
	  (cond (theStartCoords
		 (setq i-state-x (parse-integer theStartCoords :end 3)
		       i-state-y (parse-integer theStartCoords :start 3) )
		 (list i-state-x i-state-y) ) ;change to dotted pair?
		(t
		 (gentemp "cp") )))
	 (i-state-stat-form
	  (cond ((equalp "Coil" theStartForm)          'coil)
		((equalp "Herringbone" theStartForm)   'herringbone)
		((equalp "Halted_Column" theStartForm) 'halted-column)
		((equalp "Halted_Wedge" theStartForm)  'halted-wedge)
		((equalp "Halted_Bounding_Overwatch" theStartForm)
		 'halted-bounding-overwatch )
		(t                                     'herringbone) ))
	 (l1-mv-out-method
	  (and one-leg?
	       (cond ((equalp "React_to_indirect_fire_drill" Leg1BDrill)
		      (case i-state-stat-form
			    ((coil herringbone) 'rtifd-sf)
			    ((halted-column halted-wedge) 'rtifd-htf)
			    (halted-bounding-overwatch 'rtifd-hbo) ))
		     (t
		      ;nil
		      (case i-state-stat-form
			    ((coil herringbone) 'mofsf)
			    ((halted-column halted-wedge) 'mofhtf)
			    (halted-bounding-overwatch 'mofhbo) )))))
	 (l1-tform
	  (and one-leg?
	       (cond ((equalp "Column" Leg1Tform)                  'ticf)
		     ((equalp "Staggered_column" Leg1Tform)        'tiscf)
		     ((equalp "Wedge" Leg1Tform)                   'tiwf)
		     ((equalp "Echelon" Leg1Tform)                 'tief)
		     ((equalp "Vee" Leg1Tform)                     'tivf)
		     ((equalp "Line" Leg1Tform)                    'tilf)
		     ((equalp "NONE_Bounding_overwatch" Leg1Tform) 'no-tf)
		     (t #|nil|# 'tiwf) )))
	 (l1-tmethod
	  (and one-leg?
	       (cond ((equalp "Traveling_technique" Leg1TravT) 'ntm)
		     ((equalp "Traveling_overwatch" Leg1TravT) 'two)
		     ((equalp "Bounding_overwatch"  Leg1TravT) 'twbo)
		     ((equalp "Tactical_road_march" Leg1TravT) 'trm)
		     (t #|nil|# 'ntm) )))
	 (l1-drill
	  (and one-leg?
	       (cond ;((equalp "NONE" Leg1BDrill) nil)
		     ((equalp "Pass_land-based_enemy" Leg1BDrill) 'plbeu)
		     ((equalp "Contact_w_small_arms" Leg1BDrill) 'cwsafd)
		     ((equalp "Passive_air_defense" Leg1BDrill) 'pad)
		     ((equalp "Defend_against_moving_air_attack" Leg1BDrill)
		      'damaa )
		     ((equalp "Defend_against_popup_air_attack" Leg1BDrill)
		      'dapaa )
		     (t 'nbd) ))) ;includes action drill & rtif variants
	 (l1-stop-form
	  (and one-leg?
	       (cond ((find l1-drill halting-battle-actions)
		      (if (eq 'twbo l1-tmethod) 'hbo 'htf) )
		     ((equalp "Coil" Leg1StopForm) 'sicf)
		     ((equalp "Herringbone" Leg1StopForm) 'sihf)
		     ((equalp "Halt_in_form" Leg1StopForm) 'htf)
		     ((equalp "Halt_bounding_overwatch" Leg1StopForm) 'hbo)
		     (t 'no-stop) )))
	 (l2-mv-out-method
	  (and two-legs?
	       (cond ((equalp "Action_to_avoid_obstacle" Leg2BDrill) 'codtao)
		     ((equalp "Action_to_avoid_impact_area" Leg2BDrill)
		      'codtaia )
		     ((equalp "Action_to_assault_enemy" Leg2BDrill) 'codtae)
		     ((equalp "React_to_indirect_fire_drill" Leg2BDrill)
		      (case l1-stop-form
			    ((sicf sihf) 'rtifd-sf)
			    (htf 'rtifd-htf)
			    (hbo 'rtifd-hbo) ))
		     (t
		      ;nil
		      (case l1-stop-form
			    ((sicf sihf) 'mofsf)
			    (htf 'mofhtf)
			    (hbo 'mofhbo)
			    (t 'mfls) )))))
	 (l2-tform
	  (and two-legs?
	       (cond ((equalp "Column" Leg2Tform)                  'ticf)
		     ((equalp "Staggered_column" Leg2Tform)        'tiscf)
		     ((equalp "Wedge" Leg2Tform)                   'tiwf)
		     ((equalp "Echelon" Leg2Tform)                 'tief)
		     ((equalp "Vee" Leg2Tform)                     'tivf)
		     ((equalp "Line" Leg2Tform)                    'tilf)
		     ((equalp "NONE_Bounding_overwatch" Leg2Tform) 'no-tf)
		     (t #|nil|# 'tiwf) )))
	 (l2-tmethod
	  (and two-legs?
	       (cond ((equalp "Traveling_technique" Leg2TravT) 'ntm)
		     ((equalp "Traveling_overwatch" Leg2TravT) 'two)
		     ((equalp "Bounding_overwatch"  Leg2TravT) 'twbo)
		     ((equalp "Tactical_road_march" Leg2TravT) 'trm)
		     (t #|nil|# 'ntm) )))
	 (l2-drill
	  (and two-legs?
	       (cond ;((equalp "NONE" Leg2BDrill) nil)
		     ((equalp "Pass_land-based_enemy" Leg2BDrill) 'plbeu)
		     ((equalp "Contact_w_small_arms" Leg2BDrill) 'cwsafd)
		     ((equalp "Passive_air_defense" Leg2BDrill) 'pad)
		     ((equalp "Defend_against_moving_air_attack" Leg2BDrill)
		      'damaa )
		     ((equalp "Defend_against_popup_air_attack" Leg2BDrill)
		      'dapaa )
		     (t 'nbd) ))) ;includes action drill & rtif variants
	 (l2-stop-form
	  (and two-legs?
	       (cond ((find l2-drill halting-battle-actions)
		      (if (eq 'twbo l2-tmethod) 'hbo 'htf) )
		     ((equalp "Coil" Leg2StopForm) 'sicf)
		     ((equalp "Herringbone" Leg2StopForm) 'sihf)
		     ((equalp "Halt_in_form" Leg2StopForm) 'htf)
		     ((equalp "Halt_bounding_overwatch" Leg2StopForm) 'hbo)
		     (t 'no-stop) )))
	 (l3-mv-out-method
	  (and three-legs?
	       (cond ((equalp "Action_to_avoid_obstacle" Leg3BDrill) 'codtao)
		     ((equalp "Action_to_avoid_impact_area" Leg3BDrill)
		      'codtaia )
		     ((equalp "Action_to_assault_enemy" Leg3BDrill) 'codtae)
		     ((equalp "React_to_indirect_fire_drill" Leg3BDrill)
		      (case l2-stop-form
			    ((sicf sihf) 'rtifd-sf)
			    (htf 'rtifd-htf)
			    (hbo 'rtifd-hbo) ))
		     (t
		      ;nil
		      (case l2-stop-form
			    ((sicf sihf) 'mofsf)
			    (htf 'mofhtf)
			    (hbo 'mofhbo)
			    (t 'mfls) )))))
	 (l3-tform
	  (and three-legs?
	       (cond ((equalp "Column" Leg3Tform)                  'ticf)
		     ((equalp "Staggered_column" Leg3Tform)        'tiscf)
		     ((equalp "Wedge" Leg3Tform)                   'tiwf)
		     ((equalp "Echelon" Leg3Tform)                 'tief)
		     ((equalp "Vee" Leg3Tform)                     'tivf)
		     ((equalp "Line" Leg3Tform)                    'tilf)
		     ((equalp "NONE_Bounding_overwatch" Leg3Tform) 'no-tf)
		     (t #|nil|# 'tiwf) )))
	 (l3-tmethod
	  (and three-legs?
	       (cond ((equalp "Traveling_technique" Leg3TravT) 'ntm)
		     ((equalp "Traveling_overwatch" Leg3TravT) 'two)
		     ((equalp "Bounding_overwatch"  Leg3TravT) 'twbo)
		     ((equalp "Tactical_road_march" Leg3TravT) 'trm)
		     (t #|nil|# 'ntm) )))
	 (l3-drill
	  (and three-legs?
	       (cond ;((equalp "NONE" Leg3BDrill) nil)
		     ((equalp "Pass_land-based_enemy" Leg3BDrill) 'plbeu)
		     ((equalp "Contact_w_small_arms" Leg3BDrill) 'cwsafd)
		     ((equalp "Passive_air_defense" Leg3BDrill) 'pad)
		     ((equalp "Defend_against_moving_air_attack" Leg3BDrill)
		      'damaa )
		     ((equalp "Defend_against_popup_air_attack" Leg3BDrill)
		      'dapaa )
		     (t 'nbd) ))) ;includes action drill & rtif variants
	 (l3-stop-form
	  (and three-legs?
	       (cond ((find l3-drill halting-battle-actions)
		      (if (eq 'twbo l3-tmethod) 'hbo 'htf) )
		     ((equalp "Coil" Leg3StopForm) 'sicf)
		     ((equalp "Herringbone" Leg3StopForm) 'sihf)
		     ((equalp "Halt_in_form" Leg3StopForm) 'htf)
		     ((equalp "Halt_bounding_overwatch" Leg3StopForm) 'hbo)
		     (t 'no-stop) )))
	 g-state-x
	 g-state-y
	 (g-state-xy
	  (cond (theEndCoords
		 (setq g-state-x (parse-integer theEndCoords :end 3)
		       g-state-y (parse-integer theEndCoords :start 3) )
		 (list g-state-x g-state-y) ) ;SGW's unifier won't work for
		(t                            ; dotted pairs
		 (gentemp "cp") )))

	 (l1-end-coord (gentemp "cp"))
	 (l1-reqd-opids nil)
	 (l1-i-state
	  (and one-leg?
	       (cons i-state-xy
		     (case i-state-stat-form
			   ((coil herringbone)
			   `((in-stat-formation White ,i-state-xy
						,i-state-stat-form
						,(gentemp "$security")
						0.0 )))
			   (halted-column
			    `((stopped-at White ,i-state-xy 0.0)
			      (in-trav-formation White ,i-state-xy ,i-state-xy
						 Column ,(gentemp "$ff")
						 ,(gentemp "$lf")
						 ,(gentemp "$rf")
						 ,(gentemp "$tmethod") )))
			   (halted-wedge
			    `((stopped-at White ,i-state-xy 0.0)
			      (in-trav-formation White ,i-state-xy ,i-state-xy
						 Wedge ,(gentemp "$ff")
						 ,(gentemp "$lf")
						 ,(gentemp "$rf")
						 ,(gentemp "$tmethod") )))
			   (halted-bounding-overwatch
			    `((stopped-at White ,i-state-xy 0.0)) )
			   ))))
	 (l1-time (gentemp "$exec-time"))
	 (l1-g-state ;used as part of l2-i-state
	  (and one-leg?
	       (prog1 t (when l1-mv-out-method
			      (push l1-mv-out-method l1-reqd-opids) ))
	       (cons l1-end-coord
		     (case l1-stop-form
			   ((sicf sihf)
			    (push l1-stop-form l1-reqd-opids)
			    `((in-stat-formation White ,l1-end-coord
						 ,(if (eq 'sicf l1-stop-form)
						      'coil 'herringbone )
						 ,(gentemp "$security")
						 ,l1-time )))
			   (hbo
			    (push l1-stop-form l1-reqd-opids)
			    `((stopped-at White ,l1-end-coord ,l1-time)) )
			   (htf
			    (push l1-stop-form l1-reqd-opids)
			    `((stopped-at White ,l1-end-coord ,l1-time)
			      (in-trav-formation
			       White ,i-state-xy
			       ,l1-end-coord
			       ,(case l1-tform
				      (ticf 'column)
				      (tiscf 'staggered-column)
				      (tiwf 'wedge)
				      (tief 'echelon)
				      (tivf 'vee)
				      (tilf 'line)
				      (t (gentemp "$tform")) )
			       ,(gentemp "$ff")
			       ,(gentemp "$lf")
			       ,(gentemp "$rf")
			       ,(gentemp "$tmethod") )))
			   (t ;travel through without stopping
			    `((at-location White ,l1-end-coord ,l1-time)
			      (moving-along-leg White ,i-state-xy
						,l1-end-coord
						,(gentemp "$security")
						,(gentemp "$method") )))))))
	 (l2-reqd-opids nil)
	 (l2-end-coord (gentemp "cp"))
	 (l2-time (gentemp "$exec-time"))
	 (l2-g-state ;used as part of l3-i-state
	  (and two-legs?
	       (prog1 t (when l2-mv-out-method
			      (push l2-mv-out-method l2-reqd-opids) ))
	       (cons l2-end-coord
		     (case l2-stop-form
			   ((sicf sihf)
			    (push l2-stop-form l2-reqd-opids)
			    `((in-stat-formation White ,l2-end-coord
						 ,(if (eq 'sicf l2-stop-form)
						      'coil 'herringbone )
						 ,(gentemp "$security")
						 ,l2-time )))
			   (hbo
			    (push l2-stop-form l2-reqd-opids)
			    `((stopped-at White ,l2-end-coord ,l2-time)) )
			   (htf
			    (push l2-stop-form l2-reqd-opids)
			    `((stopped-at White ,l2-end-coord ,l2-time)
			      (in-trav-formation
			       White ,l1-end-coord
			       ,l2-end-coord
			       ,(case l2-tform
				      (ticf 'column)
				      (tiscf 'staggered-column)
				      (tiwf 'wedge)
				      (tief 'echelon)
				      (tivf 'vee)
				      (tilf 'line)
				      (t (gentemp "$tform")) )
			       ,(gentemp "$ff")
			       ,(gentemp "$lf")
			       ,(gentemp "$rf")
			       ,(gentemp "$tmethod") )))
			   (t ;move through without stopping
			    `((at-location White ,l2-end-coord ,l2-time)
			      (moving-along-leg White ,l1-end-coord
						,l2-end-coord
						,(gentemp "$security")
						,(gentemp "$method") )))))))
	 (l3-reqd-opids nil)
	 (l3-time (gentemp "$exec-time"))
	 (l3-g-state
	  (and three-legs?
	       (prog1 t (when l3-mv-out-method
			      (push l3-mv-out-method l3-reqd-opids) ))
	       (cons g-state-xy
		     (case l3-stop-form
			   ((sicf sihf)
			    (push l3-stop-form l3-reqd-opids)
			    `((in-stat-formation White ,g-state-xy
						 ,(if (eq 'sicf l3-stop-form)
						      'coil 'herringbone )
						 ,(gentemp "$security")
						 ,l3-time )))
			   (hbo
			    (push l3-stop-form l3-reqd-opids)
			    `((stopped-at White ,g-state-xy ,l3-time)) )
			   (htf
			    (push l3-stop-form l3-reqd-opids)
			    `((stopped-at White ,g-state-xy ,l3-time)
			      (in-trav-formation
			       White ,l2-end-coord
			       ,g-state-xy
			       ,(case l3-tform
				      (ticf 'column)
				      (tiscf 'staggered-column)
				      (tiwf 'wedge)
				      (tief 'echelon)
				      (tivf 'vee)
				      (tilf 'line)
				      (t (gentemp "$tform")) )
			       ,(gentemp "$ff")
			       ,(gentemp "$lf")
			       ,(gentemp "$rf")
			       ,(gentemp "$tmethod") )))))))
	 (additional-constraints nil)
	 (l2-i-state l1-g-state)
	 (l3-i-state l2-g-state)
	 l1-actions l1-orders l1-constraints
	 l2-actions l2-orders l2-constraints
	 l3-actions l3-orders l3-constraints
	 last-i-state mapping
	 ) ;let*
    (when min-dur
	  (push `(< ,min-dur ,l3-time) additional-constraints) )
    (when max-dur
	  (push `(< ,l3-time ,max-dur) additional-constraints) )

    (unless (or (null l1-tform)
		(eq 'no-tf l1-tform) )
	    (push l1-tform l1-reqd-opids) )
    (when l1-tmethod (push l1-tmethod l1-reqd-opids))
    (when l1-drill (push l1-drill l1-reqd-opids))
    (if (intersection halting-battle-actions l1-reqd-opids)
	(setq l1-reqd-opids
	      (remove
	       'hbo
	       (remove 'htf (remove 'sicf (remove 'sihf l1-reqd-opids))) ))
      (when (and l1-tmethod
		 (null (intersection halt-actions l1-reqd-opids)) )
	    (push (if (eq 'twbo l1-tmethod) 'mtlefbo 'mtlefnbo)
		  l1-reqd-opids )))

    (unless (or (null l2-tform)
		(eq 'no-tf l2-tform) )
	    (push l2-tform l2-reqd-opids) )
    (when l2-tmethod (push l2-tmethod l2-reqd-opids))
    (when l2-drill (push l2-drill l2-reqd-opids))
    (if (intersection halting-battle-actions l2-reqd-opids)
	(setq l2-reqd-opids
	      (remove
	       'hbo
	       (remove 'htf (remove 'sicf (remove 'sihf l2-reqd-opids))) ))
      (when (and l2-tmethod
		 (null (intersection halt-actions l2-reqd-opids)) )
	    (push (if (eq 'twbo l2-tmethod) 'mtlefbo 'mtlefnbo)
		  l2-reqd-opids )))

    (unless (or (null l3-tform)
		(eq 'no-tf l3-tform) )
	    (push l3-tform l3-reqd-opids) )
    (when l3-tmethod (push l3-tmethod l3-reqd-opids))
    (when l3-drill (push l3-drill l3-reqd-opids))
    (if (intersection halting-battle-actions l3-reqd-opids)
	(setq l3-reqd-opids
	      (remove
	       'hbo
	       (remove 'htf (remove 'sicf (remove 'sihf l3-reqd-opids))) ))
      (when (and l3-tmethod
		 (null (intersection halt-actions l3-reqd-opids)) )
	    (push (if (eq 'twbo l3-tmethod) 'mtlefbo 'mtlefnbo)
		  l3-reqd-opids )))


    ;; for debugging
    (with-open-file
     (out-stream "Test/forms-parser.out"
		 :direction :output
		 :if-exists :supersede
		 :if-does-not-exist :create)
     (format out-stream
	     "~%Plan requirements parsed from Html form~
               ~%~
               ~%  Initial state: ~a~
               ~%    1st leg required opids: ~a~
               ~%    1st leg goal: ~a~
               ~%~
               ~%    2nd leg initial state: ~a~
               ~%    2nd leg required opids: ~a~
               ~%    2nd leg goal: ~a~
               ~%~
               ~%    3rd leg initial state: ~a~
               ~%    3rd leg required opids: ~a~
               ~%  Goal state: ~a~
               ~%~
               ~%  Additional constraints: ~a"
	    l1-i-state l1-reqd-opids l1-g-state
	    l2-i-state l2-reqd-opids l2-g-state
	    l3-i-state l3-reqd-opids l3-g-state
	    additional-constraints ))
    ;(break)

    ;; Because the system generates plans from G to I, we have to start
    ;;  planning the exercise from its last leg.  As each leg is
    ;;  instantiated, the binds of its plan must be passed to the next
    ;;  leg so that start/end codes constraints ACROSS legs are maintained.


    ;; for debugging
    (with-open-file
     (out-stream "Test/planner.out"
		 :direction :output
		 :if-exists :supersede
		 :if-does-not-exist :create)

     (setq *solution* nil
	   *open* nil )
     (format out-stream "~%=============LEG 3==============================~%")
     (multiple-value-setq (l3-actions l3-orders l3-constraints)
			  (plan-scenario l3-i-state l3-g-state l3-reqd-opids
					 :debug-stream out-stream ))
     (setq last-i-state
	   (operator-effects
	    (find 'i (plan-a *solution*)
		  :key #'operator-opid ))
	   *solution* nil
	   *open* nil
	   mapping (poss-codesignates-p (cdr l2-g-state) last-i-state) )
     (if mapping
	 (unless (eq t mapping)
		 (format out-stream "~%Applying mapping ~s to Leg 2 G: ~s"
			 mapping l2-g-state )
		 (setq l2-g-state (instantiate l2-g-state mapping)) )
       (format out-stream "~%I of Leg 3: ~s~
                           ~% does not match~
                           ~%G of Leg 2: ~s"
	       last-i-state (cdr l2-g-state) ))

     (format out-stream "~%=============LEG 2==============================~%")
     (multiple-value-setq (l2-actions l2-orders l2-constraints)
			  (plan-scenario l2-i-state l2-g-state l2-reqd-opids
					 :debug-stream out-stream ))
     (setq last-i-state
	   (operator-effects
	    (find 'i (plan-a *solution*)
		  :key #'operator-opid ))
	   *solution* nil
	   *open* nil
	   mapping (poss-codesignates-p (cdr l1-g-state) last-i-state) )
     (if mapping
	 (unless (eq t mapping)
		 (format out-stream "~%Applying mapping ~s to Leg 1 G: ~s"
			 mapping l1-g-state )
		 (setq l1-g-state (instantiate l1-g-state mapping)) )
       (format out-stream "~%I of Leg 2: ~s~
                           ~% does not match~
                           ~%G of Leg 1: ~s"
	       last-i-state (cdr l1-g-state) ))

     (format out-stream "~%=============LEG 1==============================~%")
     (multiple-value-setq (l1-actions l1-orders l1-constraints)
			  (plan-scenario l1-i-state l1-g-state l1-reqd-opids
					 :debug-stream out-stream ))

     (format out-stream
	     "~%~
               ~% SCENARIO SOLUTION FOUND!~
               ~%~
               ~% The new exercise contains these actions:~{~%~%    ~a~}~
	       ~%~
               ~% The training table for the new exercise ~
                             is:~{~%~%    ~a~}~
	       ~%~
               ~% The new exercise also places constraints ~
                             on the scenario:~{~%~%    ~a~}"
	    (append l1-actions l2-actions l3-actions)
	    (append l1-orders l2-orders l3-orders)
	    (append l1-constraints l2-constraints l3-constraints
		    additional-constraints )
	    ) ;format
     ) ;with-open-file

    ;; Collect all of the unfulfilled enabling conditions of all these
    ;;  plans, plus the additional constraints supplied by the user,
    ;;  and pass them off to the CSP engine.

    ))

;;;;;; DEBUG


(defun test0 () ;from ../DemoDir/demo.lisp
  (demo 
   :theStartForm "Herringbone"
   :theStartCoords "390175"
   :MinDuration "60"
   :MaxDuration "180"
   :one-leg? "on"
   :Leg1Tform "Column"
   :Leg1TravT "Traveling_technique"
   :Leg1BDrill "Contact_w_small_arms"
   :Leg1StopForm "NONE"
   :two-legs? "on"
   :Leg2Tform "NONE_bounding_overwatch"
   :Leg2TravT "Bounding_overwatch"
   :Leg2BDrill "Defend_against_popup_air_attack"
   :Leg2StopForm "Halt_bounding_overwatch"
   :three-legs? "on"
   :Leg3Tform "Vee"
   :Leg3TravT "Traveling_overwatch"
   :Leg3BDrill "NONE"
   :Leg3StopForm "Coil"
   ))

(defun test1 () ;for LEG 1
  (plan-scenario
   '((390 175)
     (IN-STAT-FORMATION WHITE (390 175) HERRINGBONE $security2 0.0))
   '(cp1 (AT-LOCATION WHITE cp1 $exec-time3)
	 (MOVING-ALONG-LEG WHITE (390 175) cp1 $security4
			   $method5))
   '(MTLEFNBO CWSAFD NTM TICF MOFSF)
   :debug-stream t ))

(defun test2 () ;for LEG 2
  (plan-scenario
   '(cp1 (AT-LOCATION WHITE cp1 $exec-time3)
	 (MOVING-ALONG-LEG WHITE (390 175) cp1 $security4
			   $method5))
   '(cp6 (STOPPED-AT WHITE cp6 $exec-time7))
   '(DAPAA TWBO MFLS)
   :debug-stream t ))

(defun test3 () ;for LEG 3
  (plan-scenario
   '(cp6 (STOPPED-AT WHITE cp6 $exec-time7))
   '(cp0
     (IN-STAT-FORMATION WHITE cp0 COIL $security9 $exec-time8))
   '(MTLEFNBO NBD TWO TIVF SICF MOFHBO)
   :debug-stream t ))

#|
;; these don't have defaults for the various stages

;; dp isn't aiming for planning-without-defaults for the time being, because
;;  debugging it is very time-consuming and we'll probably switch to a
;;  case base anyway 7/10/97

(defun test4 () ;for LEG 1
  (plan-scenario
   '((390 175)
     (IN-STAT-FORMATION WHITE (390 175) herringbone $security2 0.0))
   '(cp15 (AT-LOCATION WHITE cp15 $exec-time3)
	  (MOVING-ALONG-LEG WHITE (390 175) cp1 $security4
			    $method5))
   '(CWSAFD NTM TICF)
   :debug-stream t ))

(defun test5 () ;for LEG 2
  (plan-scenario
   '(cp1 (AT-LOCATION WHITE cp1 $exec-time3)
	 (MOVING-ALONG-LEG WHITE (390 175) cp1 $security4
			   $method5))
   '(cp6 (STOPPED-AT WHITE cp6 $exec-time7))
   '(DAPAA TWBO)
   :debug-stream t ))

(defun test6 () ;for LEG 3
  (plan-scenario
   '(cp6 (STOPPED-AT WHITE cp6 $exec-time7))
   '(cp0
     (IN-STAT-FORMATION WHITE cp0 COIL $security14 $exec-time13))
   '(TWO TIVF SICF)
   :debug-stream t ))
|#

(defun test7 () ;from ../DemoDir/demo.lisp
  (demo 
   :theStartForm "Herringbone"
   :theStartCoords "390175"
   :MinDuration "120"
   :MaxDuration "600"
   :one-leg? "on"
   :Leg1Tform "Echelon"
   :Leg1TravT "Tactical_road_march"
   :Leg1BDrill "React_to_indirect_fire_drill"
   :Leg1StopForm "NONE"
   :two-legs? "on"
   :Leg2Tform "Staggered_column"
   :Leg2TravT "Traveling_overwatch"
   :Leg2BDrill "Action_to_avoid_obstacle"
   :Leg2StopForm "Halt_in_form"
   :three-legs? "on"
   :Leg3Tform "Wedge"
   :Leg3TravT "Traveling_technique"
   :Leg3BDrill "Pass_land-based_enemy"
   :Leg3StopForm "Coil"
   ))

(defun test8 () ;for LEG 1
  (plan-scenario
   '((390 175)
     (IN-STAT-FORMATION WHITE (390 175) HERRINGBONE
			$security2 0.0))
   '(cp1
     (AT-LOCATION WHITE cp1 $exec-time3)
     (MOVING-ALONG-LEG WHITE (390 175) cp1 $security4
		       $method5))
   '(MTLEFNBO NBD TRM TIEF RTIFD-SF)
   :debug-stream t ))

(defun test9 () ;for LEG 2
  (plan-scenario
   '(cp1
     (AT-LOCATION WHITE cp1 $exec-time3)
     (MOVING-ALONG-LEG WHITE (390 175) cp1
		       $security4 $method5))
   '(cp6
     (STOPPED-AT WHITE cp6 $exec-time7)
     (IN-TRAV-FORMATION WHITE cp1 cp6 STAGGERED-COLUMN
			$ff8 $lf9 $rf10 $tmethod11))
   '(NBD TWO TISCF HTF CODTAO)
   :debug-stream t ))

(defun test10 () ;for LEG 3
  (plan-scenario
   '(cp6
     (STOPPED-AT WHITE cp6 $exec-time7)
     (IN-TRAV-FORMATION WHITE cp1 cp6
			STAGGERED-COLUMN $ff8 $lf9 $rf10
			$tmethod11))
   '(cp0
     (IN-STAT-FORMATION WHITE cp0 COIL $security13
			$exec-time12))
   '(MTLEFNBO PLBEU NTM TIWF SICF MOFHTF)
   :debug-stream t ))

(defun test11 ()
  (demo
   :theStartForm "Halted_Bounding_Overwatch"
   :theStartCoords "390175"
   :theEndCoords "420280"
   :MinDuration "60"
   :MaxDuration "180"
   :one-leg? "on"
   :Leg1Tform "Wedge"
   :Leg1TravT "Traveling_technique"
   :Leg1BDrill "React_to_indirect_fire_drill"
   :Leg1StopForm "NONE"
   :two-legs? "on"
   :Leg2Tform "Line"
   :Leg2TravT "Traveling_technique"
   :Leg2BDrill "Action_to_assault_enemy"
   :Leg2StopForm "NONE"
   :three-legs? "on"
   :Leg3Tform "Wedge"
   :Leg3TravT "Traveling_technique"
   :Leg3BDrill "Passive_air_defense"
   :Leg3StopForm "Halt_in_form"
   ))

(defun test12 () ;for LEG 1
  (plan-scenario
   '((390 175)
     (STOPPED-AT WHITE (390 175) 0.0))
   '(cp0
     (AT-LOCATION WHITE cp0 $exec-time1)
     (MOVING-ALONG-LEG WHITE (390 175) cp0 $security2
		       $method3))
   '(MTLEFNBO NBD NTM TIWF RTIFD-HBO)
   :debug-stream t ))

(defun test13 () ;for LEG 2
  (plan-scenario
   '(cp0
     (AT-LOCATION WHITE cp0 $exec-time1)
     (MOVING-ALONG-LEG WHITE (390 175) cp0
		       $security2 $method3))
   '(cp4
     (AT-LOCATION WHITE cp4 $exec-time5)
     (MOVING-ALONG-LEG WHITE cp0 cp4 $security6 $method7))
   '(MTLEFNBO NBD NTM TILF CODTAE)
   :debug-stream t ))

(defun test14 () ;for LEG 3
  (plan-scenario
   '(cp4
     (AT-LOCATION WHITE cp4 $exec-time5)
     (MOVING-ALONG-LEG WHITE cp0 cp4 $security6
		       $method7))
   '((420 280)
     (STOPPED-AT WHITE (420 280) $exec-time8)
     (IN-TRAV-FORMATION WHITE cp4 (420 280) WEDGE $ff9 $lf10
			$rf11 $tmethod12))
   '(PAD NTM TIWF MFLS)
   :debug-stream t ))
