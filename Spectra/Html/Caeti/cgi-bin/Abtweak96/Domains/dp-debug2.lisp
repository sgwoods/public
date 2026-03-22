
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
	(in-stat-formation White cp2 Coil 
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
      *g1* '((started-on-leg White cp1 cp2 Move-From $tf $meth))

      ;----------------------------------------------------------
      ; TRAVEL FORMATIONS

      ;for Column
      *i2-1* '((started-on-leg White cp1 cp2 $movement Column $meth)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Wedge-l
      *i2-2* '((started-on-leg White cp1 cp2 $movement Wedge-l $meth)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Wedge-l
      *g2* '((in-trav-formation White cp1 cp2 Wedge-l $ff $fl $fr $meth))

      ;----------------------------------------------------------
      ; TRAVEL METHODS

      ;for Traveling technique
      *i3-1* '((started-on-leg White cp1 cp2 $movement $tf Trav-techn)
	       (in-trav-formation White cp1 cp2 $tf
				  F-fire-excellent $fl $fr Trav-techn )
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Traveling technique
      *g3-1* '((moving-along-leg White cp1 cp2
				 Speed-excellent Security-mod
				 Trav-techn ))

      ;for Trav overwatch
      *i3-2* '((started-on-leg White cp1 cp2 $movement $tf Trav-overw)
	       (in-trav-formation White cp1 cp2 $tf
				  F-fire-excellent $fl $fr Trav-overw )
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Traveling overwatch
      *g3-2* '((moving-along-leg White cp1 cp2
				 Speed-good Security-good
				 Trav-overw ))

      ;----------------------------------------------------------
      ; BATTLE DRILLS

      ;for Nbd
      *i4* '((moving-along-leg White cp1 cp2 $a $b Trav-techn)
	     (in-trav-formation White cp1 cp2 $d $e $f $g Trav-techn)
	     (ready-for-drill White cp1 cp2)
	     (NOT firing-on White $xy3 $direct-or-indirect
		  $xy1 $xy2 ))

      ;for Nbd
      *g4* '((moving-along-leg White cp1 cp2 $a $b Trav-techn)
	     (in-trav-formation White cp1 cp2 $d $e $f $g Trav-techn)
	     (drill-scheduled) )

      ;----------------------------------------------------------
      ; FINISH MOVEMENT

      ;for Mtle-nbo
      *i5-1* '((moving-along-leg White cp1 cp2 $sp1 $sec1 Trav-techn)
	       (in-trav-formation White cp1 cp2 $tf $ff $fl $fr Trav-techn)
	       (drill-scheduled)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    cp1 cp2 ))

      ;for Mtle-nbo
      *g5* '((at-location White cp2))

      ;for Mtle-bo
      *i5-2* '((moving-along-leg White cp1 cp2 $sp1 $sec1 Bound-overw)
	       (drill-scheduled)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    cp1 cp2 ))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; just start with 'cl' then ':ld dp-debug2.lisp' and '(dp-load)'
