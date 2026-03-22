;; Tweak-specific functions for interfacing with planner.

;;  --- initialization routines. ------------

(defun tw-make-initial-plan (initial goal &optional (required-ops nil) )
  "/planner/planner.lsp
    returns an initial tweak plan"
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
	    :effects nil))
	)
    (declare (type operator i g))

    (create-plan 'initial-plan
		 :a (list i g)
		 :b '((i g))
		 :cost 0
		 :required-ops required-ops
		 )))

;; --- termination routines.  ---------------

(defun tw-goal-p (state)
  "/planner/planner.lsp
    tweak termination condition."
  (declare 
      (type plan state) )
  (mtc state) )


;; --- Successor generation routines. -----------------

(defun tw-successors&costs (plan)
  "
   tweak - returns a list of successor states and costs."
  (declare (type array plan) )

  (cond 

   (*tc-mode* 
    (mapcar #'(lambda (state) (list state (get-plan-cost state)))
	    (all-successors plan)) )

   (t
    (mapcar #'(lambda (state) (list state (get-plan-cost state)))
	    (successors plan)) )))


