(defun repair-prog2 (prog Wposn)

  (comment1 "prog      = " prog)
  (comment1 "Wposn     = " Wposn)

  (let* (
	 (init-part    (subseq prog 0 (1+ Wposn)))
	 (d    (comment1 "init-part  = " init-part))
	 (findBposn  (find-b prog (1+ Wposn) (length prog) 0))
	 (x    (comment1 "findBposn = " findBposn))
	 (moveEs     (get-es prog Wposn findBposn nil))
	 (y    (comment1 "moveEs    = " moveEs))
	 (moveEids   (mapcar #'(lambda (x) (second (third x))) moveEs))
	 (zz   (comment1 "moveEids  = " moveEids))
	 )
    (if moveEs
	(let* (
	       (b-id       (second (third (nth findBposn prog))))
	       (z    (comment1 "b-id      = " b-id))
	       (findEposn  (find-e prog findBposn b-id)) 
	       (a    (comment1 "findEposn = " findEposn))
	       (remv-es-part 
		(remv-es (subseq prog (1+ Wposn) findEposn) moveEids))
	       (b    (comment1 "remv-es-pt = " remv-es-part))
	       (newTilEposn   (append  remv-es-part
				       (list (nth findEposn prog))))
	       (c    (comment1 "newTilEpos = " newTilEposn))
	       (remainder  (subseq prog (1+ findEposn) (length prog)))
	       (e (comment1 "remainder = " remainder))
	       (newprog (append init-part newTilEposn moveEs remainder))
	       )
	  (comment1 "++ Warn of RepairProg2 at Wposn = " Wposn)
	  (comment1 "             moved End elements = " moveEs)
	  newprog
	  )
      (progn
	(comment1 "++ Note no RepairProg2 reqd at Wposn = " Wposn)
	prog))))

(defun remv-es (subprog moveEids)
  (remove-if #'(lambda (x) (and 
			    (equal  (first  (third x)) 'e)  
			    (member (second (third x)) moveEids)))
	     subprog))

(defun get-es (prog posn last expect-es)
  (let (
	(sol-list nil)
	)
  (loop    (if (eq posn last) (return))
     (comment1 "posn = " posn)
     (let* (
	    (this-stmt (nth posn prog))
	    (stmt-type (first  (third this-stmt)))
	    (stmt-id   (second (third this-stmt)))
	   )
       (cond
	((eq stmt-type 'e)
	 (progn
           (comment1 "stmt E = " this-stmt)
	   (if (null expect-es)                           ; no e expected
	       (progn
		 (comment1 "add stmt to sol-list = " this-stmt)
		 (setq sol-list (append sol-list (list this-stmt)))
		 )
	     (if (eq (first expect-es) stmt-id)
		 (progn
		   (comment1 "pop = " (first expect-es))
		   (pop expect-es)
		   )
	       (progn
		 (comment2 "Unexpected E Err exp/fnd= " 
			   (first expect-es) stmt-id)
		 nil
		 )))))
	((eq stmt-type 'b)
	 (progn
           (comment1 "push stmt B = " this-stmt)
	   (push stmt-id expect-es)
	   ))
	(t 
	 (progn
           (comment1 "stmt OTHER = " this-stmt)
	   nil))
	))
     (setq posn (1+ posn))
     )
  sol-list ))

;; old version
(defun get-es-old (prog startpos endpos)
  (let ( (part (subseq prog startpos endpos)) )
    (remove-if #'(lambda (x) (not (equal (first (third x)) 'e)))
	       part)))

(defun find-b (prog posn last expect-bs)
  (if (eq posn last)
      nil
    (let (
	  (stmt-type  (first (third (nth posn prog))))
	  )
    (if (equal stmt-type 'b)
	(if (> expect-bs 0)
	    (find-b prog (1+ posn) last (1- expect-bs))
	  posn)
      (if (or (equal stmt-type 'w) (equal stmt-type 'f))
	  (find-b prog (1+ posn) last (1+ expect-bs))
	(find-b prog (1+ posn) last expect-bs) )))))  
	
;; old version
(defun find-b-old (prog posn)
  (position 'B prog :start posn 
	    :test #'(lambda (a b) (equal (first (third b)) a))))

(defun find-e (prog posn b-id)
  (position 'E prog   :start posn 
	    :test #'(lambda (a b) (and 
				   (equal (first (third b)) a)
				   (equal (second (third b)) b-id))))) 

;; ---------------------------------------------------------------------------

(setq l1 '( 
	   (0  2 (a))
	   (1  2 (d))
	   (2  2 (b 1))
	   (3  2 (z))
	   (6  2 (e 3))
	   (5  2 (y))
	   (4  2 (e 1))
	   (7  2 (t))
	   (8  2 (e 4))
	   ))

(setq x1 '( 
	   (0  2 (a))
	   (1  2 (b))
	   (2  2 (w))
	   (3  2 (x))
	   (4  2 (e 1))
	   (5  2 (y))
	   (6  2 (e 2))
	   (7  2 (z))
	   (8  2 (b 3))
	   (9  2 (u))
	   (10 2 (v))
	   (11 2 (p))
	   (12 2 (e 3)) 
	   (13 2 (c))
	   (14 2 (d))
	   ))

(setq x3 '( 
	   (0  2 (a))
	   (1  2 (a2))
	   (2  2 (w))             ;; <- current W in question
	   (3  2 (x))
	   (4  2 (e 1))           ;; <- e to move (ok)
	   (5  2 (y))
	                          ;; skip in searching for B for W ...
	   (6  2 (w))             ;; <- w XX move candidate occurs before b
	   (7  2 (b 9))           ;;    w begin 9
	   (8  2 (zz))            ;;    w body (anything b9->e9)
	   (9  2 (e 9))           ;;    w end   9

	                          ;; skip in searching for B for W ...
	   (10 2 (w))             ;; <- w YY move candidate occurs before b
	   (11 2 (yy))            ;;    w if then body (anything w->next b) 
	   (12 2 (b 10))          ;;    w else begin 10
	   (13 2 (zz))            ;;    w else body    (anything b10->e10)
	   (14 2 (e 10))          ;;    w else end   10

	   (15 2 (f))             ;; <- f
	   (16 2 (b 99))          ;;    f begin 9
	   (17 2 (zz))            ;;    f body (anything b9->e9)
	   (18 2 (e 99))          ;;    f end   9

	   (19 2 (y2))
	   (20 2 (e 2))           ;; <- e to move (ok)
	   (21 2 (z))
                                  ;; OUR w else begin body  
	   (22 2 (b 3))           ;; <- FIRST "w-unmatched" B
	   (23 2 (u))
	   (24 2 (v))
	   (25 2 (p))
	   (26 2 (e 3))           ;; OUR w else end body

                                  ;; <- insertion point for moved es (ok)

	   (27 2 (c))
	   (28 2 (d))

	   ))


;;  ---------------------------------------------------------------------------

(setq l1 '( 
	   (0  2 (a))
	   (1  2 (d))
	   (2  2 (b 1))
	   (3  2 (z))
	   (6  2 (e 3))
	   (5  2 (y))
	   (4  2 (e 1))
	   (7  2 (t))
	   (8  2 (e 4))
	   (9  2 (f)) 
	   ))

