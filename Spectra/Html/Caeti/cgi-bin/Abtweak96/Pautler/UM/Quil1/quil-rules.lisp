;; quil-rules.lisp
;; These are the rules from Alex's dissertation work, as listed in
;;  "Forming User Models by Understanding User Feedback".

;; This file replaces the _prevents_
;;  pred that Alex used with _has-result_(NOT).  This change in
;;  preds makes it clear that some rules are subsumed by others here,
;;  and we have removed such redundancy when we have noticed it.

;; Ontology:
;;  Events can have several possible causes, but only one enabler.
;;  Causal and enabling relations can be either immediate or transitive.
;;  An event cannot be both an enabler and a cause of another event.

(reset-dbs)

(def-rule
  :er1
  '((_is-desired ?event1) <-
    ((_has-result_ ?event1 ?event2) AND
     (_is-desired ?event2) )))

(def-rule
  :er2
  '((_is-desired ?event1) <-
    ((_enables_ ?event1 ?event2) AND
     (_is-desired ?event2) )))

;;ER3 subsumed by ER1

(def-rule
  :er4
  '((_is-desired (NOT ?event1)) <-
    ((_has-result_ ?event1 ?event2) AND
     (_is-desired (NOT ?event2)) )))

(def-rule
  :er5
  '((_is-desired (NOT ?event2)) <-
    ((_enables_ ?event1 ?event2) AND
     (_is-desired (NOT ?event1)) )))

(def-rule
  :er6
  '((_is-desired ?event1) <-
    ((_has-result_ ?event1 (NOT ?event2)) AND
     (_is-desired ?event2) )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; finding best plans

(def-rule
  :er7
  '((_is-best-plan-for_ ?plan1 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     (NOT ((NOT= ?plan2 ?plan1) AND
	   (_has-result_ ?plan2 ?goal) )))))

(def-rule
  :er8
  '((_is-best-plan-for_ ?plan1 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((NOT= ?side-effect ?goal) AND
      ((_has-result_ ?plan1 ?side-effect) AND
       ((_is-desired ?side-effect) AND
	(NOT ((NOT= ?plan2 ?plan1) AND
	      ((_has-result_ ?plan2 ?goal) AND
	       (_has-result_ ?plan2 ?side-effect) )))))))))

(def-rule
  :er9
  '((_is-best-plan-for_ ?plan1 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((NOT (_has-result_ ?plan1 ?side-effect)) AND
      ((_is-desired (NOT ?side-effect)) AND
       (NOT ((NOT= ?plan2 ?plan1) AND
	     ((_has-result_ ?plan2 ?goal) AND
	      (NOT (_has-result_ ?plan2 ?side-effect)) ))))))))

(def-rule
  :er10
  '((_is-best-plan-for_ ?plan1 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((NOT (_enables_ ?plan1 ?side-eventuality)) AND
      ((_is-desired (NOT ?side-eventuality)) AND
       (NOT ((NOT= ?plan2 ?plan1) AND
	     ((_has-result_ ?plan2 ?goal) AND
	      (NOT (_enables_ ?plan2 ?side-eventuality)) ))))))))

;;ER11 subsumed by ER8

;;ER12 subsumed by ER9


;;;;;;;;;;;;;;;;;;;; plan comparisons

(def-rule
  :er13
  '((_is-better-plan-than_for_ ?plan1 ?plan2 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     (NOT (_has-result_ ?plan2 ?goal)) )))

(def-rule
  :er14
  '((_is-better-plan-than_for_ ?plan1 ?plan2 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((NOT= ?side-effect ?goal) AND
      ((_has-result_ ?plan1 ?side-effect) AND
       ((_is-desired ?side-effect) AND
	((_has-result_ ?plan2 ?goal) AND
	 (NOT (_has-result_ ?plan2 ?side-effect)) )))))))

(def-rule
  :er15
  '((_is-better-plan-than_for_ ?plan1 ?plan2 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((NOT (_has-result_ ?plan1 ?side-effect)) AND
      ((_is-desired (NOT ?side-effect)) AND
       ((_has-result_ ?plan2 ?goal) AND
	(_has-result_ ?plan2 ?side-effect) ))))))

(def-rule
  :er16
  '((_is-better-plan-than_for_ ?plan1 ?plan2 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((NOT (_enables_ ?plan1 ?side-eventuality)) AND
      ((_is-desired (NOT ?side-eventuality)) AND
       ((_has-result_ ?plan2 ?goal) AND
	(_enables_ ?plan2 ?side-eventuality) ))))))

