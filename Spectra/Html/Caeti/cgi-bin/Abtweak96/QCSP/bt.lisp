;; bt.lisp

;;;
;;;  Generic backtracking algorithm (non-recursive)
;;;
;;;

(defstruct (bt-state (:type vector) :named)
  "An intermediate state of a backtracking process.
   Users are not required to have knowledge about this data structure.
   See MAKE-INITIAL-BT-STATE for more information."

    node-id             ; unique node identifier
    prev-node-id        ; parent node identifier - if applicable
    partial-solution    ; list of variable-value pairs
    symbol              ; symbol to be instantiated next
    value               ; current symbol value
    domain              ; candidates for instantiation of current symbol
    variables-left      ; list of variables not tried yet
    arc-cost            ; cost of work spent making this node arc-consistent
                        ;  or partially arc-consistent, 0 means none.
                        ; this is NOT cumulative for ancestors.
    depth               ; current node depth in search tree 
    max-fail-level      ; maximum constraint level any of this node's children
                        ; have failed on their attempts to generate children.
                        ; If we backtrack TO THIS node (BJ on), we will  
                        ; want to BT all the way up to the max-fail-level 
                        ; instead.
    parent-state)       ; parent backtracking state


(defun make-initial-bt-state (variables-list)
  "Contructor of initial state of a backtracking process.
   Input: An a-list of 'variables'.  Each entry has its car the name of a
          variable and its cdr a list of domain value for that variable.
   Output: A bt-state for initiating the backtracking process.
   MPR VERSION"
  (when variables-list
        (make-bt-state  
	 :node-id            'Root
	 :prev-node-id       nil
	 :partial-solution   nil
	 :symbol             nil
	 :value              nil
	 :domain             nil
	 :variables-left     variables-list
	 :arc-cost           0
	 :depth              0
	 :max-fail-level     0
	 :parent-state       nil )))

