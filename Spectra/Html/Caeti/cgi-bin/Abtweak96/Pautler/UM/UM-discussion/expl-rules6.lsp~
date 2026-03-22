;;;;;;;;;;;; EXPLANATION RULES AND FACTS

;; (Alex's rules ran from er-1 to er-30, so we start with ER-31.)

;;ER-31:BEST-PLAN-FROM-SUITABILITY-OF-ACTIONS
(((action_by_has-suitability_for_ ?A1 ?Person ?N1 ?G) AND
  ((action_by_has-suitability_for_ ?A2 ?Person ?N2 ?G) AND
   (< ?N2 ?N1) ))
 -> (_doing_is-better-action-than_for_ ?Person ?A1 ?A2 ?G) )

;;ER-32:BETTER-PLAN-FROM-SUITABILITY-OF-ACTIONS
(((action_by_has-suitability_for_ ?A ?Person ?N1 ?G) AND
  (not-exists_such-that_ ;satis'd by proc-attachment which uses CWA
   (action_by_has-suitability_for_ ?A2 ?Person ?N2 ?G)
   (< ?N2 ?N1) ))
 -> (_doing_is-best-action-for_ ?Person ?A ?G) )

;;ER-33:ACTION-SUITABILITY-FROM-COST-BENEFIT-ANALYSIS
(((_has_values-of_in_                                ;procedural-attachment(PA)
   ?E All ?e1 (_has-influence_ Result ?A ?e1) ) AND
  ((_has-non-empty-intersection-with_ ?E ?G) AND     ;PA or inductive rules(IR)
   ((_has-collective-desirability_for_ (_in-role_ ?E Result) ?N1 ?Person) AND
    ((_has_values-of_in_
      ?P All ?p1 (_has-influence_ Enable ?p1 ?A) ) AND ;PA
     ((_contains-unsatisfieds_ ?P ?P2) AND             ;PA or IR
      (_has-collective-desirability_for_ (_in-role_ ?P2 Enable)
					 ?N2
					 ?Person ))))))
 -> (action_by_has-suitability_for_ ?A ?Person (+ ?N1 ?N2) ?G) )

;; Note that ?E contains effects matching some goals, effects matching the
;;  negation of some goals, and effects desirable or undesirable by default.
;;  Effects which match or counteract goals get their desirability values
;;  from parsed/inferred user input.

;;EF1:DESIRABILITY-OF-NOTHING-IS-ZERO
(_has-desirability_for_ (_in-role NIL ?result-or-enable) 0 ?Everyone)
;; This fact is intended for acts with no preconds.
;; Assume all regular preconds have N < 0 desirability.

;;ER-34:DESIRABILITY-FROM-DESIRABILITY-OF-NEGATION
((_has-desirability_for_ (_in-role_ (NOT ?S) ?RoE) ?N ?Person)
 -> (_has-desirability_for_ (_in-role_ ?S ?RoE) (- ?N) ?Person) )

;;ER-35:COLLECTIVE-DESIRABILITY-FROM-BASE-CASE
((_has-desirability_for_ (_in-role_ ?S ?RoE) ?N ?Person)
 -> (_has-collective-desirability_for_ (_in-role_ ?S ?RoE) ?N ?Person) )

;;ER-36:COLLECTIVE-DESIRABILITY-FROM-SUM-OF-PARTS
(((_has-desirability_for_ (_in-role_ ?S1 ?RoE) ?N1 ?Person) AND
  (_has-collective-desirability_for_ (_in-role_ ?S2 ?RoE) ?N2 ?Person) )
 -> (_has-collective-desirability_for_
     (_in-role_ (?S1 AND ?S2) ?RoE)
     (+ ?N2 ?N1)
     ?Person ))

;; All 'Prevent' influences would now be represented as Result-NOTs.

;; If 'E' has desirability 'N' as a Result, it might have desirability
;;  '-N' as an Enable, but I'm not sure of that.

;; Explaining why a User thinks a plan is best or better is complicated
;;  here by the fact that we can't break a suitability number into
;;  a sum of desirability values (e.g. 4 => 1 + 2 + 1).  Perhaps this is
;;  fatal to this approach.  On the other hand, I suspect that the real
;;  task of User Modelling is to readjust the *weights* that a User is
;;  believed to ascribe to different goals and beliefs.

;; REWRITES OF ALEX'S OLD RULES

;; DP doubts that these rules accurately reflect human reasoning, because
;;  desirability may require weighing the space of all known effects,
;;  actions, and enablers, just as finding the best plan did.

;;ER-37:DESIRABILITY-OF-CAUSE-FROM-DESIRABILITY-OF-EFFECT (was er-1,3,4,6)
(((_has-desirability_for_ (_in-role_ ?effect Result) ?N ?person) AND
  (_has-influence_ Result ?cause ?effect) )
 -> (_has-desirability_for_ (_in-role_ ?cause (options Action Result))
			    ?N
			    ?person ))

;;ER-38:DESIRABILITY-OF-ENABLER-FROM-DESIRABILITY-OF-ENABLED (was er-2)
(((_has-desirability_for_ (_in-role_ ?enabled (options Action Enable))
			  ?N
			  ?person ) AND
  (_has-influence_ Enable ?enabler ?enabled) )
 -> (_has-desirability_for_ (_in-role_ ?enabler Enable) ?N ?person) )

;;ER-39:DESIRABILITY-OF-ENABLED-FROM-DESIRABILITY-OF-ENABLER (was er-5)
(((_has-desirability_for_ (_in-role_ ?enabler Enable) ?N ?person) AND
  (_has-influence_ Enable ?enabler ?enabled) )
 -> (_has-desirability_for_ (_in-role_ ?enabled (options Action Enable))
			    ?N
			    ?person ))


;;ER-56:DESIRABILITY-OF-EFFECT-FROM-DESIRABILITY-OF-EFFECT-REPETITIONS
(((_has-desirability_for_ ?effect1 ?N ?person) AND
  ((_has-influence_ Result (repetitions-of ?effect2) ?effect1) AND
   ((_has-frequency_ (repetitions-of ?effect2) Common) AND
    ((_has-influence_ Result ?situation (NOT ?effect1)) AND
     (NOT ?situation) ))))
 -> (_has-desirability_for_ ?effect2 ?N ?person) )

(_has-influence_ Result
		 (repetitions-of (file_is-in_ ?file ?dir))
		 (fill-up_ ?dir) )
;;etc


;;ER-40:TRANSITIVITY-OF-CAUSING (was er-19,27)
(((_has-influence_ Result ?cause ?effect1) AND
  (_has-influence_ Result ?effect1 ?effect2) )
 -> (_has-influence_ Result ?cause ?effect2) )

;;ER-41:FIRST-FAILED-TRANSITIVITY-OF-CAUSING (was er-20)
(((NOT (_has-influence_ Result ?cause ?effect1)) AND
  (_has-influence_ Result ?effect1 ?effect2) )
 -> (NOT (_has-influence_ Result ?cause ?effect2)) )

;;ER-42:SECOND-FAILED-TRANSITIVITY-OF-CAUSING (no previous version)
(((_has-influence_ Result ?cause ?effect1) AND
  (NOT (_has-influence_ Result ?effect1 ?effect2)) )
 -> (NOT (_has-influence_ Result ?cause ?effect2)) )

;;ER-43:DOUBLE-FAILED-TRANSITIVITY-OF-CAUSING (was er-22)
(((NOT (_has-influence_ Result ?cause ?effect1)) AND
  (NOT (_has-influence_ Result ?effect1 ?effect2)) )
 -> (NOT (_has-influence_ Result ?cause ?effect2)) )

;;ER-44:PREVENTION-IS-ALSO-FAILURE-TO-CAUSE (was er-21)
((_has-influence_ Result ?cause (NOT ?effect))
 -> (NOT (_has-influence_ Result ?cause ?effect)) )

;;ER-45:CAUSING-IS-NOT-PREVENTING (was er-29) (logically same as ER-44)
((_has-influence_ Result ?cause ?effect)
 -> (NOT (_has-influence_ Result ?cause (NOT ?effect))) )

;;ER-46:TRANSITIVE-ENABLE-FROM-UNIQUE-CAUSE-AND-ENABLE (was er-23)
(((_has-influence_ Result ?cause ?effect) AND
  ((_has-influence_ Enable ?effect ?enabled) AND
   (not-exists_such-that_
    (_has-influence_ Result ?cause2 ?effect)
    (NOT (= ?cause2 ?cause)) )))
 -> (_has-influence_ Enable ?cause ?enabled) )

;; We might be missing some plan possibilities if we never consider
;;  actions which are not *unique* causes of enablements (i.e., if
;;  actions A and B both cause C which enables D, we won't consider
;;  A or B in order to enable D.)

;;ER-47:FIRST-FAILED-TRANS-ENABLE-FROM-ENABLE-AND-CAUSE (was er-24)
(((NOT (_has-influence_ Enable ?enabler ?enabled)) AND
  (_has-influence_ Result ?enabled ?effect) )
 -> (NOT (_has-influence_ Enable ?enabler ?effect)) )

;;ER-48:SECOND-FAILED-TRANS-ENABLE-FROM-ENABLE-AND-CAUSE (no previous version)
(((_has-influence_ Enable ?enabler ?enabled) AND
  (NOT (_has-influence_ Result ?enabled ?effect)) )
 -> (NOT (_has-influence_ Enable ?enabler ?effect)) )

;;ER-49:DOUBLE-FAILED-TRANS-ENABLE-FROM-ENABLE-AND-CAUSE (no previous version)
(((NOT (_has-influence_ Enable ?enabler ?enabled)) AND
  (NOT (_has-influence_ Result ?enabled ?effect)) )
 -> (NOT (_has-influence_ Enable ?enabler ?effect)) )

;;ER-50:CAUSING-IS-NOT-ENABLING (was er-25) (This seems weird to DP)
((_has-influence_ Result ?cause ?effect)
 -> (NOT (_has-influence_ Enable ?cause ?effect)) )

;;ER-51:PREVENTING-ACTION-FROM-PREVENTING-ENABLER (was er-26)
(((_has-influence_ Result ?cause (NOT ?effect)) AND
  (_has-influence_ Enable ?effect ?enabled) )
 -> (_has-influence_ Result ?cause (NOT ?enabled)) )

;;ER-52:FIRST-FAILED-TRANSITIVITY-OF-PREVENTING (was er-28) (compare to ER-41)
(((NOT (_has-influence_ Result ?cause (NOT ?effect1))) AND
  (_has-influence_ Result ?effect1 ?effect2) )
 -> (NOT (_has-influence_ Result ?cause (NOT ?effect2))) )

;;ER-53:SECOND-FAILED-TRANSITIVITY-OF-PREVENTING (no prev) (compare to ER-42)
(((_has-influence_ Result ?cause (NOT ?effect1)) AND
  (NOT (_has-influence_ Result ?effect1 ?effect2)) )
 -> (NOT (_has-influence_ Result ?cause (NOT ?effect2))) )

;;ER-54:DOUBLE-FAILED-TRANSITIVITY-OF-PREVENTING (no prev) (compare to ER-43)
(((NOT (_has-influence_ Result ?cause (NOT ?effect1))) AND
  (NOT (_has-influence_ Result ?effect1 ?effect2)) )
 -> (NOT (_has-influence_ Result ?cause (NOT ?effect2))) )

;;ER-55:ENABLING-IS-NOT-PREVENTING
((_has-influence_ Enable ?enabler ?enabled)
 -> (NOT (_has-influence_ Result ?enabler (NOT ?enabled))) )

#| DP is not sure these are needed or that they make sense.
;;ER-56:TRANSITIVITY-OF-ENABLING (no previous version)
(((_has-influence_ Enable ?enabler ?enabled1) AND
  (_has-influence_ Enable ?enabled1 ?enabled2) )
 -> (_has-influence_ Enable ?enabler ?enabled2) )

;;ER-57:FIRST-FAILED-TRANSITIVITY-OF-ENABLING (no previous version)
((NOT (_has-influence_ Enable ?enabler ?enabled1)) AND
  (_has-influence_ Enable ?enabled1 ?enabled2) )
 -> (NOT (_has-influence_ Enable ?enabler ?enabled2)) )

