;; quil2-rules.lisp

;;;;;;;;;;;; EXPLANATION RULES AND FACTS

(reset-dbs-1)

(setq *block-on-search-history-duplication?* nil)

;; Alex's rules ran from er1 to er30, so we start with ER31.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;             COST-BENEFIT BASICS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def-rule-1 ;BETTER-ACTION-FROM-SUITABILITY-OF-ACTIONS
  'er31
  '((_doing_is-better-action-than_for_ ?Person ?A1 ?A2 ?G ! ?N1 ?N2)
    <-
    ((action_by_has-suitability__for_ ?A1 ?Person ?N1 ?N2 ?G) AND
     ((action_by_has-suitability__for_ ?A2 ?Person ?N3 ?N4 ?G) AND
      (< (+ ?N3 ?N4) (+ ?N2 ?N1)) ))))

(def-rule-1 ;BEST-ACTION-FROM-SUITABILITY-OF-ACTIONS
  'er32
  ;; NOTE: ?A2 is backtrack-sensitive
  '((_doing_is-best-action-for_ ?Person ?A1 ?G ! ?N1 ?N2)
    <-
    ((action_by_has-suitability__for_ ?A1 ?Person ?N1 ?N2 ?G) AND
     (NOT ((NOT= ?A2* ?A1) AND
	   ((action_by_has-suitability__for_ ?A2 ?Person ?N3% ?N4% ?G) AND
	    (< (+ ?N2 ?N1) (+ ?N3% ?N4%)) ))))))

(def-fact ;GIVING-UP-IS-ALWAYS-AN-OPTION
  ;; This is a default, for use when ER31 or ER32 need an action but ER33
  ;; can't recommend anything.                     ;v perhaps Nbenefits<0
  '(action_by_has-suitability__for_ Give-up ?person 0 0 ?G) )

(def-rule-1 ;ACTION-SUITABILITY-FROM-COST-BENEFIT-ANALYSIS
  'er33
  ;; Note that ?E contains effects matching some goals, effects matching the
  ;;  negation of some goals, and effects desirable or undesirable by default.
  ;;  Effects which match or counteract goals get their desirability values
  ;;  from parsed/inferred user input.
  ;; Note also that ?E need only have a nonempty intersection with ?G; it
  ;;  doesn't have to be a proper subset of ?G.  So, these rules could
  ;;  recommend an action that doesn't satisfy all of the asserted goals, if
  ;;  it satisfies some and either a) no action satisfies all asserted goals,
  ;;  or b) unasserted goals sum up to more importance than asserted goals.
  '((action_by_has-suitability__for_ ?Action ?Person ?N1 ?N2 ?Goal)
    <-
    ((_has-influence_ Result ?Action (:intersect ?Effects ?Goal)) AND
     ((_has-collective-desirability_for_ (_in-role_ ?Effects Result)
					 ?N1 ?Person ) AND
      ((_has-influence_ Enable ?Preconds ?Action) AND
       ((_contains-unsatisfieds_ ?Preconds ?Unsat-Preconds) AND
	(_has-collective-desirability_for_ (_in-role_ ?Unsat-Preconds Enable)
					   ?N2
					   ?Person )))))))

(def-rule-1 ;COLLECTIVE-DESIRABILITY-FROM-SUM-OF-PARTS
  'er34
  '((_has-collective-desirability_for_
     (_in-role_ (PAIR ?S1 ?S2) ?RoE)
     (+ ?N2 ?N1)
     ?Person )
    <-
    ((_has-desirability_for_ (_in-role_ ?S1 ?RoE) ?N1 ?Person) AND
     (_has-collective-desirability_for_ (_in-role_ ?S2 ?RoE) ?N2 ?Person) )))

(def-rule-1 ;COLLECTIVE-DESIRABILITY-FROM-BASE-CASE
  'er35
  '((_has-collective-desirability_for_ (_in-role_ ?S ?RoE) ?N ?Person)
    IMPLIED-BY
    ((NOT= ?S (PAIR ?S1% ?S2%)) AND ;to force use of er34 even w/o rule ordering
     (_has-desirability_for_ (_in-role_ ?S ?RoE) ?N ?Person) )))