(def-rule
  :er17
  '((_is-better-plan-than_for_ ?plan1 ?plan2 ?goal) <-
    ((_has-result_ ?plan1 ?goal) AND
     ((_has-result_ ?plan1 (NOT ?side-effect)) AND
      ((_is-desired (NOT ?side-effect)) AND
       ((_has-result_ ?plan2 ?goal) AND
	(_has-result_ ?plan2 ?side-effect) )))))) ;its diff with ER14

;;ER18 is subsumed by ER15


;;;;;;;;;;;;;;;;;;;;;;;

(def-rule ;causal transitivity
  :er19
  '((_has-result_ ?event1 ?event3) <-
    ((_has-result_ ?event1 ?event2) AND
     (_has-result_ ?event2 ?event3) )))

(def-rule
  :er20
  '((NOT (_has-result_ ?event1 ?event3)) <-
    ((NOT (_has-result_ ?event1 ?event2)) AND
     (_has-result_ ?event2 ?event3) )))

(def-rule
  :er21
  '((NOT (_has-result_ ?event1 ?event2)) <-
    (_has-result_ ?event1 (NOT ?event2)) ))

(def-rule ;not a commonsensical fact
  :er22
  '((NOT (_has-result_ ?event1 ?event3)) <-
    ((NOT (_has-result_ ?event1 (NOT ?event2))) AND
     (_has-result_ ?event2 (NOT ?event3)) )))

(def-rule
  :er23
  '((_enables_ ?event1 ?event3) <-
    ((_has-result_ ?event1 ?event2) AND
     ((_enables_ ?event2 ?event3) AND
      (NOT ((NOT= ?event4 ?event1) AND
	    (_has-result_ ?event4 ?event2) ))))))

(def-rule
  :er24
  '((NOT (_enables_ ?event1 ?event3)) <-
    ((NOT (_enables_ ?event1 ?event2)) AND
     (_has-result_ ?event2 ?event3) )))

(def-rule
  :er25
  '((NOT (_enables_ ?event1 ?event2)) <- (_has-result_ ?event1 ?event2)) )

(def-rule
  :er26
  '((_has-result_ ?event1 (NOT ?event3)) <-
    ((_has-result_ ?event1 (NOT ?event2)) AND
     (_enables_ ?event2 ?event3) )))

;;ER27 subsumed by ER19

;;ER28 subsumed by ER22

;;ER29 subsumed by ER21

(def-rule
  :er30
  '((NOT (_has-result_ ?event1 (NOT ?event2))) <-
    (_enables_ ?event1 ?event2) ))


;; explanation rules added by DP 8/97 to make up for rules removed due to
;;  being subsumed

(def-rule
  :er31
  '((_is-desired (NOT (NOT ?event))) <- (_is-desired ?event)) )

(def-rule
  :er32
  '((_has-result_ ?event1 (NOT (NOT ?event2))) <-
    (_has-result_ ?event1 ?event2) ))

(def-rule ;not yet needed, but added for completeness
  :er33
  '((_enables_ ?event1 (NOT (NOT ?event2))) <-
    (_enables_ ?event1 ?event2) ))

(def-rule ;not yet needed, but added for completeness
  :er34
  '((_has-result_ (NOT (NOT ?event1)) ?event2) <-
    (_has-result_ ?event1 ?event2) ))

(def-rule ;not yet needed, but added for completeness
  :er35
  '((_enables_ (NOT (NOT ?event1)) ?event2) <-
    (_enables_ ?event1 ?event2) ))


;; END explanation rules

(forget) ;clear list of conclusions









(def-rule :bf1 '(_has-result_ rm-i remove-file))
(def-rule :bf2 '(_has-result_ rm-i ask-before-remove))
(def-rule :bf3 '(_is-desired ask-before-remove))                   ;assumption
;; NBF: no plan other than rm-i causes 'remove-file and 'ask-before-remove

(prove '(_is-best-plan-for_ ?plan remove-file))

(def-rule :bf4 '(_has-result_ ask-before-remove answer-questions))

(infer-from '(_is-desired (NOT answer-questions)))

(def-rule :bf5 '(_has-result_ mv-tmp remove-file))
(def-rule :bf6 '(_has-result_ mv-tmp recoverable-file))
(def-rule :bf7 '(_is-desired recoverable-file))                    ;assumption
;; NBF: no plan other than mv-tmp causes 'remove-file and 'recoverable-file

(infer-from '(_is-desired (NOT fill-up-tmp)))

(def-rule :bf8 '(_has-result_ mv-tmp fill-up-tmp))      ;assumption (erroneous)
;; NBF: rm-i does not cause fill-up-tmp

(def-rule :bf9 '(_has-result_ cleanup-program (NOT fill-up-tmp)))
;; NBF for NOT: (NOT (_has-result_ mv-tmp (NOT clean-up-program)))