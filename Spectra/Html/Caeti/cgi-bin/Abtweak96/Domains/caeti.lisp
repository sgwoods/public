;***************************************************************************
;*****                   CAETI operators                               *****
;***************************************************************************

(setq *domain* 'caeti)

;---------------------------------------------------------------------------
;
; filter imposition operators are used in post virtual plan modification
;
;---------------------------------------------------------------------------

(setq impose-fls (make-operator
	    :opid 'impose-fls
	    :name '(impose-filter-leg-start $a $b)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-leg-start $a $b)
			     )))

(setq impose-fle (make-operator
	    :opid 'impose-fle
	    :name '(impose-filter-leg-end $a $b)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-leg-end $a $b)
			     )))

(setq impose-fof (make-operator
	    :opid 'impose-fof
	    :name '(impose-filter-oriented-from $a $b $c)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-oriented-from $a $b $c)
			     )))

(setq impose-fmogt (make-operator
	    :opid 'impose-fmogt
	    :name '(impose-filter-move-order-given-to $a $b $c $d $e)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-move-order-given-to $a $b $c $d $e)
			     )))

(setq impose-fsogt (make-operator
	    :opid 'impose-fsogt
	    :name '(impose-filter-stop-order-given-to $a $b $c)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-stop-order-given-to $a $b $c)
			     )))

(setq impose-fc (make-operator
	    :opid 'impose-fc
	    :name '(impose-filter-clear $a)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-clear $a)
			     )))

(setq impose-flls1 (make-operator
	    :opid 'impose-flls1
	    :name '(impose-filter-leg-lateral-space $a $b)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-leg-lateral-space $a $b)
			     )))

(setq impose-flls2 (make-operator
	    :opid 'impose-flls2
	    :name '(impose-filter-loc-lateral-space $a $b)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-loc-lateral-space $a $b)
			     )))

(setq impose-fe (make-operator
	    :opid 'impose-fe
	    :name '(impose-filter-empty $a)
	    :cost 0
	    :preconditions '()
	    :effects       '(
			     (filter-empty $a)
			     ))) 

(setq impose-faogt
      (make-operator
       :opid 'impose-faogt
       :name '(impose-filter-action-order-given-to $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-action-order-given-to $a $b $c)
			)))

(setq impose-fcrgt
      (make-operator
       :opid 'impose-fcrgt
       :name '(impose-filter-contact-report-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-contact-report-given-to $a $b $c $d)
			)))

(setq impose-ffogt
      (make-operator
       :opid 'impose-ffogt
       :name '(impose-filter-fire-order-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-fire-order-given-to $a $b $c $d)
			)))

(setq impose-fia1
      (make-operator
       :opid 'impose-fia1
       :name '(impose-filter-item-at $a $b)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-item-at $a $b)
			)))

(setq impose-fia2
      (make-operator
       :opid 'impose-fia2
       :name '(impose-filter-item-alongside $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-item-alongside $a $b $c)
			)))

(setq impose-fit
      (make-operator
       :opid 'impose-fit
       :name '(impose-filter-item-type $a $b)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-item-type $a $b)
			)))

(setq impose-fo
      (make-operator
       :opid 'impose-fo
       :name '(impose-filter-overwatching $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-overwatching $a $b $c)
			)))

(setq impose-frf
      (make-operator
       :opid 'impose-frf
       :name '(impose-filter-receives-fire $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-receives-fire $a $b $c)
			)))

(setq impose-fnhogt
      (make-operator
       :opid 'impose-fnhogt
       :name '(impose-filter-nohold-order-given-to $a $b)
       :cost 1
       :preconditions '()
       :effects       '(
			(filter-nohold-order-given-to $a $b)
			))) 

;---------------------------------------------------------------------------
;
; all possible domain operators (adapted from gtsp-movement-ops.txt with 
;    some changes)
;
;---------------------------------------------------------------------------

(setq mfls (make-operator
	    :opid 'mfls
	    :name '(move-from-leg-start  $group $loc $leg1 $leg2 
					 $speed $security
					 $method $trav-st-loc)
	    :cost 1
	    
	    :preconditions '(
			     (at-location      $group $loc)
			     (moving-along-leg $group $leg1
					       $speed $security
					       $trav-st-loc $method)
			     (filter-leg-start $leg2 $loc)
			     (filter-leg-end   $leg1 $loc)
			     (filter-oriented-from $leg2 Forward $leg1)
			     (filter-move-order-given-to $group $loc
							 MoveThrough $tform
							 $method)
			     )
	    :effects       '(
			     (started-on-leg $group $leg2
					     $loc MoveThrough $tform $method)
			     (not moving-along-leg $group $leg1 
				                   $speed $security 
						   $trav-st-loc $method)
			     (not at-location $group $loc)
			     
			     (trigger-mfls)
			     )))

