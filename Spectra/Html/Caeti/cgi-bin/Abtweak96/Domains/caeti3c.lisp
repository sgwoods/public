;; Pautler CAETI 3 CHANGED Nov 26/96

;***************************************************************************
;*****                           CAETI operators                       *****
;***************************************************************************

(setq *domain* 'caeti3b)



;; ---------------------------------------------------------------------------
;; Debugging aids
;; ---------------------------------------------------------------------------

(defun lcs () (load "Domains/caeti3b"))

(setq *initial*
      '(#| 
	(fact-NOT-equal $thing1 $thing2)
	(NOT firing $group1 $trav-st-loc1 $enemy1 $fire-type1)
	|#
	(in-stat-formation White cp1 Herringbone 
			   $security1 $exec-speed1 $mo-speed1)
	))

(setq *goal*
      '(
	(in-stat-formation White cp5 Coil 
			   $security2 $exec-speed2 $mo-speed2)
	))

(defun pm () (plan *initial* *goal* :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))




;;--------------------------------------------------------------------------
;; Move-out methods
;;--------------------------------------------------------------------------

(setq mfls
      (make-operator
       :opid 'mfls
       :name '(Move-from-leg-start $group $xy1 $xy2 $xy3
				   $speed $security
				   $method)
       :cost 1
       :preconditions '(
			(at-location      $group $xy2)
			(moving-along-leg $group $xy1 $xy2
					  $speed $security
					  $method)
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
			(filter-clear $xy1 $xy2)
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
			(filter-clear $xy1 $xy2)
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
			(filter-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-excellent Security-mod
					  Trav-techn)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Trav-techn)

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
			(filter-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-good Security-good
					  Trav-overw)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement $tform Trav-overw)

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
       :cost 6 ;3
       :preconditions '(
			(started-on-leg $group $xy1 $xy2
					$movement No-Tform Bound-overw)
			(filter-leg-lateral-space $xy1 $xy2 
						  (options 4 5+))
			(filter-clear $xy1 $xy2)
			)
       :effects       '(
			(moving-along-leg $group $xy1 $xy2
					  Speed-mod Security-excellent
					  Bound-overw)
			(NOT started-on-leg $group $xy1 $xy2
			     $movement No-Tform Bound-overw)

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
					  $speed $security
					  $method)
			(in-trav-formation $group $xy1 $xy2 $tform 
					   $fire-f $fire-l $fire-r
					   $method)
			(filter-empty $xy2)
			)
       :effects       '(
			(at-location $group $xy2)
			(NOT in-trav-formation
			     $group $xy1 $xy2 $tform
			     $fire-f $fire-l $fire-r
			     $method)

			(trigger-mtle-nbo)
			)))

(setq mtle-bo
      (make-operator
       :opid 'mtle-bo
       :name '(Move-to-leg-end-bo $group $xy1 $xy2 $speed $security)
       :cost 1
       :preconditions '(
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security
					  Bound-overw)
			(filter-empty $xy2)
			)
       :effects       '(
			(at-location $group $xy2)
			
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
			(filter-stop-order-given-to $group $xy2
						    $tform) ;was 'Immed-halt
			(filter-empty $xy2)
			)
       :effects       '(
			(stopped-at $group $xy2)
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method)

			(trigger-htf)
			)))

;;--------------------------------------------------------------------------
;; Methods of stopping / Stationary formations
;;--------------------------------------------------------------------------

(setq sicoil
      (make-operator
       :opid 'sicoil
       :name '(Stop-in-coil $group $xy1 $xy2 $speed $security $method)
       :cost 1
       :preconditions '(
			(at-location $group $xy2)
			(moving-along-leg $group $xy1 $xy2 
					  $speed $security
					  $method)
			(filter-stop-order-given-to
			 $group $xy2 Coil)
			(filter-loc-lateral-space $xy2 (options 4 5+))

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
       :name '(Stop-in-herringbone $group $xy1 $xy2 $speed $security $method)
       :cost 2
       :preconditions '(
			(at-location $group $xy2)
			(moving-along-leg $group $xy1 $xy2 $speed $security
					  $method)
			(filter-stop-order-given-to
			 $group $xy2 Herringbone)
			(filter-loc-lateral-space $xy2 (options 2 3 4 5+))
			)
       :effects       '(
			(in-stat-formation $group $xy2 Herringbone
					   Security-good
					   Execute-fast Move-out-fast)
			(NOT moving-along-leg $group $xy1 $xy2
			     $speed $security $method )

			(trigger-siherr)
			)))

;; 

;---------------------------------------------------------------------------
;
; filter imposition operators are used in post virtual plan modification
;
;---------------------------------------------------------------------------

