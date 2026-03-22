;; Pautler CAETI 7 CHANGED Mar 23/97

;;***************************************************************************
;;*****                           CAETI operators                       *****
;;***************************************************************************

;; NOTE: Any change to the predicates used for operator-names, or any
;;  new ops, should be accompanied by updates to the op-name list
;;  in "caeti-demoX.lsp".

#|
;; These are needed only if we add a component for making enemy actions
;;  realistic, which would probably involve keeping helicopters around
;;  for an air attack for some time after the platoon has taken cover
;;  and stopped.
;;--------------------------------------------------------------------------
;; Waiting methods        STAGE 0
;;--------------------------------------------------------------------------

(setq wihtf
      (make-operator
       :opid 'wihtf
       :name '(Wait-in-halted-trav-formation $group $xy2 $exec-time $exec-time2)
       :cost 1
       :stage 0
       :preconditions '(
			(stopped-at $group $xy2 $exec-time)

			(viewable      $xy2 Helicopter $group $exec-time)
			(none-viewable $xy2 Helicopter $group $exec-time2)
			(< $exec-time $exec-time2)
			)
       :effects       '(
			(stopped-at $group $xy2 $exec-time2)

			(NOT stopped-at $group $xy2 $exec-time)
			)))

;; This op would not be used after an air attack, because the drill allows
;;  only enough time to halt a traveling formation and not to change to
;;  a stationary formation.  Yet, helicopters might appear after a plt
;;  has executed a stationary formation.
(setq wisf
      (make-operator
       :opid 'wisf
       :name '(Wait-in-stat-formation $group $xy1 $exec-time $exec-time2 !
				      $sform $security $exec-speed
				      $mv-out-speed )
       ;; The !'s separate info about the current leg from info about
       ;;  the just-completed leg (a leg to be fleshed out by backchaining
       ;;  through a new set of leg stages).
       :cost 1
       :stage 0
       :preconditions '(
			(in-stat-formation $group $xy1 $sform 
					   $security $exec-speed 
					   $mv-out-speed $exec-time )

			(viewable      $xy1 Helicopter $group $exec-time)
			(none-viewable $xy1 Helicopter $group $exec-time2)
			(< $exec-time $exec-time2)
			)
       :effects       '(
			(in-stat-formation $group $xy1 $sform 
					   $security $exec-speed 
					   $mv-out-speed $exec-time2 )

			(NOT in-stat-formation $group $xy1 $sform
			     $security $exec-speed $mv-out-speed $exec-time )
			)))
|#
;;--------------------------------------------------------------------------
;; Move-out methods     STAGE 1
;;--------------------------------------------------------------------------

;; This would be used only for a change of trav formation or trav technique.
(setq mfls
      (make-operator
       :opid 'mfls
       :name '(Move-from-leg-start $group $xy2 $xy3 $tform $method2 $exec-time
				   ! $xy1 $method1 $speed $security )
       :cost 1
       :stage 1
       :preconditions '(
			(at-location $group $xy2 $exec-time)
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method1 )

			(angle-formed $xy1 $xy2 $xy3 180.0)
			(move-order-given-to $group Move-Through $xy2
					     $tform $method2 )
			)
       :effects       '(
			(started-on-leg $group $xy2 $xy3 Move-through $tform
					$method2 $exec-time )
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method1 )
			(NOT at-location $group $xy2 $exec-time)
			)))

;; This would be used for a change of direction, trav form, or trav techn.
(setq ad
      (make-operator
       :opid 'ad
       :name '(Action-drill $group $xy2 $xy3 $tform $method2 $exec-time
			    $degrees ! $xy1 $method1 $speed $security )
       :cost 2
       :stage 1
       :preconditions '(
			(at-location $group $xy2 $exec-time)
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method1 )

			(angle-formed $xy1 $xy2 $xy3 $degrees)
			(< 14.0   (absolute-value (- 180.0 $degrees)))
			(minimize (absolute-value (- 180.0 $degrees)))
			(action-move-order-given-to $group $degrees $xy2
						    $tform $method2 )
			)
       :effects       '(
			(started-on-leg $group $xy2 $xy3 $degrees $tform
					$method2 $exec-time )
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method1 )
			(NOT at-location $group $xy2 $exec-time)
			)))