;;ER-58:SECOND-FAILED-TRANSITIVITY-OF-ENABLING (no previous version)
(((_has-influence_ Enable ?enabler ?enabled1) AND
  (NOT (_has-influence_ Enable ?enabled1 ?enabled2)) )
 -> (NOT (_has-influence_ Enable ?enabler ?enabled2)) )

;;ER-59:DOUBLE-FAILED-TRANSITIVITY-OF-ENABLING (no previous version)
(((NOT (_has-influence_ Enable ?enabler ?enabled1)) AND
  (NOT (_has-influence_ Enable ?enabled1 ?enabled2)) )
 -> (NOT (_has-influence_ Enable ?enabler ?enabled2)) )
|#

;;;;;;;;;;;; DOMAIN FACTS

;;DF-1
(_has-influence_ Result (rm-i_from_ ?file ?dir) (file_removed-from_ ?file ?dir))
;;DF-2
(_has-influence_ Result
		 (rm-i_from_ ?file ?dir)
		 (user-queried-before_
		  (file_removed-from_ ?file ?dir) ))
;;DF-3
(_has-influence_ Result
		 (mv_from_to-dir_ ?file ?dir1 ?dir2)
		 (file_removed-from_ ?file ?dir1) )
;;DF-4
(_has-influence_ Result
		 (mv_from_to-dir_ ?file ?dir1 ?dir2)
		 (file_recoverable-from_ ?file ?dir2) ) ;was file_is-in_
