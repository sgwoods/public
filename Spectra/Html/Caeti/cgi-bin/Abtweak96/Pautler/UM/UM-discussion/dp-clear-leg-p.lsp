(defun gs-which-touch-segment (x1 y1 x2 y2
				  &aux (x-diff (- x2 x1))
				  (gs-list nil) )
  (cond ((= x-diff 0)
	 (let (y3 y4)
	   (if (> y2 y1)
	       (setq y3 y1
		     y4 y2 )
	     (setq y3 y2
		   y4 y1 ))
	   (do ((y5 y3 (1+ y5)))
	       ((> y5 y4) gs-list)
	       (push `(,x1 ,y5) gs-list) )))
	(t
	 (let* ((slope (/ (- y2 y1) x-diff))
		x-start y-start x-end y-end y-diff ascending? )
	   (if (> x-diff 0)
	       (setq x-start x1
		     y-start y1
		     x-end x2
		     y-end y2
		     y-diff (- y2 y1) )
	     (setq x-start x2
		   y-start y2
		   x-end x1
		   y-end y1
		   y-diff (- y1 y2) ))
	   (setq ascending?
		 (or (= 0 y-diff)
		     (< 0 (/ y-diff (abs y-diff))) ))
	   (do* ((y3 (- y-start 0.5) y3)
		 (y4 (+ y3 (* 0.5 slope)) (+ y4 slope))
		 (x6 x-start (1+ x6)) )
		((> x6 x-end) gs-list)
		(if ascending?
		    (do* ((y5 (min (ceiling y4) y-end) y5)
			  (y6 y5 (1- y6)) )
			 ((< y6 y3)
			  (setq y3 y4) )
			 (push `(,x6 ,y6) gs-list) )
		  (do* ((y5 (max (floor y4) (1- y-end)) y5)
			(y6 y5 (1+ y6)) )
		       ((> y6 y3)
			(setq y3 y4) )
		       (push `(,x6 ,(1+ y6)) gs-list) )))))))