(setq mofsf
      (make-operator
       :opid 'mofsf
       :name '(Move-out-from-stat-form $group $xy1 $xy2 $tform $method
				       $exec-time !
				       $sform $security $exec-speed
				       $mv-out-speed )
       :cost 3  ;Pref should lean toward Mfls or Action-drills because most legs
       :stage 1 ; will be in the middle of a route/plan.
       :preconditions '(
			(in-stat-formation $group $xy1 $sform 
					   $security $exec-speed 
					   $mv-out-speed $exec-time )

			(none-viewable $xy1 Helicopter $group $exec-time)
			(leg-clear $xy1 $xy2)
			;; minimum execution distance?
			(move-order-given-to
			 $group Move-From $xy1 $tform $method )
			)
       :effects       '(
			(started-on-leg $group $xy1 $xy2
					Move-From $tform $method
					(+ $exec-time
					   (if (= Coil $sform)
					       0.2
					     0.1 ))) ;Herringbone
			(NOT in-stat-formation $group $xy1 $sform
			     $security $exec-speed $mv-out-speed $exec-time )
			)))

(setq mofhtf
      (make-operator
       :opid 'mofhtf
       :name '(Move-out-from-halted-trav-formation
	       $group $xy2 $xy3 $tform2 $method2 $exec-time !
	       $xy1 $tform1 $method1 $fire-f $fire-l $fire-r )
       :cost 4 ;DP thinks that this act is much less common than the other four.
       :stage 1
       :preconditions '(
			(stopped-at $group $xy2 $exec-time)
			(in-trav-formation $group $xy1 $xy2 $tform1
					   $fire-f $fire-l $fire-r $method1 )

			(none-viewable $xy2 Helicopter $group $exec-time)
			(leg-clear $xy2 $xy3)
			(move-order-given-to
			 $group Move-From $xy2 $tform2 $method2 )
			)
       :effects       '(
			(started-on-leg $group $xy2 $xy3
					Move-From $tform2 $method2
					(+ $exec-time 0.05) )
			(NOT in-trav-formation $group $xy1 $xy2 $tform1
			     $fire-f $fire-l $fire-r $method1 )
			(NOT stopped-at $group $xy2 $exec-time)
			)))

;;--------------------------------------------------------------------------
;; Traveling formations     STAGE 2
;;--------------------------------------------------------------------------
;;
;; Troops prefer wedges to staggered columns, which they prefer to columns;
;; so, staggered columns and columns are made more expensive here.  I assume
;; that echelons, lines, and vees are comparable to staggered columns.

(setq wltf
      (make-operator
       :opid 'wltf
       :name '(Wedge-left-traveling-formation ;;left flank is longer
	       $group1 $movement $xy1 $xy2 $method $group2 $exec-time )
       :cost 1
       :stage 2
       :preconditions '(
			(started-on-leg $group1 $xy1 $xy2 $movement Wedge-left
					$method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Wedge-left
					   F-fire-excellent L-fire-good
					   R-fire-moderate $method )
			))) 
(setq wrtf
      (make-operator
       :opid 'wrtf
       :name '(Wedge-right-traveling-formation
	       $group1 $movement $xy1 $xy2 $method $group2 $exec-time )
       :cost 1
       :stage 2
       :preconditions '(
			(started-on-leg $group1 $xy1 $xy2 $movement Wedge-right
					$method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Wedge-right
					   F-fire-excellent L-fire-moderate
					   R-fire-good $method )
			)))
(setq sctf
      (make-operator
       :opid 'sctf
       :name '(Staggered-column-traveling-formation
	       $group $movement $xy1 $xy2 $method $exec-time )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2 $movement
					Staggered-column $method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 2 3 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Staggered-column
					   F-fire-good L-fire-good
					   R-fire-good $method )
			)))
(setq eltf
      (make-operator
       :opid 'eltf
       :name '(Echelon-left-traveling-formation
	       $group $movement $xy1 $xy2 $method $exec-time )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2 $movement Echelon-left
					$method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Echelon-left
					   F-fire-excellent L-fire-excellent
					   R-fire-bad $method )
			))) 
