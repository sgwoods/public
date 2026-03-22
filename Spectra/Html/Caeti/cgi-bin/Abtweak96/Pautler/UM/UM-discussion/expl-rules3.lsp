;; Explanation-Rules based on Cost-Benefit Analysis
;;  with differing evaluations for X as a pre- or post-condition

(((action_by_has-suitability_for_ ?A1 ?Person ?N1 ?G) AND
  ((action_by_has-suitability_for_ ?A2 ?Person ?N2 ?G) AND
   (< ?N2 ?N1) ))
 -> (_doing_is-better-action-than_for_ ?Person ?A1 ?A2 ?G) )

(((action_by_has-suitability_for_ ?A ?Person ?N1 ?G) AND
  (not-exists_such-that_ ;satis'd by proc-attachment which uses CWA
   (action_by_has-suitability_for_ ?A2 ?Person ?N2 ?G)
   (< ?N2 ?N1) ))
 -> (_doing_is-best-action-for_ ?Person ?A ?G) )

(((_has-influence_ Result ?A ?E) AND ;?E is a complete list of effects
  ((_intersects_with_diff1_diff2_ ?E ?G ?I ?D1 ?foo1) AND ;proc-att or induc rules
   ((NOT (empty_ ?I)) AND
    ((_intersects_with_ ?D1 (NOT ?G) ?I2 ?D2 ?foo3) AND ;unwanted side-eff's
     ((_has-collective-desirability_for_ (_in-role_ (?I AND ?D2) Result)
					 ?N1
					 ?Person ) AND
      ((_has-collective-desirability-for_ (_in-role_ ?I2 Result) ?N2 ?Person) AND
       ((_has-influence_ Enable ?P ?A) AND ;?P is a complete list of preconds
	((_contains-unsatisfieds_ ?P ?P2) AND ;satis'd by p-a (poss w/ i-r)
	 (_has-collective-desirability_for_ (_in-role_ ?P2 Enable)
					    ?N3
					    ?Person )))))))))
 -> (action_by_has-suitability_for_ ?A ?Person (+ ?N1 ?N2 ?N3) ?G) )


;; the default values for the desirability of ?I2, the unwanted side effects,
;;  may be positive in the general case, and there's no way here to change
;;  that assessment due to the fact that these side effects conflict with ?G 


(_has-desirability_for_ (_in-role NIL ?result-or-enable) 0 ?Everyone)
;; This rule is intended for acts with no preconds.
;; Assume all preconds have N < 0 desirability.

((_has-desirability_for_ (_in-role_ (NOT ?E) ?R) ?N ?Person)
 -> (_has-desirability_for_ (_in-role_ ?E ?R) (- ?N) ?Person) )

((_has-desirability_for_ (_in-role_ ?E ?R) ?N ?Person)
 -> (_has-collective-desirability_for_ (_in-role_ ?E ?R) ?N ?Person) )

(((_has-desirability_for_ (_in-role_ ?E1 ?R) ?N1 ?Person) AND
  (_has-collective-desirability_for_ (_in-role_ ?E2 ?R) ?N2 ?Person) )
 -> (_has-collective-desirability_for_
     (_in-role_ (?E1 AND ?E2) ?R)
     (+ ?N2 ?N1)
     ?Person ))

;; Note that G is not given any special desirability because it is the goal;
;;  the only purpose of providing G is to lend a focus to the search for acts.

;; The user supplies the Influence and Has-desirability facts.  (Also, if
;;  an action has no preconds, the user would have to tell us that the
;;  act had 'NIL' preconds.)

;; All 'Prevent' influences would now be represented as Result-NOTs.

;; If 'E' has desirability 'N' as a Result, it might have desirability
;;  '-N' as an Enable, but I'm not sure of that.

;; Explaining why a User thinks a plan is best or better is complicated
;;  here by the fact that we can't break a suitability number into
;;  a sum of desirability values (e.g. 4 => 1 + 2 + 1).  Perhaps this is
;;  fatal to this approach.  On the other hand, I suspect that the real
;;  task of User Modelling is to readjust the *weights* that a User is
;;  believed to ascribe to different goals and beliefs.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Application of rules to Alex's old dialog

;; (1-1) User: What's the best way to remove a file?

