; 
; (plan ...) is the main routine that invokes either abtweak or tweak.
;

; (necc-operator-inclusions nil)   ;; '( )

(defun plan (initial goal &key 
		     (planner-mode           'abtweak)
		     (continue-p             nil)
		     (mp-mode                t)
		     (abstract-goal-mode     t) 
		     (drp-mode               t)
		     (left-wedge-mode        t)
		     (subgoal-determine-mode 'stack)
		     (exist-est-heuristic    'poss-then-nece)
		     (heuristic-mode         'operator-costs-sum)
		     (use-primary-effect-p   nil)
		     (expand-bound           1000)
		     (generate-bound         1000)
		     (open-bound             1000)
		     (cpu-sec-limit          600)   ; 10 min
		     (init-plan              nil)
		     (existing-only          nil)
		     (solution-limit         100)
		     (abs-branching-limit    5)
		     (tc-mode                nil)

		     (required-ops           nil) ;; NOTE THESE ARE OPIDS

		     (print-output-p         nil)
		     (plan-debug-stream      nil)
		     (drp-debug-mode         nil)
		     (declob-debug-mode      nil)
		     (debug-mode             nil)   ; output debug info
		     (debug-break-mode       nil)   ; stop in debug mode
               )
  "/Plan/plan.lsp
   initialize a plan, and invoke a search routine for 
   A* search.

   initial ---set of initial conditions  
   goal    ---set of goal conditions            "

  (declare 
   (type list    initial)               
   (type list    goal) 
   (type atom    planner-mode)           ; 'tweak / 'abtweak / 'mr / 'mr-crit
   (type atom    mp-mode)                ; t / nil
   (type symbol  abstract-goal-mode)     ; t / nil
   (type symbol  drp-mode)               ; t / nil
   (type symbol  left-wedge-mode)        ; t / nil
   (type atom    subgoal-determine-mode) ; 'random / 'tree / 'stack
   (type symbol  exist-est-heuristic)    ; 'diff-stage-nece-and-poss
   (type atom    heuristic-mode)         ; 'num-of-ops 
   (type symbol  use-primary-effect-p)   ; t / nil
   (type integer expand-bound)
   (type integer generate-bound)
   (type integer open-bound)
   (type atom    tc-mode)                ; t / nil
   (type list    required-ops)           ; e.g. '(ttm totm)
   (type symbol  print-output-p)         ; t / nil
   (type atom    plan-debug-stream)      ; t / nil / <string>
   (type symbol  drp-debug-mode)         ; t / nil
   (type symbol  declob-debug-mode)      ; t / nil
   (type symbol  debug-mode)             ; t / nil
   (type symbol  debug-break-mode)       ; t / nil
   )

  ; set control global flags (default values specified in planner function)
  (initialize-global-variables
   planner-mode continue-p mp-mode abstract-goal-mode 
   drp-mode left-wedge-mode subgoal-determine-mode exist-est-heuristic
   heuristic-mode use-primary-effect-p expand-bound
   generate-bound open-bound cpu-sec-limit
   existing-only abs-branching-limit tc-mode required-ops
   print-output-p
   plan-debug-stream drp-debug-mode declob-debug-mode
   debug-mode debug-break-mode
   )
  ; initialize properly closed "globals"
  (reset-print-current-plan-cost)

  (setq *solution-limit* solution-limit)
  (let ((initial-plan
	 (or init-plan
	     (make-initial-plan initial goal required-ops) )))
    (declare (type plan initial-state))

    (setq *solution* initial-plan)
    ;;for the purpose of aborting successfully, should any
    ;;unexpected events occur.
    (if *use-primary-effect-p* 
	(setf (operator-primary-effects
	       (first (plan-a initial-plan))) ; initial operator
	      (operator-effects
	       (first (plan-a initial-plan)))))
    (A-search initial-plan)       ;sets *solution*
    (output-solution-information) ;uses *solution*
    ))


; ---- make-initial-plan ----

(defun make-initial-plan (initial goal &optional (required-ops nil) )
  "/Planner/planner.lsp
    returns an initial plan - based on *planner-mode*"
  (declare (type list initial) (type list goal))

  (if (or (eq *planner-mode* 'abtweak)
	  (eq *planner-mode* 'mr-crit))
      (ab-make-initial-plan initial goal required-ops )
      (tw-make-initial-plan initial goal required-ops )))


; --- termination ---

(defun goal-p (state)
  "/Abtweak/plan.lsp
    Abtweak/Tweawk/MR planning termination condition."
  (declare 
      (type plan state) )
  (cond((eq *planner-mode* 'abtweak)
	(ab-goal-p state))
       ((or (eq *planner-mode* 'mr)
	    (eq *planner-mode* 'mr-crit))
	(mr-goal-p state))
       (t (tw-goal-p state))))
      
; --- successors generation ---

(defun successors&costs (plan)
  "/planner/planner.lsp
    returns a list of successor states and costs."
  (declare (type plan plan) )

  (case *planner-mode*
	((mr mr-crit)
	 (mr-successors&costs plan) )
	(abtweak
	 (ab-successors&costs plan) )
	(t
	 (tw-successors&costs plan) )))




