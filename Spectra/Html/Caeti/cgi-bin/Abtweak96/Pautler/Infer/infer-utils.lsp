;; infer-utils.lsp
;; To be used with infer.lsp
;; 8/97 David Pautler

(defmacro push-end (item1 list1)
  (declare (list list1))

  `(if (consp ,list1)
       (nconc ,list1 (list ,item1))
     (if (null ,list1)
	 (setf ,list1 (list ,item1))
       (error "List arg, ~a, to push-end is not a list" ,list1) )))


;;;;;;;;;;;;;;;;;;;; VARIABLES

(defstruct (var
	    (:print-function
	     (lambda (var stream depth)
	       (declare (ignore depth))
	       (format stream "?~a~a"
		       (or (var-symbol var) (var-base var))
		       (if (var-backtrack-sensitive? var)
			   "*"
			 (if (var-constraint-fns var)
			     "&"
			   (if (var-binding-required? var) "" "%") ))
		       ))))
  (base "foo")
  (symbol nil)
  (noncodes-items nil)
  (backtrack-sensitive? nil)
  (binding-required? t)
  (constraint-fns nil) )

(set-macro-character #\?
		     #'(lambda (stream char &aux label penul-len)
			 (declare (ignore char))
			 (setq label (symbol-name (read stream t nil t))
			       penul-len (1- (length label)) )
			 (cond ((equalp "*" (subseq label penul-len))
				(make-var :base (subseq label 0 penul-len)
					  :binding-required? nil
					  :backtrack-sensitive? t ))
			       ((equalp "%" (subseq label penul-len))
				(make-var :base (subseq label 0 penul-len)
					  :binding-required? nil ))
			       (t (make-var :base label)) ))
		     t )

(defun var-equalp (item1 item2)
  (or (equalp item1 item2)
      (and (var-p item1)
	   (var-p item2)
	   (var-symbol-equalp item1 item2) )))

(defun var-symbol-equalp (var1 var2)
  (declare (array var1 var2))

  (if (var-symbol var1) ;so they aren't both NIL
      (equalp (var-symbol var1) (var-symbol var2))
    (and (null (var-symbol var2))
	 (equalp (var-base var1) (var-base var2)) )))

;; We need to have one var per var-name within each propo/rule to insure that
;;  noncodes items added to a var in one position will also have an effect
;;  for that var as it appears other places within a propo.
;; We need to uniquify vars across propos to insure that unifications like
;;  this: (unify '(foo ?x 3) '(foo 5 ?x) nil) actually result in success.

(defun standardize-vars (propo &optional (var-alist1 nil))
  (declare (list propo var-alist1))

  (let ((var-alist2 (make-standard-vars propo var-alist1)))
    (values
     (if var-alist2
	 (instantiate propo var-alist2)
       propo )
     var-alist2 )))

(defun make-standard-vars (item &optional (var-alist nil))
  (declare (list var-alist))

  (if (consp item)
      (make-standard-vars (cdr item)
			  (make-standard-vars (car item) var-alist) )
    (if (var-p item)
	(if (assoc item var-alist :test #'var-symbol-equalp)
	    var-alist
	  (cons (cons item
		      (make-var :base (var-base item)
				:symbol (gentemp (var-base item))
				:backtrack-sensitive?
				(var-backtrack-sensitive? item)
				:binding-required?
				(var-binding-required? item)
				:constraint-fns
				(var-constraint-fns item)
				))
		var-alist ))
      var-alist )))


;;;;;;;;;;;;;;;;;;;; ATTACHED PROCEDURES

(let ((eval-pred-fns-table (make-hash-table)) ;for attached procedures
      (action-pred-fns-table (make-hash-table)) )

  ;; Restriction: All pred fns must take these args and only these args:
  ;;              The args of the predicate + The codes-pairs at that point
  ;;              + The noncodes-alist at that point

  ;;              EVAL procedures return 6 values:
  ;;               1) The truth of the propo
  ;;               2) a codes-pairs list
  ;;               3) a noncodes-alist
  ;;               4) three NILs - for untried completions, facts, and rules

  (defun def-pred-fn (predicate use-type fn)
    (setf (gethash predicate
		   (case use-type
			 (EVAL   eval-pred-fns-table)
			 (ACTION action-pred-fns-table)
			 (t (error "Unrecognized use-type: ~a" use-type)) ))
	  fn ))

  (defun get-pred-fn (predicate use-type)
    (gethash predicate
	     (case use-type
		   (EVAL   eval-pred-fns-table)
		   (ACTION action-pred-fns-table)
		   (t (error "Unrecognized use-type: ~a" use-type)) )))
  )

;; These attached procedures are the only methods allowed for changing a
;;  noncodes constraint.
;;  The EVAL method does two things:
;;   1) it checks whether a noncodes constraint holds, as represented either
;;      in the working list of constraints or in the permanent list attached
;;      to a var;
;;   2) if the constraint holds, and it is a new constraint, then the method
;;      adds it (only) to the working list.  The working list of noncodes
;;      constraints is useful for implementing Negation-by-failure clauses.
;;  The ACTION method only makes changes to the permanent list attached to a
;;   var, and this is the only way that a constraint can be added to a var's
;;   permanent noncodes list.  The permanent list is useful for enforcing
;;   premises such as:
;;        ((_likes_ Susie ?person) AND (NOT= ?person Mephistopheles))

(def-pred-fn
  'NOT=
  'EVAL
  #'(lambda (arg1 arg2 codes-pairs noncodes-alist search-depth)
      (declare (list codes-pairs noncodes-alist) (ignore search-depth))

      (multiple-value-bind
       (unify? codes-pairs1)

       (unify (instantiate arg1 codes-pairs)
	      (instantiate arg2 codes-pairs)
	      nil noncodes-alist )
       (dolist (codes-pair1 codes-pairs1)
	       (setq noncodes-alist
		     (update-noncodes-alist (car codes-pair1)
					    (cdr codes-pair1)
					    noncodes-alist )))
       (values
	(not (and unify?
		  (null codes-pairs1) ))
	codes-pairs
	noncodes-alist
	nil nil nil nil ))))

(defun update-noncodes-alist (arg1 arg2 noncodes-alist
				   &key (once-already? nil)
				   &aux (pair1 nil) )
  (declare (list noncodes-alist pair1))

  (cond ((var-p arg1)
	 (if once-already?
	     (if (setq pair1 (assoc arg1 noncodes-alist))
		 (if (find arg2 (cdr pair1) :test #'equalp)
		     noncodes-alist
		   (cons (cons arg1 (cons arg2 (cdr pair1)))
			 (remove pair1 noncodes-alist) )) ;NONDESTRUCTIVE!!
	       (cons (list arg1 arg2) noncodes-alist) )
	   (update-noncodes-alist
	    arg2
	    arg1
	    (if (setq pair1 (assoc arg1 noncodes-alist))
		(if (find arg2 (cdr pair1) :test #'equalp)
		    noncodes-alist
		  (cons (cons arg1 (cons arg2 (cdr pair1)))
			(remove pair1 noncodes-alist) ))
	      (cons (list arg1 arg2) noncodes-alist) )
	    :once-already? t )))
	((and (not once-already?)
	      (var-p arg2) )
	 (update-noncodes-alist arg2 arg1 noncodes-alist :once-already? t) )
	(t noncodes-alist) ))

(def-pred-fn
  'NOT=
  'ACTION
  #'(lambda (arg1 arg2 codes-pairs)
      (declare (ignore codes-pairs))

      (when (var-p arg1)
	    (push arg2 (var-noncodes-items arg1)) )
      (when (var-p arg2)
	    (push arg1 (var-noncodes-items arg2)) )))


;;;;;;;;;;;;;;;;;;;; UNIFICATION and INSTANTIATION

(defun unify* (item1 item2) ;for unifying from a command-line prompt
  (unify (standardize-vars item1)
	 (standardize-vars item2)
	 nil
	 nil ))


(defvar *arithmetical-ops* '(+ - * /))

(defun unify (item1 item2 codes-pairs noncodes-alist
		    &aux unify? codes-pairs1 codes-pair args
		    instand-options instand-range )
  (declare (list codes-pairs noncodes-alist codes-pairs1 codes-pair args))

  (cond ((var-equalp item1 item2) ;also applies to non-vars
	 (values t codes-pairs) )

	;; These 4 conditions represent nontraditional unif functionalities
	((and (consp item2)
	      (eq 'NOT (first item2))
	      (consp (second item2))
	      (eq 'NOT (first (second item2)))
	      (progn
		(multiple-value-setq
		 (unify? codes-pairs1)

		 (unify item1 (second (second item2))
			codes-pairs noncodes-alist ))
		unify? ))
	 (values t codes-pairs1) )
	((and (consp item1)
	      (eq 'NOT (first item1))
	      (consp (second item1))
	      (eq 'NOT (first (second item1)))
	      (progn
		(multiple-value-setq
		 (unify? codes-pairs1)

		 (unify (second (second item1)) item2
			codes-pairs noncodes-alist ))
		unify? ))
	 (values t codes-pairs1) )
	((and (consp item1)
	      (find (first item1) *arithmetical-ops*)
	      (every #'numberp
		     (setq args
			   (listify
			    (mapcar-1
			     #'(lambda (arg) (instantiate arg codes-pairs))
			     (rest item1) )))))
	 (unify (apply (first item1) args) item2 codes-pairs noncodes-alist) )
	((and (consp item2)
	      (find (first item2) *arithmetical-ops*)
	      (every #'numberp
		     (setq args
			   (listify
			    (mapcar-1
			     #'(lambda (arg) (instantiate arg codes-pairs))
			     (rest item2) )))))
	 (unify item1 (apply (first item2) args) codes-pairs noncodes-alist) )

	((var-p item1)
	 (and (not (noncodes-path-between-p item1 item2
					    noncodes-alist codes-pairs ))
	      (not (permanent-noncodes-path-between-p item1 item2 codes-pairs))
	      (not (contained-within-p item1 item2
				       codes-pairs )) ;item2 may be fn-app
	      (if (setq codes-pair
			(assoc item1 codes-pairs :test #'var-equalp) )
		  (unify (cdr codes-pair) item2 codes-pairs noncodes-alist)
		(if (every #'(lambda (constr-fn) ;nontraditional for UNIFY
			       (funcall constr-fn item2) )
			   (var-constraint-fns item1) )
		    (values t
			    (if (and (var-p item2)
				     (codes-path-between-p item2 item1
							   codes-pairs ))
				codes-pairs
			      (cons (if (and (var-p item2)
					     (null (var-constraint-fns item2))
					     (var-constraint-fns item1) )
					(cons item2 item1)
				      (cons item1 item2) )
				    codes-pairs )))
		  (values nil codes-pairs) ))))
	((var-p item2)
	 (and (not (noncodes-path-between-p item2 item1
					    noncodes-alist codes-pairs ))
	      (not (permanent-noncodes-path-between-p item2 item1 codes-pairs))
	      (not (contained-within-p item2 item1
				       codes-pairs )) ;item1 may be fn-app
	      (if (setq codes-pair
			(assoc item2 codes-pairs :test #'var-equalp) )
		  (unify (cdr codes-pair) item1 codes-pairs noncodes-alist)
		(if (every #'(lambda (constr-fn) ;nontraditional for UNIFY
			       (funcall constr-fn item1) )
			   (var-constraint-fns item2) )
		    (values t (cons (cons item2 item1) codes-pairs))
		  (values nil codes-pairs) ))))

	;; These are nonstandard additional functionalities (for preconds)
	((and (consp item1)
	      (eq (first item1) :INTERSECT) )
	 ;;eg i1=(:intersect ?E (PAIR G1 G4)) i2=(PAIR G1 (PAIR G2 G3))
	 (multiple-value-bind
	  (unify? codes-pairs1)

	  (unify (second item1) item2 codes-pairs noncodes-alist)
	  (multiple-value-bind
	   (unify2? codes-pairs2)

	   (and unify?
		(pairs-unify-intersection
		 (instantiate (second item1) codes-pairs1)
		 (instantiate (third item1) codes-pairs)
		 codes-pairs1 noncodes-alist ))
	   (if unify2?
	       (values t codes-pairs2)
	     (values nil codes-pairs) ))))
	((and (consp item1)
	      (eq (first item1) :SUBSET) )
	 (multiple-value-bind
	  (unify? codes-pairs1)

	  (unify (second item1) item2 codes-pairs noncodes-alist)
	  (multiple-value-bind
	   (unify2? codes-pairs2)
	   
	   (and unify?
		(pairs-unify-subsetp (instantiate (second item1) codes-pairs1)
				     (instantiate (third item1) codes-pairs)
				     codes-pairs1 noncodes-alist ))
	   (if unify2?
	       (values t codes-pairs2)
	     (values nil codes-pairs) ))))
	((and (consp item2)
	      (find (first item2) '(:INTERSECT :SUBSET)) )
	 (unify item2 item1 codes-pairs noncodes-alist) )
	((and (consp item1)
	      (eq (first item1) :OPTIONS)
	      (setq instand-options (instantiate (rest item1) codes-pairs))
	      (some-1 #'var-p instand-options) )
	 (error
	  "The OPTIONS precond ~s contains a variable, which is not ~
           allowable.  Please revise your domain knowledge."
	  instand-options ))
	((and (consp item1)
	      (eq (first item1) :OPTIONS) )
	 (values (not (null (find-1 (instantiate item2 codes-pairs)
				    instand-options )))
		 codes-pairs ))
	((and (consp item1)
	      (eq (first item1) :RANGE)
	      (setq instand-range (instantiate (rest item1) codes-pairs))
	      (some-1 #'var-p instand-range) )
	 (error
	  "The RANGE precond ~s contains a variable, which is not ~
           allowable.  Please revise your domain knowledge."
	  instand-range ))
	((and (consp item1)
	      (eq (first item1) :RANGE) )
	 (setq item2 (instantiate item2 codes-pairs))
	 (values
	  (or (eq item2 (first instand-range)) ;? item2 = neg-infin = lower-lmt
	      (eq item2 (second instand-range));? item2 = pos-infin = upper-lmt
	      (and (numberp item2)
		   (or (eq 'NEG-INFIN (first instand-range))
		       (and (numberp (first instand-range))
			    (> item2 (first instand-range)) ))
		   (or (eq 'POS-INFIN (second instand-range))
		       (and (numberp (second instand-range))
			    (< item2 (second instand-range)) ))))
	  codes-pairs ))

	;; these are standard parts of UNIFY functionality
	((and (consp item1)
	      (consp item2) )
	 (and (let ((len1 (length-1 item1))
		    (len2 (length-1 item2)) )
		(or (= len1 len2)
		    (and (oddp len1)                ;allows (?x . ?y):((foo a))
			 (var-p (cdr (last item1))) )
		    (and (oddp len2)
			 (var-p (cdr (last item2))) )))
	      (multiple-value-bind
	       (unify? codes-pairs1)

	       (unify (first item1) (first item2) codes-pairs noncodes-alist)
	       (and unify?
		    (unify (rest item1) (rest item2)
			   codes-pairs1 noncodes-alist )))))
	(t (values nil codes-pairs)) ))

(defun contained-within-p (var1 item2 codes-pairs &aux codes-pair)
  (declare (array var1) (list codes-pairs codes-pair))

  (or (and (var-p item2)
	   (or (var-equalp var1 item2)
	       (and (setq codes-pair
			  (assoc item2 codes-pairs :test #'var-equalp) )
		    (contained-within-p var1 (cdr codes-pair) codes-pairs) )))
      (and (consp item2)
	   (or (contained-within-p var1 (car item2) codes-pairs)
	       (contained-within-p var1 (cdr item2) codes-pairs) ))))

(defun codes-path-between-p (var1 item2 codes-pairs &aux val)
  (declare (array var1) (list codes-pairs))

  (and (setq val (cdr (assoc var1 codes-pairs)))
       (or (var-equalp val item2)
	   (and (var-p val)
		(codes-path-between-p val item2 codes-pairs) ))))

(defun noncodes-path-between-p (var1 item2 noncodes-alist codes-pairs
				     &optional (search-history nil)
				     &aux ncs val negative-evidence? )
  (declare (array var1) (list noncodes-alist codes-pairs ncs))

  (values
   (and (not (setq negative-evidence? (eq var1 item2)))
	(not (find var1 search-history))
	(or (and (setq ncs (cdr (assoc var1 noncodes-alist)))
		 (if (functionp ncs)
		     (funcall ncs item2)
		   (some ;assume a list
		    #'(lambda (nc-elem)
			(or (and (functionp nc-elem)
				 (funcall nc-elem item2) )
			    (var-equalp nc-elem item2)
			    (and (consp nc-elem)
				 (consp item2)
				 (unify nc-elem item2
					codes-pairs noncodes-alist ))
			    (and (var-p nc-elem)
				 (or (codes-path-between-p
				      nc-elem
				      item2
				      codes-pairs )
				     (multiple-value-bind
				      (path? neg-ev?)

				      (noncodes-path-between-p
				       nc-elem
				       item2
				       noncodes-alist
				       codes-pairs
				       (cons var1 search-history) )
				      (setq negative-evidence?
					    (or negative-evidence? neg-ev?) )
				      path? )))))
		    ncs )))
	   (and (not negative-evidence?)
		(setq val (cdr (assoc var1 codes-pairs)))
		(multiple-value-bind
		 (path? neg-ev?)

		 (noncodes-path-between-p
		  val
		  item2
		  noncodes-alist
		  codes-pairs
		  (cons var1 search-history) )
		 (setq negative-evidence? (or negative-evidence? neg-ev?))
		 path? ))
	   (and (not negative-evidence?)
		(setq val (car (rassoc var1 codes-pairs)))
		(multiple-value-bind
		 (path? neg-ev?)

		 (noncodes-path-between-p
		  val
		  item2
		  noncodes-alist
		  codes-pairs
		  (cons var1 search-history) )
		 (setq negative-evidence? (or negative-evidence? neg-ev?))
		 path? ))
	   ))
   negative-evidence? ))

(defun permanent-noncodes-path-between-p (var1 item2 codes-pairs
					       &optional (search-history nil))
  (declare (array var) (list codes-pairs search-history))

  (some
   #'(lambda (nc-elem) ;v there will often be backptrs among vars
       (and (not (find nc-elem search-history))
	    (or (var-equalp nc-elem item2)
		(and (functionp nc-elem)
		     (funcall nc-elem item2) )
		(and (var-p nc-elem)
		     (or (codes-path-between-p nc-elem
					       item2
					       codes-pairs )
			 (permanent-noncodes-path-between-p
			  nc-elem
			  item2
			  codes-pairs
			  (cons nc-elem search-history) ))))))
   (var-noncodes-items var1) ))

(defun instantiate (item1 codes-pairs &aux item1-bind args)
  (declare (list codes-pairs args))

  (cond ((and (consp item1)
	      (find (first item1) *arithmetical-ops*)
	      (every #'numberp
		     (setq args
			   (listify
			    (mapcar-1
			     #'(lambda (arg1)
				 (instantiate arg1 codes-pairs) )
			     (rest item1) ))))
	      )
	 (apply (first item1) args) )
	((consp item1)
	 (cons (instantiate (first item1) codes-pairs)
	       (instantiate (rest item1) codes-pairs) ))
	((not (var-p item1))
	 item1 )
	((setq item1-bind (assoc item1 codes-pairs :test #'var-equalp))
	 (instantiate (cdr item1-bind) codes-pairs) )
	(t item1) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;              CODE FOR 'PAIRS' DATA FORMAT
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun pairs-unify-intersection (pair1 pair2 codes-pairs noncodes-alist)
  ;;Find bindings for each item in pair1 that appears in pair2; there must
  ;; be a non-NIL intersection between pair1 and pair2 to return T.
  ;; eg p1=(PAIR 1 (PAIR 2 3)) p2=(PAIR 3 4)
  ;;NOTE: the PAIR data format used in pair1 and pair2 has nothing to do
  ;; with the data format in codes-pairs, which are simple cons cells
  (if pair1
      (if (and (consp pair1)
	       (eq 'PAIR (first pair1)) )
	  (multiple-value-bind
	   (inters1? codes-pairs1)

	   (pairs-unify-intersection (second pair1) pair2
				     codes-pairs noncodes-alist )
	   (multiple-value-bind
	    (inters2? codes-pairs2)

	    (pairs-unify-intersection (third pair1) pair2
				      codes-pairs1 noncodes-alist )
	    (values (or inters1? inters2?)
		    (if inters2? codes-pairs2 codes-pairs1) )))
	(if pair2
	    (if (and (consp pair2)
		     (eq 'PAIR (first pair2)) )
		(multiple-value-bind
		 (unify? codes-pairs1)

		 (unify pair1 (second pair2) codes-pairs noncodes-alist)
		 (if unify?
		     (values t codes-pairs1)
		   (pairs-unify-intersection pair1 (third pair2)
					     codes-pairs noncodes-alist )))
	      (unify pair1 pair2 codes-pairs noncodes-alist) )
	  (values nil codes-pairs) ))
    (values nil codes-pairs) ))

(defun pairs-unify-subsetp (pair1 pair2 codes-pairs noncodes-alist)
  ;;Find bindings for each item in pair1 that appears in pair2; pair1 must
  ;; be a subset of pair2 to return T.
  ;; eg p1=(PAIR 2 1) p2=(PAIR 1 (PAIR 2 3))
  (if pair1
      (if (and (consp pair1)
	       (eq 'PAIR (first pair1)) )
	  (multiple-value-bind
	   (subs1? codes-pairs1)

	   (pairs-unify-subsetp (second pair1) pair2
				codes-pairs noncodes-alist )
	   (if subs1?
	       (multiple-value-bind
		(subs2? codes-pairs2)

		(pairs-unify-subsetp (third pair1) pair2
				     codes-pairs1 noncodes-alist )
		(if subs2?
		    (values t codes-pairs2)
		  (values nil codes-pairs) ))
	     (values nil codes-pairs) ))
	(if pair2
	    (if (and (consp pair2)
		     (eq 'PAIR (first pair2)) )
		(multiple-value-bind
		 (subs1? codes-pairs1)

		 (unify pair1 (second pair2) codes-pairs noncodes-alist)
		 (if subs1?
		     (values t codes-pairs1)
		   (pairs-unify-subsetp pair1 (third pair2)
					codes-pairs noncodes-alist )))
	      (unify pair1 pair2 codes-pairs noncodes-alist) )
	  (values nil codes-pairs) ))
    (values nil codes-pairs) ))
