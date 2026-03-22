;;;;;  DIALOG 1

;; 1-1 User: What's the best way to remove a file?

   Query: Give a binding for ?plan from
   (_is-best-plan-for_ ?plan1 (file-removed_ ?file1))


;; 1-2 Advisor: Use "rm -i filename" to remove a file.  It asks for
;;  confirmation before removing the file.

   (_is-best-plan-for_ (rm-i_ ?file1)           ;found via ER-8
		       (file-removed_ ?file1) )
   ;; explanation for recommendation:
   (_has-influence_ Result
		    (rm-i_ ?file1)
		    (query-for-permission-before_ 
		     (file-removed_ ?file1) ))


;; 1-3 User: Why? (= Why is <confirming> important?)

   Query: Show the unshared supports for the conclusion:
   (desirable_
    (query-for-permission-before_ (file-removed_ ?file)) )
   ;; The Advisor had believed that both supports had been shared, so in
   ;;  this case it has to choose one or both to tell.


;; 1-4 Advisor: That prevents accidentally removing a file.

   (_has-influence_ Result
		    (query-for-permission-before_ (file-removed_ ?file1))
		    (NOT ((file-removed_ ?file1) AND
			  (desirable_ (NOT (file-removed_ ?file1))) )))


;; 1-5 User: But I don't want to answer questions.

   (desirable_ (NOT (user-queried-before_ (file-removed_ ?file1))))


;; 1-6 Advisor: Why not?

   ;; Advisor can explain the user's statement, but for some reason the
   ;;  Advisor is not willing to accept the statement on face value.
   ;;  We have to invoke the explainer again, and ER-5 works,
   ;;  finding more than one possibility.  So it asks for a clarification.

   ;; possibility 1: (too much time)
   (_has-influence_ Enable ;shared
		    (_to-degree_ (user-provides_ Time) Much)
		    (user-queried-before_ (file-removed_ ?file1)) )

   ;; possibility 2: (too much typing)
   (_has-influence_ Enable ;shared
		    (_to-degree_ (user-provides_ Typing) Much)
		    (user-queried-before_ (file-removed_ ?file1)) )

   ;; These possibilities don't seem different enough to require a
   ;;  clarification, but they're all I could imagine.  See 2-10
   ;;  for a better example.


