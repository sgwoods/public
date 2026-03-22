;; ct.lsp

(defun revise (symbol1 domain1 symbol2 domain2 consistent-p partial-solution )
  "The REVISE routine by Mackworth.
   SYMBOL and SYMBOL2 are two variable names.
   DOMAIN1 and DOMAIN2 are their respective domains.
   CONSISTENT-P is a function as specfied in the backtracking routine to check
   for the consistency of two instantiations.
   The function returns a new domain for SYMBOL1."

  (let ((any-incompatibilities? nil)
	(compatibles-in-domain1 nil) )
    (dolist (value1 domain1)
	    (if (compatible-p symbol1 value1 symbol2 domain2 
			      consistent-p partial-solution)
		(progn
		  (when *debug-ac*
			(comment4 "AC3: Compatible"
				  symbol1 value1 symbol2 domain2 ))
		  (push value1 compatibles-in-domain1)
		  (incf *ac-count-compat*) )
	      (progn
		(when *debug-ac* 
		      (comment4 "AC3: Not compatible"
				symbol1 value1 symbol2 domain2 ))
		(setq any-incompatibilities? t) ;never reset to nil :DP
		(incf *ac-count-notcompat*) )))
    (values compatibles-in-domain1 any-incompatibilities?) ))

(defun compatible-p (symbol1 value1 symbol2 domain2 
			     consistent-p partial-solution)
  (some
   #'(lambda (value2)
       (first (funcall consistent-p
		       symbol1 value1
		       symbol2 value2
		       partial-solution )))
   domain2 ))

(defun ac-3 (variable-list arc-p consistent-p partial-solution)
  "The AC-3 routine by Mackworth.
   VARIABLE-LIST is a list of variables as specified in the backtracking
   routine. It is a list of sublists: the car of each is a variable symbol and
   the cdr is a list of all possible domain values for that variable.
   ARC-P is a function as described in ARC-P.
   CONSISTENT-P is a function as described in CONSISTENT-P.
   The function returns a new variable list which is arc-consistent."

  (let ((arc-list (get-all-arcs variable-list arc-p)) 
	(var-list (copy-alist variable-list))
	compatibles-in-domain1
	any-incompatibilities? )

    (do (symbol1 symbol2) ;open-ended loop, due to updating of arc-list
	((endp arc-list) var-list)
	(setq symbol1  (first  (first arc-list))
	      symbol2  (second (first arc-list))
	      arc-list (rest arc-list) )

	(multiple-value-setq (compatibles-in-domain1 any-incompatibilities?)
			     (revise symbol1
				     (cdr (assoc symbol1 var-list
						 :test #'equalp ))
				     symbol2
				     (cdr (assoc symbol2 var-list
						 :test #'equalp ))
				     consistent-p
				     partial-solution ))

	(when any-incompatibilities?
	      (setf (cdr (assoc symbol1 var-list :test #'equalp))
		    compatibles-in-domain1 )
	      (setq arc-list ;update domains of nearby vars :DP
		    (union arc-list 
			   (get-incident-arcs symbol1 symbol2 var-list arc-p)
			   :test #'equal ))))))

(defun get-incident-arcs (symbol1 symbol2 variable-list arc-p)
  (let ((arc-list nil) 
	symbol )
    (dolist (variable variable-list)
	    (setq symbol (first variable))
	    (when (and (not (equal symbol symbol1))
		       (not (equal symbol symbol2))
		       (funcall arc-p symbol symbol1))
		  (push (list symbol symbol1) arc-list) ))
    arc-list ))

(defun degree-of-node (symbol variable-list arc-p)
  (let ((arc-list nil) 
	symbol1 )
    (dolist (variable variable-list (values (length arc-list) arc-list))
	    (setq symbol1 (first variable))
	    (when (and (not (equal symbol1 symbol))
		       (funcall arc-p symbol symbol1) )
		  (setq arc-list (cons (list symbol symbol1) arc-list)) ))
    ))

(defun get-all-arcs (variable-list arc-p)
  "Create a list of all the existing arcs.
   Input: VARIABLE-LIST is a list of sublist, each has its car a variable
          symbol and its cdr a list of domain values for that variable.
          ARC-P is a function as defined in ARC-P."
  (let (arc-list symbol1 symbol2)
    (dolist (variable1 variable-list)
	    (dolist (variable2 variable-list)
		    (setq symbol1 (first variable1)
			  symbol2 (first variable2) )
		    (when (and (not (equal symbol1 symbol2))
			       (funcall arc-p symbol1 symbol2) )
			  (push (list symbol1 symbol2) arc-list) ))
	    ) ;2nd dolist
    arc-list ))


