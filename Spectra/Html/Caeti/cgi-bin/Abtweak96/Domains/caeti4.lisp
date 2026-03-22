;; Pautler CAETI 3b CHANGED Nov 30/96

;***************************************************************************
;*****                           CAETI operators                       *****
;***************************************************************************

(setq *domain* 'caeti4)

(defun lcs () (load "Domains/caeti4"))

;;--------------------------------------------------------------------------
;; Move-out methods
;;--------------------------------------------------------------------------

(setq mfls
      (make-operator
       :opid 'mfls
       :name '(Move-from-leg-start $group $xy1 $xy2 $xy3
				   $speed $security $method)
       :cost 1
       :preconditions '(
			(at-location      $group $xy2)
			(moving-along-leg $group $xy1 $xy2
					  $speed $security $method)
			(filter-oriented-from $xy2 $xy3 Forward
					      $xy1 $xy2)
			(filter-move-order-given-to $group $xy2
						    Move-Through $tform
						    $method)
			)
       :effects       '(
			(started-on-leg $group $xy2 $xy3
					Move-Through $tform $method)
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method)
			(NOT at-location $group $xy2)
			     
			(trigger-mfls)
			)))

(setq mofsf
      (make-operator
       :opid 'mofsf
       :name '(Move-out-from-stat-form $group $xy1 $xy2
				       $sform $security $exec-speed
				       $mv-out-speed $tform $method)
       :cost 1
       :preconditions '(
			(in-stat-formation $group $xy1 $sform 
					   $security $exec-speed 
					   $mv-out-speed)
			(filter-leg-clear $xy1 $xy2)
			(filter-move-order-given-to
			 $group $xy1 Move-From $tform $method)
			)
       :effects       '(
			(started-on-leg $group $xy1 $xy2
					Move-From $tform $method)
			(NOT in-stat-formation $group $xy1 $sform
			     $security $exec-speed $mv-out-speed)

			(trigger-mofsf)
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
       :preconditions '(
			(stopped-at $group $xy1)
			(in-trav-formation $group $xy1 $xy2 $tform1
					   $fire-f $fire-l $fire-r
					   $method)
			(filter-move-order-given-to
			 $group $xy1 Move-From $tform2 $method)
			(filter-leg-clear $xy1 $xy2)
			)
       :effects       '(
			(started-on-leg $group $xy1 $xy2
					Move-From $tform2 $method)
			(NOT in-trav-formation $group $xy1 $xy2 $tform1
			     $fire-f $fire-l $fire-r $method)
			(NOT stopped-at $group $xy1)

			(trigger-mofhtf)
			)))

;;--------------------------------------------------------------------------
;; Traveling formations
;;--------------------------------------------------------------------------
;;
;; Troops prefer wedges to staggered columns, which they prefer to columns;
;; so, staggered columns and columns are made more expensive here.  I assume
;; that echelons, lines, and vees are comparable to staggered columns.

(setq cmf
      (make-operator
       :opid 'cmf
       :name '(Column-moving-formation $group $movement $xy1 $xy2 $method)
       :cost 3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Column $method)
			(filter-leg-lateral-space $xy1 $xy2
						  (options 1 2 3 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Column
					   F-fire-mod L-fire-mod R-fire-mod
					   $method)

			(trigger-cmf)
			)))

(setq scmf
      (make-operator
       :opid 'scmf
       :name '(Staggered-column-moving-formation
	       $group $movement $xy1 $xy2 $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Stag-column $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 2 3 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Stag-column
					   F-fire-good L-fire-good
					   R-fire-good $method)

			(trigger-scmf)
			)))
(setq wlmf
      (make-operator
       :opid 'wlmf
       :name '(Wedge-left-moving-formation ;;left flank is longer
	       $group1 $group2 $movement $xy1 $xy2 $method
	       )
       :cost 1
       :preconditions '(
			(started-on-leg $group1 $xy1 $xy2
					$movement Wedge-l $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 4 5+))
			(filter-overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Wedge-l
					   F-fire-excellent L-fire-good
					   R-fire-moderate $method)

			(trigger-wlmf)
			))) 
(setq wrmf
      (make-operator
       :opid 'wrmf
       :name '(Wedge-right-moving-formation
	       $group1 $group2 $movement $xy1 $xy2 $method
	       )
       :cost 1
       :preconditions '(
			(started-on-leg $group1 $xy1 $xy2
					$movement Wedge-r $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 4 5+))
			(filter-overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Wedge-r
					   F-fire-excellent
					   L-fire-moderate R-fire-good
					   $method)

			(trigger-wrmf)
			)))