;; 1-7 User: It takes too long. (= I don't want to spend the time.)

   (desirable_ (NOT (_to-degree_ (user-provides_ Time) Much)))

   ;; It's not clear why the Advisor accepts this statement and does not
   ;;  ask for a clarification again.  Instead, the Advisor looks for
   ;;  an alternate best plan.


;; 1-8 Advisor: Alternatively, use "mv filename /tmp" to remove a file.  It
;;  allows you to recover a removed file.


   (_is-best-plan-for_ (mv_to_ ?file1 Slash-tmp)        ;found via ER-8
		       (file-removed_ ?file1) )
   ;; explanation for recommendation:
   (_has-influence_ Enable
		    (mv_to_ ?file1 Slash-tmp)
		    (undo_ (file-removed_ ?file1)) )


;; 1-9 User: But I don't own "/tmp".

   (NOT (owned-by-user_ Slash-tmp))

   ;; Again, the Advisor chooses for some reason not to ask why the
   ;;  user believes this; he just uses the statement to find the
   ;;  contradiction the user has in mind. (perhaps some difference
   ;;  between desires and beliefs, although a desire has gone unchallenged).

   ;; There is no ERule about existing situations which prevent plans.
   ;; New rule ER-31:
   (((_has-influence_ Result ?P ?G) AND
     ((_has-influence_ Result ?P2 ?G) AND
      ((NOT ?E) AND
       ((_has-influence_ Enable ?E ?P) AND
	(NOT (_has-influence_ Enable ?E ?P2)) ))))
    -> (_is-better-than_for_ ?P2 ?P ?G) )


;; 1-10 Advisor: You don't need to own a directory to move a file into it.

   (NOT (_has-influence_ Enable
			 (owned-by-user_ ?directory)
			 (mv_to_ ?file ?directory) ))

;; 1-11 User: What about moving files to a floppy?

   ;;Query: is the following propo true?
   (_is-better-plan-than_for_ (mv_to_ ?file1 (floppy-in-drive ?drive))
			      (mv_to_ ?file1 Slash-tmp)
			      (file-removed_ ?file1) )

   ;; The Advisor tries to prove the query, fails, then tries to prove
   ;;  the *inverse* of the query, succeeds, and explains how it did so.


;; 1-12 Advisor: Moving files to a floppy is slower than moving them to "/tmp".

   (_is-better-plan-than_for_ (mv_to_ ?file1 Slash-tmp)
			      (mv_to_ ?file1 (floppy-in-drive ?drive))
			      (file-removed_ ?file1) )
   ;; In order to motivate the use of the word "slower" in the text, we'll
   ;;  have to include the two "to-degree" facts below plus the > comparison.

   ;; new ER-32, which weighs two plans using a single shared but unequal
   ;;  attribute.
   (((_has-influence_ Result ?P ?G) AND
     ((_has-influence_ Result ?P2 ?G) AND
      ((_has-influence_ Enable (_to-degree_ ?E ?D1) ?P) AND
       ((_has-influence_ Enable (_to-degree_ ?E ?D2) ?P2) AND
	((> ?D1 ?D2) AND
	 (desirable (NOT ?E)) )))))
    -> (_is-better-plan-than_for_ ?P2 ?P1 ?G) )

   ;; supports:
   (_has-influence_ Result ;shared
		    (mv_to_ ?file (floppy-in-drive ?drive))
		    (file-removed_ ?file) )
   (_has-influence_ Result ;shared
		    (mv_to_ ?file Slash-tmp)
		    (file-removed_ ?file) )
   (_has-influence_ Enable ;shared
		    (_to-degree_ (user-provides_ Time) 3) ;approximated seconds
		    (mv_to_ ?file (floppy-in-drive ?drive)) )
   (_has-influence_ Enable ;shared
		    (_to-degree_ (user-provides_ Time) 1)
		    (mv_to_ ?file Slash-tmp) )
   ;; > done by procedural attachment ==> assumed shared
   (desirable_ (NOT (user-provides_ Time))) ;shared






;;;;;  DIALOG 2

;; 2-1 User: What's the best way to remove a file?

   ;; (see 1-1)


;; 2-2 Advisor: Use "rm -i filename" to remove a file.  It asks for
;;  confirmation before removing the file.

   ;; (see 1-2)


;; 2-3 User: But I don't want to answer questions.

   ;; (see 1-5)


;; 2-4 Advisor: But that doesn't take much time.

   ;; (The inference here is the same as that in 1-6 except only one
   ;;  explanation rule is found to match, and the Advisor believes
   ;;  the negation.)

   (NOT (_has-influence_ Enable ;shared
			 (_to-degree_ (user-provides_ Time) Much)
			 (user-queried-before_ (file-removed_ ?file1)) ))

;; 2-5 User: It takes too much time.

   ;; The User denies the Advisor's statement (not something abduced from
   ;;  it), so the Advisor searches for an alternative plan.


;; 2-6 Advisor: Alternatively, use "mv filename /tmp" to remove a file.  It
;;  allows you to recover a removed file.

   ;; (see 1-8)


;; 2-7 User: But I don't want my files in "/tmp".

   (desirable_ (NOT ((_is-stored-in_ ?file1 Slash-tmp) AND
		     (_is-owned-by_ ?file1 User) )))

   ;; The Advisor explains this to itself, then searches for an alternate plan


;; 2-8 Advisor: You can make a directory in "/tmp" so that your files aren't
;;  readable by other users.

   (_is-best-plan-for_ (((_is-subdir-of_ ?dir1 Slash-tmp) AND
			 ((_has_permission-for_ User Read ?dir1) AND
			  (mv_to_ ?file1 ?dir1) )) OR
			((not-exists_such-that_
			  (_is-subdir-of_ ?dir1 Slash-tmp)
			  (_has_permission-for_ User Read ?dir1) ) AND
			 (complete_before_
			  (create-subdir_of_ ?dir1 Slash-tmp)
			  ((set_permission-of_to_ Read ?dir1 User) AND
			   (mv_to_ ?file1 ?dir1) ))))
		       (file-removed_ ?file1) )

   ;; Representing plan steps within plans is proving to be quite
   ;;  difficult, so I can't commit to this representation as
   ;;  a final form.


;; 2-9 User: That takes too much work. (= too much typing)

   ;; "That" doesn't seem ambiguous at first, because it seems it must
   ;;  be referring to the total work involved, not the work required by
   ;;  just one of the plan steps (or a subset).  However, the user's
   ;;  response below indicates that "That" refers only to the action
   ;;  of moving/removing.

   (desirable_ (NOT (_to-degree_ (user-provides_ Typing) Much)))


;; 2-10 Advisor: Why?

   ;; I haven't worked these out yet.

;; 2-11 User: Removing a file would require typing a long file name (every
;;  time I wanted to remove a file using that subdirectory).

;; 2-12 Advisor: You can make "remove" an alias.