(setq mofsf (make-operator
	    :opid 'mofsf
	    :name '(move-out-from-stat-form 
		    $group  $leg $leg-start 
		    $sform $security $exec-speed  $mv-out-speed 
		    $tform $method 
		    )
	    :cost 1
	    :preconditions '(
			     (in-stat-formation $group $leg-start $sform 
						$security $exec-speed 
						$mv-out-speed)
			     (filter-clear $leg)
			     (filter-leg-start $leg $leg-start)
			     (filter-move-order-given-to $group  $leg-start 
						    MoveFrom $tform $method)
			     )
	    :effects       '(
			     (started-on-leg $group $leg 
					     $leg-start MoveFrom
					     $tform $method)
			     (not in-stat-formation $group $leg-start $sform
						$security $exec-speed 
						$mv-out-speed)

			     (trigger-mofsf)
			     )))

;; There does not appear to be a reason to prefer one method of moving
;; out over another as a default, so this is the same cost as Mofsf.
(setq mofhtf
      (make-operator
       :opid 'mofhtf
       :name '(Move-out-from-halted-trav-formation
	       $group $leg $tform1 $fire-f $fire-l $fire-r
	       $trav-st-loc $tform2 $method
	       )
       :cost 1
       :preconditions '(
			(stopped-at $group $trav-st-loc)
			(in-trav-formation $group $leg $tform1
					   $fire-f $fire-l $fire-r
					   $trav-st-loc $method)
			(filter-move-order-given-to
			 $group ?trav-st-loc MoveFrom $tform2 $method)
			(filter-clear $leg)
			(filter-leg-start $leg $trav-st-loc)
			)
       :effects       '(
			(started-on-leg $group $leg
					$trav-st-loc MoveFrom
					$tform2 $method)
			(not in-trav-formation $group $leg $tform1
			     ?fire-f $fire-l $fire-r $trav-st-loc $method)
			(not stopped-at $group $trav-st-loc)

			(trigger-mofhtf)
			)))

;; ---------------------------------------------------------------------------
;; Traveling Formations
;; ---------------------------------------------------------------------------
;;
;; Troops prefer wedges to staggered columns, which they prefer to columns;
;; so, staggered columns and columns are made more expensive here.  I assume
;; that echelons, lines, and vees are comparable to staggered columns.

(setq cmf (make-operator
	    :opid 'cmf
	    :name '(column-moving-formation $group $leg 
					    $trav-st-loc $movement $method
					    )
	    :cost 3
	    :preconditions '(
			     (started-on-leg $group $leg
					     $trav-st-loc $movement
					     Column $method)
			     (filter-leg-lateral-space $leg 1+)
			     )
	    :effects       '(
			     (in-trav-formation $group $leg Column
 				F-fire-mod L-fire-mod R-fire-mod
				$trav-st-loc $method)

			     (trigger-cmf)
			     )))

(setq scmf
      (make-operator
       :opid 'scmf
       :name '(Staggered-column-moving-formation
	       $group $leg $trav-st-loc $movement $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement Stag-column $method)
			(filter-leg-lateral-space $leg 2+)
			)
       :effects       '(
			(in-trav-formation $group $leg Stag-column
					   F-fire-good L-fire-good R-fire-good
					   $trav-st-loc $method)

			(trigger-scmf)
			)))
(setq wlmf
      (make-operator
       :opid 'wlmf
       :name '(Wedge-left-moving-formation ;;left flank is longer
	       $group2 $leg $group1 $trav-st-loc $movement $method
	       )
       :cost 1
       :preconditions '(
			(started-on-leg $group1 $leg
					$trav-st-loc $movement Wedge-l
					$method)
			(filter-leg-lateral-space $leg 4+)
			(filter-overwatching $group2 $group1 $leg)
			)
       :effects       '(
			(in-trav-formation $group1 $leg Wedge-l
					   F-fire-excellent L-fire-good
					   R-fire-moderate
					   $trav-st-loc $method)

			(trigger-wlmf)
			))) 