(setq ertf
      (make-operator
       :opid 'ertf
       :name '(Echelon-right-traveling-formation
	       $group $movement $xy1 $xy2 $method $exec-time )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2 $movement Echelon-right
					$method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Echelon-right
					   F-fire-excellent L-fire-bad
					   R-fire-excellent $method )
			)))

(setq vtf ;;; !!!!!!!!!!! The fire values for the Vee are only guesses
      (make-operator
       :opid 'vtf
       :name '(Vee-traveling-formation $group $movement $xy1 $xy2 $method
				       $exec-time )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Vee $method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Vee
					   F-fire-excellent L-fire-moderate
					   R-fire-moderate $method )
			)))
(setq ltf
      (make-operator
       :opid 'ltf
       :name '(Line-traveling-formation
	       $group1 $movement $xy1 $xy2 $method $group2 $exec-time )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Line $method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Line
					   F-fire-excellent L-fire-bad
					   R-fire-bad $method )
			)))
(setq ctf
      (make-operator
       :opid 'ctf
       :name '(Column-traveling-formation $group $movement $xy1 $xy2 $method
					  $exec-time )
       :cost 3
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Column $method $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 1 2 3 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Column
					   F-fire-moderate L-fire-moderate
					   R-fire-moderate $method )
			)))

;;--------------------------------------------------------------------------
;; Traveling methods     STAGE 3
;;--------------------------------------------------------------------------

(setq ttm
      (make-operator
       :opid 'ttm
       :name '(Traveling-technique-of-movement
	       $group $movement $xy1 $xy2 $tform $exec-time)
       :cost 1
       :stage 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2 $movement $tform
					Traveling-technique $exec-time )
			(in-trav-formation $group $xy1 $xy2 $tform
					   (options F-fire-moderate F-fire-good
						    F-fire-excellent )
					   $u5 $u6 Traveling-technique )

			(leg-clear $xy1 $xy2)
			;; minimum travel distance?
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-excellent Security-moderate
					  Traveling-technique )
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Traveling-technique $exec-time )

			(ready-for-drill $group $xy1 $xy2 $exec-time 1.0)
			)))

;; The only kinds of traveling formations used with the traveling overwatch
;;  in the training tables are staggered column and vee.  We do not know
;;  if those two are more appropriate for traveling overwatches than others
;;  or why.
(setq totm
      (make-operator
       :opid 'totm
       :name '(Traveling-overwatch-technique-of-movement
	       $group $movement $xy1 $xy2 $tform $exec-time )
       :cost 6 ;=TT + col + mfls + 1 ;consider only after TT leg tried
       :stage 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2 $movement $tform
					Traveling-overwatch $exec-time )
			(in-trav-formation $group $xy1 $xy2 $tform
					   (options F-fire-good
						    F-fire-excellent ) 
					   $u5 $u6
					   Traveling-overwatch )

			(leg-clear $xy1 $xy2)
			;; minimum travel distance?
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2 Speed-good
					  Security-good Traveling-overwatch )
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Traveling-overwatch $exec-time )

			(ready-for-drill $group $xy1 $xy2 $exec-time 1.75)
			)))

;; Bounding overwatches do not use traveling formations. -DHarper
;; The platoon leader chooses which kind of bounding overwatch to use
;;  (alternating or successive), not the CoCmdr. -DHarper

(setq botm
      (make-operator
       :opid 'botm
       :name '(Bounding-overwatch-technique-of-movement
	       $group $movement $xy1 $xy2 $exec-time )
       :cost 11 ;= totm + col + mfls + 1 ;consider only after TT/totm leg tried
       :stage 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2 $movement
					No-traveling-formation
					Bounding-overwatch $exec-time )

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(leg-clear $xy1 $xy2)
			;; minimum travel distance?
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2 Speed-moderate
					  Security-excellent
					  Bounding-overwatch )
			(NOT started-on-leg $group $xy1 $xy2
			     $movement No-traveling-formation
			     Bounding-overwatch $exec-time )

			(ready-for-drill $group $xy1 $xy2 $exec-time 2.5)
			)))
;; The same security or better should be possible by traveling along a ridge
;;  which separates you from the enemy.

;;--------------------------------------------------------------------------
;; Battle Drills             STAGE 4
;;--------------------------------------------------------------------------

