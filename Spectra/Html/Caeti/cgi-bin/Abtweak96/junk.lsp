;;; foo

(defun ordered-i-g-and-reqd-ops-triples (i g reqd-opids)
  (let* ((required-ops
	  (mapcar #'(lambda (reqd-opid)
		      (find reqd-opid *operators*
			    :key #'operator-opid ))
		  required-opids ))
	 (required-ops-combos
	  (leg-combos-for-required-ops required-ops) )
	 (combo-len (length (car required-ops-combos))) ;all the same
	 (actor-group (second (second i))) ;other i's or g also okay
	 )
    (do* ((reqd-ops-combos1 required-ops-combos (cdr reqd-ops-combos1))
	  (reqd-ops-combo (car reqd-ops-combos1) (car reqd-ops-combos1))
	  (CPs-list nil nil)
	  (old-location (first g) old-location)
	  )
	 ((null reqd-ops-combos1))
	 (dotimes (n (1- combo-len))
		  (push (make-var (gentemp "cp")) CPs-list) )
	 (setq cp-pairs
	       (form-cp-pairs (append CPs-list (list (car i)))) )
	 (setq sub-i-and-g-pairs
	       (mapcar
		#'(lambda (cp-pair)
		    (prog1
			(cons
			 `((at-location ,actor-group ,(cdr cp-pair))
			   (moving-along-leg ,actor-group
					     ,(car cp-pair)
					     ,(cdr cp-pair)
					     (make-var (gentemp "speed"))
					     (make-var (gentemp "security"))
					     (make-var (gentemp "method"))
					     ))
			 `((at-location ,actor-group ,old-location)) )
		      (setq old-location (cdr cp-pair)) ))
		cp-pairs ))
	 ;;generate I and G's for middle legs of routes
	 ;;create new instance for each reqd-op: (create-new-op-instance op)
	 ;;make a series of calls to 'plan' ;these should be done in reverse
	 ;; order from G, so that all binds which get to I' are transfered
	 ;; to G'.

	 ;;cp-pairs used for the leg-start and prior-pt in Mfls's "moving"
	 )
    ))


(defun form-cp-pairs (CPs) ;e.g. (1 2 3 4) --> ((1 . 2)(2 . 3)(3 . 4))
  (and (cdr CPs)
       (let ((pair (cons (first CPs) (second CPs))))
	 (if (cddr CPs)
	     (cons pair
		   (form-cp-pairs (cdr CPs)) )
	   (list pair) ))))

(defun leg-combos-for-required-ops (ops)
  (disjoint-combinations (segregate-ops-by-stages ops)) )

(defun segregate-ops-by-stages (operators)
  (declare (list operators))

  (let ((stages-alist nil)
	op1-stage
	op1-alist )
    (dolist (op1 operators)
	    (setq op1-stage (operator-stage op1))
	    (cond ((null op1-stage) 'diddly)
		  ;; For the time being, we are not going to allow ops with
		  ;;  NIL stages (i.e. filter ops) to be part of a required
		  ;;  ops list.  It would confuse things.
		  ((setq op1-alist (assoc op1-stage stages-alist))
		   (push op1 (cdr op1-alist)) )
		  ((null op1-alist)
		   (push (list op1-stage op1)
			 stages-alist ))
		  (t 'diddly) ))
    (mapcar #'cdr stages-alist) )) ;strip off numerical index

;; I have lost the "leftover" reqd-ops here(v).  What I really want from
;;  ((a1 a2)(b1)) is ( ((a1 b1)(a2)) ((a1)(a2 b1)) )

;;((c1 c2 c3)) --> (((c1)(c2)(c3)))
;;((b1)(c1 c2 c3)) --> (((b1 c1)(c2)(c3)) ((c1)(b1 c2)(c3)) ((c1)(c2)(b1 c3)) )

(defun disjoint-combinations (sets1)
  (if sets1
      (if (cdr sets1)
	  (let* ((items1 (car sets1))
		 (disj-combos1 (disjoint-combinations (cdr sets1)))
		 (items-combos-len-diff
		  (- (length items1)
		     (length (car disj-combos1)) )) ;all the same
		 (filler-list (make-list (abs items-combos-len-diff)))
		 (items-permos
		  (if (<= 0 items-combos-len-diff)
		      (permutations items1)
		    (remove-duplicates
		     (permutations (append items1 filler-list))
		     :test #'equalp ))))
	    (when (< 0 items-combos-len-diff)
		  (setq disj-combos1
			(mapcar #'(lambda (disj-combo1)
				    (append disj-combo1 filler-list) )
				disj-combos1 )))
	    (mapcar
	     #'(lambda (items-permo1)
		 (apply
		  #'append
		  (mapcar #'(lambda (disj-combo1)
			      (mapcar #'(lambda (x y)
					  (if x
					      (cons x y)
					    y ))
				      items-permo1
				      disj-combo1 ))
			  disj-combos1 )))
	     items-permos ))
	(list (mapcar #'list (car sets1))) )
    (list nil) ))

(defun permutations (set1)
  (if set1
      (apply
       #'append
       (mapcar #'(lambda (item1)
		   (mapcar #'(lambda (permo1)
			       (cons item1 permo1) )
			   (permutations (remove item1 set1 :count 1)) ))
	       set1 ))
    (list nil) ))


#|
(defun combinations (set1)
  (if set1
      (let ((item1 (car set1))
	    (combos1 (combinations (cdr set1))) )
	(append combos1
		(mapcar #'(lambda (set2)
			    (cons item1 set2) )
			combos1 )))
    (list nil) ))

;;e.g. ((a1 a2)(b1 b2)(c1)) --> ((a1 b1 c1)(a2 b1 c1)(a1 b2 c1)(a2 b2 c1))
(defun disjoint-combinations2 (sets1)
  (if sets1
      (apply
       #'append
       (mapcar
	#'(lambda (disj-combo1)
	    (mapcar
	     #'(lambda (item1)
		 (cons item1 disj-combo1) )
	     (car sets1) ))
	(disjoint-combinations2 (cdr sets1)) ))
    (list nil) ))
|#