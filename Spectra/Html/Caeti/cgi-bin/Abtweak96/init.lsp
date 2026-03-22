; /planner/init

; load object code files or lisp code files

; Load Search Routines
(load  "Search-routines/init")

; Load TWEAK
(load "Tw-routines/init")

; Load ABTWEAK
(load "Ab-routines/init")

; Load user defined heuristic
(load "My-routines/heuristic")

(load "Domains/check-primary-effects")

; Load Domain definitions
;(load "Domains/hanoi-3")

(load "Plan-routines/init-global-vars")
(load "Plan-routines/planner-interface")
(load "Plan-routines/planner-heuristic")
(load "Plan-routines/predicate-fns")

(load "Mcallester-plan/init")
(load "plan")


;;DP utility
(defun sift (filter-fn items &key (keep-evals? nil) &aux val)
  "returns all items that satisfy the filter-fn (can also be set to return
   the non-NIL results of applying filter-fn to the items)"
  (apply #'append
	 (mapcar #'(lambda (item)
		     (if (setq val (funcall filter-fn item))
			 (list (if keep-evals? val item))
		       nil ))
		 items )))