(setq nbd
      (make-operator
       :opid 'nbd
       :name '(No-battle-drill $group $xy1 $xy2 $exec-time $tt-multiplier)
       :cost 1 ;must have some cost, so reqd ops can cost less
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2 $exec-time
					 $tt-multiplier )
			)
       :effects       '(
			(drill-scheduled $exec-time $tt-multiplier)
			(NOT ready-for-drill $group $xy1 $xy2 $exec-time
			                     $tt-multiplier )
			)))

(setq cfcr
      (make-operator
       :opid 'cfcr
       :name '(Contact-from-contact-report $group $xy1 $xy2 $xy3 $x4 $x5
					   $direct-or-indirect
					   $exec-time $tt-multiplier )
       :cost 2
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2 $exec-time
					 $tt-multiplier )

			;require cover for enemy??? represent field of vision??

			;add travel time!!!!!!!!!!!!!!!
			(item $xy3 Enemy-small-arms-fire $exec-time)
			(subsegment $x4 $x5 $x1 $x2)
			(separation $x4 $x3 0.0 1.0);1km is max range sm-arms
			(separation $x5 $x3 0.0 2.5);2.5 is max range our tank
			(contact-report-given-to
			 $group $xy4 $xy3 No-antitank-weapons )

			;cribbed from FTG
			(fire-order-given-to $group $xy4 $xy3
					     $direct-or-indirect )
			)
       :effects       '(
			;cribbed from FTG
			(firing-on $group $xy3 $direct-or-indirect $xy4 $xy5)
			;not used with cribs
			;(item-targeted $group $xy4 Ground $xy3)

			;v no time added (yet)
			(drill-scheduled $exec-time $tt-multiplier)
			(NOT ready-for-drill $group $xy1 $xy2 $exec-time
			                     $tt-multiplier )
			)))

;;DP - I would think training for contact drills would be harder when the
;;     CoCmdr did not provide warnings by giving contact reports, so I've
;;     made this op more expensive to reflect its less frequent use.
(setq cfs
      (make-operator
       :opid 'cfs
       :name '(Contact-from-sighting $group $xy1 $xy2 $xy3 $x4 $x5 $exec-time
				     $tt-multiplier )
       :cost 3
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2 $exec-time
					 $tt-multiplier )

			;require cover for enemy??? represent field of vision??
			(item $xy3 Enemy-small-arms-fire $exec-time)
			(subsegment $x4 $x5 $x1 $x2)
			(separation $x4 $x3 0.0 1.0);1km is max range sm-arms
			(separation $x5 $x3 0.0 2.5);2.5 is max range our tank

			;cribbed from FTG
			(fire-order-given-to $group $xy4 $xy3
					     $direct-or-indirect )
			)
       :effects       '(
			;cribbed from FTG
			(firing-on $group $xy3 $direct-or-indirect $xy4 $xy5)
			;not used with cribs
			;(item-targeted $group $xy4 Ground $xy3)

			;v no time added (yet)
			(drill-scheduled $exec-time $tt-multiplier)
			(NOT ready-for-drill $group $xy1 $xy2 $exec-time
			                     $tt-multiplier )
			)))
#|
;; So far, firing is the only order issued in the middle of a leg.
(setq ftg
      (make-operator
       :opid 'ftg
       :name '(Fire-toward-ground $group $xy4 $xy5 $xy3 $direct-or-indirect)
       :cost 1
       :stage 4
       :preconditions '(
			(item-targeted $group $xy4 Ground $xy3)

			(fire-order-given-to $group $xy4 $xy3
					     $direct-or-indirect )
			)
       :effects       '(
			(firing-on $group $xy3 $direct-or-indirect $xy4 $xy5)
			(NOT item-targeted $group $xy4 Ground $xy3)
			)))
|#
(setq ef
      (make-operator
       :opid 'ef
       :name '(End-fire $group $xy3 $direct-or-indirect $xy4 $xy5)
       :cost 1
       :stage 4
       :preconditions '(
			(firing-on $group $xy3 $direct-or-indirect $xy4 $xy5)

			(cease-fire-order-given-to $group $xy5 $xy3
						   $direct-or-indirect )
			)
       :effects       '(
			(NOT firing-on $group $xy3 $direct-or-indirect
 			               $xy4 $xy5)
			)))
;;What if target is destroyed before reaching xy5?