(def-fact ;DESIRABILITY-OF-NOTHING-IS-ZERO
  ;; This fact is intended for acts with no preconds.
  ;; Assume all regular preconds have N < 0 desirability.
  '(_has-desirability_for_ (_in-role_ NIL ?result-or-enable) 0 ?Anyone) )

(def-rule-1 ;ASCRIPTION-OF-ADVISOR-PREFERENCES-TO-OTHERS
  'er36
  '((_has-desirability_for_ ?situation ?des-val ?Anyone)
    <-
    ((NOT= ?Anyone Advisor) AND ;to prevent search loops
     (_has-desirability_for_ ?situation ?des-val Advisor) )))

(def-rule-1 ;DESIRABILITY-OF-EFFECT-FROM-DESIRABILITY-OF-EXTREME-EFFECT
  'er37
  ;; This is used to match the user input of 'user desire fill up /tmp -5'
  ;;  to 'user desires file in /tmp 0' through a contradiction (zero and
  ;;  nonzero valuations are taken to be a contradiction here).
  '(((_has-desirability_for_ (_in-role_ ?extreme-effect Result) ?N ?person) AND
     ((_has-influence_ Promote ;was Result
		       (repetitions-of ?effect) ?extreme-effect ) AND
      ((_typical (repetitions-of ?effect)) AND
       (_has-influence_ Result ;here only to provide an assump for A to counter
			(repetitions-of ?effect) ?extreme-effect )))) ;AND
       #|((_has-influence_ Result ?preventative (NOT ?extreme-effect)) AND
	(NOT ?preventative) ))))|#
    -> (_has-desirability_for_ (_in-role_ ?effect Result) ?N ?person) ))

(def-rule-1
  'er38
  '((_has-desirability_for_ (_in-role_ ?effect1 Result) ?N ?P)
    IMPLIED-BY
    ((_has-influence_ Result ?effect1 (:intersect ?all-effects ?effect2)) AND
     ((_has-desirability_for_ (_in-role_ ?effect2 Result) ?N1 ?P) AND
      ;;^ This is just a way of allowing user commts to activate this rule
      (_has-collective-desirability_for_ (_in-role_ ?all-effects Result)
					 ?N ?P) ))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;             CAUSAL KNOWLEDGE
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-rule-1 ;TRANSITIVITY-OF-CAUSING (was er-19,27)
  'er40
  '((_has-influence_ Result ?cause ?effect2)
    <-
    ((NOT= ?cause ?effect2) AND
     ((_has-influence_ Result ?cause ?effect1) AND
      (_has-influence_ Result ?effect1 ?effect2) ))))

(def-rule-1 ;FIRST-FAILED-TRANSITIVITY-OF-CAUSING (was er-20)
  'er41
  '((NOT (_has-influence_ Result ?cause ?effect2))
    <-
    ((NOT= ?cause ?effect2) AND
     ((NOT (_has-influence_ Result ?cause ?effect1)) AND
      (_has-influence_ Result ?effect1 ?effect2) ))))

(def-rule-1 ;SECOND-FAILED-TRANSITIVITY-OF-CAUSING (no previous version)
  'er42
  '((NOT (_has-influence_ Result ?cause ?effect2))
    <-
    ((NOT= ?cause ?effect2) AND
     ((_has-influence_ Result ?cause ?effect1) AND
      ((NOT= ?effect1 ?effect2) AND ;shouldn't be needed
       (NOT (_has-influence_ Result ?effect1 ?effect2)) )))))

(def-rule-1 ;PREVENTION-IS-ALSO-FAILURE-TO-CAUSE (was er-21)
  'er43
  '((NOT (_has-influence_ Result ?cause ?effect))
    IMPLIED-BY
    ((NOT= ?cause ?effect) AND
     (_has-influence_ Result ?cause (NOT ?effect)) )))

