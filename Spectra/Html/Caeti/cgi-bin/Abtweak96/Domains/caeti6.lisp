;; Pautler CAETI 5 CHANGED Jan 10/97

;***************************************************************************
;*****                           CAETI operators                       *****
;***************************************************************************

(setq *domain* 'caeti6)

(defun lcs () (load "Domains/caeti6"))

;;--------------------------------------------------------------------------
;; Move-out methods     STAGE 1
;;--------------------------------------------------------------------------

(setq mfls
      (make-operator
       :opid 'mfls
       :name '(Move-from-leg-start $group $xy1 $xy2 $xy3
				   $speed $security $method)
       :cost 1
       :stage 1
       :preconditions '(
			(at-location      $group $xy2)
			(moving-along-leg $group $xy1 $xy2
					  $speed $security $method)

			(oriented-from $xy2 $xy3 Forward $xy1 $xy2)
			(move-order-given-to $group $xy2
					     Move-Through $tform $method)
			)
       :effects       '(
			(started-on-leg $group $xy2 $xy3
					Move-Through $tform $method)
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method)
			(NOT at-location $group $xy2)
			)))

(setq mofsf
      (make-operator
       :opid 'mofsf
       :name '(Move-out-from-stat-form $group $xy1 $xy2
				       $sform $security $exec-speed
				       $mv-out-speed $tform $method)
       :cost 1
       :stage 1
       :preconditions '(
			(in-stat-formation $group $xy1 $sform 
					   $security $exec-speed 
					   $mv-out-speed)

			(leg-clear $xy1 $xy2)
			(move-order-given-to
			 $group $xy1 Move-From $tform $method)
			)
       :effects       '(
			(started-on-leg $group $xy1 $xy2
					Move-From $tform $method)
			(NOT in-stat-formation $group $xy1 $sform
			     $security $exec-speed $mv-out-speed)
			)))

;; There does not appear to be a reason to prefer one method of moving
;; out over another as a default, so this is the same cost as Mofsf.
(setq mofhtf
      (make-operator
       :opid 'mofhtf
       :name '(Move-out-from-halted-trav-formation
	       $group $xy1 $xy2 $tform2 $fire-f $fire-l $fire-r
	       $tform1 $method
	       )
       :cost 1
       :stage 1
       :preconditions '(
			(stopped-at $group $xy1)
			(in-trav-formation $group $xy1 $xy2 $tform1
					   $fire-f $fire-l $fire-r
					   $method)

			(leg-clear $xy1 $xy2)
			(move-order-given-to
			 $group $xy1 Move-From $tform2 $method)
			)
       :effects       '(
			(started-on-leg $group $xy1 $xy2
					Move-From $tform2 $method)
			(NOT in-trav-formation $group $xy1 $xy2 $tform1
			     $fire-f $fire-l $fire-r $method)
			(NOT stopped-at $group $xy1)
			)))

;;--------------------------------------------------------------------------
;; Traveling formations     STAGE 2
;;--------------------------------------------------------------------------
;;
;; Troops prefer wedges to staggered columns, which they prefer to columns;
;; so, staggered columns and columns are made more expensive here.  I assume
;; that echelons, lines, and vees are comparable to staggered columns.

(setq cmf
      (make-operator
       :opid 'cmf
       :name '(Column-moving-formation $group $xy1 $xy2 $movement $method)
       :cost 3
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Column $method)

			(leg-lateral-space $xy1 $xy2 (options 1 2 3 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Column
					   F-fire-mod L-fire-mod R-fire-mod
					   $method)
			)))

(setq scmf
      (make-operator
       :opid 'scmf
       :name '(Staggered-column-moving-formation
	       $group $xy1 $xy2 $movement $method
	       )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Stag-column $method)

			(leg-lateral-space $xy1 $xy2 (options 2 3 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Stag-column
					   F-fire-good L-fire-good
					   R-fire-good $method)
			)))
(setq wlmf
      (make-operator
       :opid 'wlmf
       :name '(Wedge-left-moving-formation ;;left flank is longer
	       $group1 $xy1 $xy2 $group2 $movement $method
	       )
       :cost 1
       :stage 2
       :preconditions '(
			(started-on-leg $group1 $xy1 $xy2
					$movement Wedge-l $method)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Wedge-l
					   F-fire-excellent L-fire-good
					   R-fire-moderate $method)
			))) 