(setq elmf
      (make-operator
       :opid 'elmf
       :name '(Echelon-left-moving-formation
	       $group $movement $xy1 $xy2 $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Echelon-l $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Echelon-l
					   F-fire-excellent L-fire-excellent
					   R-fire-bad $method)

			(trigger-elmf)
			))) 
(setq ermf
      (make-operator
       :opid 'ermf
       :name '(Echelon-right-moving-formation
	       $group $movement $xy1 $xy2 $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Echelon-r $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Echelon-r
					   F-fire-excellent L-fire-bad
					   R-fire-excellent $method)

			(trigger-ermf)
			)))

(setq vmf ;;; !!!!!!!!!!! The fire values for the Vee are only guesses
      (make-operator
       :opid 'vmf
       :name '(Vee-moving-formation
	       $group $movement $xy1 $xy2 $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Vee $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 4 5+))
			)
       :effects       '(
			(in-trav-formation $group $xy1 $xy2 Vee
					   F-fire-excellent L-fire-moderate
					   R-fire-moderate $method)

			(trigger-vmf)
			)))
(setq lmf
      (make-operator
       :opid 'lmf
       :name '(Line-moving-formation
	       $group1 $group2 $movement $xy1 $xy2 $method
	       )
       :cost 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement Line $method)
			(filter-leg-lateral-space $xy1 $xy2 (options 4 5+))
			(filter-overwatching $group2 $group1 $xy1 $xy2)
			)
       :effects       '(
			(in-trav-formation $group1 $xy1 $xy2 Line
					   F-fire-excellent L-fire-bad
					   R-fire-bad $method)

			(trigger-lmf)
			)))

;;--------------------------------------------------------------------------
;; Traveling methods
;;--------------------------------------------------------------------------

(setq ttm
      (make-operator
       :opid 'ttm
       :name '(Traveling-technique-of-movement
	       $group $movement $xy1 $xy2 $tform)
       :cost 1
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement $tform Trav-techn)
			(in-trav-formation $group $xy1 $xy2 $tform
					   (options F-fire-mod F-fire-good
						    F-fire-excellent)
					   $u5 $u6
					   Trav-techn)
			(filter-leg-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-excellent Security-mod
					  Trav-techn)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Trav-techn)

			(ready-for-drill $group $xy1 $xy2)
			(trigger-ttm)
			)))

;; The only kinds of traveling formations used with the traveling overwatch
;;  in the training tables are staggered column and vee.  We do not know
;;  if those two are more appropriate for traveling overwatches than others
;;  or why.
(setq totm
      (make-operator
       :opid 'totm
       :name '(Traveling-overwatch-technique-of-movement
	       $group $movement $xy1 $xy2 $tform)
       :cost 2
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement $tform Trav-overw)
			(in-trav-formation $group $xy1 $xy2 $tform
					   (options F-fire-good
						    F-fire-excellent) 
					   $u5 $u6
					   Trav-overw)
			(filter-leg-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-good Security-good
					  Trav-overw)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Trav-overw)

			(ready-for-drill $group $xy1 $xy2)
			(trigger-totm)
			)))

;; Bounding overwatches do not use traveling formations. -DHarper
;; The platoon leader chooses which kind of bounding overwatch to use,
;;  typically, not the CoCmdr. -DHarper

(setq botm
      (make-operator
       :opid 'botm
       :name '(Bounding-overwatch-technique-of-movement
	       $group $movement $xy1 $xy2)
       :cost 6 ;has to be more expensive than TT or TO + most expensive tform
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement No-Tform Bound-overw)
			(filter-leg-lateral-space $xy1 $xy2 
						  (options 4 5+))
			(filter-leg-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-mod Security-excellent
					  Bound-overw)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement No-Tform Bound-overw)

			(ready-for-drill $group $xy1 $xy2)
			(trigger-botm)
			)))

;; ---------------------------------------------------------------------------
;; Methods for completing travel
;; ---------------------------------------------------------------------------

(setq mtle-nbo
      (make-operator
       :opid 'mtle-nbo
       :name '(Move-to-leg-end-nbo $group $xy1 $xy2 $speed $security
				   $tform $fire-f $fire-l $fire-r
				   $method
				   )
       :cost 1
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security $method)
			(in-trav-formation $group $xy1 $xy2 $tform 
					   $fire-f $fire-l $fire-r
					   $method)

			(drill-scheduled)
			(filter-loc-empty $xy2)
			)
       :effects       '(
			(at-location $group $xy2)
			(NOT in-trav-formation
			     $group $xy1 $xy2 $tform
			     $fire-f $fire-l $fire-r
			     $method)

			(NOT drill-scheduled)
			(trigger-mtle-nbo)
			)))