(defun backtracking (current-state consistent-p
				   &key (forward-checking       t)
				   (dynamic-rearrangement  t)
				   (dfa-rearrangement    nil)
				   (one-solution-only      t)
				   (backjump             nil)
				   (arc-c                nil)
				   (sch-c                nil) )
  "Generic backtracking routine.
   Input: CURRENT-STATE is an internal state of a backtracking process 
          from which the backtracking is to start.  To initiate a new
          backtracking process, use MAKE-INITIAL-BT-STATE to create the 
          initial state.   CONSISTENT-P is a function as specified in
          the documentation of CONSISTENT-P.
   Output: Two values are returned.  The first is the list of solution
           found.  The list will contain only one solution if keyword
           :ONE-SOLUTION-ONLY is true, otherwise, it will contain all the
           solution found by the backtracking process starting in the 
           given state.  A solution is structured as a list of variable-
           value pairs (a list of 2 elements).  The first element of the
           pair is a variable symbol, and the second is the value instantiated
           to the variable.  The second returned value is the next state
           of the backtracking process.  It can be passed back to the 
           function to resume backtracking so that more solution can be
           collected.  If the second returned value is NIL then the 
           backtracking process terminates.
   Keyword: :FORWARD-CHECKING and :DYNAMIC-REARRANGEMENT indicate if the
            backtracking process will applies forward-checking and dynamic-
            rearrangement to speed up the search.  :ONE-SOLUTION-ONLY specifies
            if only one solution needed.  All flags are default to be true."
  (let (prev-node-id
	node-id
	partial-solution
	symbol
	value
	domain
	variables-left
	arc-cost
	depth
	max-fail-level
	parent-state
	(solution-set nil)
	sp-all
	sp-fail-level
	s-p
	#|;; establish value from data-flow analysis when/if applicable
	(consumer-type-list
	 (and dfa-rearrangement ;Steve says that Caeti will never use this :DP
	      (generate-two-level-consumer-type-list *current-template*) ))|#
	) ;let

    (setq *internal-start-time* (get-internal-run-time))

    ;; EXIT CONDITION if null
    (unless current-state
	    (setq *internal-end-time* (get-internal-run-time))
	    (show-solution :solution-set  solution-set 
			   :exit-location 'null-current-state)
	    (return-from backtracking 'error) )

    ;; ------------------------------
    ;; Set up initial variables for this visit position in search space
    ;;  assume
    ;;    1) Variable list is either sorted or random, such that the
    ;;       the desired selection is first in the variable list
    ;;    2) Variable domain list is either sorted or random, such that
    ;;       the desired next instantiation is first in the domain list

    (setq node-id          (bt-state-node-id          current-state)
	  prev-node-id     (bt-state-prev-node-id     current-state)
	  partial-solution (bt-state-partial-solution current-state)
	  ;; get symbol from front of list
	  symbol           (get-first-symbol
			    (bt-state-variables-left  current-state) )
	  ;; not selected yet
	  value            (bt-state-value            current-state)
	  ;; get symbol domain from first variable alist item
	  domain           (rest (first
				  (bt-state-variables-left current-state) ))
	  ;; all but front one
	  variables-left   (rest (bt-state-variables-left current-state))
	  arc-cost         (bt-state-arc-cost         current-state)
	  depth            (1+  (bt-state-depth       current-state))
	  max-fail-level   (bt-state-max-fail-level   current-state)
	  parent-state     (bt-state-parent-state     current-state) )

    ;; ------------------------------
    ;; start search
    (when *debug*
	  (show-state :node-id          node-id
		      :prev-node-id     prev-node-id
		      :partial-solution partial-solution
		      :symbol           symbol
		      :value            value
		      :domain           domain
		      :variables-left   variables-left
		      :arc-cost         arc-cost
		      :depth            depth
		      :max-fail-level   max-fail-level
		      :parent-state     nil
		      :where            '"Initial Selection"
		      )
	  (setq *initial-state* current-state) )

    (loop

     ;; check CPU limit bound, exit if exceeded
     (when (> (- (get-internal-run-time) *internal-advance-start-time*)
	      (* *cpu-sec-limit* internal-time-units-per-second) )
	   (comment1 "Time limit bound exceeded" *cpu-sec-limit*)
	   (setq *internal-end-time* (get-internal-run-time))
	   (show-solution :solution-set solution-set
			  :exit-location 'time-bound-exceeded)
	   (return-from backtracking 'time-bound)
	   )

     ;; check CPU checkpoint bound, output when encountered ...
     (when (> (- (get-internal-run-time) *internal-advance-start-time*)
	      (* *this-check-point* internal-time-units-per-second) )
	   (comment1 "Checkpoint ..." *this-check-point*)
	   (setq *internal-end-time* (get-internal-run-time))
	   (show-solution :solution-set  solution-set
			  :exit-location 'CHECKPOINT )
	   (setq *this-check-point* (+ *this-check-point* 
				       *check-point-interval*))
	   )

       (if (endp domain)

	   ;; no more domain for this variable
	   (block
	    domain-exhausted
	    (when *debug* (comment1 '"Domain exhausted for" symbol))

	    ;; No where to backtrack to, exit
	    (unless parent-state
		    (when *debug*
			  (comment1 '"Done: BT Node w/o parent" node-id))
		    (setq *internal-end-time* (get-internal-run-time))
		    (show-solution 
		     :solution-set solution-set
		     :exit-location 'null-parent-state)
		    (return-from backtracking 'complete) )

	    ;; BACKJUMP ?
	    ;; If Visit node's parent has a max-fail-level of less
	    ;;  than its own depth, then we wish to backtrack
	    ;;  to the max-fail-level.  The difference between the two
	    ;;  is how many levels we wish to go up.  Note a diff of 
	    ;;  1 is only the immediate parent.  2 is his parent, etc.
	    (let* ((mfl  (bt-state-max-fail-level parent-state))
		   (diff (- depth mfl)) )
	      (if (and backjump
		       (not (= mfl -1))
		       (> diff 1) ) ; backjump several levels
		  (let ((bt-parent
			 (get-n-parent (1- diff) parent-state) ))
		    ;; backtrack num levels here.
		    (when (or *debug* *debug-consis*)
			  (comment  "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
			  (comment1 "BackJump! to level ..." mfl)
			  (comment1 "   to node  ..." bt-parent)
			  (comment1 "      id    ..."
				    (bt-state-node-id bt-parent) )
			  (comment  "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$") )
		    (incf *backjump-count*)
		    (setq node-id        (bt-state-node-id        bt-parent)
			  prev-node-id   (bt-state-prev-node-id   bt-parent)
			  partial-solution
			  (bt-state-partial-solution bt-parent)

			  symbol         (bt-state-symbol         bt-parent)
			  value          (bt-state-value          bt-parent)
			  domain         (bt-state-domain         bt-parent)
			  variables-left (bt-state-variables-left bt-parent)
			  arc-cost       (bt-state-arc-cost       bt-parent)
			  depth          (bt-state-depth          bt-parent)
			  max-fail-level (bt-state-max-fail-level bt-parent)
			  parent-state   (bt-state-parent-state   bt-parent) )
		    ) ;then clause of if (and backjump...)

		(progn ; backtrack 1 level, ie select next var to instantiate
		  (setq node-id        (bt-state-node-id        parent-state)
			prev-node-id   (bt-state-prev-node-id   parent-state)
			partial-solution
			(bt-state-partial-solution parent-state)
			symbol         (bt-state-symbol         parent-state)
			value	       (bt-state-value          parent-state)
			domain	       (bt-state-domain         parent-state)
			variables-left (bt-state-variables-left parent-state)
			arc-cost       (bt-state-arc-cost       parent-state)
			depth	       (bt-state-depth          parent-state)
			max-fail-level (bt-state-max-fail-level parent-state)
			parent-state   (bt-state-parent-state   parent-state) )
		  )))
		      
	    (when *debug*
		  (show-state :node-id          node-id
			      :prev-node-id     prev-node-id
			      :partial-solution partial-solution
			      :symbol           symbol
			      :value            value
			      :domain           domain
			      :variables-left   variables-left
			      :arc-cost         arc-cost
			      :depth            depth
			      :max-fail-level   max-fail-level
			      :parent-state     parent-state
			      :where "BACKTRACK TO THIS NODE" ))
	    ) ;; block domain-exhausted

	 ;; More domain values available for this variable
	 (block ;else clause of if (endp domain)
	  next-domain-value
		
	  ;; ------------------------------
	  ;; Essentially visiting the node without generating a
	  ;;  formal search space node.

	  (incf *nodes-visited*)
	  (setq node-id         (create-node-id)
		value           (first domain)	;; Note PERHAPS CHOOSE RANDOM ?
		domain          (rest domain)
		max-fail-level  0 )
	  (when *debug*
		(show-state :node-id          node-id
			    :prev-node-id     prev-node-id
			    :partial-solution partial-solution
			    :symbol           symbol
			    :value            value
			    :domain           domain
			    :variables-left   variables-left
			    :arc-cost         arc-cost
			    :depth            depth
			    :max-fail-level   max-fail-level
			    :parent-state     parent-state
			    :where            '"Visit"
			    )
		(comment1s ">>>>>> Node " node-id)
		(comment3 "Current: symbol, value, partial"
			  symbol value partial-solution ))
		      
	  ;; Check constraint(s) for this assignment of val to sym
	  ;;  with respect to previous assignments only
	  (setq sp-all (satisfy-p partial-solution symbol value consistent-p)
		sp-fail-level (second sp-all)
		s-p (first sp-all) )

	  ;; Adjust parent of visit node (if it exists)
	  ;; for max-fail-level as appropriate
	  (when *debug*
		(comment2 "SP results s-p, sp-fail-level" 
			  s-p sp-fail-level ))

	  (when parent-state
		(let ((old (bt-state-max-fail-level parent-state)))
		  (when (and (not (= old -1)) 
			     (> sp-fail-level old))
			(setf (bt-state-max-fail-level parent-state) 
			      sp-fail-level ))))
		
	  ;; Philip Wong to reply ... testing shows same for queens
	  ;;  (when (or forward-checking s-p)
	  (when s-p  
		(if (endp variables-left)

		    ;; No variables remaining, since this is consistent
		    ;;  this must be a solution
		    (block
		     no-variables-left

		     (when (or *debug* *debug-consis*)
			   (comment  "--------------------------")
			   (comment1 '"Solution found" node-id)
			   (comment  "--------------------------") )

		     ;; Solution is a valid successor !
		     (when parent-state
			   (decf (bt-state-max-fail-level parent-state)) )

		     (if one-solution-only
			 (progn
			   (push (cons (list symbol value)
				       partial-solution ) 
				 solution-set )
			   (show-solution 
			    :solution-set solution-set
			    :exit-location 'one-solution)
			   (return-from backtracking t)

			   ;; one solution only wanted, create solution 
			   ;;  node and return
			   ;;  (return-from
			   ;;   backtracking
			   ;;	(values
			   ;;	 (list (cons (list symbol value)
			   ;;	             partial-solution ))
			   ;;	 (make-bt-state
			   ;;	  :node-id          node-id
			   ;;	  :prev-node-id     prev-node-id
			   ;;	  :partial-solution partial-solution 
			   ;;	  :symbol           symbol
			   ;;	  :value            value
			   ;;	  :domain           domain
			   ;;	  :variables-left   variables-left
			   ;;	  :arc-cost         arc-cost
			   ;;	  :depth            depth
			   ;;	  :max-fail-level   max-fail-level
			   ;;	  :parent-state     parent-state) )) 
			   ) ;progn 

		       ;; else, multiple solutions wanted
		       (push (append partial-solution
				     (list (list symbol value)) )
			     solution-set ))
		     ) ;end block no-variables-left

		  ;; Variables remain, need to recall this consistent
		  ;;   node for later backtracking k...
		  (block instantiate-next-variable

			 (incf *backtrack-nodes-created*)

			 ;; Adjust parent of visit node before we generate
			 ;;  BT child to show that other visit nodes with
			 ;;  this parent are no longer candidates for 
			 ;;  Backjumping.
			 (when parent-state
			       (decf (bt-state-max-fail-level parent-state)) )
			 (setq parent-state
			       (make-bt-state
				:node-id          node-id
				:prev-node-id     prev-node-id
				:partial-solution partial-solution
				:symbol           symbol
				:value            value
				:domain           domain
				:variables-left   variables-left
				:arc-cost         arc-cost
				:depth            depth
				:max-fail-level   max-fail-level
				:parent-state     parent-state ))

			 (when (or *debug* *debug-consis*)
			       (comment  "-------------------")
			       (comment1 "> BACKTRACK POINT <" node-id)
			       (comment  "-------------------") )

			 ;; Remember prev-node-id
			 (setq prev-node-id node-id)

			 ;; ------------------------------
			 ;; Maintain work done so far in current node
			 ;;  most recent at head.
			 (setq partial-solution
			       (append partial-solution
				       (list (list symbol value)) ))

			 ;; ------------------------------
			 ;; Optionally, apply spatial consistency propagation
			 ;;  here to reduce domain size for this constraint
			 ;;  alone.
			 (when sch-c
			       (setq variables-left 
				     (spatial-consis symbol value 
						     variables-left )))

			 ;; ------------------------------
			 ;; Optionally, check arc-consistency to some
			 ;;  extent at this backtrack node before
			 ;;  continuing further... the key here is
			 ;;  to spend less work in later search by spending
			 ;;  time here reducing domain sizes, possibly
			 ;;  even emptying a domain.
			 (when arc-c
			       (let* ((cost-before *constraint-cks*)
				      (old         variables-left)
				      (merged
				       (append partial-solution variables-left))
				      (ps-length (length partial-solution))
				      (reduced-set
				       (ac-3 merged #'arc-p
					     #'consistent-p partial-solution ))
				      cost-after )
				 (setq variables-left
				       (nthcdr ps-length reduced-set)
				       cost-after *constraint-cks*
				       arc-cost (- cost-after cost-before) )
				 (when (and *debug*
					    (not (equal old variables-left)) )
				       (comment2 "Arc-c was,is"
						 old variables-left ))
				 (when (and *debug-csp*
					    (not (equal old variables-left)) )
				       (show-state
					:node-id          node-id
					:prev-node-id     prev-node-id
					:partial-solution partial-solution
					:symbol           symbol
					:value            value
					:domain           domain
					:variables-left   variables-left
					:arc-cost         arc-cost
					:depth            depth
					:max-fail-level   max-fail-level
					:parent-state     parent-state
					:where            "CSP" )
				       (comment1 "Var was" old ) )))

			 ;; ------------------------------
			 ;; Simplify domains remaining by removing future
			 ;;  variables values that are inconsistent with
			 ;;  the just selected value

			 ;; FORWARD-CHECKING adjustment
			 (when forward-checking
			       (when *debug*
				     (comment1 "FC varleft input"
					       variables-left ))
			       (setq variables-left
				     (forward-checking
				      symbol
				      value
				      consistent-p
				      variables-left
				      partial-solution     ;; added for mpr
				      ))
			       (when *debug*
				     (comment1 "FC varleft out"
					       variables-left ))
			       ) ;-- end when forward-checking

			 ;; DYNAMIC REARRANGEMENT sort
			 (when dynamic-rearrangement
			       (when *debug*
				     (comment1 "DR varleft input"
					       variables-left ))
			       (setq variables-left
				     (dynamic-rearrangement variables-left) )
			       (when *debug*
				     (comment1 "DR varleft out"
					       variables-left ))
			       ) ;-- end when

			 ;; DFA REARRANGEMENT sort (no forward checking used)
			 ;;  note uses DFA to instantiate domains dynamically
			 (let ((dfa-result nil))
			   (if dfa-rearrangement
			       (progn
				 (when *debug*
				       (comment1 "DFA-R varleft in "
						 variables-left ))
				 (setq dfa-result
				       (dfa-rearrangement partial-solution) )

				 ;; Sel the next symbol/var to instantiate &
				 ;; Get dom directly from DFA analy for var  
				 (setq symbol (first  dfa-result)
				       domain (second dfa-result)
				       variables-left
				       (remove-var symbol variables-left) )
				 (when *debug*
				       (comment1 "DFA-R varleft out"
						 variables-left )
				       (comment2 "DFA-R Next Symbol, domain"
						 symbol domain ))
				 (incf depth)
				 ) ; then clause / prog dfa-rearr

			     (progn ;else clause
			       ;; ------------------------------ 
			       ;; Sel the next symbol/variable to instantiate
			       (setq symbol (get-first-symbol variables-left))
			       ;; Get domain from chosen variable domain
			       (setq domain (cdar variables-left))
			       (when *debug*
				     (comment2 "Next Symbol, domain"
					       symbol domain ))
			       (incf depth)
			       ;; ------------------------------ 
			       ;; Remv selected var from remaining varlist
			       (setq variables-left (rest variables-left))
			       )) ;if
			   ) ; let

			 ) ;; block inst-nxt-var
		  ) ;; if endp var-left
		) ;; when s-p
	  ) ;; block nxt dom val

	 ) ;; endp domain
       ) ;; loop 
    ) ;; let
  ) ;; defun 


(defun get-n-parent (n parent)
  "Get the nth ancestor of parent.  Used for multiple level backtracking when
   backjump flag is in use."

  (if parent
      (if (= n 1)
	  (bt-state-parent-state parent)
	(get-n-parent (1- n) (bt-state-parent-state parent)) )
    (progn
      (comment "Error in get-n-parent (n)" n)
      nil )))

;; ------------------------------
;; Check a potential assignment against partial solution

(defun satisfy-p (partial-solution symbol value consistent-p)
  "Verify that this symbol and value instantiation is consistent 
   with the partial solution so far.  The partial solution is passed
   with the first bindings being the TOP of the search tree, so 
   it will fail on the highest possible bindings first.  We can take
   advantage of this via backjumping.  Satisfy will return a list
   either (t   0) indicating a satisfy is true, or (nil L) where L is
   the level of failure of the variable .. ie which variable position in
   the list is the failure."

  (incf *satisfy-p-calls*)
  (when *debug-consis*
	(comment3 "Satisfy-p <symbol, value, partial>"
		  symbol value partial-solution ))

  (dolist (instantiated-var partial-solution t)
	  (incf *satisfy-p-cost*)
    
	  ;; Note that a 3-ary failure must only show a satisfy fail for the
	  ;; MAX of the other two  variables found to be involved, and in
	  ;; general an n-ary constraint application must only result in a
	  ;; level returned as the MAX of the other n-1 variables found to be
	  ;; involved.  Note also that any n-ary constraint only partially
	  ;; bound ALWAYS  returns success,  never failure.

	  (when *debug-consis*
		(comment1 "    inst-var-ck call" instantiated-var) )
	  (let* ((result (funcall consistent-p 
				  symbol 
				  value 
				  (first instantiated-var) 
				  (second instantiated-var)
				  partial-solution ))
		 (ck-val    (first  result))
		 (ck-level  (second result)) )

	    (unless ck-val
		    (return-from satisfy-p (list nil ck-level)) )
	    )) ;dolist
    
  ;; sym, val succeeds with partial solution.
  (list 't 0) )


(defun get-first-symbol (variables-left)
  "Select symbol from head of variables left list."
  (first (first variables-left)) )
	   
;; ------------------------------
;;
(defun forward-checking (symbol value consistent-p var-list 
				partial-solution)
  "Heuristic FC
   At a node, given the current selection of instantiation value for
   the current symbol, remove any domain values in the other
   still to be instantiated variables that are inconsistent with 
   this node's assignment."

  (incf *for-check-calls*)
  (let* ((variable-list (reverse var-list))  ;; reverse so we dont affect order
	 (new-variable-list nil)             ;; result of look ahead
	 (proceed-p         t)
	 var-symbol
	 var-domain )

    ;; look ahead to see if this symbol and value would be consistent
    ;;  with other variables to instantiate yet and their domain values,
    ;;  if not, delete that domain value.
    (dolist (variable variable-list (values new-variable-list proceed-p))

	    (setq var-symbol (first variable)     ;; get first symbol
		  var-domain nil )                ;; init domain nil

	    ;; for each of the domain values for this symbol
	    ;;  lets check if it is consistent with given symbol and value
	    (dolist (domain-value (rest variable))
		    (incf *for-check-cost*)

		    ;; Check consistency
		    (let* ((result
			    (funcall consistent-p
				     var-symbol 
				     domain-value
				     symbol
				     value  ;;v  added partial solution for mpr
				     partial-solution ))
			   (ck-val   (first result))
			   ;(ck-level (second result)) ;never used :DP
			   )
		      (when ck-val
			    (setq var-domain
				  (append var-domain (list domain-value)) )))
		    ) ;dolist

	    ;; This line replaced.. it used to reverse the order while parsing
	    ;; Steve Woods March 93 
	    ;;	  (setq var-domain (cons domain-value var-domain))

	    (push (cons var-symbol var-domain) new-variable-list)
	    (setq proceed-p (and proceed-p var-domain)) )))
#|
;; ---------------------------------------------------------------------------
;; Heuristic DFA-R ... Data-Flow-Analysis-Based Rearrangement
;;
;; April 28, 1997 - new heuristic to exploit DFA during search,
;;   in particular as a method of domain replacement from DFA branching
;;
;; Choose the new variable as the uninstantiated variable of type T so-far
;;  which is connected to one of the existing  instantiated variables
;;  and which has the smallest domain size where domain size is calculatd
;;  by the data-flow-analysis leading out of a particular instantiated 
;;  variable and domain value.  
;;
;; Assumptions:
;; 1 Connectivity is determined only interms of p-d-d and g-d-d and c-d-d
;;    as per Yongjun's data-flow analysis structure
;; 2 It is assumed that the template graph is fully connected in terms of these
;;   arc types
;; 3 The get-next-var-and-domain function call returns the next variable and
;;   domain value set for use during search
;;
(defun dfa-rearrangement ( partial-solution )
  (incf *dfa-rearr-calls*)
  (incf *dyn-rearr-cost*)

  (get-next-variable-to-instantiate partial-solution
				    consumer-type-list ) ;global var? :DP

  ;; this function returns a list = (variable domain) to search
  )
|#
;; ---------------------------------------------------------------------------
;; Heuristic DR
;;  Make sure that of the remaining symbols yet to be instantiated such 
;; that the one with the smallest domain size is selected next, thus 
;; limiting the search branching factor.   Note this is only order (# varleft)
;; since it only bubbles the shortes to the front.
;; Since this can be easily applied at each node and need not indicate the same
;;  order for various parts of the search, it is "dynamic".    
;;  Combining FC and DR may result in the further reduction
;;  in the branching factor as FC limits domain size, and DR selects smallest.
(defun dynamic-rearrangement (var-list)
  (let ((variable-list (reverse var-list)))
    (incf *dyn-rearr-calls*)
    (unless (endp variable-list)
	    (let* ((tightest-var      (first variable-list))
		   (min-cardinality   (length tightest-var))
		   (new-variable-list nil)
		   cardinality )
	      (dolist (variable (rest variable-list) new-variable-list)
		      (setq cardinality (length (rest variable)))
		      (incf *dyn-rearr-cost*)
		      (cond ((< cardinality min-cardinality)
			     (setq new-variable-list
				   (cons tightest-var new-variable-list)
				   tightest-var variable
				   min-cardinality cardinality ))
			    (t
			     (setq new-variable-list
				   (cons variable new-variable-list) ))))

	      (setq new-variable-list
		    (cons tightest-var new-variable-list) )

	      )) ;; let/unless
    )) ;; let/defun


;; Heuristic AS Advance-sort
;; This heuristic sorts an entire list of remaining symbols into an order where
;; the symbols with the smallest domain size are listed first.  This ordering
;; is useful when DR is NOT in use, ie we pre-sort the entire domain, and
;; then use this order throughout our search.

(defun advance-sort ( var-list )
  "Sort variable list by domain size.  Smallest first."
  (sort var-list
	#'(lambda (x y)
	    (< (length (cdr x))
	       (length (cdr y)) ))))