(setq wrmf
      (make-operator
       :opid 'wrmf
       :name '(Wedge-right-moving-formation
	       $group1 $xy1 $xy2 $group2 $movement $method
	       )
       :cost 1
       :stage 2
       :preconditions '(
			(started-on-leg $group1 $xy1 $xy2
					$movement Wedge-r $method)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Wedge-r
					   F-fire-excellent
					   L-fire-moderate R-fire-good
					   $method)
			)))
(setq elmf
      (make-operator
       :opid 'elmf
       :name '(Echelon-left-moving-formation
	       $group $xy1 $xy2 $movement $method
	       )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Echelon-l $method)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Echelon-l
					   F-fire-excellent L-fire-excellent
					   R-fire-bad $method)
			))) 
(setq ermf
      (make-operator
       :opid 'ermf
       :name '(Echelon-right-moving-formation
	       $group $xy1 $xy2 $movement $method
	       )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Echelon-r $method)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Echelon-r
					   F-fire-excellent L-fire-bad
					   R-fire-excellent $method)
			)))

(setq vmf ;;; !!!!!!!!!!! The fire values for the Vee are only guesses
      (make-operator
       :opid 'vmf
       :name '(Vee-moving-formation
	       $group $xy1 $xy2 $movement $method
	       )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Vee $method)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Vee
					   F-fire-excellent L-fire-moderate
					   R-fire-moderate $method)
			)))
(setq lmf
      (make-operator
       :opid 'lmf
       :name '(Line-moving-formation
	       $group1 $xy1 $xy2 $group2 $movement $method
	       )
       :cost 2
       :stage 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Line $method)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Line
					   F-fire-excellent L-fire-bad
					   R-fire-bad $method)
			)))

;;--------------------------------------------------------------------------
;; Traveling methods     STAGE 3
;;--------------------------------------------------------------------------

(setq ttm
      (make-operator
       :opid 'ttm
       :name '(Traveling-technique-of-movement
	       $group $xy1 $xy2 $movement $tform)
       :cost 1
       :stage 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement $tform Trav-techn)
			(in-trav-formation $group $xy1 $xy2 $tform
					   (options F-fire-mod F-fire-good
						    F-fire-excellent)
					   $u5 $u6
					   Trav-techn)

			(leg-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-excellent Security-mod
					  Trav-techn)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Trav-techn)

			(ready-for-drill $group $xy1 $xy2)
			)))

;; The only kinds of traveling formations used with the traveling overwatch
;;  in the training tables are staggered column and vee.  We do not know
;;  if those two are more appropriate for traveling overwatches than others
;;  or why.
(setq totm
      (make-operator
       :opid 'totm
       :name '(Traveling-overwatch-technique-of-movement
	       $group $xy1 $xy2 $movement $tform)
       :cost 6 ;=TT + col + mfls + 1 ;consider only after TT leg tried
       :stage 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement $tform Trav-overw)
			(in-trav-formation $group $xy1 $xy2 $tform
					   (options F-fire-good
						    F-fire-excellent) 
					   $u5 $u6
					   Trav-overw)

			(leg-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-good Security-good
					  Trav-overw)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Trav-overw)

			(ready-for-drill $group $xy1 $xy2)
			)))

;; Bounding overwatches do not use traveling formations. -DHarper
;; The platoon leader chooses which kind of bounding overwatch to use,
;;  typically, not the CoCmdr. -DHarper

(setq botm
      (make-operator
       :opid 'botm
       :name '(Bounding-overwatch-technique-of-movement
	       $group $xy1 $xy2 $movement)
       :cost 11 ;= totm + col + mfls + 1 ;consider only after TT/totm leg tried
       :stage 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement No-Tform Bound-overw)

			(leg-lateral-space $xy1 $xy2 (options 4 5+))
			(leg-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-mod Security-excellent
					  Bound-overw)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement No-Tform Bound-overw)

			(ready-for-drill $group $xy1 $xy2)
			)))

; STAGE 4 is battle drills (see below)

