;***************************************************************************
; CAETI sample operators
;***************************************************************************

;
; operators
;

(setq mofsf (make-operator
	    :opid 'mofsf
	    :name '(move-out-from-stat-form 
		    $group  $sform $security $exec-speed  $mv-out-speed 
		    $tform $method $leg $leg-start
		    )
	    :cost 1
	    :preconditions '(
			     (in-stat-formation $group $leg-start $sform 
						$security $exec-speed 
						$mv-out-speed)
			     (filter-clear $leg)
			     (filter-leg-start $leg $leg-start)
			     (filter-order-given-to $group  $leg-start 
				             MoveFrom $tform $method)
			     )
	    :effects       '(
			     (started-on-leg $group $leg)
			     (not in-stat-formation $group $leg-start $sform
						$security $exec-speed 
						$mv-out-speed)
			     (start-form-and-method-ordered  $leg-start
			                      MoveFrom $tform $method)
			     )
	    ))

(setq *operators* (list
		   mofsf
		   ))

;
; initial state
;
(setq initial '( 
		(filter-leg-start $a $b)
		(filter-clear $c)
		(filter-order-given-to $d $e $f $g $h)

		(in-stat-formation g1 leg-start1 coil $i $j $k)
		))
;
; goal state
;
(setq goal '( 
	     (started-on-leg g1 $some-leg)
	     ))

;; ---------------------------------------------------------------------------
;; Testing below
;; ---------------------------------------------------------------------------

(defun lcs () (load "Domains/caeti-simple"))
(defun pm () (plan initial goal :planner-mode 'mr))
(defun pcr () (plan-cr *solution*))