;;DF-5
(_has-desirability_for_ (_in-role_ (user-queried-before_ 
				    (file_removed-from_ ?file ?dir) )
				   Result )
			3 ;good in general
			?everyone )
;; The work involved in typing responses for this should be folded in with
;;  the evaluation of other typing work (e.g. pathnames) somehow.

;;DF-6
(_has-desirability_for_ (_in-role_ (file_recoverable-from_ ?file ?dir) Result)
			3 ;good in general
			?everyone )
#|(_has-desirability_for_ (_in-role_ (file_is-in_ ?file ?dir) Result)
			0 ;no reason for joy or sorrow!
			?everyone )|#
;;DF-7
(_has-influence_ Enable
		 (_has_permission-for_ User Write ?dir)
		 (rm-i_from_ ?file ?dir) )
;;DF-8
(_has-influence_ Enable
		 (_types_ User (avg-num-of-symbols 11)) ;6 + approx5:filenm
		 (rm-i_from_ ?file ?dir) )
;;DF-9
(_has-influence_ Enable
		 (_has_permission-for_ User Write ?dir)
		 (mv_from_to-dir_ ?file ?dir ?dir2) )
;;DF-10
(_has-influence_ Enable
		 (_has_permission-for_ User Write ?dir2)
		 (mv_from_to-dir_ ?file ?dir ?dir2) )
;;DF-11
(_has-influence_ Enable
		 (_types_ User (avg-num-of-symbols 13)) ;8 + approx5:filenm
		 (mv_from_to-dir_ ?file ?dir Slash-tmp) )
;;DF-12
(_has-desirability_for_
 (_in-role_ (_types_ ?Person (avg-num-of-symbols ?num))
	    Enable )
 (/ (- ?num) 5) ;the division here is an attempt to norm diffclty w/other acts
 ?Person )

;;DF-13
(_has-influence_ Result
		 (user-queried-before_ ?sys-action)
		 (_required-answer-queries User) ) ;silly?

;;;;;;;;;;;; DIALOG RULES AND FACTS

;;LR-1:DESIRABILITY-OF-EFFECT-FROM-QUERY-FOR-BEST-PLAN
((user-query-for_bindings-of_in_
  ?foo
  ?A1
  (doing_is-best-action-for_ User ?A1 ?effect) )
 -> (_has-desirability_for_ (_in-role_ ?effect Result) 5 User) )