;; ---------------------------------------------------------------------------
;; Methods for completing travel     STAGE 5
;; ---------------------------------------------------------------------------

(setq mtle-nbo
      (make-operator
       :opid 'mtle-nbo
       :name '(Move-to-leg-end-nbo $group $xy1 $xy2 $speed $security
				   $tform $fire-f $fire-l $fire-r
				   $method
				   )
       :cost 1
       :stage 5
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security $method)
			(in-trav-formation $group $xy1 $xy2 $tform 
					   $fire-f $fire-l $fire-r
					   $method)
			(not = Bound-overw $method)

			(drill-scheduled)
			(loc-empty $xy2)
			(precedes $xy1 $xy2) ;Used only for determining checkpoint ordering after
			)                    ; planning (for graphing); hence, not on critical list
       :effects       '(
			(at-location $group $xy2)
			(NOT in-trav-formation $group $xy1 $xy2 $tform
			     $fire-f $fire-l $fire-r $method)

			(NOT drill-scheduled)
			)))

(setq mtle-bo
      (make-operator
       :opid 'mtle-bo
       :name '(Move-to-leg-end-bo $group $xy1 $xy2 $speed $security)
       :cost 1
       :stage 5
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security Bound-overw)

			(drill-scheduled)
			(loc-empty $xy2)
			(precedes $xy1 $xy2)
			)
       :effects       '(
			(at-location $group $xy2)
			
			(NOT drill-scheduled)
			)))

(setq htf
      (make-operator
       :opid 'htf
       :name '(Halt-trav-formation $group $xy1 $xy2 $speed $security
				   $tform $fire-f $fire-l $fire-r
				   $method)
       :cost 2
       :stage 5
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method)
			(in-trav-formation $group $xy1 $xy2 $tform
					   $fire-f $fire-l $fire-r
					   $method)

			(drill-scheduled)
			(stop-order-given-to $group $xy2
						    $tform) ;was 'Immed-halt
			(loc-empty $xy2)
			)
       :effects       '(
			(stopped-at $group $xy2)
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method)

			(NOT drill-scheduled)
			)))

;;--------------------------------------------------------------------------
;; Methods of stopping / Stationary formations
;;--------------------------------------------------------------------------

(setq sicoil
      (make-operator
       :opid 'sicoil
       :name '(Stop-in-coil $group $xy1 $xy2 $speed $security $method
			    $xy3 $direct-or-indirect )
       :cost 1
       :stage 6
       :preconditions '(
			(at-location $group $xy2)
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security $method)
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2)

			(stop-order-given-to $group $xy2 Coil)
			(loc-radial-space $xy2 (options 4 5+))
			(loc-empty $xy2) ;added to help CSP w/Initial State
			)
       :effects       '(
			(in-stat-formation $group $xy2 Coil
					   Security-excl Execute-slow
					   Move-out-slow)
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method)
			)))

(setq siherr
      (make-operator
       :opid 'siherr
       :name '(Stop-in-herringbone $group $xy1 $xy2 $speed $security $method
			    $xy3 $direct-or-indirect )
       :cost 2
       :stage 6
       :preconditions '(
			(at-location $group $xy2)
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method)
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2)

			(stop-order-given-to $group $xy2 Herringbone)
			(loc-radial-space $xy2 (options 2 3 4 5+))
			(loc-empty $xy2) ;added to help CSP w/Initial State
			)
       :effects       '(
			(in-stat-formation $group $xy2 Herringbone
					   Security-good
					   Execute-fast Move-out-fast)
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method )
			)))

;;--------------------------------------------------------------------------
;; Battle Drills
;;--------------------------------------------------------------------------

(setq nbd
      (make-operator
       :opid 'nbd
       :name '(No-battle-drill $group $xy1 $xy2)
       :cost 0
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)
			)
       :effects       '(
			(drill-scheduled)
			(NOT ready-for-drill $group $xy1 $xy2)
			)))

