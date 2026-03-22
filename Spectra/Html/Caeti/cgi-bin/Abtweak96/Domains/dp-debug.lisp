
;; ---------------------------------------------------------------------------
;; Debugging aids
;; ---------------------------------------------------------------------------

(setq *initial*
      '(
	(in-stat-formation White cp1 Herringbone 
			   $security1 $exec-speed1 $mo-speed1)
	(NOT firing-on White $xy3 $direct-or-indirect
	     $xy1 $xy2 )
	))

(setq *goal*
      '(
	(in-stat-formation White cp5 Coil 
			   $security2 $exec-speed2 $mo-speed2)
	))

(defun pm () (plan *initial* *goal* :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))


;; These are some items that may be useful for testing whether the
;;  planner selects the right op at a specific point in an
;;  anticipated plan.

(defun dp () (setq *dp-debug-mode* (not *dp-debug-mode*)))

(setq ;----------------------------------------------------------
      ; MOVE OUT

      ;for Mfls
      *i1* '((at-location White cp1)
	     (moving-along-leg White cp0 cp1 $sp2 $sec2 $meth2)
	     (NOT firing-on White $xy3 $direct-or-indirect
		  $xy1 $xy2 ))

      ;for Mfls
      *g1* '((started-on-leg White cp1 cp5 Move-From $tf $meth))

      ;----------------------------------------------------------
      ; TRAVEL FORMATIONS

      ;for Column
      *i2-1* '((started-on-leg White cp1 cp5 $movement Column $meth)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Wedge-l
      *i2-2* '((started-on-leg White cp1 cp5 $movement Wedge-l $meth)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Wedge-l
      *g2* '((in-trav-formation White cp1 cp5 Wedge-l $ff $fl $fr $meth))

      ;----------------------------------------------------------
      ; TRAVEL METHODS

      ;for Traveling technique
      *i3-1* '((started-on-leg White cp1 cp5 $movement $tf Trav-techn)
	       (in-trav-formation White cp1 cp5 $tf
				  F-fire-excellent $fl $fr Trav-techn )
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Traveling technique
      *g3-1* '((moving-along-leg White cp1 cp5
				 Speed-excellent Security-mod
				 Trav-techn ))

      ;for Trav overwatch
      *i3-2* '((started-on-leg White cp1 cp5 $movement $tf Trav-overw)
	       (in-trav-formation White cp1 cp5 $tf
				  F-fire-excellent $fl $fr Trav-overw )
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Traveling overwatch
      *g3-2* '((moving-along-leg White cp1 cp5
				 Speed-good Security-good
				 Trav-overw ))

      ;----------------------------------------------------------
      ; BATTLE DRILLS

      ;for Nbd
      *i4* '((moving-along-leg White cp1 cp5 $a $b Trav-techn)
	     (in-trav-formation White cp1 cp5 $d $e $f $g Trav-techn)
	     (ready-for-drill White cp1 cp5)
	     (NOT firing-on White $xy3 $direct-or-indirect
		  $xy1 $xy2 ))

      ;for Nbd
      *g4* '((moving-along-leg White cp1 cp5 $a $b Trav-techn)
	     (in-trav-formation White cp1 cp5 $d $e $f $g Trav-techn)
	     (drill-scheduled) )

      ;----------------------------------------------------------
      ; FINISH MOVEMENT

      ;for Mtle-nbo
      *i5-1* '((moving-along-leg White cp1 cp5 $sp1 $sec1 Trav-techn)
	       (in-trav-formation White cp1 cp5 $tf $ff $fl $fr Trav-techn)
	       (drill-scheduled)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    cp1 cp5 ))

      ;for Mtle-nbo
      *g5* '((at-location White cp5))

      ;for Mtle-bo
      *i5-2* '((moving-along-leg White cp1 cp5 $sp1 $sec1 Bound-overw)
	       (drill-scheduled)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    cp1 cp5 ))

      ;----------------------------------------------------------

      *effect* ;from Wlmf
      '(in-trav-formation $group1 $xy1 $xy2 Wedge-l
			  F-fire-excellent L-fire-good
			  R-fire-moderate $method)
      *precond* ;from Ttm
      '(in-trav-formation $group $xy1 $xy2 $tform
			  (options F-fire-mod F-fire-good
				   F-fire-excellent)
			  $u5 $u6
			  Trav-techn)

      )