(setq mtle-bo
      (make-operator
       :opid 'mtle-bo
       :name '(Move-to-leg-end-bo $group $xy1 $xy2 $speed $security)
       :cost 1
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security Bound-overw)

			(drill-scheduled)
			(filter-loc-empty $xy2)
			)
       :effects       '(
			(at-location $group $xy2)
			
			(NOT drill-scheduled)
			(trigger-mtle-bo)
			)))

(setq htf
      (make-operator
       :opid 'htf
       :name '(Halt-trav-formation $group $xy1 $xy2 $speed $security
				   $tform $fire-f $fire-l $fire-r
				   $method)
       :cost 2
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method)
			(in-trav-formation $group $xy1 $xy2 $tform
					   $fire-f $fire-l $fire-r
					   $method)

			(drill-scheduled)
			(filter-stop-order-given-to $group $xy2
						    $tform) ;was 'Immed-halt
			(filter-loc-empty $xy2)
			)
       :effects       '(
			(stopped-at $group $xy2)
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method)

			(NOT drill-scheduled)
			(trigger-htf)
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
       :preconditions '(
			(at-location $group $xy2)
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security $method)
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2)
			(filter-stop-order-given-to $group $xy2 Coil)
			(filter-loc-radial-space $xy2 (options 4 5+))
			(filter-loc-empty $xy2) ;added to help CSP w/Initial State
			)
       :effects       '(
			(in-stat-formation $group $xy2 Coil
					   Security-excl Execute-slow
					   Move-out-slow)
			(NOT moving-along-leg $group $xy1 $xy2 
			     $speed $security $method)

			(trigger-sicoil)
			)))

(setq siherr
      (make-operator
       :opid 'siherr
       :name '(Stop-in-herringbone $group $xy1 $xy2 $speed $security $method
			    $xy3 $direct-or-indirect )
       :cost 2
       :preconditions '(
			(at-location $group $xy2)
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method)
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2)
			(filter-stop-order-given-to $group $xy2 Herringbone)
			(filter-loc-radial-space $xy2 (options 2 3 4 5+))
			(filter-loc-empty $xy2) ;added to help CSP w/Initial State
			)
       :effects       '(
			(in-stat-formation $group $xy2 Herringbone
					   Security-good
					   Execute-fast Move-out-fast)
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method )

			(trigger-siherr)
			)))

;;--------------------------------------------------------------------------
;; Battle Drills
;;--------------------------------------------------------------------------

(setq nbd
      (make-operator
       :opid 'nbd
       :name '(No-battle-drill $group $xy1 $xy2)
       :cost 0
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)
			)
       :effects       '(
			(drill-scheduled)
			(NOT ready-for-drill $group $xy1 $xy2)
			;no trigger
			)))

(setq cfcr
      (make-operator
       :opid 'cfcr
       :name '(Contact-from-contact-report $group $xy1 $xy2 $xy3)
       :cost 1
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)

			;require cover for enemy???
			(filter-item Enemy-small-arms-fire $xy3)
			(filter-same-segment-space $xy3 $xy1 $xy2 1)
			(filter-contact-report-given-to
			 $group $xy1 $xy2 $xy3 No-antitank-weapons)

			;cribbed from FTG
			(filter-fire-order-given-to $group $xy1 $xy2 $xy3
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
			(trigger-cfcr)
			)))

;;DP - I would think training for contact drills would be harder when the
;;     CoCmdr did not provide warnings by giving contact reports, so I've
;;     made this op more expensive to reflect its less frequent use.
(setq cfs
      (make-operator
       :opid 'cfs
       :name '(Contact-from-sighting $group $xy1 $xy2 $xy3)
       :cost 2
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)

			;require cover for enemy???
			(filter-item Enemy-small-arms-fire $xy3)
			(filter-same-segment-space $xy3 $xy1 $xy2 1)

			;cribbed from FTG
			(filter-fire-order-given-to $group $xy1 $xy2 $xy3
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
			(trigger-cfs)
			)))