(setq cfcr
      (make-operator
       :opid 'cfcr
       :name '(Contact-from-contact-report $group $xy1 $xy2 $xy3)
       :cost 1
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)

			;require cover for enemy???
			(item Enemy-small-arms-fire $xy3)
			(same-segment-space $xy3 $xy1 $xy2 1)
			(contact-report-given-to
			 $group $xy1 $xy2 $xy3 No-antitank-weapons)

			;cribbed from FTG
			(fire-order-given-to $group $xy1 $xy2 $xy3
						    $direct-or-indirect)
			)
       :effects       '(
			;cribbed from FTG
			(firing-on $group $xy3 $direct-or-indirect
				   $xy1 $xy2)
			;not used with cribs
			;(item-targeted $group $xy1 $xy2 Ground $xy3)

			(drill-scheduled)
			(NOT ready-for-drill $group $xy1 $xy2)
			)))

;;DP - I would think training for contact drills would be harder when the
;;     CoCmdr did not provide warnings by giving contact reports, so I've
;;     made this op more expensive to reflect its less frequent use.
(setq cfs
      (make-operator
       :opid 'cfs
       :name '(Contact-from-sighting $group $xy1 $xy2 $xy3)
       :cost 2
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)

			;require cover for enemy???
			(item Enemy-small-arms-fire $xy3)
			(same-segment-space $xy3 $xy1 $xy2 1)

			;cribbed from FTG
			(fire-order-given-to $group $xy1 $xy2 $xy3
						    $direct-or-indirect)
			)
       :effects       '(
			;cribbed from FTG
			(firing-on $group $xy3 $direct-or-indirect
				   $xy1 $xy2)
			;not used with cribs
			;(item-targeted $group $xy1 $xy2 Ground $xy3)

			(drill-scheduled)
			(NOT ready-for-drill $group $xy1 $xy2)
			)))
#|
;; So far, firing is the only order issued in the middle of a leg.
(setq ftg
      (make-operator
       :opid 'ftg
       :name '(Fire-toward-ground $group $xy1 $xy2 $xy3 $direct-or-indirect)
       :cost 1
       :stage 4
       :preconditions '(
			(item-targeted $group $xy1 $xy2 Ground $xy3)

			(fire-order-given-to $group $xy1 $xy2 $xy3
						    $direct-or-indirect)
			)
       :effects       '(
			(firing-on $group $xy3 $direct-or-indirect
				   $xy1 $xy2)
			(NOT item-targeted $group $xy1 $xy2 Ground $xy3)
			)))
|#
(setq ef
      (make-operator
       :opid 'ef
       :name '(End-fire $group $xy3 $direct-or-indirect $xy1 $xy2)
       :cost 0
       :stage 4
       :preconditions '(
			(firing-on $group $xy3 $direct-or-indirect
				   $xy1 $xy2)
			)
       :effects       '(
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2)
			)))
#|
(setq fia
      (make-operator
       :opid 'fia
       :name '(Fire-into-air $group $xy1 $xy2 $xy3 $xy4 $xy5)
       :cost 1
       :stage 4
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)
			;(item-targeted $group $xy1 $xy2 Air $xy3)

			(item Mountain $xy3)
			(same-segment-space $xy3 $xy1 $xy2 2)
			(item Helicopter $xy4)
			(separation $xy4 $xy3 1 1)
			(vector-intersects $xy4 $xy3 $xy1 $xy2 $xy5)
			;$xy5 is the intersect pt; it is a val ret'd by the CSP
			)
       :effects       '(
			(enemy-forced-to-evade $group $xy1 $xy2 $xy5 $xy4)
			)))

(setq vfaa
      (make-operator
       :opid 'vfaa
       :name '(Veer-from-air-attack $group $xy1 $xy2 $xy3 $xy4 $xy5)
       :cost 1
       :stage 4
       :preconditions '(
			(enemy-forced-to-evade $group $xy1 $xy2 $xy3 $xy4)

			(angle-formed $xy3 $xy4 $xy5 45) ;xy3 is apex
			(separation $xy3 $xy5 1 1)
			(item Forest $xy5) ;or any cover
			)
       :effects       '(
			;'Stopped' should force a second leg in order to get
			; to the goal, but that's not fixed yet.
			;(stopped-at $group $xy5)
			(NOT enemy-forced-to-evade $group $xy1 $xy2 $xy3 $xy4)

			(drill-scheduled)
			(NOT ready-for-drill $group $xy1 $xy2)
			)))