(def-rule-1 ;CAUSING-IS-NOT-PREVENTING (was er-29) (logically same as ER43)
  'er44
  '((NOT (_has-influence_ Result ?cause (NOT ?effect)))
    IMPLIED-BY
    ((NOT= ?cause ?effect) AND
     (_has-influence_ Result ?cause ?effect) )))

(def-rule-1 ;TRANSITIVE-ENABLE-FROM-UNIQUE-CAUSE-AND-ENABLE (was er-23)
  'er45
  ;; This rule is a step toward modelling enablements more fully, but we might
  ;;  be missing some plan possibilities if we never consider
  ;;  actions which are not *unique* causes of enablements (i.e., if
  ;;  actions A and B both cause C which enables D, we won't consider
  ;;  A or B in order to enable D.)
  '((_has-influence_ Enable ?cause ?enabled)
    <-
    ((NOT= ?cause ?enabled) AND
     ((_has-influence_ Result ?cause ?effect) AND
      ((_has-influence_ Enable ?effect ?enabled) AND
       (NOT ((NOT= ?cause2 ?cause) AND
	     (_has-influence_ Result ?cause2 ?effect) )))))))

(def-rule-1 ;FIRST-FAILED-TRANS-ENABLE-FROM-ENABLE-AND-CAUSE (was er-24)
  'er46
  '((NOT (_has-influence_ Enable ?enabler ?effect))
    <-
    ((NOT= ?enabler ?effect) AND
     ((NOT (_has-influence_ Enable ?enabler ?enabled)) AND
      (_has-influence_ Result ?enabled ?effect) ))))

(def-rule-1 ;SECOND-FAILED-TRANS-ENABLE-FROM-ENABLE-AND-CAUSE (no prev version)
  'er47
  '((NOT (_has-influence_ Enable ?enabler ?effect))
    <-
    ((NOT= ?enabler ?effect) AND
     ((_has-influence_ Enable ?enabler ?enabled) AND
      ((NOT= ?enabled ?effect) AND ;shouldn't be needed
       (NOT (_has-influence_ Result ?enabled ?effect)) )))))

(def-rule-1 ;CAUSING-IS-NOT-ENABLING (was er-25) (This seems weird to DP)
  'er48
  '((NOT (_has-influence_ Enable ?cause ?effect))
    IMPLIED-BY
    ((NOT= ?cause ?effect) AND
     (_has-influence_ Result ?cause ?effect) )))

(def-rule-1 ;a weird prevention rule (was er-22); I'm not sure this is true
  'er49
  '((NOT (_has-influence_ Result ?cause ?effect2))
    <-
    ((NOT= ?cause ?effect2) AND
     ((NOT (_has-influence_ Result ?cause (NOT ?effect1))) AND
      (_has-influence_ Result ?effect1 (NOT ?effect2)) ))))

(def-rule-1 ;PREVENTING-ACTION-FROM-PREVENTING-ENABLER (was er-26)
  'er50
  '((_has-influence_ Result ?cause (NOT ?enabled))
    <-
    ((NOT= ?cause (NOT ?enabled)) AND
     ((_has-influence_ Result ?cause (NOT ?effect)) AND
      (_has-influence_ Enable ?effect ?enabled) ))))

(def-rule-1 ;FIRST-FAILED-TRANSITIVITY-OF-PREVENTING (was er-28) (comp to ER41)
  'er51
  '((NOT (_has-influence_ Result ?cause (NOT ?effect2)))
    <-
    ((NOT= ?cause (NOT ?effect2)) AND
     ((NOT (_has-influence_ Result ?cause (NOT ?effect1))) AND
      (_has-influence_ Result ?effect1 ?effect2) ))))

(def-rule-1 ;SECOND-FAILED-TRANSITIVITY-OF-PREVENTING (no prev) (comp to ER42)
  'er52
  '((NOT (_has-influence_ Result ?cause (NOT ?effect2)))
    <-
    ((NOT= ?cause (NOT ?effect2)) AND
     ((_has-influence_ Result ?cause (NOT ?effect1)) AND
      ((NOT= ?effect1 ?effect2) AND ;shouldn't be needed
       (NOT (_has-influence_ Result ?effect1 ?effect2)) )))))