(setq impose-fof
      (make-operator
       :opid 'impose-fof
       :name '(impose-filter-oriented-from $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-oriented-from $a $b $c $d $e))))
(setq impose-fc
      (make-operator
       :opid 'impose-fc
       :name '(impose-filter-clear $a $b)
       :cost 0
       :preconditions '()
       :effects       '((filter-clear $a $b))))
(setq impose-flls1
      (make-operator
       :opid 'impose-flls1
       :name '(impose-filter-leg-lateral-space $a $b $c)
       :cost 0
       :preconditions '()
       :effects       '((filter-leg-lateral-space $a $b $c))))
(setq impose-flls2
      (make-operator
       :opid 'impose-flls2
       :name '(impose-filter-loc-lateral-space $a $b)
       :cost 0
       :preconditions '()
       :effects       '((filter-loc-lateral-space $a $b))))
(setq impose-fe
      (make-operator
       :opid 'impose-fe
       :name '(impose-filter-empty $a)
       :cost 0
       :preconditions '()
       :effects       '((filter-empty $a)))) 
(setq impose-fo
      (make-operator
       :opid 'impose-fo
       :name '(impose-filter-overwatching $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((filter-overwatching $a $b $c $d))))
(setq impose-fcrgt
      (make-operator
       :opid 'impose-fcrgt
       :name '(impose-filter-contact-report-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((filter-contact-report-given-to $a $b $c $d))))
(setq impose-fmogt
      (make-operator
       :opid 'impose-fmogt
       :name '(impose-filter-move-order-given-to $a $b $c $d $e)
       :cost 0
       :preconditions '()
       :effects       '((filter-move-order-given-to $a $b $c $d $e))))
(setq impose-fsogt
      (make-operator
       :opid 'impose-fsogt
       :name '(impose-filter-stop-order-given-to $a $b $c)
       :cost 0
       :preconditions '()
       :effects       '((filter-stop-order-given-to $a $b $c))))
(setq impose-ffogt
      (make-operator
       :opid 'impose-ffogt
       :name '(impose-filter-fire-order-given-to $a $b $c $d)
       :cost 1
       :preconditions '()
       :effects       '((filter-fire-order-given-to $a $b $c $d))))
(setq impose-faogt
      (make-operator
       :opid 'impose-faogt
       :name '(impose-filter-action-order-given-to $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((filter-action-order-given-to $a $b $c))))
(setq impose-fia1
      (make-operator
       :opid 'impose-fia1
       :name '(impose-filter-item-at $a $b)
       :cost 1
       :preconditions '()
       :effects       '((filter-item-at $a $b))))
(setq impose-fia2
      (make-operator
       :opid 'impose-fia2
       :name '(impose-filter-item-alongside $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((filter-item-alongside $a $b $c))))
(setq impose-fit
      (make-operator
       :opid 'impose-fit
       :name '(impose-filter-item-type $a $b)
       :cost 1
       :preconditions '()
       :effects       '((filter-item-type $a $b))))
(setq impose-frf
      (make-operator
       :opid 'impose-frf
       :name '(impose-filter-receives-fire $a $b $c)
       :cost 1
       :preconditions '()
       :effects       '((filter-receives-fire $a $b $c))))
(setq impose-fnhogt
      (make-operator
       :opid 'impose-fnhogt
       :name '(impose-filter-nohold-order-given-to $a $b)
       :cost 1
       :preconditions '()
       :effects       '((filter-nohold-order-given-to $a $b)))) 

; ---------------------------------------------------------------------------
; actual operator list used in domain
;

(setq *operators* (list
		   impose-fof
		   impose-fc
		   impose-flls1
		   impose-flls2
		   impose-fe
		   impose-fmogt
		   impose-fsogt
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
		   botm 

		   mtle-nbo 
		   mtle-bo 

		   htf

		   sicoil
		   siherr

		   ))
; ---------------------------------------------------------------------------
;
; preconditions requiring NEW operators for establishment
;  (ie they WILL NOT make use of existing establishers)
;
(setq *precond-new-est-only-list*
      '(
       (filter-oriented-from $a $b $c $d $e)
       (filter-move-order-given-to $a $b $c $d $e)
       (filter-stop-order-given-to $a $b $c)
       (filter-clear $a $b)
       (filter-leg-lateral-space $a $b $c)
       (filter-loc-lateral-space $a $b)
       (filter-empty $a)

       (at-location     $ $)
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
    (NOT stopped-at  $ $)
    (at-location     $ $)
    (NOT at-location $ $)
    (moving-along-leg $ $ $ $ $ $)
    (NOT moving-along-leg $ $ $ $ $ $)
    (started-on-leg $ $ $ $ $ $)
    (NOT started-on-leg $ $ $ $ $ $)
    (in-stat-formation $ $ $ $ $ $)
    (NOT in-stat-formation $ $ $ $ $ $)
    (in-trav-formation $ $ $ $ $ $ $ $)
    (NOT in-trav-formation $ $ $ $ $ $ $ $)

    (item-targeted   $ $ $)
    (NOT item-targeted   $ $ $)
    (approach-original-axis-then $ $ $)
    (NOT approach-original-axis-then $ $ $)
    (pass-obstacle-then     $ $ $)
    (NOT pass-obstacle-then $ $ $)
    (verge-from-obstacle-then     $ $ $)
    (NOT verge-from-obstacle-then $ $ $)
    )
   (0  
    (filter-oriented-from $ $ $ $ $)
    (filter-clear $ $)
    (filter-leg-lateral-space $ $ $)
    (filter-loc-lateral-space $ $)
    (filter-empty $) 
    (filter-overwatching $ $ $ $)
    (filter-contact-report-given-to $ $ $)
    (filter-item-at $ $)
    (filter-item-alongside $ $ $)
    (filter-type $ $)
    (filter-move-order-given-to $ $ $ $ $)
    (filter-stop-order-given-to $ $ $)
    (filter-fire-order-given-to $ $ $ $)

    (filter-action-order-given-to $ $ $)
    (filter-nohold-order-given-to $ $)
    (filter-receives-fire $ $ $)
    )
   ))
(setq *critical-loaded* 'caeti-default3b)

;**************** settings for left-wedge mode *************

; preference values for each successive level of abstraction
;  - related to top down property
;  this value is factored into the heuristic for preference of
;  plans - essentially preferring level k over level k+1 by a
;  depth-factor as indicated in *k-list* at this k
;
(setq *left-wedge-list* '(0 0))