#|
;; So far, firing is the only order issued in the middle of a leg.
(setq ftg
      (make-operator
       :opid 'ftg
       :name '(Fire-toward-ground $group $xy1 $xy2 $xy3 $direct-or-indirect)
       :cost 1
       :preconditions '(
			(item-targeted $group $xy1 $xy2 Ground $xy3)
			(filter-fire-order-given-to $group $xy1 $xy2 $xy3
						    $direct-or-indirect)
			)
       :effects       '(
			(firing-on $group $xy3 $direct-or-indirect
				   $xy1 $xy2)
			(NOT item-targeted $group $xy1 $xy2 Ground $xy3)
			(trigger-ftg)
			)))
|#
(setq ef
      (make-operator
       :opid 'ef
       :name '(End-fire $group $xy3 $direct-or-indirect $xy1 $xy2)
       :cost 0
       :preconditions '(
			(firing-on $group $xy3 $direct-or-indirect
				   $xy1 $xy2)
			)
       :effects       '(
			(NOT firing-on $group $xy3 $direct-or-indirect
			     $xy1 $xy2)
			;no trigger
			)))
#|
(setq fia
      (make-operator
       :opid 'fia
       :name '(Fire-into-air $group $xy1 $xy2 $xy3 $xy4 $xy5)
       :cost 1
       :preconditions '(
			(ready-for-drill $group $xy1 $xy2)
			;(item-targeted $group $xy1 $xy2 Air $xy3)

			(filter-item Mountain $xy3)
			(filter-same-segment-space $xy3 $xy1 $xy2 2)
			(filter-item Helicopter $xy4)
			(filter-separation $xy4 $xy3 1 1)
			(filter-vector-intersects $xy4 $xy3 $xy1 $xy2 $xy5)
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
       :preconditions '(
			(enemy-forced-to-evade $group $xy1 $xy2 $xy3 $xy4)

			(filter-angle-formed $xy3 $xy4 $xy5 45) ;xy3 is apex
			(filter-separation $xy3 $xy5 1 1)
			(filter-item Forest $xy5) ;or any cover
			)
       :effects       '(
			;'Stopped' should force a second leg in order to get
			; to the goal, but that's not fixed yet.
			;(stopped-at $group $xy5)
			(NOT enemy-forced-to-evade $group $xy1 $xy2 $xy3 $xy4)

			(drill-scheduled)
			(NOT ready-for-drill $group $xy1 $xy2)
			(trigger-vfaa)
			)))
|#
;---------------------------------------------------------------------------
;
; filter imposition operators are used in post virtual plan modification
;
;---------------------------------------------------------------------------