(def-rule-1 ;ENABLING-IS-NOT-PREVENTING
  'er53
  '((NOT (_has-influence_ Result ?enabler (NOT ?enabled)))
    IMPLIED-BY
    ((NOT= ?enabler (NOT ?enabled)) AND
     (_has-influence_ Enable ?enabler ?enabled) )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;             FACT BASE
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-fact '(_has_permission-for_ ?person Write (home-dir-of ?person)))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (_types-about_chars-for_ ?person ?N ?action) Enable)
    (/ (- ?N) 5)
    ?person )) ;can't be 'Advisor' due to nested mention in this rule

;; RM
(def-fact
  '(_has-influence_ Result
		    (rm_from_ ?file% ?dir%)
		    (file_removed-from_ ?file% ?dir%) ))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (file_removed-from_ ?file% ?dir%) Result)
    8 Advisor )) ;should be -8 normally
(def-fact
  '(_has-influence_ Enable
		    (PAIR
		     (_has_permission-for_ User Write ?dir%)
		     (_types-about_chars-for_ User 8 (rm_from_ ?file% ?dir%)) )
		    (rm_from_ ?file% ?dir%) ))

;; RM -I
(def-fact
  '(_has-influence_ Result
		    (rm-i_from_ ?file% ?dir%)
		    (PAIR
		     (file_removed-from_ ?file% ?dir%)
		     (user-queried-before_ (file_removed-from_ ?file% ?dir%)) )))
(def-fact ;should be derived from desire to avoid accidental removal !!!!!!!!!!
  '(_has-desirability_for_
    (_in-role_ (user-queried-before_ (file_removed-from_ ?file% ?dir%)) Result)
    5 Advisor ))
#|
(def-fact
  '(_has-influence_ Result
		    (user-queried-before_ (file_removed-from_ ?file% ?dir%))
		    (PAIR
		     (_required-to-answer-query User)
		     (file_recoverable-until_ ?file% Affirm-remove-query) )))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (_required-to-answer-query User) Result)
    -2 Advisor ))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (file_recoverable-until_ ?file% Affirm-remove-query) Result)
    7 Advisor ))
|#
(def-fact
  '(_has-influence_ Enable
		    (PAIR
		     (_has_permission-for_ User Write ?dir%)
		     (_types-about_chars-for_ User 11 (rm-i_from_ ?file% ?dir%)))
		    (rm-i_from_ ?file% ?dir%) ))

;; MV TO /TMP
(def-fact
  '(_has-influence_ Result
		    (mv_from_to-dir_ ?file% ?dir% Slash-tmp)
		    (PAIR
		     (file_removed-from_ ?file% ?dir%)
		     (file_is-in_ ?file% Slash-tmp) )))
(def-fact ;should be derived from desire to avoid accidental removal !!!!!!!!!!
  '(_has-desirability_for_
    (_in-role_ (file_is-in_ ?file% Slash-tmp) Result)
    3 Advisor )) ;not as good as query because mv takes up space for awhile
(def-fact
  '(_has-influence_ Enable
		    (_types-about_chars-for_
		     User 12
		     (mv_from_to-dir_ ?file% ?dir% Slash-tmp) )
		    (mv_from_to-dir_ ?file% ?dir% Slash-tmp) ))

;; MV TO FLOPPY
(def-fact
  '(_has-influence_ Result
		    (mv_from_to-dir_ ?file% ?dir% (root-of (floppy-for ?file%)))
		    (PAIR
		     (file_removed-from_ ?file% ?dir%)
		     (file_is-in_ (root-of (floppy-for ?file%))) )))
(def-fact ;should be derived from desire to avoid accidental removal
  '(_has-desirability_for_
    (_in-role_ (file_is-in_ (root-of (floppy-for ?file%))) Result)
    3 Advisor )) ;not as good as query because mv takes up space for awhile
