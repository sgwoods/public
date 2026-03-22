Most of the remaining Movement Operators
================================

;; Steve, look at the filters in ATVTE and RTIF; they could be a problem.

;; Ops for the air attack drill (w/ direct and oblique lines of attack, and
;;  w/ and w/o cover), tactical road march, and actions on contact have
;;  not been defined yet.

;; GIVE THE CMF (column) OPERATOR A COST OF 3.
;; CHANGE ECOIL'S NAME TO SICOIL ("stop in coil")

;====================================================================

;; mofhtf included
;; scmf included
;; wlmf included
;; wrmf included
;; elmf included 
;; ermf included 

;; vmf
;; lmf

;			)))

;;;
;;; 6 METHODS OF TRAVELLING
;;;

;; Speed is the default preference (over security) here, so the later
;; ops are more expensive.

;; totm included
;; abotm included
;; abotm included
;; sbotm included

;;;
;;; ***** Tactical-road-march (just buttoned up travel)
;;; What threats/ROE might motivate it?
;;;

;;;
;;; 4 ACTIONS FOR COMPLETING TRAVEL
;;;

;; The default preference here is for security, so halting is more
;; expensive than stopping in a stationary formation.

;; htf included

;; The default preference for formations is the coil, because it is more
;; secure; so, the herringbone is made more expensive.

;; siherr included


;;; ???????????????????????????????????????????????????????????????????????????

;;;
;;; Drills
;;;

;; We need another filter to ensure that the helicopter leg will be close
;;  enough to the plt to attack.
(setq daawc
      (make-operator
       :opid 'daawc
       :name '(Direct-air-attack-with-cover)
       :cost 2
       :preconditions '(
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(helicopter-flight-along-leg $enemy $leg2)
			(leg-end $leg2 $trav-st-loc) ;leg1-> t-s-loc <-leg2
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 Forward $leg1)

			(filter-leg-start $leg3 $trav-st-loc)
			(filter-item-at Cover $leg3) ;v or Forward-Left
			(filter-oriented-from $leg3 Forward-Right $leg1)
			)
       :effects       '(
			;fire at helicopters
			;veer off line of attack 45 degrees at top speed
			;halt in cover
			)))
;;; attack from oblique angle; attacks without cover

;; This op is a near-copy of 'Move-from-leg-start' but places more
;; constraints on the scenario, so it is more expensive.
;; This is a way of firing without changing direction or slowing.
;; Do we need both the enemy placement AND the contact report?  (If not,
;;  should we check if there's any obstruction to sighting the enemy?)
;; What consequences does targeting/firing have -- the enemy is not
;;  necessarily destroyed if we fire.
(setq contact-dr
      (make-operator
       :opid 'contact-dr
       :name '(Contact-drill $group $leg1 $leg2 $target
			     $direction $loc $speed $security
			     $trav-st-loc $tform $method)
       :cost 2
       :preconditions '(
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-contact-report-given-to
			 $group $trav-st-loc $direction No-antitank-weapons)
			(filter-item-alongside $target $leg2 $direction)
			(filter-item-type $target Enemy-small-arms-fire)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 Forward $leg1)
			)
       :effects       '(
			(started-on-leg $group $leg2 $trav-st-loc
					MoveThrough $tform $method)
			(item-targeted $group Enemy-small-arms-fire $leg2)
			(NOT moving-along-leg $group $leg1
			     $speed $security $trav-st-loc $method)
			)))

;; So far, firing is the only order issued in the middle of a leg.
(setq fire
      (make-operator
       :opid 'fire
       :name '(Fire $group $leg $target $directness)
       :cost 1
       :preconditions '(
			(item-targeted $group $target $leg)
			(filter-fire-order-given-to $group $leg
						    $target $directness)
			)
       :effects       '(
			(firing-on $group $target $directness $leg)
			)))