(setq impose-fof
      (make-operator
       :opid 'impose-fof
       :name '(oriented-from $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-oriented-from $a $b $c $d $e))))
(setq impose-fmogt
      (make-operator
       :opid 'impose-fmogt
       :name '(move-order-given-to $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-move-order-given-to $a $b $c $d $e))))
(setq impose-fc
      (make-operator
       :opid 'impose-fc
       :name '(leg-clear $a $b)
       :cost 0
       :preconditions '()
       :effects       '((filter-leg-clear $a $b))))
(setq impose-flls
      (make-operator
       :opid 'impose-flls
       :name '(leg-lateral-space $a $b $c)
       :cost 0
       :preconditions '()
       :effects       '((filter-leg-lateral-space $a $b $c))))
(setq impose-fo
      (make-operator
       :opid 'impose-fo
       :name '(overwatching $a $b $c $d)
       :cost 0
       :preconditions '()
       :effects       '((filter-overwatching $a $b $c $d))))
(setq impose-fe
      (make-operator
       :opid 'impose-fe
       :name '(loc-empty $a)
       :cost 0
       :preconditions '()
       :effects       '((filter-loc-empty $a)))) 
(setq impose-fsogt
      (make-operator
       :opid 'impose-fsogt
       :name '(stop-order-given-to $a $b $c)
       :cost 0
       :preconditions '()
       :effects       '((filter-stop-order-given-to $a $b $c))))
(setq impose-flrs
      (make-operator
       :opid 'impose-flrs
       :name '(loc-radial-space $a $b)
       :cost 0
       :preconditions '()
       :effects       '((filter-loc-radial-space $a $b))))
(setq impose-fi
      (make-operator
       :opid 'impose-fi
       :name '(item $a $b)
       :cost 0
       :preconditions '()
       :effects       '((filter-item $a $b))))
(setq impose-fsss
      (make-operator
       :opid 'impose-fsss
       :name '(same-segment-space $a $b $c $d)
       :cost 0
       :preconditions '()
       :effects       '((filter-same-segment-space $a $b $c $d))))
(setq impose-fcrgt
      (make-operator
       :opid 'impose-fcrgt
       :name '(contact-report-given-to $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-contact-report-given-to $a $b $c $d $e))))
(setq impose-ffogt
      (make-operator
       :opid 'impose-ffogt
       :name '(fire-order-given-to $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-fire-order-given-to $a $b $c $d $e))))
(setq impose-fs
      (make-operator
       :opid 'impose-fs
       :name '(separation $a $b $c $d)
       :cost 0
       :preconditions '()
       :effects       '((filter-separation $a $b $c $d))))
(setq impose-fvi
      (make-operator
       :opid 'impose-fvi
       :name '(vector-intersects $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-vector-intersects $a $b $c $d $e))))
(setq impose-faf
      (make-operator
       :opid 'impose-faf
       :name '(angle-formed $a $b $c $d)
       :cost 0
       :preconditions '()
       :effects       '((filter-angle-formed $a $b $c $d))))


#| The following ops have no use in this file
(setq impose-faogt
      (make-operator
       :opid 'impose-faogt
       :name '(action-order-given-to $a $b $c)
       :cost 0
       :preconditions '()
       :effects       '((filter-action-order-given-to $a $b $c))))
(setq impose-frf
      (make-operator
       :opid 'impose-frf
       :name '(receives-fire $a $b $c)
       :cost 0
       :preconditions '()
       :effects       '((filter-receives-fire $a $b $c))))
(setq impose-fnhogt
      (make-operator
       :opid 'impose-fnhogt
       :name '(nohold-order-given-to $a $b)
       :cost 0
       :preconditions '()
       :effects       '((filter-nohold-order-given-to $a $b)))) 
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
	(filter-oriented-from $a $b $c $d $e)
	(filter-move-order-given-to $a $b $c $d $e)
	(filter-leg-clear $a $b)
	(filter-leg-lateral-space $a $b $c)
	(filter-overwatching $a $b $c $d)
	(filter-loc-empty $a)
	(filter-stop-order-given-to $a $b $c)
	(filter-loc-radial-space $a $b)
	(filter-item $a $b)
	(filter-same-segment-space $a $b $c $d)
	(filter-contact-report-given-to $a $b $c $d $e)
	(filter-fire-order-given-to $a $b $c $d $e)
	(filter-separation $a $b $c $d)
	(filter-vector-intersects $a $b $c $d $e)
	(filter-angle-formed $a $b $c $d)

	(drill-scheduled)

	(at-location     $ $)

	(trigger-mfls)
	(trigger-mofsf)
	(trigger-mofhtf)
	(trigger-cmf)
	(trigger-scmf)
	(trigger-wlmf)
	(trigger-wrmf)
	(trigger-elmf)
	(trigger-ermf)
	(trigger-vmf)
	(trigger-lmf)
	(trigger-ttm)
	(trigger-totm)
	(trigger-botm)
	(trigger-mtle-nbo)
	(trigger-mtle-bo)
	(trigger-htf)
	(trigger-sicoil)
	(trigger-siherr)
	(trigger-cfcr)
	(trigger-cfs)
	(trigger-ftg)
	(trigger-vfaa)
	))

;***************************************************************************
; AbTweak domain part - criticality lists, used only in Abtweak 
;
; satisfied first = high, last = lower
;
;***************************************************************************

(setq *critical-list* '(
   (2
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
    (filter-oriented-from $ $ $ $ $)
    (filter-move-order-given-to $ $ $ $ $)
    (filter-leg-clear $ $)
    (filter-leg-lateral-space $ $ $)
    (filter-overwatching $ $ $ $)
    (filter-loc-empty $) 
    (filter-stop-order-given-to $ $ $)
    (filter-loc-radial-space $ $)
    (filter-item $ $)
    (filter-same-segment-space $ $ $ $)
    (filter-contact-report-given-to $ $ $ $ $)
    (filter-fire-order-given-to $ $ $ $ $)
    (filter-separation $ $ $ $)
    (filter-vector-intersects $ $ $ $ $)
    (filter-angle-formed $ $ $ $)
    #| These are not used in this file
    (filter-action-order-given-to $ $ $)
    (filter-nohold-order-given-to $ $)
    (filter-receives-fire $ $ $)
    |#
    )
   ))
(setq *critical-loaded* 'caeti-default4)

;**************** settings for left-wedge mode *************

; preference values for each successive level of abstraction
;  - related to top down property
;  this value is factored into the heuristic for preference of
;  plans - essentially preferring level k over level k+1 by a
;  depth-factor as indicated in *k-list* at this k
;
(setq *left-wedge-list* '(0 0))