(setq l2 '( 
	   (0  2 (a))
	   (1  2 (d))
	   (2  2 (b 1))
	   (3  2 (z))
	   (4  2 (e 3))
	   (5  2 (b 9))
	   (6  2 (y2))
	   (7  2 (y))
	   (8  2 (e 9))
	   (9  2 (y3))
	   (10 2 (e 1))
	   (11 2 (t))
	   (12 2 (e 4))
	   (13 2 (f)) 
	   ))

(defun fix-inter (prog posn last)
  (let (
	(sol-list    nil)
	(bad-e-list  nil)
	(expect-es nil)
	)
  (loop    (if (eq posn last) (return))
     (comment1 "posn = " posn)
     (let* (
	    (this-stmt (nth posn prog))
	    (stmt-type (first  (third this-stmt)))
	    (stmt-id   (second (third this-stmt)))
	   )
       (cond
	((eq stmt-type 'e)
	 (progn
           (comment1 "stmt E = " this-stmt)
	   (if (null expect-es)                           ; no e expected, fnd
	       (progn
		 (comment1 "Bad e found, not expected = " this-stmt)
		 (setq bad-e-list (append bad-e-list (list this-stmt)))
		 )
	     (if (eq (first expect-es) stmt-id)          ; e expected
		 (progn
		   (comment1 "Good e found = " this-stmt)
		   (setq sol-list (append sol-list (list this-stmt)))
		   (pop expect-es)
		   )
	       (progn                                   ; e expect, bad fnd
		 (comment1 "Bad e found, diff expected = " this-stmt)
		 (setq bad-e-list (append bad-e-list (list this-stmt)))
		 )))))
	((eq stmt-type 'b)
	 (progn
           (comment1 "Begin stmt found = " this-stmt)
	   (setq sol-list (append sol-list (list this-stmt)))
	   (push stmt-id expect-es)
	   ))
	(t 
	 (progn
           (comment1 "Normal stmt fuond = " this-stmt)
	   (setq sol-list (append sol-list (list this-stmt)))
	   nil))
	))
     (setq posn (1+ posn))
     )
  (list bad-e-list sol-list)
  ))