(setq wrmf
      (make-operator
       :opid 'wrmf
       :name '(Wedge-right-moving-formation
	       $group2 $leg $group1 $trav-st-loc $movement $method
	       )
       :cost 1
       :preconditions '(
			(started-on-leg $group1 $leg $trav-st-loc
					$movement Wedge-r $method)
			(filter-leg-lateral-space $leg 4+)
			(filter-overwatching $group2 $group1 $leg)
			)
       :effects       '(
			(in-trav-formation $group1 $leg Wedge-r
					   F-fire-excellent
					   L-fire-moderate R-fire-good
					   $trav-st-loc $method)

			(trigger-wrmf)
			)))
(setq elmf
      (make-operator
       :opid 'elmf
       :name '(Echelon-left-moving-formation
	       $group $leg $trav-st-loc $movement $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement Echelon-l $method)
			(filter-leg-lateral-space $leg 4+)
			)
       :effects       '(
			(in-trav-formation $group $leg Echelon-l
					   F-fire-excellent L-fire-excellent
					   R-fire-bad
					   $trav-st-loc $method)

			(trigger-elmf)
			))) 
(setq ermf
      (make-operator
       :opid 'ermf
       :name '(Echelon-right-moving-formation
	       $group $leg $trav-st-loc $movement $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement Echelon-r $method)
			(filter-leg-lateral-space $leg 4+)
			)
       :effects       '(
			(in-trav-formation $group $leg Echelon-r
					   F-fire-excellent L-fire-bad
					   R-fire-excellent
					   $trav-st-loc $method)

			(trigger-ermf)
			)))

;;; !!!!!!!!!!! The fire values for the Vee are only guesses
(setq vmf
      (make-operator
       :opid 'vmf
       :name '(Vee-moving-formation
	       $group $leg $trav-st-loc $movement $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement Vee $method)
			(filter-leg-lateral-space $leg 4+)
			)
       :effects       '(
			(in-trav-formation $group $leg Vee
					   F-fire-excellent L-fire-moderate
					   R-fire-moderate
					   $trav-st-loc $method)

			(trigger-vmf)
			)))
(setq lmf
      (make-operator
       :opid 'lmf
       :name '(Line-moving-formation
	       $group1 $leg $group2 $trav-st-loc $movement $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement Line $method)
			(filter-leg-lateral-space $leg 4+)
			(filter-overwatching $group2 $group1 $leg)
			)
       :effects       '(
			(in-trav-formation $group1 $leg Line
					   F-fire-excellent L-fire-bad
					   R-fire-bad
					   $trav-st-loc $method)

			(trigger-lmf)
			)))

;; ---------------------------------------------------------------------------
;; Moving Techniques
;; ---------------------------------------------------------------------------

(setq ttm (make-operator
	    :opid 'ttm
	    :name '(traveling-technique-of-movement
		   $group $leg $tform $loc
		   $trav-st-loc
		   )
	    :cost 1
	    :preconditions '(
			     (filter-clear $leg)
			     (started-on-leg $group $leg
					     $trav-st-loc $movement
					     $tform Trav-techn)
			     (in-trav-formation $group $leg $tform
						F-fire-mod $u5 $u6
						$trav-st-loc Trav-techn)
			     )
	    :effects       '(
			     (moving-along-leg $group $leg 
					       Speed-excellent Security-mod
					       $trav-st-loc Trav-techn)
			     (not started-on-leg
				  $group $leg
				  $trav-st-loc $movement $tform Trav-techn)

			     (trigger-ttm)
			     )))

(setq totm
      (make-operator
       :opid 'totm
       :name '(Traveling-overwatch-technique-of-movement
	       $group $leg $tform $trav-st-loc $movement)
       :cost 2
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement $tform Trav-overw)
			(in-trav-formation $group $leg $tform
					   F-fire-good+ $u5 $u6
					   $trav-st-loc Trav-overw)
			(filter-clear $leg)
			)
       :effects       '(
			(moving-along-leg $group $leg Speed-good Security-good
					  $trav-st-loc Trav-overw)
			(NOT started-on-leg $group $leg $trav-st-loc
			     $movement $tform Trav-overw)

			(trigger-totm)
			)))
(setq abotm
      (make-operator
       :opid 'abotm
       :name '(Alternate-bounding-overwatch-technique-of-movement
	       $group $leg $tform $trav-st-loc $movement)
       :cost 3
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement $tform Alt-bound-overw)
			(in-trav-formation $group $leg $tform
					   F-fire-excellent $u5 $u6
					   $trav-st-loc Alt-bound-overw)
			(filter-clear $leg)
			)
       :effects       '(
			(moving-along-leg $group $leg
					  Speed-mod Security-excellent
					  $trav-st-loc Alt-bound-overw)
			(NOT started-on-leg $group $leg $trav-st-loc
			     $movement $tform Alt-bound-overw)

			(trigger-abotm)
			(trigger-ttm)
			)))
