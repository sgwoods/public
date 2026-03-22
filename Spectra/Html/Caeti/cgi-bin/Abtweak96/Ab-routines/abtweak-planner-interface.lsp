;; AbTweak and Planner interface routines.

(defvar *first-time* nil) ;signals first time through successor routine,
;;for abtweak, so as to generate alternate successor states.

;; ---------- make-initial plan

(defun ab-make-initial-plan (initial goal &optional (required-ops nil) )
  "/planner/planner.lsp
    abtweak - returns a initial plan"
  (declare (list initial goal required-ops))

  (let ((i (create-operator-instance
	    :opid 'i
	    :name (list 'i (first initial)) ;(I <loc of I>)
	    :preconditions nil
	    :effects (rest initial) ))
	(g (create-operator-instance
	    :opid 'g
	    :name (list 'g (first goal)) ;(G <loc of G>)
	    :preconditions (rest goal)
	    :effects nil ))
        )
    (declare (type operator i g))

    (setq *first-time* t)
    (create-plan 'initial-plan
		 :a (list i g)
		 :b '((i g))
		 :kval  (find-initial-k-val)
		 :required-ops required-ops
		 )))

;; -------------   Solution Checking Part. ------------

(defun ab-goal-p (plan)
   "Ab-routines/abtweak-planner-interface.lsp
    note :: a    tweak plan is correct if prob is nil, and default kval is 0
            an abtweak plan is correct if prob is nil, and kval = 0"
   (declare (type array plan))

   (and (ab-mtc plan)
	(= (plan-kval plan) 0)) )

;;--------- successors and costs generation. -----------

(defun ab-successors&costs (plan)
  "Ab-routines/abtweak-planner-interface.lsp
   returns a list of successor states and costs."
  (declare (type array plan) )

  (mapcar #'(lambda (state) (list state (get-plan-cost state)))
          (ab-successors plan) ))


;----------- find-initial-k-val

(defun find-initial-k-val ()
  "Ab-routines/abtweak-planner-interface.lsp
   returns the highest criticality value of the hierarchy"

  (apply #'max (mapcar #'car *critical-list*)) )