;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Application of rules to Dialog 0

;;---------------------------------------------------------------------
;; (0-1) User: What's the best way to remove a file?

(user-query-for_bindings-of_in_
 1 ;<up to number>/All
 ?A1
 (_doing_is-best-action-for_ User ?A1 (file_removed-from_ sk-file1 sk-dir1)) )

;; I assume the user's current directory is the dir of the file to be removed.
;; Assume sk-file1 is a single file and not a set of files, which might make
;;  "rm -r" or "rm -ir" a better choice.

;; Advisor matches query to consequent of ER-32, then uses ER-33 to try
;;  to satisfy antecedents.  There are two ways of satisfying ER-33:

;;     1st option for removing a file:
;;         rm-i (ER-33 uses DF-1,2,LR-1,DF-5,7,8,assump-1,DF-12)

;;     2nd (and last) option for removing a file:
;;         mv to /tmp (ER-33 uses DF-3,4,LR-1,DF-6,9,10,11,assump-1,2,DF-12)

;;     assump-1:
       (_has_permission-for_ User Write Slash-tmp)
;;       If the user indicates that this is not true, it may be impossible
;;       for him to achieve (but if he is su, it's easy and thus not
;;       undesirable)

;;     assump-2:
       (_has-permission-for_ User Write sk-dir1) ;current dir

;; Option 1, using rm -i, ranks higher.  Querying before removing is its
;;  most desirable side effect (or least undesirable enablement), so that
;;  is what is mentioned as a justification.
;;---------------------------------------------------------------------
;; (0-2) Advisor: Use "rm -i filename".  It asks for confirmation
;;  before removing the file.
;;---------------------------------------------------------------------
;; (0-3) User: But I don't want to answer questions.

(_has-desirability_for_ (_in-role_ (_required-to-answer-queries User) Result)
			-5     ;5 is default for user desirability stmts,
			User ) ; unless we apply more commonsense knowledge
;; It's not clear how the parser would realize that this is a result, not
;;  an enablement.

;; Advisor tries matching ER antecedents to this rep; ER-37 fits, using
;;  DF-13 for support.  The instantiated consequent of ER-37 conflicts
;;  with a premise used for ER-33, the desirability of being queried first,
;;  which has the same propositional content but a value of 3 (not -5).
;;  Using the -5 value instead causes the rating of "mv to /tmp" to surpass
;;  the previous favorite, "rm -i", so it is mentioned as an alternative.
;;  The justification might be inferred somehow from the most desirable side
;;  effect (value 0 here) using DF-14 and DF-15.
;;---------------------------------------------------------------------
;; (0-4) Advisor: As an alternative, use "mv filename /tmp".  It
;;  allows you to recover the removed file.

;;    (DP: What about the fact that both "rm" and "mv" can prompt with
;;     permission info if the destination file is write-protected?
;;     Why not use "mv -f filename /tmp"?)
;;---------------------------------------------------------------------
;; (0-5) User: But I don't want to fill up "/tmp".

(_has-desirability_for_ (_in-role_ (fill-up_ Slash-tmp) Result) -5 User)
;; It's not clear how the parser would realize that this is a result, not
;;  an enablement.

;; ER-56 is triggered by this fact, with support from assump-3 and DF-16
;;   assump-3:
     (_has-influence_ Result         ;v should be repetitions of act, not effect
		      (repetitions-of (file_is-in_ ?file ?dir))
		      (fill-up_ ?dir) )
;;  The instantiated consequent of ER-56, concerning the undesirability of
;;   having a file in /tmp, conflicts with a premise supporting "mv to /tmp"
;;   as the best plan (via ER-32).
;;  Yet, instead of suggesting a third alternate plan, the Advisor looks first
;;   to see if it believes the negation of the User's latest assumption.
;;   Alex used ER-xx to derive this negation, using:

;;   DF-xx
     (NOT (_has-influence_ Result
			   (mv_to-dir_from_ ?file ?dir2 ?dir1)
			   (NOT (cleanup-program-for_ ?dir2)) ))
;;   and DF-17.

;;   ER-xx and DF-xx don't seem to be natural facts, however.

;;---------------------------------------------------------------------

;; (0-6) Advisor: Using "mv filename /tmp" won't fill up "/tmp".
;;  There's a program which cleans up "/tmp".