(def-fact
  '(_has-influence_ Enable
		    (PAIR
		     (_has_in-hand User Unassigned-floppy)
		     (_types-about_chars-for_
		      User 14
		      (mv_from_to-dir_ ?file% ?dir%
				       (root-of (floppy-for ?file%)) )))
		    (mv_from_to-dir_ ?file% ?dir%
				     (root-of (floppy-for ?file%)) )))
(def-fact
  '(_has-desirability_for_ (_in-role_ (_has_in-hand ?person Unassigned-floppy)
				      Enable )
			   -5
			   ?person ))

;;;;;; about /tmp cleanup
#|
(def-fact
  '(_has-influence_ Result
		    (repetitions-of (file_is-in_ ?file% ?dir%))
		    (_filled-up ?dir%) ))
|#
(def-fact
  '(_has-influence_ Promote
		    (repetitions-of (file_is-in_ ?file% ?dir%))
		    (_filled-up ?dir%) ))
(def-fact ;just for testing
  '(_typical (repetitions-of (_hits_button User Space))) )
(def-fact
  '(_typical (repetitions-of (file_is-in_ ?file% Slash-tmp))) )
(def-fact ;just for testing
  '(_typical (repetitions-of (_hits_button User Enter))) )
(def-fact
  '(_has-influence_ Result
		    (_has-automated-cleanup-program Slash-tmp)
		    (NOT (_filled-up Slash-tmp)) ))
#|
(def-fact
  '(_has-automated-cleanup-program Slash-tmp) ) ;User assumes NOT-cleanup-prog
|#

;;;;;;;;;;;; extras (not used)

;; None of the NOT propos from the original db have been included, because
;;  NBF will return the correct truth value for them.  They included both
;;  Result and Enable relations.

(def-fact
  '(_has-influence_ Result
		    (user-queried-before_ ?system-action%)
		    (_required-to-answer-query User) )) ;almost tautological
(def-fact
  '(_has-influence_ Result
		    (file_is-in_ ?file% Slash-tmp)
		    (file_recoverable-until_ ?file% End-of-day) ))
(def-fact
  '(_has-influence_ Result
		    (file_is-in_ ?file% (root-of (floppy-for ?file%)))
		    (file_recoverable-until_
		     ?file%
		     (written-over (floppy-for ?file%)) )))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (file_recoverable-until_ ?file% End-of-day) Result)
    8 Advisor ))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (file_recoverable-until_ ?file%
					(written-over (floppy-for ?file%)) )
	       Result )
    9 Advisor ))
(def-fact
  '(_has-desirability-for_
    (_in-role_ (_filled-up Slash-tmp) Result)
    -8 Advisor ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;             TESTS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun t1 ()
  (reset-dbs-2)
  (RESPOND-TO
   '(_doing_is-best-action-for_
     User ?A
     (file_removed-from_ file-sk1 (home-dir-of User))
     ! ?N1 ?N2 )))

(defun t2 ()
  ;;(setq *verbose1?* t)
  (RESPOND-TO
   '(_has-desirability_for_
     (_in-role_ (_required-to-answer-query User) Result) ;ask-before-remove
     -5
     User )))

(defun t3 ()
  ;;(setq *verbose1?* t)

(def-rule-1
  'er39
  '((NOT (_has-influence_ Result ?event1 ?event2))      ;E1=reps of file-in /tmp
    <- (_has-influence_ Result ?event3% (NOT ?event2)) ));E3=/tmp cleanup program

  (RESPOND-TO
   '(_has-desirability_for_
     (_in-role_ (_filled-up Slash-tmp) Result) ;fill-up-tmp
     -5
     User )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;             RUMINATIONS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|

