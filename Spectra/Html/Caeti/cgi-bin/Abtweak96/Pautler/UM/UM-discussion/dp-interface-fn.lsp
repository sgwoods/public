;;; This file will eventually contain a fn which can be used as an
;;;  interface to the combined planner and CSP engine.

(defun gen-scen (&optional (debug? t))
  (load "Domains/caeti.lisp")

  (let ((goal-state nil)
	(initial-state nil)
	(default-goal-state
	  '(in-stat-formation White cp5 Coil $ex-sp1 $mo-sp1 $sec1) )
	(default-initial-state
	  '(in-stat-formation White cp1 Herringbone $ex-sp2 $mo-sp2 $sec2) )
	)

	(format *standard-output*
		"~%~
                 ~% What states do you want to use for the Goal State?~
                 ~%~
                 ~% The default is defined to be:~
                 ~%    (in-stat-formation White cp5 Coil~
                 ~%                       $execution-speed1~
                 ~%                       $move-out-speed1~
                 ~%                       $security1)~
                 ~% (Use Ctrl-D to end your list.)
                 ~%")
	(do ((input-text (prompt-for-g-or-i) (prompt-for-g-or-i))
	     (first-pass? t nil) )
	    ((eql 'no-more input-text)
	     (when first-pass?
		   (setq goal-state default-goal-state) ))
	    (if goal-state
		(nconc goal-state (list input-text))
	      (setq goal-state (list input-text)) ))

	(format *standard-output*
		"~%~
                 ~% What states do you want to use for the Initial State?~
                 ~%~
                 ~% The default is defined to be:~
                 ~%    (in-stat-formation White cp1 Herringbone~
                 ~%                       $execution-speed2~
                 ~%                       $move-out-speed2~
                 ~%                       $security2)~
                 ~% (Use Ctrl-D to end your list.)
                 ~%")
	(do ((input-text (prompt-for-g-or-i nil) (prompt-for-g-or-i nil))
	     (first-pass? t nil) )
	    ((eql 'no-more input-text)
	     (when first-pass?
		   (setq initial-state default-initial-state) ))
	    (if initial-state
		(nconc initial-state (list input-text))
	      (setq initial-state (list input-text)) ))

	;; Prompt for desired ops, desired limits on ops, and
	;;  desired ordering constraints on ops.

	(plan initial-state goal-state :debug-mode debug?)

	;; Take the 'impose-filter' stmts from the output of 'plan' and
	;;  add some domain specific control stmts (e.g. 'prefer shorter
	;;  routes').  Pass that to a CSP engine which will attempt
	;;  to map the filters to the target terrain.

	;; The final output should be a set of labelled checkpoints
	;;  with map coordinates, a list of orders to the plt from
	;;  the OC, and a list of enemy units, placements,
	;;  and executable orders.  (The last list might be a set
	;;  of ModSAF instructions instead.)

	))

(defun prompt-for-g-or-i (&optional (goal? t))
  (format *standard-output* "~%~a state: "
	  (if goal? "Goal" "Initial") )
  (read *standard-input* nil 'no-more nil)
  )