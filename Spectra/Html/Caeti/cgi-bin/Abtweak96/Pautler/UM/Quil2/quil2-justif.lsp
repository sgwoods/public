;; quil2-justif.lsp
;; 11/5/97
;; Experimental code for providing a justification for the Advisor's
;; recommended actions.

(defun interf (&aux (action-nodes nil))
  (mapc
   #'(lambda (node1)
       (when (eq 'ACTION_BY_HAS-SUITABILITY__FOR_
		 (first (node-propo node1)) )
	     (push node1 action-nodes) ))
   *advisor-model* )
  action-nodes )

(defun max-1 (i1 &key (key #'identity) &rest l1 &aux max2)
  (cond (l1
	 (setq max2 (max-1 l1 :key key))
	 (if (< (funcall key max1) (funcall key max2))
	     max2
	   max1 ))
	(t
	 i1 )))
      
(defun node-effects-sum (n1) (fourth (node-propo n1)))
(defun node-preconds-sum (n1) (fifth (node-propo n1)))

(defun interf4 (recom-node action-nodes) ;action-nodes doesn't incl recom-node
  (let (max-nonrecom-effects-sum-node
	max-nonrecom-preconds-sum-node
	recom-effects-des nonrecom-effects-des
	recom-preconds-des nonrecom-preconds-des
	)
    (format t "~%The Advisor recommends~
               ~%        ~s~
               ~%because"
	    (second (node-propo recom-node)) )
    (cond ((and (setq max-nonrecom-effects-sum-node
		      (max-1 action-nodes :key #'node-effects-sum) )
		(> (node-effects-sum recom-node)
		   (node-effects-sum max-nonrecom-effects-sum-node) ))
	   (setq recom-effects-des (interf3 recom-node :effects? t)
		 nonrecom-effects-des
		 (interf3 max-nonrecom-effects-sum-node :effects? t) )
	   (format t " it yields these side benefits:~{~%        ~s~}~
                      ~%that you would not get from doing~
                      ~%         ~s~
                      ~%instead."
		   (ldiff recom-effects-des nonrecom-effects-des)
		   ;;^ these must also have a higher value than zero
		   (second (node-propo max-nonrecom-effects-sum-node))
		   )
	   )
	  ((and (setq max-nonrecom-preconds-sum-node
		      (max-1 action-nodes :key #'node-preconds-sum) )
		(> (node-preconds-sum recom-node)
		   (node-preconds-sum max-nonrecom-preconds-sum-node) ))
	   (setq recom-preconds-des
		 (interf3 recom-node :effects? nil)
		 nonrecom-preconds-des
		 (interf3 max-nonrecom-preconds-sum-node :effects? nil) )
	   (format t " it avoids the additional costs:~{~%        ~s~}~
                      ~%that would come from doing~
                      ~%        ~s~
                      ~%instead."
		   (ldiff nonrecom-preconds-des recom-preconds-des)
		   (second (node-propo max-nonrecom-preconds-sum-node))
		   )
	   )
	  (t
	   ;; look for unique recom effects?
	   ))))

(defun interf3 (node1 &key (effects? t) (ante? nil) &aux propo1 instance1)
  (and (node-p node1)
       (setq propo1 (node-propo node1))
       (if (and (eq '_HAS-DESIRABILITY_FOR_ (first propo1))
		(eq (if effects? 'RESULT 'ENABLE)
		    (third (second propo1)) )
		(eq 'USER (fourth propo1)) )
	   (list (list (third propo1)           ;des value
		       (second (second propo1)) ;effect or precond propo
		       ))
	 (or (and (setq instance1 (car (node-instances node1)))
		  (interf3 instance1 :effects? effects?) )
	     (and (not ante?)
		  (apply
		   #'append
		   (mapcar
		    #'(lambda (x) (interf3 x :effects? effects? :ante? t))
		    (listify (rule-antes (node-container node1))) )))
	     ) ;or
	 ) ;if
       ))

#| this is a precursor, with a different justif strategy, to interf2
(defun interf2 (recom-node goal-propo action-nodes
			   &aux (action-justifs-alist nil)
			   nongoal-effects-justifs
			   recom-effects-quart highest-nonrecom-effect
			   highest-nonrecom-precond )
  (mapc
   #'(lambda (action-node1)
       (when (node-container action-node1)
	     (push (cons action-node1 ;v 'desire-User' leaves of proof tree
			 (interf3 action-node1 :ante? nil) )
		   action-justifs-alist )))
   action-nodes )
  (setq nongoal-effects-justifs
	(mapcar
	 #'(lambda (action-justifs-alist1)
	     (cons (car action-justifs-alist1)
		   (apply
		    #'append
		    (mapcar
		     #'(lambda (justif)
			 (and (eq 'RESULT (first justif))
			      (not (equalp goal-propo (third justif)))
			      (list justif) ))
		     (cdr action-justifs-alist1) ))))
	 action-justifs-alist )

	recom-effects-quart
	(assoc recom-node nongoal-effects-justifs)
	nongoal-effects-justifs
	(remove recom-effects-quart nongoal-effects-justifs)
	
	highest-nonrecom-effect ;for response type 1
	

	;; ...
	)
  ;; is response method 1 applicable?
  ;; no -> set highest-nonrecom-effects-sum (for response type 2)

  ;; try other response methods
  )
|#