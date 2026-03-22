;; Explanation-Rules based on Cost-Benefit Analysis

(((action_has-suitability_for_ ?A1 ?N1 ?G) AND
  ((action_has-suitability_for_ ?A2 ?N2 ?G) AND
   (< ?N2 ?N1) ))
 -> (_is-better-action-than_for_ ?A1 ?A2 ?G) )

(((action_has-suitability_for_ ?A ?N1 ?G) AND
  (not-exists_such-that_ ;satis'd by proc-attachment which uses CWA
   (action_has-suitability_for_ ?A2 ?N2 ?G)
   (< ?N2 ?N1) ))
 -> (_is-best-action-for_ ?A ?G) )

(((_has-influence_ Result ?A ?E) AND ;?E is a complete list of effects
  ((_contains_ ?E ?G) AND ;satis'd by proc-attachment or inductive rules
   ((_has-collective-desirability_ ?E ?N1) AND
    ((_has-influence_ Enable ?P ?A) AND ;?P is a complete list of preconds
     (_has-collective-desirability_ ?P ?N2) ))))
 -> (action_has-suitability_for_ ?A (+ ?N1 ?N2) ?G) )

(_has-desirability_ NIL 0) ; for acts with no preconds

((_has-desirability_ (NOT ?E) ?N) -> (_has-desirability_ ?E (- ?N)))

((_has-desirability_ ?E ?N) -> (_has-collective-desirability_ ?E ?N))

(((_has-desirability_ ?E1 ?N1) AND (_has-collective-desirability_ ?E2 ?N2))
 -> (_has-collective-desirability_ (?E1 AND ?E2) (+ ?N2 ?N1)) )

;; Note that G is not given any special desirability because it is the goal;
;;  the only purpose of providing G is to lend a focus to the search for acts.

;; The user supplies the Influence and Has-desirability facts.  (Also, if
;;  an action has no preconds, the user would have to tell us that the
;;  act had 'NIL' preconds.)

;; All 'Prevent' influences would now be represented as Result-NOTs.

;; Explaining why a User thinks a plan is best or better is complicated
;;  here by the fact that we can't break a suitability number into
;;  a sum of desirability values (e.g. 4 => 1 + 2 + 1).  Perhaps this is
;;  fatal to this approach.  On the other hand, I suspect that the real
;;  task of User Modelling is to readjust the *weights* that a User is
;;  believed to ascribe to different goals and beliefs.
