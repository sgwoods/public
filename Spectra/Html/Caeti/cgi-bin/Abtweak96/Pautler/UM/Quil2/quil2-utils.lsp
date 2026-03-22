;; quil2-utils.lsp
;; To be used in support of quil2.lsp

(defvar *verbose1?* nil) ;for debugging explanation scoring
(defvar *verbose2?* nil) ;for debugging 'backchain-2' traces

(defvar *block-on-search-history-duplication?* t)
(defvar *block-on-search-depth-limit?* t)

(defvar *facts* nil)
(defvar *b-rules* nil) ;only used by find-advisor-expl; hash-tbls are norm

(defvar *user-model* nil)         ;Each of these is a list of facts
(defvar *advisor-model* nil)
(defvar *user-focus-space* nil)
(defvar *advisor-focus-space* nil)
(defvar *old-advisor-focus-space* nil)

(defmacro push-newer-node (item1 list1) ;needed so generate-rsp works on A side
  `(if ,list1
       (setq ,list1
	     (cons ,item1
		   (remove ,item1 ,list1
			   :test #'(lambda (x y)
				     (equalp (node-propo x)
					     (node-propo y) )))))
     (setq ,list1 (list ,item1)) ))


;;;;;;;;;;;;;;;;;;;; ATTACHED PROCEDURES

;; Lists within propos must be represented as coll's, not list-of's or
;;  conjunctions, for this code to work.

(def-pred-fn
  '<
  'EVAL
  #'(lambda (arg1 arg2 codes-pairs noncodes-alist search-depth)
      (declare (list codes-pairs noncodes-alist) (ignore search-depth))

      (values
       (progn
	 (setq arg1 (instantiate arg1 codes-pairs)
	       arg2 (instantiate arg2 codes-pairs) )
	 (and (numberp arg1)
	      (numberp arg2)
	      (< arg1 arg2) ))
       codes-pairs
       noncodes-alist
       nil nil nil nil )))

(def-pred-fn
  '_contains-unsatisfieds_
  'EVAL
  #'(lambda (arg1 arg2 codes-pairs noncodes-alist search-depth
		  &aux (unsatisfied-item nil) )
      (declare (list codes-pairs noncodes-alist) (number search-depth))

      (setq arg1 (instantiate arg1 codes-pairs))
      (cond ((var-p arg1)
	     (error "The preconds var ~s must be bound by this point or the ~
                     CONTAINS-UNSATISFIEDS procedure can't work."
		    arg1 ))
	    (t
	     (mapc
	      #'(lambda (propo1 &aux (node1 (make-node :propo propo1)))
		  (multiple-value-bind
		   (satisfied? codes-pairs1 noncodes-alist1)

		   (backchain-2 (make-node :propo propo1)
				*facts* *facts*
				(get-relevant-rule-nodes
				 node1 :antes? nil :all-rules? t )
				nil codes-pairs noncodes-alist nil
				search-depth )
		   (if satisfied?
		       (setq codes-pairs codes-pairs1
			     noncodes-alist noncodes-alist1 )
		     (setq unsatisfied-item
			   (if unsatisfied-item
			       (list 'PAIR propo1 unsatisfied-item)
			     propo1 ))
		     )))
	      (pair-to-list arg1) )
	     (values
	      t
	      (cons (cons arg2 unsatisfied-item) codes-pairs)
	      noncodes-alist
	      nil nil nil nil )
	     ) ;t in cond
	    )))

(defun pair-to-list (item)
  (and item
       (if (and (consp item)
		(eq 'PAIR (first item)) )
	   (cons (second item)
		 (pair-to-list (third item)) )
	 (list item) )))


;;;;;;;;;;;;;;;;;;;; DATA STRUCTURES FOR CLAUSES AND RULES

;;for facts, antecs, and conseqs
(defstruct (node
	    (:print-function
	     (lambda (node stream depth)
	       (declare (ignore depth))
	       (format stream "[~s]" (node-propo node)) )))
  propo (container nil) (instance-of nil) (instances nil) (contradicts nil) )

(defstruct (rule
	    (:print-function
	     (lambda (rule stream depth)
	       (declare (ignore depth))
	       (format stream "{~s:~s <- ~s}"
		       (rule-id rule)
		       (rule-conseqs rule) (rule-antes rule) ))))
  id antes conseqs )

(defun reset-dbs-1 ()
  (setq *facts* nil)
  (setq *b-rules* nil)
  (clear-rule-tables)
  (reset-dbs-2) )

(defun reset-dbs-2 ()
  (setq *user-model* nil
	*advisor-model* (copy-list *facts*)
	*user-focus-space* nil
	*advisor-focus-space* nil ))

(defun def-fact (propo &aux (node (make-node :propo (standardize-vars propo))))
  (push-end node *facts*)
  node )

(let ((b-antec-pred-table          (make-hash-table :size 100))
      (b-neg-antec-pred-table      (make-hash-table :size 20))
      (b-conseq-pred-table         (make-hash-table :size 50))
      (b-neg-conseq-pred-table     (make-hash-table :size 20))
      (b-all-antec-pred-table      (make-hash-table :size 100))
      (b-all-neg-antec-pred-table  (make-hash-table :size 20))
      (b-all-conseq-pred-table     (make-hash-table :size 50))
      (b-all-neg-conseq-pred-table (make-hash-table :size 20))

      (f-antec-pred-table          (make-hash-table :size 40))
      (f-neg-antec-pred-table      (make-hash-table :size 10))
      (f-conseq-pred-table         (make-hash-table :size 20))
      (f-neg-conseq-pred-table     (make-hash-table :size 10))
      (f-all-antec-pred-table      (make-hash-table :size 40))
      (f-all-neg-antec-pred-table  (make-hash-table :size 10))
      (f-all-conseq-pred-table     (make-hash-table :size 20))
      (f-all-neg-conseq-pred-table (make-hash-table :size 10))
      )

  (defun debug-tables ()
    (format t "~%~%antec")
    (maphash
     #'(lambda (key val)
	 (format t "~%   ~s :~{~%       ~s~} ~s" key val (length val)) )
     b-antec-pred-table )
    (format t "~%~%neg-antec")
    (maphash
     #'(lambda (key val)
	 (format t "~%   ~s :~{~%       ~s~} ~s" key val (length val)) )
     b-neg-antec-pred-table )
    (format t "~%~%conseq")
    (maphash
     #'(lambda (key val)
	 (format t "~%   ~s :~{~%       ~s~} ~s" key val (length val)) )
     b-conseq-pred-table )
    (format t "~%~%neg-conseq")
    (maphash
     #'(lambda (key val)
	 (format t "~%   ~s :~{~%       ~s~} ~s" key val (length val)) )
     b-neg-conseq-pred-table )
    (format t "~%~%~%all antecs")
    (maphash
     #'(lambda (key val)
	 (format t "~%   ~s :~{~%       ~s~} ~s" key val (length val)) )
     b-all-antec-pred-table ))

  (defun clear-rule-tables ()
    (clrhash b-antec-pred-table)
    (clrhash b-neg-antec-pred-table)
    (clrhash b-conseq-pred-table)
    (clrhash b-neg-conseq-pred-table)
    (clrhash b-all-antec-pred-table)
    (clrhash b-all-neg-antec-pred-table)
    (clrhash b-all-conseq-pred-table)
    (clrhash b-all-neg-conseq-pred-table)
    (clrhash f-antec-pred-table)
    (clrhash f-neg-antec-pred-table)
    (clrhash f-conseq-pred-table)
    (clrhash f-neg-conseq-pred-table)
    (clrhash f-all-antec-pred-table)
    (clrhash f-all-neg-antec-pred-table)
    (clrhash f-all-conseq-pred-table)
    (clrhash f-all-neg-conseq-pred-table) )

  (defun def-rule-1 (tag propo &key (syntactic? nil))
    (declare (symbol tag) (list propo))

    (let* ((rule-type (second propo))
	   (rule-propo (standardize-vars propo))
	   antec-nodes conseq-nodes rule )
      (case rule-type
	    (<-
	     (setq antec-nodes  (compose-nodes (third rule-propo))
		   conseq-nodes (compose-nodes (first rule-propo))
		   rule         (make-rule :id tag
					   :antes antec-nodes
					   :conseqs conseq-nodes ))
	     (install-rule-parts antec-nodes rule syntactic?
				 b-antec-pred-table b-all-antec-pred-table
				 b-neg-antec-pred-table
				 b-all-neg-antec-pred-table )
	     (install-rule-parts conseq-nodes rule syntactic?
				 b-conseq-pred-table b-all-conseq-pred-table
				 b-neg-conseq-pred-table
				 b-all-neg-conseq-pred-table )
	     (push-end rule *b-rules*)
	     rule
	     )
	    (->
	     (setq antec-nodes  (compose-nodes (first rule-propo))
		   conseq-nodes (compose-nodes (third rule-propo))
		   rule         (make-rule :id tag
					   :antes antec-nodes
					   :conseqs conseq-nodes ))
	     (install-rule-parts antec-nodes rule syntactic?
				 f-antec-pred-table f-all-antec-pred-table
				 f-neg-antec-pred-table
				 f-all-neg-antec-pred-table )
	     (install-rule-parts conseq-nodes rule syntactic?
				 f-conseq-pred-table f-all-conseq-pred-table
				 f-neg-conseq-pred-table
				 f-all-neg-conseq-pred-table )
	     )
	    (IMPLIED-BY
	     (setq antec-nodes  (compose-nodes (third rule-propo))
		   conseq-nodes (compose-nodes (first rule-propo))
		   rule         (make-rule :id tag
					   :antes antec-nodes
					   :conseqs conseq-nodes ))
	     (install-rule-parts antec-nodes rule syntactic?
				 b-antec-pred-table b-all-antec-pred-table
				 b-neg-antec-pred-table
				 b-all-neg-antec-pred-table )
	     (install-rule-parts conseq-nodes rule syntactic?
				 b-conseq-pred-table b-all-conseq-pred-table
				 b-neg-conseq-pred-table
				 b-all-neg-conseq-pred-table )
	     (push-end rule *b-rules*)
	     (setq rule-propo   (standardize-vars propo) ;make a new copy
		   antec-nodes  (compose-nodes (third rule-propo))
		   conseq-nodes (compose-nodes (first rule-propo))
		   rule         (make-rule :id tag
					   :antes antec-nodes
					   :conseqs conseq-nodes ))
	     (install-rule-parts antec-nodes rule syntactic?
				 f-antec-pred-table f-all-antec-pred-table
				 f-neg-antec-pred-table
				 f-all-neg-antec-pred-table )
	     (install-rule-parts conseq-nodes rule syntactic?
				 f-conseq-pred-table f-all-conseq-pred-table
				 f-neg-conseq-pred-table
				 f-all-neg-conseq-pred-table )
	     )
	    ))
    tag )

  (defun get-relevant-rule-nodes (node1 &key (bc? t)
					(antes? t) (all-rules? nil)
					&aux (propo1 (node-propo node1))
					pred1 )
    ;; A node containing a conjunction -- which should only happen for
    ;;  uniqueness checks (eg, (NOT ((NOT= ..) and ...)) -- will yield
    ;;  NIL, which is exactly what we would want in that case.
    (and (consp propo1)
	 (setq pred1 (first propo1))
	 (if bc?
	     (cond ((eq 'NOT pred1)
		    (setq propo1 (second propo1))
		    (and (consp propo1)
			 (setq pred1 (first propo1))
			 (if antes?
			     (if all-rules?
				 (gethash pred1 b-all-neg-antec-pred-table)
			       (gethash pred1 b-neg-antec-pred-table) )
			   (if all-rules?
			       (gethash pred1 b-all-neg-conseq-pred-table)
			     (gethash pred1 b-neg-conseq-pred-table) ))))
		   (t
		    (if antes?
			(if all-rules?
			    (gethash pred1 b-all-antec-pred-table)
			  (gethash pred1 b-antec-pred-table) )
		      (if all-rules?
			  (gethash pred1 b-all-conseq-pred-table)
			(gethash pred1 b-conseq-pred-table) ))))
	   (cond ((eq 'NOT pred1)
		  (setq propo1 (second propo1))
		  (and (consp propo1)
		       (setq pred1 (first propo1))
		       (if antes?
			   (if all-rules?
			       (gethash pred1 f-all-neg-antec-pred-table)
			     (gethash pred1 f-neg-antec-pred-table) )
			 (if all-rules?
			     (gethash pred1 f-all-neg-conseq-pred-table)
			   (gethash pred1 f-neg-conseq-pred-table) ))))
		 (t
		  (if antes?
		      (if all-rules?
			  (gethash pred1 f-all-antec-pred-table)
			(gethash pred1 f-antec-pred-table) )
		    (if all-rules?
			(gethash pred1 f-all-conseq-pred-table)
		      (gethash pred1 f-conseq-pred-table) )))))))

  ) ;lex-closure LET

(defun install-rule-parts (nodes rule syntactic? pred-table all-pred-table
				 neg-pred-table all-neg-pred-table )
  (mapc-1
   #'(lambda (node1 &aux (propo1 (node-propo node1)) pred1)
       (setf (node-container node1) rule)
       (cond ((not (consp propo1)) 'do-nothing) ;e.g. a var
	     ((and (setq pred1 (first propo1))
		   (eq 'NOT pred1) )
	      (setq propo1 (second propo1))
	      (unless (or (not (consp propo1))
			  (not (setq pred1 (first propo1)))
			  (consp pred1)
			  (get-pred-fn pred1 'EVAL) )
		      (unless syntactic?
			      (push-end node1
					(gethash pred1 neg-pred-table) )
			      'dummy-for-macro )
		      (push-end node1
				(gethash pred1 all-neg-pred-table) )
		      'dummy-for-macro ))
	     (t
	      (unless (or (consp pred1)
			  (get-pred-fn pred1 'EVAL) )
		      (unless syntactic?
			      (push-end node1
					(gethash pred1 pred-table) )
			      'dummy-for-macro )
		      (push-end node1
				(gethash pred1 all-pred-table) )
		      'dummy-for-macro ))))
   nodes ))

(defun compose-nodes (propo) ;returns a list* or a single node
  (if (eq 'AND (second propo))
      (cons (make-node :propo (first propo))
	    (compose-nodes (third propo)) )
    (make-node :propo propo) ))

(defun copy-rule-1 (rule &aux new-rule (var-alist nil) node2)
  (setq new-rule
	(make-rule
	 :id (rule-id rule)
	 :antes   (mapcar-1 #'(lambda (node1)
				(multiple-value-setq
				 (node2 var-alist)

				 (copy-node-1 node1 var-alist) )
				node2 )
			    (rule-antes rule) )
	 :conseqs (mapcar-1 #'(lambda (node1)
				(multiple-value-setq
				 (node2 var-alist)

				 (copy-node-1 node1 var-alist) )
				node2 )
			    (rule-conseqs rule) )))
  (mapc-1
   #'(lambda (antec) (setf (node-container antec) new-rule))
   (rule-antes new-rule) )
  (mapc-1
   #'(lambda (conseq) (setf (node-container conseq) new-rule))
   (rule-conseqs new-rule) )
  new-rule )

(defun copy-node-1 (node1 &optional (var-alist1 nil))
  ;; instance-of, instances, and contradicts ptrs are not copied over
  (multiple-value-bind
   (propo1 var-alist2)

   (standardize-vars (node-propo node1) var-alist1)
   (values (make-node :propo propo1)
	   var-alist2 )))