(setq fia
      (make-operator
       :opid 'fia
       :name '(Fire-into-air $group $xy1 $xy2 $xy3 $xy4 $xy5 $foo $exec-time
			     $tt-multiplier )
       :cost 1
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2 $exec-time
					 $tt-multiplier )
			;(item-targeted $group $xy4 Air $xy3)

			(terrain-type $xy3 Mountain $foo) ;foo is speed-factor
			(same-segment-space $xy3 $xy1 $xy2 2.0)
			(item $xy4 Helicopter $exec-time)
			(separation $xy4 $xy3 0.1 0.6)
			(vector-intersects $xy4 $xy3 $xy1 $xy2 $xy5)
			;$xy5 is the intersect pt; it is a val ret'd by the CSP
			)
       :effects       '(
			;;This represents a way of 'firing' ABOVE a grid point
			(enemy-forced-to-evade $group $xy1 $xy2 $xy5 $xy4
					       $exec-time $tt-multiplier )
			)))

;; Beware: The 'angle-formed' constraint here would lead to a very sharp
;;  right turn if the helicopter attacked from the right.
(setq vfaa
      (make-operator
       :opid 'vfaa
       :name '(Veer-from-air-attack $group $xy1 $xy2 $xy5 $xy4 $xy6
				    $speed $security $method
				    $exec-time $tt-multiplier $t-time1 $t-time2)
       :cost 4
       :stage 4
       :preconditions '(
			(enemy-forced-to-evade $group $xy1 $xy2 $xy5 $xy4
					       $exec-time $tt-multiplier )
			(moving-along-leg $group $xy1 $xy2 ;here only to get
					  $speed $security ; binds for canceling
					  $method )

			(angle-formed $xy4 $xy5 $xy6 45.0) ;xy5 is apex
			(separation $xy5 $xy6 0.2 0.5)
			(terrain-type $xy6 Forest $foo) ;or any cover
			(leg-clear $xy5 $xy6)
			(leg-lateral-space $xy5 $xy6 (options 4 5+))
			(loc-empty $xy6)
			(collective-travel-time $xy1 $xy5 $t-time1)
			(collective-travel-time $xy5 $xy6 $t-time2)
			)
       :effects       '(
			(stopped-at $group $xy6
				    (+ $exec-time
				       (* $t-time1
					  $tt-multiplier )
				       $t-time2 ))
			(NOT moving-along-leg $group $xy1 $xy2 ;because of
			                      $speed $security ; premature stop
					      $method )
			;since chaining from goal, no need to prev Mtle & Stop's

			(NOT enemy-forced-to-evade $group $xy1 $xy2 $xy5 $xy4
			                           $exec-time $tt-multiplier )

			;not used:(drill-scheduled $exec-time $tt-multiplier)
			(NOT ready-for-drill $group $xy1 $xy2
			                     $exec-time $tt-multiplier )
			)))

;; DRILL: React to indirect fire
;;  add operator(s) here


;; ---------------------------------------------------------------------------
;; Methods for completing travel     STAGE 5
;; ---------------------------------------------------------------------------

(setq mtle-nbo
      (make-operator
       :opid 'mtle-nbo
       :name '(Move-to-leg-end-nbo $group $xy1 $xy2 $speed $security
				   $tform $method $fire-f $fire-l $fire-r
				   $exec-time $tt-multiplier $t-time )
       :cost 1
       :stage 5
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security $method )
			(in-trav-formation $group $xy1 $xy2 $tform 
					   $fire-f $fire-l $fire-r $method )
			(NOT = Bounding-overwatch $method)

			(drill-scheduled $exec-time $tt-multiplier)
			(loc-empty $xy2)
			(collective-travel-time $xy1 $xy2 $t-time)
			(precedes $xy1 $xy2) ;Used only for determining
			) ; checkpoint ordering after planning (for graphing);
       :effects       '(  ; hence, not on critical list
			(at-location $group $xy2
				     (+ $exec-time
					(* $tt-multiplier $t-time) ))
			(NOT in-trav-formation $group $xy1 $xy2 $tform
			     $fire-f $fire-l $fire-r $method )

			(NOT drill-scheduled $exec-time $tt-multiplier)
			)))