(let ((terrain-f-names '(impose-filter-oriented-from
			 impose-filter-clear impose-filter-leg-lateral-space
			 impose-filter-empty
			 impose-filter-loc-radial-space
			 impose-filter-item impose-filter-same-segment-space
			 impose-filter-separation impose-filter-vector-intersects
			 impose-filter-angle-formed ))
      (order-f-names '(impose-filter-move-order-given-to
		       impose-filter-overwatching
		       impose-filter-stop-order-given-to
		       impose-filter-contact-report-given-to
		       impose-filter-fire-order-given-to ))
      (exercise-names '(;Move-from-leg-start
			Move-out-from-stat-form
			Move-out-from-halted-trav-formation
			Column-moving-formation
			Staggered-column-moving-formation
			Wedge-left-moving-formation
			Wedge-right-moving-formation
			Echelon-left-moving-formation
			Echelon-right-moving-formation
			Vee-moving-formation
			Line-moving-formation
			Traveling-technique-of-movement
			Traveling-overwatch-technique-of-movement
			Bounding-overwatch-technique-of-movement
			;Move-to-leg-end-nbo
			;Move-to-leg-end-bo
			Halt-trav-formation
			Stop-in-coil
			Stop-in-herringbone
			;No-battle-drill
			Contact-from-contact-report
			Contact-from-sighting
			Fire-toward-ground
			;End-fire
			Fire-into-air
			Veer-from-air-attack
			)))

  (defun caeti-demo1 (&optional (wait-count 1000))
    (format t "~%~
               ~% Start condition for new exercise:~{~%~%    ~a~}~
               ~%~
               ~% End condition for new exercise:~{~%~%    ~a~}~
               ~%~
               ~%~
               ~% Planning the new exercise..."
	    *initial* *goal* )
    (plan *initial* *goal* :quiet-mode t)
    (if *solution*
	(let* ((plan1-op-props
		(mapcar #'operator-name (plan-a *solution*)) )
	       (plan1-terrain-f-op-props
		(mapcar #'(lambda (op-n2)
			    (cons
			     (subseq (symbol-name (car op-n2)) 14)
			     (cdr op-n2) ))
			(setq *fl* ;for debug
			      (apply #'append
				     (mapcar #'(lambda (op-n1)
						 (and (find (car op-n1)
							    terrain-f-names )
						      (list op-n1) ))
					     plan1-op-props ))
			      )))
	       (plan1-order-f-op-props
		(mapcar #'(lambda (op-n2)
			    (cons
			     (subseq (symbol-name (car op-n2)) 14)
			     (cdr op-n2) ))
			(sort
			 (apply #'append
				(mapcar #'(lambda (op-n1)
					    (and (find (car op-n1)
						       order-f-names )
						 (list op-n1) ))
					plan1-op-props ))
			 #'string-lessp ;just places 'move's before 'stop's
			 :key #'car )))
	       (plan1-exercise-op-props
		(apply #'append
		       (mapcar #'(lambda (op-n1)
				   (and (find (car op-n1) exercise-names)
					(list op-n1) ))
			       plan1-op-props )))
	       )
	  (format t "~%~
                     ~% SOLUTION FOUND!~
                     ~%~
                     ~% The new exercise contains these actions:~{~%~%    ~a~}"
		  plan1-exercise-op-props )
	  (dotimes (c wait-count) 'wait)
	  (format t "~%~
                     ~% The training table for the new exercise is:~{~%~%    ~a~}"
		  plan1-order-f-op-props )
	  (dotimes (c wait-count) 'wait)
	  (format t "~%~
                     ~% The new exercise also places some constraints ~
                        on the terrain:~{~%~%    ~a~}"
		  plan1-terrain-f-op-props )
	  (dotimes (c wait-count) 'wait)
	  (format t "~%~
                     ~% Testing terrain with the new constraints..." )


	  ;place Steve's CSP call here


	  ) ;let
      (format t "~%~
                 ~% ...the planner failed to find a solution." )
      ) ;if
    ) ;defun
  ) ;let