;; Compare this op to the Contact-drill (here, there are antitank weapons)
;; ***** Cover? weapons standoff? or assault?
;; This op allows rear action.
;; This is a way of changing direction without stopping.
;; The contact report should really be given before the move order.
;; This op is a near-copy of 'Move-from-leg-start's preconds but places more
;;  constraints on the scenario, so it is more expensive.
;; The effects should be similar to 'Halt-in-trav-form' if there is cover,
;;  because the plt will stop in that cover; the effects should be something
;;  else if there is no cover, because it will turn into an assault.
(setq atvte
      (make-operator
       :opid 'atvte
       :name '(Action-to-verge-toward-enemy $group $leg1 $leg2 $enemy
					    $speed $security $direction
					    $trav-st-loc $tform $method)
       :cost 2
       :preconditions '(
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-contact-report-given-to $group $trav-st-loc
							$direction
							Antitank-weapons)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform $method)
			(filter-item-at $enemy $leg2)
			(filter-item-type $enemy Enemy-with-antitank-weapons)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 $direction $leg1)
			(fact-not-equal Forward $direction)
			)
       :effects       '(
			(started-on-leg $group $leg2
					$trav-st-loc MoveThrough
					$tform $method)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))

;; The following 4 ops should be used in place of 'Move-from-leg-start'
;;  for 4 travel legs around an obstacle.  We need a mirror set of
;;  4 ops for swinging to the right of an obstacle.  I am ignoring
;;  actions rear for now.
;; This op would be the 4th and last to be executed.
;; This is a way of changing direction without stopping.
;; $dir is Left or Right, not Forward or Back
;; This op is a near-copy of 'Move-from-leg-start's preconds but places more
;; constraints on the scenario, so it is more expensive.
(setq atra
      (make-operator
       :opid 'atra
       :name '(Action-to-resume-axis $group $leg1 $leg2 $dir $speed $security
				     $trav-st-loc $tform $method)
       :cost 2
       :preconditions '(
			(approach-original-axis-then $group $leg1 $dir)
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-action-order-given-to $group $trav-st-loc $dir)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 $dir $leg1)
			)
	     :effects '(
			(started-on-leg $group $leg2 $trav-st-loc MoveThrough
					$tform $method)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))
;; This op would be the 3rd to be executed.
(setq altaa
      (make-operator
       :opid 'altaa
       :name '(Action-left-to-approach-axis $group $leg1 $leg2 $speed $security
					    $trav-st-loc $tform $method)
       :cost 2
       :preconditions '(
			(pass-obstacle-then $group $leg1 Left)
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-action-order-given-to $group $trav-st-loc
						      Left)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 Left $leg1)
			)
       :effects       '(
			(started-on-leg $group $leg2 $trav-st-loc MoveThrough
					$tform $method)
			(approach-original-axis-then $group $leg2 Right)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))
;; This op would be the 3rd to be executed.
(setq artaa
      (make-operator
       :opid 'artaa
       :name '(Action-right-to-approach-axis $group $leg1 $leg2 $speed
					     $security
					     $trav-st-loc $tform $method)
       :cost 2
       :preconditions '(
			(pass-obstacle-then $group $leg1 Right)
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-action-order-given-to $group $trav-st-loc
						      Right)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 Right $leg1)
			)
       :effects       '(
			(started-on-leg $group $leg2 $trav-st-loc MoveThrough
					$tform $method)
			(approach-original-axis-then $group $leg2 Left)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))
;; This op would be the 2nd to be executed.
;; $dir is Left or Right, not Forward or Back
(setq atpo
      (make-operator
       :opid 'artpo
       :name '(Action-to-pass-obstacle $group $leg1 $leg2 $dir $speed
				       $security $trav-st-loc $tform $method)
       :cost 2
       :preconditions '(
			(verge-from-obstacle-then $group $leg1 $dir)
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-action-order-given-to $group $trav-st-loc
						      $dir)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 $dir $leg1)
			)
       :effects       '(
			(started-on-leg $group $leg2 $trav-st-loc MoveThrough
					$tform $method)
			(pass-obstacle-then $group $leg2 $dir)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))
;; This op would be the 1st to be executed.
;; Obstacle's incl "danger areas"
;; Requiring an action order here may be unnecessary; the pldr might be
;;  able to decide to bypass on his own.
(setq altvfo
      (make-operator
       :opid 'altvfo
       :name '(Action-left-to-verge-from-obstacle $group $leg1 $leg2 $speed
						  $security $trav-st-loc $tform
						  $method)
       :cost 2
       :preconditions '(
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-action-order-given-to $group $trav-st-loc
						      Left)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 Left $leg1)
			(filter-leg-start $leg3 $trav-st-loc)
			(filter-item-at Obstacle $leg3)
			(filter-oriented-from $leg3 Forward $leg1)
			(filter-leg-start $leg4 $trav-st-loc)
			(filter-item-at Obstacle $leg4)
			(filter-oriented-from $leg4 Right $leg1)
			)
       :effects       '(
			(started-on-leg $group $leg2 $trav-st-loc MoveThrough
					$tform $method)
			(verge-from-obstacle-then $group $leg2 Right)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))