;; Collective-travel-time is calculated by getting the speed-factors for
;;  each of the terrain squares between xy1 and xy2, multiplying each
;;  of those factors by the length of the path segment within its square,
;;  and summing those products.
;;      (terrain-type $xy $terr-type $speed-factor)
;; Exec-time and the TT-speed-multiplier are included in the Ready-for-drill
;;  effect in case we later want to be able to calculate the specific time
;;  intervals that an enemy unit should be present for a battle drill.

(setq mtle-bo
      (make-operator
       :opid 'mtle-bo
       :name '(Move-to-leg-end-bo $group $xy1 $xy2 $speed $security
				  $exec-time $tt-multiplier $t-time )
       :cost 2 ;DP thinks this act is less common than Mtle-nbo
       :stage 5
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  Bounding-overwatch )

			(drill-scheduled $exec-time $tt-multiplier)
			(loc-empty $xy2)            ;^ should be 2.5, but leave
			(collective-travel-time $xy1 $xy2 $t-time)
			(precedes $xy1 $xy2)
			)
       :effects       '(
			(at-location $group $xy2
				     (+ $exec-time
					(* $tt-multiplier $t-time) ))
			
			(NOT drill-scheduled $exec-time $tt-multiplier)
			)))

(setq htf
      (make-operator
       :opid 'htf
       :name '(Halt-traveling-formation $group $xy1 $xy2 $speed $security
					$tform $method $fire-f $fire-l $fire-r
					$exec-time $tt-multiplier $t-time )
       :cost 3 ;DP thinks this act is less common than Mtle-bo
       :stage 5
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method )
			(in-trav-formation $group $xy1 $xy2 $tform
					   $fire-f $fire-l $fire-r $method )

			(drill-scheduled $exec-time $tt-multiplier)
			(stop-order-given-to $group $xy2
						    $tform ) ;was 'Immed-halt
			(collective-travel-time $xy1 $xy2 $t-time)
			(loc-empty $xy2)
			(loc-radial-space $xy2 (options 4 5+))
			(precedes $xy1 $xy2)
			)
       :effects       '(
			(stopped-at $group $xy2
				     (+ $exec-time
					0.05 ;time needed to stop
					(* $tt-multiplier $t-time) ))
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method )

			(NOT drill-scheduled $exec-time $tt-multiplier)
			)))

;;--------------------------------------------------------------------------
;; Methods of stopping / Stationary formations       STAGE 6
;;--------------------------------------------------------------------------

(setq siherr
      (make-operator
       :opid 'siherr
       :name '(Stop-in-herringbone $group $xy1 $xy2 $speed $security $method
				   $exec-time $xy3 $direct-or-indirect
				   )
       :cost 1 ;cheaper because easier, although less secure
       :stage 6
       :preconditions '(
			(at-location $group $xy2 $exec-time)
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method )
			(NOT firing-on $group $xy3 $direct-or-indirect
			               $xy1 $xy2 )

			(stop-order-given-to $group $xy2 Herringbone)
			(loc-radial-space $xy2 (options 2 3 4 5+))
			(loc-empty $xy2) ;added to help CSP w/Initial State
			;; minimum execution distance?
			)
       :effects       '(
			(in-stat-formation $group $xy2 Herringbone
					   Security-good Execute-fast
					   Move-out-fast (+ $exec-time 0.1) )
			(NOT moving-along-leg $group $xy1 $xy2
			                      $speed $security $method )
			)))

(setq sicoil
      (make-operator
       :opid 'sicoil
       :name '(Stop-in-coil $group $xy1 $xy2 $speed $security $method
			    $exec-time $xy3 $direct-or-indirect )
       :cost 2
       :stage 6
       :preconditions '(
			(at-location $group $xy2 $exec-time)
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security $method )
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2 )

			(stop-order-given-to $group $xy2 Coil)
			(loc-radial-space $xy2 (options 4 5+))
			(loc-empty $xy2) ;added to help CSP w/Initial State
			;; minimum execution distance?
			)
       :effects       '(
			(in-stat-formation $group $xy2 Coil
					   Security-excellent Execute-slow
					   Move-out-slow (+ $exec-time 0.2) )
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method )
			)))

;;---------------------------------------------------------------------------
;;
;; filter imposition operators are used in post virtual plan modification
;;
;;---------------------------------------------------------------------------