;; (I assume the user's current directory is the dir of the file to be removed)
;; Assume ?file1 is a single file and not a set of files, which might make
;;  "rm -r" or "rm -ir" a better choice.

((user-query-for_bindings-of_in_
  1 ;<up to number>/All
  ?A1
  (_doing_is-best-action-for_ User ?A1 (file_removed-from_ ?file1 ?dir1)) ) AND
  (_has-desirability_for_ (_in-role_ (file_removed-from_ ?file ?dir) Result)
			  4 ;bad in general, but the goal in this case
			  User ))

;; (1-2) Advisor: Use "rm -i filename".  It asks for confirmation
;;  before removing the file.

;; 1st option for removing a file:

(_has-influence_ Result
		 (rm-i_from_ ?file ?dir)
		 ((file_removed-from_ ?file ?dir) AND
		  (user-queried-before_
		   (file_removed-from_ ?file ?dir) )))
;; Is this a valid effects list, or should we actually be looking at the
;;  internals of the rm-i plan?

(_has-desirability_for_ (_in-role_ (user-queried-before_ 
				    (file_removed-from_ ?file ?dir) )
				   Result )
			3 ;good in general
			?person )
;; The work involved in typing responses for this should be folded in with
;;  the evaluation of other typing work somehow.

(_has-influence_ Enable
		 ((_has_permission-for_ User Write ?dir) AND
		  (_types_ User (avg-num-of-symbols 11)) ) ;6 + approx5:filenm
		 (rm-i_from_ ?file ?dir) )
(_has_permission-for_ User Write Slash-tmp)
;;The above is an assumption.  If the user indicates that it is not true, it
;; may be impossible for him to achieve (but if he is su, it's easy and thus
;; not undesirable)

(_has-desirability_for_ (_in-role_ (_types_ ?Person (avg-num-of-symbols ?num))
				   Enable )
			(/ (- ?num) 5) ;div is attempt to norm diffclty w/other acts
			?Person )

;; 2nd (and last) option for removing a file:

(_has-influence_ Result
		 (mv_from_to-dir_ ?file ?dir1 ?dir2)
		 ((file_removed-from_ ?file ?dir1) AND
		  (file_is-in_ ?file ?dir2) ))
;; reuse desirability of removing a file
(_has-desirability_for_ (_in-role_ (file_is-in_ ?file ?dir) Result)
			0 ;no reason for joy or sorrow!
			?Person )
(_has-influence_ Enable
		 ((_has_permission-for_ User Write ?dir) AND
		  (_types_ User (avg-num-of-symbols 13)) ) ;8 + approx5:filenm
		 (mv_from_to-dir_ ?file ?dir Slash-tmp) )
;; reuse rule for desirability of typing



;; (1-3) User: But I don't want to answer questions.

   ;; How much should we decrease the desirability value for the queries??



;; (1-4) Advisor: As an alternative, use "mv filename /tmp".  It
;;  allows you to recover the removed file.

;;    (DP: What about the fact that both "rm" and "mv" can prompt with
;;     permission info if the destination file is write-protected?
;;     Why not use "mv -f filename /tmp"?)

;; (1-5) User: But I don't want to fill up "/tmp".

;; (1-6) Advisor: Using "mv filename /tmp" won't fill up "/tmp".
;;  There's a program which cleans up "/tmp".



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;er-1
(((_has-influence_ Result ?A ?E) AND
  (_has-desirability_ (_in-role_ ?E Result) ?N) )
 -> (_has-desirability_ ?A ?N) )                          ;is this right?

;; rules used by Alex's old example

;;er-4
(((_has-influence_ Result ?E ?E2) AND
  (desirable_ (NOT ?E2)) )
 -> (desirable_ (NOT ?E)) )

;;er-8
(((_has-influence_ Result ?P ?G) AND
  ((_has-influence_ Result ?P ?E) AND
   ((desirable_ ?E) AND
    (not-exists_such-that_ ?P2
			   ((_has-influence_ Result ?P2 ?G) AND
			    (_has-influence_ Result ?P2 ?E) )))))
 -> (_is-best-plan-for_ ?P ?G) )

;;er-15
(((_has-influence_ Result ?P ?G) AND
  ((NOT (_has-influence_ Result ?P ?E)) AND
   ((desirable_ (NOT ?E)) AND
    ((_has-influence_ ?P2 ?G) AND
     (_has-influence_ ?P2 ?E) ))))
 -> (_is-better-plan-than_for_ ?P ?P2 ?G) )

;;er-22
(((NOT (_has-influence_ Result ?E (NOT ?E2))) AND
  (_has-influence_ Result ?E2 (NOT ?E3)) )
 -> (NOT (_has-influence_ Result ?E ?E3)) )
