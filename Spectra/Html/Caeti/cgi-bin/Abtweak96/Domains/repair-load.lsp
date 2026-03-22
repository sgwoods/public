(defun rld () (rlc) (rll))

(defun rlc ()
	(compile-file "Tw-routines/successors")
	(compile-file "Ab-routines/ab-successors")
	(compile-file "Mcallester-plan/successors")
	(compile-file "Search-routines/search"))

(defun rll ()
	(load "Tw-routines/successors")
	(load "Ab-routines/ab-successors")
	(load "Mcallester-plan/successors")
	(load "Search-routines/search"))