(def-rule-1 ;DESIRABILITY-OF-CAUSE-FROM-DESIRABILITY-OF-ALL-EFFECTS (er1,3,4,6)
  'erX1
  '((_has-desirability_for_ (_in-role_ ?state Result) ?N ?person)
    IMPLIED-BY
    ((_has_values-of_in_
      ?Effects All ?e (_has-influence_ Immed-result ?state ?e) ) AND
     (_has-collective-desirability_for_ (_in-role_ ?Effects Result)
					?N ?person ))))

(def-rule-1 ;DESIRABILITY-OF-ENABLER-FROM-DIFFICULTY-OF-BEST-PLAN (no prev ver)
  'erX2
  '((_has-desirability_for_ (_in-role_ ?state Enable) ?Npreconds ?person)
    IMPLIED-BY
    (_doing_is-best-action-for_ ?person ?A ?state ! ?Neffects ?Npreconds) ))





;;LR-1:DESIRABILITY-OF-EFFECT-FROM-QUERY-FOR-BEST-PLAN
((user-query-for_bindings-of_in_
  ?foo
  ?A1
  (doing_is-best-action-for_ User ?A1 ?effect) )
 -> (_has-desirability_for_ (_in-role_ ?effect Result) 5 User) )


;; This rule can be skipped if the KB is encoded using negative des-vals
;;  for desired NOTs.
(def-rule-1 ;DESIRABILITY-FROM-DESIRABILITY-OF-NEGATION
  'er37
  '((_has-desirability_for_ (_in-role_ ?S ?RoE) (- ?N) ?Person) IMPLIED-BY
    (_has-desirability_for_ (_in-role_ (NOT ?S) ?RoE) ?N ?Person) ))

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

;;er-2 and er-5, concerning desirability of enablements, do not fit the
;; cost-benefit scheme and will not be used in this new version.  They
;; were not used in Alex's analysis of Dialogue 0, either.

;;ER-56:DESIRABILITY-OF-EFFECT-FROM-DESIRABILITY-OF-EFFECT-REPETITIONS
(((_has-desirability_for_ (_in-role_ ?effect1 Result) ?N ?person) AND
  ((_has-influence_ Immed-result (repetitions-of ?effect2) ?effect1) AND
   (_has-frequency_ (repetitions-of ?effect2) Common) ))
 -> (_has-desirability_for_ (_in-role_ ?effect2 Result) ?N ?person) )
;; This doesn't fit the cost-benefit scheme well, because it derives
;;  desirability from a single effect rather than a complete set.  But
;;  it's my best stab at explaining 0-5 and generating 0-6.

;;ER-43:DOUBLE-FAILED-TRANSITIVITY-OF-CAUSING (no previous version)
(((NOT (_has-influence_ Result ?cause ?effect1)) AND
  (NOT (_has-influence_ Result ?effect1 ?effect2)) )
 -> (NOT (_has-influence_ Result ?cause ?effect2)) )

;;ER-49:DOUBLE-FAILED-TRANS-ENABLE-FROM-ENABLE-AND-CAUSE (no previous version)
(((NOT (_has-influence_ Enable ?enabler ?enabled)) AND
  (NOT (_has-influence_ Result ?enabled ?effect)) )
 -> (NOT (_has-influence_ Enable ?enabler ?effect)) )

;;ER-54:DOUBLE-FAILED-TRANSITIVITY-OF-PREVENTING (no prev) (compare to ER-43)
(((NOT (_has-influence_ Result ?cause (NOT ?effect1))) AND
  (NOT (_has-influence_ Result ?effect1 ?effect2)) )
 -> (NOT (_has-influence_ Result ?cause (NOT ?effect2))) )

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
		 (file_is-in_ ?file ?dir2) )
;;DF-5
(_has-desirability_for_ (_in-role_ (user-queried-before_ 
				    (file_removed-from_ ?file ?dir) )
				   Result )
			3 ;good in general
			?everyone )
;; The work involved in typing responses for this should be folded in with
;;  the evaluation of other typing work (e.g. pathnames) somehow.