(defun dp-load ()
  (load "QCSP/load-from-planner.lisp")
  (tcsp)
  (load "Domains/caeti4.lisp")
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
               ~% Ready to start planning the new exercise? (press any key)"
	    *initial* *goal* )
    (read-char)
    (format t "~%~
               ~% Planning the new exercise..." )
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
	  (format t "~%~% Ready to look for an appropriate terrain? (press any key)")
	  (read-char)
	  (format t "~%~
                     ~% Testing terrain with the new constraints..." )
	  (tcsp)
	  (if *solution-set*
	      (let* ((chkpt-pairs (car *solution-set*))
		     (checkpt1-loc
		      (second (assoc (second (first chkpt-pairs))
				     *current-situation* )))
		     (checkpt2-loc
		      (second (assoc (second (second chkpt-pairs))
				     *current-situation* )))
		     )
		(if (string-lessp (symbol-name (first (first chkpt-pairs)))
				  (symbol-name (first (second chkpt-pairs))) )
		    (setq cp1-name (first (first chkpt-pairs))
			  cp1-loc checkpt1-loc
			  cp2-name (first (second chkpt-pairs))
			  cp2-loc checkpt2-loc )
		  (setq cp1-name (first (second chkpt-pairs))
			cp1-loc checkpt2-loc
			cp2-name (first (first chkpt-pairs))
			cp2-loc checkpt1-loc ))
		(format t "~%~
                           ~% TERRAIN MAPPING FOUND!~
                           ~%~
                           ~%    Create first  checkpoint ~s at: ~s~
                           ~%~
                           ~%    Create second checkpoint ~s at: ~s~
                           ~%~
                           ~% Ready to show display of exercise route? (press any key)"
			cp1-name cp1-loc cp2-name cp2-loc )
		(read-char)
		(format t "~%~
                           ~% Creating display of exercise route...~
                           ~%" )

		;(print 'we-might-want-to-describe-constraints-satisfied)
		(run-shell-command "/usr/local/bin/gnuplot QCSP/TSit/gnuplot.dp-tex"
				   :wait nil )
		(run-shell-command "/usr/local/bin/ghostview -background white -landscape QCSP/TSit/.dpprep"
				   :wait nil )
#|
		(format t "~%~
                           ~% Generating Terrain Map with Plan Routing ...~s~
			   ~%")
		;; generate gnuplot input data file for the located route endpoints
		(let* (
		       (sitobj1 (get-sit-object (second (first  (first *solution-set*)))))
		       (pt1x    (first  (second sitobj1)))
		       (pt1y    (second (second sitobj1)))
		       (sitobj2 (get-sit-object (second (second (first *solution-set*)))))
		       (pt2x    (first  (second sitobj2)))
		       (pt2y    (second (second sitobj2)))
		       )
		  (setq *gnuplot-stream1* (open "TCSP-Situation/LastRoute.dat"
					       :direction :output 
					       :if-exists :overwrite
					       :if-does-not-exist :create))
		  (format *gnuplot-stream1* "~A~10T~A~&" pt1x pt1y)
		  (format *gnuplot-stream1* "~A~10T~A~&" pt2x pt2y)
		  (close *gnuplot-stream1*)
		  )
		
		(run-shell-command "QCSP/TCSP-Situation/drawl Sit-terrain-1-nil-default-0"
				   :wait nil)
|#
		(values)
		)
	    (format t "~%~
                       ~% ...failure to map the planned exercise ~
                          to the terrain." )
	    ) ;if
	  ) ;let
      (format t "~%~
                 ~% ...the planner failed to find a solution." )
      ) ;if
    ) ;defun
  ) ;let


;; testing files ...
;;
(defun gv ()
  (run-shell-command "QCSP/TCSP-Situation/drawl Sit-terrain-1-nil-default-0"
		     :wait nil)
  )


(defun gv2 ()
  ;; generate gnuplot input data file for the located route endpoints
  (let* (
	 (sitobj1 (get-sit-object (second (first  (first *solution-set*)))))
	 (pt1x    (first  (second sitobj1)))
	 (pt1y    (second (second sitobj1)))
	 (sitobj2 (get-sit-object (second (second (first *solution-set*)))))
	 (pt2x    (first  (second sitobj2)))
	 (pt2y    (second (second sitobj2)))
	 )
    (setq *gnuplot-stream1* (open "TCSP-Situation/LastRoute.dat"
				  :direction :output 
				  :if-exists :overwrite
				  :if-does-not-exist :create))
    (format *gnuplot-stream1* "~A~10T~A~&" pt1x  pt1y)
    (format *gnuplot-stream1* "~A~10T~A~&" pt2x  pt2y)
    (close *gnuplot-stream1*)
    )

  ; (run-shell-command "QCSP/TCSP-Situation/drawl Sit-terrain-1-nil-default-0"  :wait nil)

  ) ; gv2