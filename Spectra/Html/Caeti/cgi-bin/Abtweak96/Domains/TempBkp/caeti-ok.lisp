;***************************************************************************
;*****                   CAETI sample operators                        *****
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
	    :cost 0
	    
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
			     )))

(setq mofsf (make-operator
	    :opid 'mofsf
	    :name '(move-out-from-stat-form 
		    $group  $leg $leg-start 
		    $sform $security $exec-speed  $mv-out-speed 
		    $tform $method 
		    )
	    :cost 0
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
			     )))

(setq cmf (make-operator
	    :opid 'cmf
	    :name '(column-moving-formation $group $leg 
					    $trav-st-loc $movement $method
					    )
	    :cost 0
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
			     )))

(setq ttm (make-operator
	    :opid 'ttm
	    :name '(traveling-technique-of-movement
		   $group $leg $tform $loc
		   $trav-st-loc
		   )
	    :cost 0
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
			     )))

(setq mtle (make-operator
	    :opid 'mtle
	    :name '(move-to-leg-end $group $leg-end $leg
				    $speed $security
				    $tform 
				    $fire-f $fire-l $fire-r
				    $method $trav-st-loc
				    )
	    :cost 0
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
			     )))

(setq ecoil (make-operator
	    :opid 'ecoil
	    :name '(execute-coil 
		    $group $leg-end $leg
		    $speed $security
		    $method $trav-st-loc
		    )
	    :cost 0
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

		   mofsf
 		   mfls
		   cmf
		   ttm
		   mtle
		   ecoil

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
(setq *left-wedge-list* '(0 2))


;; ---------------------------------------------------------------------------
;; Testing below
;; ---------------------------------------------------------------------------

(defun lcs () (load "Domains/caeti"))
(defun lct () (load "Domains/caeti-testing"))
(defun pm () (plan initial goal :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))