;;DF-6
(_has-desirability_for_ (_in-role_ (file_is-in_ ?file ?dir) Result)
			0 ;no reason for joy or sorrow!
			?everyone )
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
;;DF-14
(_has-influence_ Result
		 (file_is-in_ ?file Slash-tmp)
		 (file_is-recoverable-until_ ?file End-of-day) )
;;DF-15
(_has-desirability_for_
 (_in-role_ (file_is-recoverable-until_ ?file ?event) Result)
 3 ;good in general
 ?everyone )

;;DF-16
(_has-frequency_ (repetitions-of (file_is-in_ ?file ?dir)) Common)
;;DF-17
(_has-influence_ Result
		 (cleanup-program-for_ Slash-tmp)
		 (NOT (fill-up_ Slash-tmp)) )
|#

#| ;; for debugging
(def-rule-1
  'r1
  '((_g-parent-of_ ?g ?c) IMPLIED-BY
    ((_parent-of_ ?g ?p) AND
     (_parent-of_ ?p ?c) )))

(def-fact '(_parent-of_ Clyde Ed))
(def-fact '(_parent-of_ Ed David))

(defun t2 ()
  (reset-dbs-2)
  (RESPOND-TO '(_g-parent-of_ ?who David))
  )
|#
#| simplified DB (only core rules, and atoms used in place of many propos)
;; RM
(def-fact
  '(_has-influence_ Result rm remove-file) )
(def-fact
  '(_has-desirability_for_ (_in-role_ remove-file Result) 8 Advisor) ) ; -8
(def-fact
  '(_has-influence_ Enable (PAIR
			    (_has-dir-write-permission User)
			    (_types-about_chars-for_ User 8 rm) )
		    rm ))
(def-fact '(_has-dir-write-permission User))
(def-fact
  '(_has-desirability_for_
    (_in-role_ (_types-about_chars-for_ ?person ?N ?action) Enable)
    (/ (- ?N) 5)
    ?person )) ;can't be 'Advisor' due to other mention

;; RM -I
(def-fact
  '(_has-influence_ Result rm-i (PAIR remove-file ask-before-remove)) )
(def-fact ;should be derived from desire to avoid accidental removal
  '(_has-desirability_for_ (_in-role_ ask-before-remove Result) 5 Advisor) )
(def-fact
  '(_has-influence_ Enable (PAIR
			    (_has-dir-write-permission User)
			    (_types-about_chars-for_ User 11 rm-i) )
		    rm-i ))

;; MV TO /TMP
(def-fact
  '(_has-influence_ Result mv-to-tmp (PAIR remove-file file-in-tmp)) )
(def-fact ;should be derived from desire to avoid accidental removal
  '(_has-desirability_for_ (_in-role_ file-in-tmp Result) 0 Advisor) )
(def-fact
  '(_has-influence_ Enable (PAIR
			    (_has-dir-write-permission User)
			    (_types-about_chars-for_ User 12 mv-to-tmp) )
		    mv-to-tmp ))

;; MV TO FLOPPY
(def-fact
  '(_has-influence_ Result mv-to-floppy (PAIR remove-file file-on-floppy)) )
(def-fact ;should be derived from desire to avoid accidental removal
  '(_has-desirability_for_ (_in-role_ file-on-floppy Result) 0 Advisor) )
(def-fact
  '(_has-influence_ Enable (PAIR
			    (_has_in-hand User Unassigned-floppy)
			    (_types-about_chars-for_ User 14 mv-to-floppy) )
		    mv-to-floppy ))
(def-fact
  '(_has-desirability_for_ (_in-role_ (_has_in-hand ?person Unassigned-floppy)
				      Enable )
			   -5
			   ?person ))
;;;;;;;;;;;;; old tests

(defun t1 ()
  (reset-dbs-2)
  (RESPOND-TO '(_doing_is-best-action-for_ User ?A remove-file ! ?N1 ?N2))
  )

(defun t2 ()
  (setq *verbose1?* t)
  (RESPOND-TO '(_has-desirability_for_ (_in-role_ ask-before-remove Result)
				       -5
				       User )))
|#