(setq sbotm
      (make-operator
       :opid 'sbotm
       :name '(Successive-bounding-overwatch-technique-of-movement
	       $group $leg $tform $trav-st-loc $movement)
       :cost 4
       :preconditions '(
			(started-on-leg $group $leg $trav-st-loc
					$movement $tform Succ-bound-overw)
			(in-trav-formation $group $leg $tform
					   F-fire-excellent $u5 $u6
					   $trav-st-loc Succ-bound-overw)
			(filter-clear $leg)
			)
       :effects       '(
			(moving-along-leg $group $leg
					  Speed-bad Security-superexcellent
					  $trav-st-loc Succ-bound-overw)
			(NOT started-on-leg $group $leg $trav-st-loc
			     $movement $tform Succ-bound-overw)

			(trigger-sbotm)
			)))

;; ---------------------------------------------------------------------------
;; Completing Travel
;; ---------------------------------------------------------------------------

(setq mtle (make-operator
	    :opid 'mtle
	    :name '(move-to-leg-end $group $leg-end $leg
				    $speed $security
				    $tform 
				    $fire-f $fire-l $fire-r
				    $method $trav-st-loc
				    )
	    :cost 1
	    :preconditions '(
			     (moving-along-leg $group $leg 
					       $speed $security
					       $trav-st-loc $method)
			     (in-trav-formation $group $leg $tform 
						$fire-f $fire-l $fire-r
						$trav-st-loc $method)
			     (filter-empty $leg-end)
			     (filter-leg-end $leg $leg-end)
			     )
	    :effects       '(
			     (at-location $group $leg-end)
			     (not in-trav-formation
				  $group $leg $tform
				  $fire-f $fire-l $fire-r
				  $trav-st-loc $method)

			     (trigger-mtle)
			     )))

(setq htf
      (make-operator
       :opid 'htf
       :name '(Halt-trav-formation $group $leg $leg-end $group $security
				   $tform $fire-f $fire-l $fire-r
				   $trav-st-loc $method)
       :cost 2
       :preconditions '(
			(moving-along-leg $group $leg $speed $security
					  $trav-st-loc $method)
			(in-trav-formation $group $leg $tform
					   $fire-f $fire-l $fire-r
					   $trav-st-loc $method)
			(filter-stop-order-given-to $group $leg-end
						    $tform) ;was Immediate-halt
			(filter-empty $leg-end)
			(filter-leg-end $leg $leg-end)
			)
       :effects       '(
			(stopped-at $group $leg-end)
			(NOT moving-along-leg $group $leg $speed $security
			     $trav-st-loc $method)

			(trigger-htf)
			)))

;; ---------------------------------------------------------------------------
;; Formations
;; ---------------------------------------------------------------------------

(setq ecoil (make-operator
	    :opid 'ecoil
	    :name '(execute-coil 
		    $group $leg-end $leg
		    $speed $security
		    $method $trav-st-loc
		    )
	    :cost 1
	    :preconditions '(
			     (at-location $group $leg-end)
			     (moving-along-leg $group $leg 
					       $speed $security
					       $trav-st-loc $method)
			     (filter-stop-order-given-to
			      $group $leg-end execute-Coil)
			     (filter-loc-lateral-space $leg-end 4+)
			     (filter-leg-end $leg $leg-end)
			     )
	    :effects       '(
			     (in-stat-formation $group $leg-end Coil
						Security-excl Execute-slow
						Move-out-slow)
			     (not moving-along-leg $group $leg 
				                   $speed $security
						   $trav-st-loc $method)

			     (trigger-ecoil)
			     )))

(setq siherr
      (make-operator
       :opid 'siherr
       :name '(Stop-in-herringbone
	       $group $leg $leg-end $speed $security
	       $trav-st-loc $method
	       )
       :cost 2
       :preconditions '(
			(at-location $group $leg-end)
			(moving-along-leg $group $leg $speed $security
					  $trav-st-loc $method)
			(filter-stop-order-given-to
			 $group $leg-end Herringbone)
			(filter-loc-lateral-space $leg-end 2+)
			(filter-leg-end $leg $leg-end)
			)
       :effects       '(
			(in-stat-formation $group $leg-end Herringbone
					   Security-good
					   Execute-fast Move-out-fast)
			(NOT moving-along-leg $group $leg $speed $security
			     $trav-st-loc $method )

			(trigger-siherr)
			)))

