(defun compute-total-cost (heuristic-function state cost)
      "planner/search/state-expansion
       computes the priority of a node by applying heuristic function"

  (declare (ignore cost))

  (funcall heuristic-function state) )

;; Nov 22/96 changed compute-total-cost to not inculde plan cost twice
;;   (+ cost (funcall heuristic-function state)))
