;; Test rule-base for Infer.lsp

(format t "~%;;;;;;;;;;;;;;;;;;;; Test 1 - simple FCing and BCing")

(reset-dbs)
(forget)

(def-rule
  :r1
  '(((same-personality ?p1 ?p2) AND
     (same-appearance ?p1 ?p2) )
    -> (same-person ?p1 ?p2) ))

(def-rule
  :r2
  '((same-personality ?p1 ?p2)
    <- (frat-brothers ?p1 ?p2) ))

(def-rule :r3 '(frat-brothers Fred Barney))

(infer-from '(same-appearance Fred Barney) :verbose? t)

(format t "~%Only correct result:  (SAME-PERSON FRED BARNEY)~%")


(format t "~%;;;;;;;;;;;;;;;;;;;; Test 2 - multiple possible FC's but only one correct one")

(reset-dbs)
(forget)

(def-rule
  :r4
  '(((_say_to_ ?p1 "You're such a bastard" ?p2) AND
     (_angry-with_ ?p1 ?p2) )
    -> (_insults_ ?p1 ?p2) ))

(def-rule
  :r5
  '(((_say_to_ ?p1 "You're such a bastard" ?p2) AND
     (_likes_ ?p1 ?p2) )
    -> (_compliments_ ?p1 ?p2) ))

(def-rule
  :r6
  '(((_say_to_ ?p1 "You're such a bastard" ?p2) AND
     (_born-illegitimate ?p2) )
    -> (_brutally-honest ?p1) ))

(def-rule :r7 '(_likes_ Jake Ted))

(infer-from '(_say_to_ Jake "You're such a bastard" Ted) :verbose? t)

(format t "~%Only correct result:  (_COMPLIMENTS_ JAKE TED)~%")


(format t "~%;;;;;;;;;;;;;;;;;;;; Test 3 - a noncodes constraint")

(reset-dbs)
(forget)

(def-rule
  :r8
  '(((_buy_for_ ?p1 beer ?p2) AND
     (_horny-for_ ?p2 ?p1) )
    -> (_sleeps-with_ ?p2 ?p1) ))

(infer-from '((_horny-for_ Cyndi ?man) AND (NOT= ?man Cletus)))

(infer-from '(_buy_for_ John beer Cyndi) :verbose? t)

(format t "~%Only correct result:  (_SLEEPS-WITH_ CYNDI JOHN)~%")

(infer-from '(_buy_for_ Cletus beer Cyndi) :verbose? t)

(format t "~%Only correct result:  NIL~%")


(format t "~%;;;;;;;;;;;;;;;;;;;; Test 4 - negation by failure")

(reset-dbs)
(forget)

(def-rule
  :r9
  '(((_has-feature_ ?item1 ?feature) AND
     (NOT ((NOT= ?item2 ?item1) AND
	   (_has-feature_ ?item2 ?feature) )))
    -> (_is-unique-for_ ?item1 ?feature) ))

(def-rule :r10 '(_has-feature_ Pepsi fizzy))

(infer-from '(_has-feature_ DrPepper fizzy) :verbose? t)

(format t "~%Only correct result:  NIL~%")

(infer-from '(_has-feature_ DrPepper made-in-Waco) :verbose? t)

(format t "~%Only correct result:  (_IS-UNIQUE-FOR_ DRPEPPER MADE-IN-WACO)~%")
;;actually, Big Red is made there, too


(format t "~%;;;;;;;;;;;;;;;;;;;; Test 5 - backtracking for antecedent support")

(reset-dbs)
(forget)

(def-rule
  :r11
  '(((_is-mother-of_ ?p1 ?p2) AND
     ((_is-mother-of_ ?p2 ?p3) AND
      ((_is-mother-of_ ?p3 ?p4) AND ;tests backtracking across 2 "levels"
       (_is-queen ?p4) )))
    -> (_is-queens-greatgrandmother ?p1) ))

(def-rule :r12 '(_is-mother-of_ Catherine Doris))
(def-rule :r13 '(_is-mother-of_ Doris Toni))
(def-rule :r14 '(_is-mother-of_ Toni Ange))
(def-rule :r15 '(_is-mother-of_ Virginia Gwynevere))
(def-rule :r16 '(_is-mother-of_ Gwynevere Mary))
(def-rule :r17 '(_is-mother-of_ Mary Elizabeth))

(infer-from '(_is-queen Elizabeth) :verbose? t)

(format t "~%Only correct result:  (_IS-QUEENS-GREATGRANDMOTHER VIRGINIA)~%")


(format t "~%;;;;;;;;;;;;;;;;;;;; Test 6")

(reset-dbs)
(forget)

;; Add a test that uses a halt predicate and another that uses at least
;;  two levels of forward-chaining, and at least two for back-chaining.