;; This op would be the 1st to be executed.
;; Obstacle's incl "danger areas"
(setq artvfo
      (make-operator
       :opid 'altvfo
       :name '(Action-right-to-verge-from-obstacle $group $leg1 $leg2 $speed
						   $security $trav-st-loc
						   $tform $method)
       :cost 2
       :preconditions '(
			(at-location $group $trav-st-loc)
			(moving-along-leg $group $leg1 $speed $security
					  $trav-st-loc $method)
			(filter-action-order-given-to $group $trav-st-loc
						      Right)
			(filter-move-order-given-to $group $trav-st-loc
						    MoveThrough $tform
						    $method)
			(filter-leg-start $leg2 $trav-st-loc)
			(filter-leg-end $leg1 $trav-st-loc)
			(filter-oriented-from $leg2 Right $leg1)
			(filter-leg-start $leg3 $trav-st-loc)
			(filter-item-at Obstacle $leg3)
			(filter-oriented-from $leg3 Forward $leg1)
			(filter-leg-start $leg4 $trav-st-loc)
			(filter-item-at Obstacle $leg4)
			(filter-oriented-from $leg4 Left $leg1)
			)
       :effects       '(
			(started-on-leg $group $leg2 $trav-st-loc MoveThrough
					$tform $method)
			(verge-from-obstacle-then $group $leg2 Left)
			(NOT moving-along-leg $group $leg1 $speed $security
			     $trav-st-loc $method)
			)))

;;; If the indirect fire is anticipated, the react order belongs in the OPORD
;;; Where is the leg going? -->It should resume whatever the axis was
;;; 'Avoid destruction' is a lame phrasing of the effect
;;; This op is a near-copy of 'Move-out-from-stationary-formation' but
;;;  places more constraints on the scenario, so it is more expensive.
(setq rtif
      (make-operator
       :opid 'rtif
       :name '(React-to-indirect-fire $group $leg $leg-start $enemy
				      $sform $security $exec-speed
				      $mv-out-speed $trav-st-loc $tform
				      $method)
       :cost 2
       :preconditions '(
			(in-stat-formation $group $leg-start ?sform
					   $security $exec-speed
					   $mv-out-speed)
			(not firing $group $trav-st-loc $enemy Direct)
			(filter-nohold-order-given-to $group $trav-st-loc)
			(filter-receives-fire $group $trav-st-loc Indirect)
			(filter-clear $leg)
			(filter-leg-start $leg $leg-start)
			)
       :effects       '(
			(started-on-leg $group $leg $trav-st-loc MoveFrom
					$tform $method)
			(avoid-destruction-at-loc $group $trav-st-loc)
			(NOT in-stat-formation $group $leg-start ?sform
			     $security $exec-speed $mv-out-speed)
			)))

;;; ???????????????????????????????????????????????????????????????????????????

;;=====================================================================

;; filters included

; ---------------------------------------------------------------------------

(setq *operators* (list
		   impose-faogt
		   impose-fcrgt
		   impose-ffogt
		   impose-fia1
		   impose-fia2
		   impose-fit
		   impose-fo
		   impose-frf
		   impose-fnhogt

		   scmf
		   wlmf
		   wrmf
		   elmf
		   ermf
		   vmf
		   lmf
		   totm
		   abotm
		   sbotm
		   htf
		   siherr
		   contact-dr
		   fire
		   atvte
		   atra
		   altraa
		   artraa
		   atpo
		   altvfo
		   artvfo
		   rtif

		   ))

(setq *critical-list* '(
   (1  			     
    ;; included
    )
   (0  
    ;; included
    )
   ))


;;;============================================

;;How does this work for the wedge????????????

;**************** settings for left-wedge mode *************

; preference values for each successive level of abstraction
;  - related to top down property
;  this value is factored into the heuristic for preference of
;  plans - essentially preferring level k over level k+1 by a
;  depth-factor as indicated in *k-list* at this k
;
;(setq *left-wedge-list* '(0 2))
