;; ---------------------------------------------------------------------------
;; Debugging aids
;; ---------------------------------------------------------------------------

(defun dp () (setq *dp-debug-mode* (not *dp-debug-mode*)))

(defun pm () (plan *initial* *goal* :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))


;; These are some items that may be useful for testing whether the
;;  planner selects the right op at a specific point in an
;;  anticipated plan.

(setq *initial*
      '(
	(in-stat-formation White cp1 Herringbone 
			   $security1 $exec-speed1 $mo-speed1)
	(NOT firing-on White $xy3 $direct-or-indirect
	     $xy1 $xy2 )
	)
      *goal*
      '(
	(in-stat-formation White cp2 Coil 
			   $security2 $exec-speed2 $mo-speed2)
	)
      ;----------------------------------------------------------
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

