; ----- Tweak heuristic functions.-----

(defun tw-which-heuristic-function ()
   "/Tweak/
  Returns a heuristic function."

   (cond 
    ( (equal *heuristic-mode* 'num-of-unsat-goals)   ; default
      (tw-heuristic-function-1))

    ( (equal *heuristic-mode* 'num-of-plan-steps)     
      (tw-heuristic-function-2))

    ( (equal *heuristic-mode* 'num-steps-cost)     
      (tw-heuristic-function-3))

    ( (equal *heuristic-mode* 'num-steps-cost-plus)     
      (tw-heuristic-function-4))

    ( (equal *heuristic-mode* 'operator-costs-sum)
      (tw-heuristic-function-5))

    ( (equal *heuristic-mode* 'user-defined)   ; user defined
      (user-heuristic))   ; has to be loaded by user.
    
    ( t 
      `(lambda (state) 0)) ))

; --- HEURISTIC 1. ---

(defun tw-heuristic-function-1 ()
  "/Tweak/tw-heuristic.lsp
   default heuristic: (case 1) 
        = number of un-necessarily satisfied goals."

 `(lambda (state) (num-of-unsat-goals state)))

; --- Supporting Functions. ---

(defun num-of-unsat-goals (plan)
  "Tweak - returns the total number of satisfied goals."
  (declare 
   (type array plan) )
  (count-if-not
   #'(lambda (ith-goal)
       (hold-p plan 'g ith-goal))
   (get-preconditions-of-opid 'g plan)))

; --- HEURISTIC 2. ---

(defun tw-heuristic-function-2 ()
  "/Tweak/tw-heuristic.lsp
   default heuristic: (case 2) 
        = size of plan."

 `(lambda (state) (num-of-plan-steps state)))

; --- Supporting Functions. ---

(defun num-of-plan-steps (plan)
  "Tweak - returns the total number of operators in plan."
  (declare 
   (type array plan) )
  (length (plan-a plan)))


; --- HEURISTIC 3. ---

(defun tw-heuristic-function-3 ()
  "/Tweak/tw-heuristic.lsp
   default heuristic: (case 3) 
        = size of plan * cost of plan steps."

 `(lambda (state) (* (num-of-plan-steps state)
		     (plan-cost state)))  )


; --- HEURISTIC 4. ---

(defun tw-heuristic-function-4 ()
  "/Tweak/tw-heuristic.lsp
   default heuristic: (case 4) 
        = size of plan + cost of plan steps."

 `(lambda (state) (+ (num-of-plan-steps state)
		     (plan-cost state)))  )


; --- HEURISTIC 5. ---

(defun tw-heuristic-function-5 ()
  "/Tweak/tw-heuristic.lsp
   default heuristic: (case 5) 
        = cost of plan steps."

 `(lambda (state) (plan-cost state))  )

    

