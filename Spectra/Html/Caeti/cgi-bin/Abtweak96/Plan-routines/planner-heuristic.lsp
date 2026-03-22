(defun which-heuristic-function ()
 "Plan-routines/planner-heuristic.lsp
   priority calculation - heuristic"
   (if (or (equal *planner-mode* 'abtweak)
	   (equal *planner-mode* 'mr-crit))
       (ab-which-heuristic-function)
       (tw-which-heuristic-function) ))

