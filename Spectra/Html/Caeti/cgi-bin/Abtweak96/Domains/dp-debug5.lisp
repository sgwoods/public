;; ---------------------------------------------------------------------------
;; Debugging aids
;; ---------------------------------------------------------------------------

(defun dp () (setq *dp-debug-mode* (not *dp-debug-mode*)))

;; These are some items that may be useful for testing whether the
;;  planner selects the right op at a specific point in an
;;  anticipated plan.

(setq *initial*
      '(cp1 ;all I's and G's must begin with their loc (used by make-init-pl)
	(in-stat-formation White cp1 Herringbone 
			   $securityI $exec-speedI $mo-speedI 0.0 )
	(NOT firing-on White $enemy-posI $direct-or-indirectI
	     $startI $endI )
	)
      *goal*
      '(cp1
	(in-stat-formation White cp2 Coil
			   $securityG $exec-speedG $mo-speedG $exec-timeG )
	)
      ;----------------------------------------------------------
      ; MOVE OUT

      ;for Mfls
      *i1* '(cp1
	     (at-location White cp1 0.0)
	     (moving-along-leg White cp0 cp1 $sp2 $sec2 $meth2)
	     (NOT firing-on White $xy3 $direct-or-indirect
		  $xy1 $xy2 ))

      ;for Mfls
      *g1* '(cp1
	     (started-on-leg White cp1 cp2 Move-From $tf $meth $exec-time))

      ;----------------------------------------------------------
      ; TRAVEL FORMATIONS

      ;for Column
      *i2-1* '(cp1
	       (started-on-leg White cp1 cp2 $movement Column $meth 0.0)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Wedge-l
      *i2-2* '(cp1
	       (started-on-leg White cp1 cp2 $movement Wedge-left $meth 0.0)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Wedge-l
      *g2* '(cp1
	     (in-trav-formation White cp1 cp2 Wedge-left $ff $fl $fr $meth))

      ;----------------------------------------------------------
      ; TRAVEL METHODS

      ;for Traveling technique
      *i3-1* '(cp1
	       (started-on-leg White cp1 cp2 $movement $tf Traveling-technique
			       0.0 )
	       (in-trav-formation White cp1 cp2 $tf
				  F-fire-excellent $fl $fr Traveling-technique )
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Traveling technique
      *g3-1* '(cp1
	       (moving-along-leg White cp1 cp2
				 Speed-excellent Security-moderate
				 Traveling-technique ))

      ;for Trav overwatch
      *i3-2* '(cp1
	       (started-on-leg White cp1 cp2 $movement $tf Traveling-overwatch
			       0.0 )
	       (in-trav-formation White cp1 cp2 $tf
				  F-fire-excellent $fl $fr Traveling-overwatch )
	       (NOT firing-on White $xy3 $direct-or-indirect
		    $xy1 $xy2 ))

      ;for Traveling overwatch
      *g3-2* '(cp1
	       (moving-along-leg White cp1 cp2
				 Speed-good Security-good
				 Traveling-overwatch ))

      ;----------------------------------------------------------
      ; BATTLE DRILLS

      ;for Nbd
      *i4* '(cp1
	     (moving-along-leg White cp1 cp2 $a $b Traveling-technique)
	     (in-trav-formation White cp1 cp2 $d $e $f $g Traveling-technique)
	     (ready-for-drill White cp1 cp2 0.0 1.0)
	     (NOT firing-on White $xy3 $direct-or-indirect
		  $xy1 $xy2 ))

      ;for Nbd
      *g4* '(cp1
	     (moving-along-leg White cp1 cp2 $a $b Traveling-technique)
	     (in-trav-formation White cp1 cp2 $d $e $f $g Traveling-technique)
	     (drill-scheduled $exec-time $tt-multiplier) )

      ;----------------------------------------------------------
      ; FINISH MOVEMENT

      ;for Mtle-nbo
      *i5-1* '(cp1
	       (moving-along-leg White cp1 cp2 $sp1 $sec1 Traveling-technique)
	       (in-trav-formation White cp1 cp2 $tf $ff $fl $fr
				  Traveling-technique )
	       (drill-scheduled 0.0 1.0)
	       (NOT firing-on White $xy3 $direct-or-indirect
		    cp1 cp2 ))

      ;for Mtle-nbo
      *g5* '(cp1
	     (at-location White cp2 $exec-time) )

      ;for Mtle-bo
      *i5-2* '(cp1
	       (moving-along-leg White cp1 cp2 $sp1 $sec1 Bounding-overwatch)
	       (drill-scheduled 0.0 2.5)
	       (NOT firing-on White $xy3 $direct-or-indirect cp1 cp2) )

      ;----------------------------------------------------------

      *effect* ;from Wlmf
      '(in-trav-formation $group1 $xy1 $xy2 Wedge-left
			  F-fire-excellent L-fire-good
			  R-fire-moderate $method)
      *precond* ;from Ttm
      '(in-trav-formation $group $xy1 $xy2 $tform
			  (options F-fire-moderate F-fire-good
				   F-fire-excellent)
			  $u5 $u6
			  Traveling-technique )

      )