|#
;---------------------------------------------------------------------------
;
; filter imposition operators are used in post virtual plan modification
;
;---------------------------------------------------------------------------

;;note: filter operators have a NIL stage value

;;note: filter ops have a cost of 1, not 0, so that there will be a
;; preference for reusing LEG-CLEAR ops

(setq impose-fof
      (make-operator
       :opid 'impose-fof
       :name '(oriented-from $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((oriented-from $a $b $c $d $e))))
(setq impose-fmogt
      (make-operator
       :opid 'impose-fmogt
       :name '(move-order-given-to $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((move-order-given-to $a $b $c $d $e))))
(setq impose-fc
      (make-operator
       :opid 'impose-fc
       :name '(leg-clear $a $b)
       :cost 1
       :preconditions '()
       :effects       '((leg-clear $a $b))))
(setq impose-flls
      (make-operator
       :opid 'impose-flls
       :name '(leg-lateral-space $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((leg-lateral-space $a $b $c))))
(setq impose-fo
      (make-operator
       :opid 'impose-fo
       :name '(overwatching $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((overwatching $a $b $c $d))))
(setq impose-fe
      (make-operator
       :opid 'impose-fe
       :name '(loc-empty $a)
       :cost 1
       :preconditions '()
       :effects       '((loc-empty $a)))) 
(setq impose-fsogt
      (make-operator
       :opid 'impose-fsogt
       :name '(stop-order-given-to $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((stop-order-given-to $a $b $c))))
(setq impose-flrs
      (make-operator
       :opid 'impose-flrs
       :name '(loc-radial-space $a $b)
       :cost 1
       :preconditions '()
       :effects       '((loc-radial-space $a $b))))
(setq impose-fi
      (make-operator
       :opid 'impose-fi
       :name '(item $a $b)
       :cost 1
       :preconditions '()
       :effects       '((item $a $b))))
(setq impose-fsss
      (make-operator
       :opid 'impose-fsss
       :name '(same-segment-space $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((same-segment-space $a $b $c $d))))
(setq impose-fcrgt
      (make-operator
       :opid 'impose-fcrgt
       :name '(contact-report-given-to $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((contact-report-given-to $a $b $c $d $e))))
(setq impose-ffogt
      (make-operator
       :opid 'impose-ffogt
       :name '(fire-order-given-to $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((fire-order-given-to $a $b $c $d $e))))
(setq impose-fs
      (make-operator
       :opid 'impose-fs
       :name '(separation $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((separation $a $b $c $d))))
(setq impose-fvi
      (make-operator
       :opid 'impose-fvi
       :name '(vector-intersects $a $b $c $d $e)
       :cost 1
       :preconditions '()
       :effects       '((vector-intersects $a $b $c $d $e))))
(setq impose-faf
      (make-operator
       :opid 'impose-faf
       :name '(angle-formed $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((angle-formed $a $b $c $d))))
(setq impose-fp
      (make-operator
       :opid 'impose-fp
       :name '(precedes $a $b)
       :cost 1
       :preconditions '()
       :effects       '((precedes $a $b))))


#| The following ops have no use in this file
(setq impose-faogt
      (make-operator
       :opid 'impose-faogt
       :name '(action-order-given-to $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((action-order-given-to $a $b $c))))
(setq impose-frf
      (make-operator
       :opid 'impose-frf
       :name '(receives-fire $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((receives-fire $a $b $c))))
(setq impose-fnhogt
      (make-operator
       :opid 'impose-fnhogt
       :name '(nohold-order-given-to $a $b)
       :cost 1
       :preconditions '()
       :effects       '((nohold-order-given-to $a $b)))) 
|#

; ---------------------------------------------------------------------------
; actual operator list used in domain
;

(setq *operators* (list
		   impose-fof
		   impose-fmogt
		   impose-fc
		   impose-flls
		   impose-fo
		   impose-fe
		   impose-fsogt
		   impose-flrs
		   impose-fi
		   impose-fsss
		   impose-fcrgt
		   impose-ffogt
		   impose-fs
		   impose-fvi
		   impose-faf
		   impose-fp
		   #|
		   impose-faogt
		   impose-frf
		   impose-fnhogt
                   |#

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
		   botm 

		   mtle-nbo 
		   mtle-bo 

		   htf

		   sicoil
		   siherr

		   nbd
		   cfcr
		   cfs
		   ;ftg
		   ef
		   ;fia
		   ;vfaa

		   ))
; ---------------------------------------------------------------------------
;
; preconditions requiring NEW operators for establishment
;  (ie they WILL NOT make use of existing establishers)
;
(setq *precond-new-est-only-list*
      '(
	;Each filter precond is satisfied by its own operator application
	(oriented-from $a $b $c $d $e)
	(move-order-given-to $a $b $c $d $e)
	;(leg-clear $a $b) ;leg-clear checked twice within each leg
	(leg-lateral-space $a $b $c)
	(overwatching $a $b $c $d)
	(loc-empty $a)
	(stop-order-given-to $a $b $c)
	(loc-radial-space $a $b)
	(item $a $b)
	(same-segment-space $a $b $c $d)
	(contact-report-given-to $a $b $c $d $e)
	(fire-order-given-to $a $b $c $d $e)
	(separation $a $b $c $d)
	(vector-intersects $a $b $c $d $e)
	(angle-formed $a $b $c $d)
	(precedes $a $b)
        
	(drill-scheduled)

	;(at-location     $ $) ;prevents use from required-ops list
	))

;***************************************************************************
; AbTweak domain part - criticality lists, used only in Abtweak 
;
; satisfied first = high, last = lower
;
;***************************************************************************

(setq *critical-list* '(
   (2
    (= $ $)
    (not = $ $)
    (at-location     $ $)
    (NOT at-location $ $)
    (moving-along-leg $ $ $ $ $ $)
    (NOT moving-along-leg $ $ $ $ $ $)
    (in-stat-formation $ $ $ $ $ $)
    (NOT in-stat-formation $ $ $ $ $ $)
    (stopped-at      $ $)
    (NOT stopped-at  $ $)
    (in-trav-formation $ $ $ $ $ $ $ $)
    (NOT in-trav-formation $ $ $ $ $ $ $ $)
    (started-on-leg $ $ $ $ $ $)
    (NOT started-on-leg $ $ $ $ $ $)
    #| These are not used in this file
    (approach-original-axis-then $ $ $)
    (NOT approach-original-axis-then $ $ $)
    (pass-obstacle-then     $ $ $)
    (NOT pass-obstacle-then $ $ $)
    (verge-from-obstacle-then     $ $ $)
    (NOT verge-from-obstacle-then $ $ $)
    |#
    )
   (1
    (ready-for-drill $ $ $)
    (NOT ready-for-drill $ $ $)
    (drill-scheduled)
    (NOT drill-scheduled)
    (item-targeted   $ $ $ $ $)
    (NOT item-targeted   $ $ $ $ $)
    (firing-on $ $ $ $ $)
    (NOT firing-on $ $ $ $ $)
    (enemy-forced-to-evade $ $ $ $ $)
    (NOT enemy-forced-to-evade $ $ $ $ $)
    )
   (0
    (oriented-from $ $ $ $ $)
    (move-order-given-to $ $ $ $ $)
    (leg-clear $ $)
    (leg-lateral-space $ $ $)
    (overwatching $ $ $ $)
    (loc-empty $) 
    (stop-order-given-to $ $ $)
    (loc-radial-space $ $)
    (item $ $)
    (same-segment-space $ $ $ $)
    (contact-report-given-to $ $ $ $ $)
    (fire-order-given-to $ $ $ $ $)
    (separation $ $ $ $)
    (vector-intersects $ $ $ $ $)
    (angle-formed $ $ $ $)
    (precedes $ $)
    #| These are not used in this file
    (action-order-given-to $ $ $)
    (nohold-order-given-to $ $)
    (receives-fire $ $ $)
    |#
    )
   ))
(setq *critical-loaded* 'caeti-default5)

;**************** settings for left-wedge mode *************

; preference values for each successive level of abstraction
;  - related to top down property
;  this value is factored into the heuristic for preference of
;  plans - essentially preferring level k over level k+1 by a
;  depth-factor as indicated in *k-list* at this k
;
(setq *left-wedge-list* '(0 0))
