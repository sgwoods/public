(defun drp-solution-information ()
  (update-abs-ref-counts 0)
  (when (plan-p *solution*) ;was *success* before DP 7/97, which seemed
	(update-abs-succ-counts 1) ; redundant
	(setf (aref *abs-success-counts* 0) 1) )
  (format *output-stream*
	  "Total Number of Abs Refinements: ~D ~2&~
	   ~% Level     Probability ~&"
	  *abs-node-count* )
  (dotimes (i (length *critical-list*))
	   (let* ((level 
		   (- (1- (length *critical-list*)) i))
		  (prob
		   (if (> (aref *abs-ref-counts* level) 0)
		       (/ 
			(aref *abs-success-counts* level)
			(aref *abs-ref-counts* level))
		     0)))
	     (format *output-stream*
		     "~% ~D           ~,3F ~&" 
		     level
		     prob ))))