; ---------------------------------------------------------------------------
; actual operator list used in domain
;
; 		   mfls

(setq *operators* (list
		   impose-fls
		   impose-fle
		   impose-fof
		   impose-fmogt
		   impose-fsogt
		   impose-fc
		   impose-flls1
		   impose-flls2
		   impose-fe
		   impose-faogt
		   impose-fcrgt
		   impose-ffogt
		   impose-fia1
		   impose-fia2
		   impose-fit
		   impose-fo
		   impose-frf
		   impose-fnhogt

 		   mfls
		   mofsf
		   mofhtf

		   cmf
		   scmf
		   wlmf
		   wrmf
		   elmf
		   ermf
		   vmf
		   lmf

		   ttm
		   totm
		   abotm
		   sbotm

		   mtle
		   htf

		   ecoil
		   siherr

		   ))
; ---------------------------------------------------------------------------
;
; preconditions requiring NEW operators for establishment
;  (ie they WILL NOT make use of existing establishers)
;
(setq *precond-new-est-only-list*
      '(
       (filter-leg-start $a $b)
       (filter-leg-end $a $b)
       (filter-oriented-from $a $b $c)
       (filter-move-order-given-to $a $b $c $d $e)
       (filter-stop-order-given-to $a $b $c)
       (filter-clear $a)
       (filter-leg-lateral-space $a $b)
       (filter-loc-lateral-space $a $b)
       (filter-empty $a)

       (at-location     $ $)
       ))

; ---------------------------------------------------------------------------
;
; initial state
;
(setq initial '( 
		(fact-not-equal $thing1 $thing2)
		(not firing $group1 $trav-st-loc1 $enemy1 $fire-type1)

		(in-stat-formation White cp1 Herringbone 
				   $security1 $exec-speed1 $mo-speed1)
		))

; ---------------------------------------------------------------------------
;
; goal state
;
(setq goal '(
	     (in-stat-formation White cp5 Coil 
				$security2 $exec-speed2 $mo-speed2)
	     ))


;***************************************************************************
; AbTweak domain part - criticality lists, used only in Abtweak 
;
; satisfied first = high, last = lower
;
;***************************************************************************

(setq *critical-list* '(
   (1  			
    (stopped-at      $ $)
    (not stopped-at  $ $)
    (item-targeted   $ $ $)
    (not item-targeted   $ $ $)
    (approach-original-axis-then $ $ $)
    (not approach-original-axis-then $ $ $)
    (pass-obstacle-then     $ $ $)
    (not pass-obstacle-then $ $ $)
    (verge-from-obstacle-then     $ $ $)
    (not verge-from-obstacle-then $ $ $)
    (at-location     $ $)
    (not at-location $ $)
    (moving-along-leg $ $ $ $ $ $)
    (not moving-along-leg $ $ $ $ $ $)
    (started-on-leg $ $ $ $ $ $)
    (not started-on-leg $ $ $ $ $ $)
    (in-stat-formation $ $ $ $ $ $)
    (not in-stat-formation $ $ $ $ $ $)
    (in-trav-formation $ $ $ $ $ $ $ $)
    (not in-trav-formation $ $ $ $ $ $ $ $)
    )
   (0  
    (filter-leg-start $ $)
    (filter-leg-end   $ $)
    (filter-oriented-from $ $ $)
    (filter-move-order-given-to $ $ $ $ $)
    (filter-stop-order-given-to $ $ $)
    (filter-clear $)
    (filter-leg-lateral-space $ $)
    (filter-loc-lateral-space $ $)
    (filter-empty $) 
    (filter-overwatching $ $ $)
    (filter-contact-report-given-to $ $ $)
    (filter-item-at $ $)
    (filter-item-alongside $ $ $)
    (filter-type $ $)
    (filter-fire-order-given-to $ $ $ $)
    (filter-action-order-given-to $ $ $)
    (filter-nohold-order-given-to $ $)
    (filter-receives-fire $ $ $)
    )
   ))
(setq *critical-loaded* 'caeti-default)

;**************** settings for left-wedge mode *************

; preference values for each successive level of abstraction
;  - related to top down property
;  this value is factored into the heuristic for preference of
;  plans - essentially preferring level k over level k+1 by a
;  depth-factor as indicated in *k-list* at this k
;
(setq *left-wedge-list* '(0 0))


;; ---------------------------------------------------------------------------
;; Testing below
;; ---------------------------------------------------------------------------

(defun lcs () (load "Domains/caeti"))
(defun lct () (load "Domains/caeti-testing"))
(defun pm () (plan initial goal :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))