;;note: filter operators have a NIL stage value

;;note: filter ops have a cost of 1, not 0, so that there will be a
;; preference for reusing ops (e.g., LEG-CLEAR is needed twice)

(setq impose-<
      (make-operator
       :opid 'impose-<
       :name '(< $a $b)
       :cost 1
       :preconditions '()
       :effects       '((< $a $b)) ))
(setq impose-fv
      (make-operator
       :opid 'impose-fv
       :name '(viewable $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((viewable $a $b $c $d)) ))
(setq impose-fnv
      (make-operator
       :opid 'impose-fnv
       :name '(none-viewable $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((none-viewable $a $b $c $d)) ))
(setq impose-faf
      (make-operator
       :opid 'impose-faf
       :name '(angle-formed $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((angle-formed $a $b $c $d)) ))
(setq impose-fm
      (make-operator
       :opid 'impose-fm
       :name '(minimize $a)
       :cost 1
       :preconditions '()
       :effects       '((minimize $a)) ))
(setq impose-fmogt
      (make-operator
       :opid 'impose-fmogt
       :name '(move-order-given-to $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((move-order-given-to $a $b $c $d $e)) ))
(setq impose-famogt
      (make-operator
       :opid 'impose-famogt
       :name '(action-move-order-given-to $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((action-move-order-given-to $a $b $c $d $e)) ))
(setq impose-fc
      (make-operator
       :opid 'impose-fc
       :name '(leg-clear $a $b)
       :cost 1
       :preconditions '()
       :effects       '((leg-clear $a $b)) ))
(setq impose-flls
      (make-operator
       :opid 'impose-flls
       :name '(leg-lateral-space $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((leg-lateral-space $a $b $c)) ))
(setq impose-fo
      (make-operator
       :opid 'impose-fo
       :name '(overwatching $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((overwatching $a $b $c $d)) ))
(setq impose-fi
      (make-operator
       :opid 'impose-fi
       :name '(item $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((item $a $b $c)) ))
(setq impose-fss
      (make-operator
       :opid 'impose-fss
       :name '(subsegment $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((subsegment $a $b $c $d)) ))
(setq impose-fs
      (make-operator
       :opid 'impose-fs
       :name '(separation $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((separation $a $b $c $d)) ))
(setq impose-fcrgt
      (make-operator
       :opid 'impose-fcrgt
       :name '(contact-report-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((contact-report-given-to $a $b $c $d)) ))
(setq impose-ffogt
      (make-operator
       :opid 'impose-ffogt
       :name '(fire-order-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((fire-order-given-to $a $b $c $d)) ))
(setq impose-fcfogt
      (make-operator
       :opid 'impose-fcfogt
       :name '(cease-fire-order-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((cease-fire-order-given-to $a $b $c $d)) ))
(setq impose-ftt
      (make-operator
       :opid 'impose-ftt
       :name '(terrain-type $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((terrain-type $a $b $c)) ))
(setq impose-fsss
      (make-operator
       :opid 'impose-fsss
       :name '(same-segment-space $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((same-segment-space $a $b $c $d)) ))
(setq impose-fvi
      (make-operator
       :opid 'impose-fvi
       :name '(vector-intersects $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((vector-intersects $a $b $c $d $e)) ))
(setq impose-fle
      (make-operator
       :opid 'impose-fle
       :name '(loc-empty $a)
       :cost 1
       :preconditions '()
       :effects       '((loc-empty $a)) ))
(setq impose-flrs
      (make-operator
       :opid 'impose-flrs
       :name '(loc-radial-space $a $b)
       :cost 1
       :preconditions '()
       :effects       '((loc-radial-space $a $b)) ))
(setq impose-fctt
      (make-operator
       :opid 'impose-fctt
       :name '(collective-travel-time $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((collective-travel-time $a $b $c)) ))
(setq impose-fp
      (make-operator
       :opid 'impose-fp
       :name '(precedes $a $b)
       :cost 1
       :preconditions '()
       :effects       '((precedes $a $b)) ))
(setq impose-fsogt
      (make-operator
       :opid 'impose-fsogt
       :name '(stop-order-given-to $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((stop-order-given-to $a $b $c)) ))


;; ---------------------------------------------------------------------------
;; actual operator list used in domain

(let (;(stage0-ops (list wihtf wisf))
      (stage1-ops (list mfls ad mofsf mofhtf))
      (stage2-ops (list ctf sctf wltf wrtf eltf ertf vtf ltf))
      (stage3-ops (list ttm totm botm))
      (stage4-ops (list nbd cfcr cfs #|ftg|# ef fia vfaa))
      (stage5-ops (list mtle-nbo mtle-bo htf))
      (stage6-ops (list siherr sicoil))
      (filter-ops (list impose-<
			impose-fv     impose-fnv    impose-faf   impose-fm
			impose-fmogt  impose-famogt impose-fc    impose-flls
			impose-fo
			impose-fi     impose-fss    impose-fs    impose-fcrgt
			impose-ffogt  impose-fcfogt impose-ftt   impose-fsss
			impose-fvi    impose-fle    impose-flrs  impose-fctt
			impose-fsogt  impose-fp ))
      )
  (setq *operators* (append #|stage0-ops|# stage1-ops stage2-ops stage3-ops
			    stage4-ops stage5-ops stage6-ops filter-ops) ))

;; ---------------------------------------------------------------------------
;; preconditions requiring NEW operators for establishment
;;  (ie they WILL NOT make use of existing establishers)

(setq *precond-new-est-only-list* nil)
;; Obsolete: reuse even filter-ops if possible!!!

;; ---------------------------------------------------------------------------
;; AbTweak domain part - criticality lists, used only in Abtweak 
;;
;; satisfied first = high, last = lower

(setq
 *critical-list*
 '(
   (2
    (=     $ $) ;this predicate has an attached procedure
    (NOT = $ $)
    (stopped-at      $ $ $)
    (NOT stopped-at  $ $ $)
    (in-stat-formation     $ $ $ $ $ $ $)
    (NOT in-stat-formation $ $ $ $ $ $ $)
    (at-location     $ $ $)
    (NOT at-location $ $ $)
    (moving-along-leg     $ $ $ $ $ $)
    (NOT moving-along-leg $ $ $ $ $ $)
    (started-on-leg     $ $ $ $ $ $ $)
    (NOT started-on-leg $ $ $ $ $ $ $)
    (in-trav-formation     $ $ $ $ $ $ $ $)
    (NOT in-trav-formation $ $ $ $ $ $ $ $)
    )
   (1
    (ready-for-drill     $ $ $ $ $)
    (NOT ready-for-drill $ $ $ $ $)
    (drill-scheduled     $ $)
    (NOT drill-scheduled $ $)
    (item-targeted       $ $ $ $)
    (NOT item-targeted   $ $ $ $)
    (firing-on     $ $ $ $ $)
    (NOT firing-on $ $ $ $ $)
    (enemy-forced-to-evade     $ $ $ $ $ $ $)
    (NOT enemy-forced-to-evade $ $ $ $ $ $ $)
    )
   (0
    (<     $ $)
    (NOT < $ $)
    (viewable $ $ $ $)
    (none-viewable $ $ $ $)
    (angle-formed $ $ $ $)
    (minimize $)
    (move-order-given-to $ $ $ $ $)
    (action-move-order-given-to $ $ $ $ $)
    (leg-clear $ $)
    (leg-lateral-space $ $ $)
    (overwatching $ $ $ $)
    (item $ $ $)
    (subsegment $ $ $ $)
    (separation $ $ $ $)
    (contact-report-given-to $ $ $ $)
    (fire-order-given-to $ $ $ $)
    (cease-fire-order-given-to $ $ $ $)
    (terrain-type $ $ $)
    (same-segment-space $ $ $ $)
    (vector-intersects $ $ $ $ $)
    (loc-empty $) 
    (loc-radial-space $ $)
    (collective-travel-time $ $ $)
    (precedes $ $)
    (stop-order-given-to $ $ $)
    )
   ))

(setq *critical-loaded* 'caeti-default8)

;;**************** settings for left-wedge mode *************
;; preference values for each successive level of abstraction
;;  - related to top down property
;;  this value is factored into the heuristic for preference of
;;  plans - essentially preferring level k over level k+1 by a
;;  depth-factor as indicated in *k-list* at this k

(setq *left-wedge-list* '(0 0))
