(setq *output-stream* t)

(setq p1
      '( (b 1) (w) (b 2) (x) (b 3) (y) (b 4) (z) 
	  (e 1) (a) (e 2) (d) (e 3) (c) (e 4) ))

(setq p2
      '( (b 1) (b 2) (x) (e 1) (y) (e 2) ))

(setq p3 
      '( (b 1) (w) (e 1) (b2) (e 2) (x) (e 1) (y) (e 2) ))

(setq p4
      '( (x1) 
	 (b 1484) 
	 (x3) 
	 (x4) 
	 (w) 
	 (b 1328) 
	 (e 1484)
	 (x7)
	 (x8)
	 (x9)
	 (b 1427)
	 (e 1328)
	 (e 1427)
	 (x13)
	 (x14)
	 ))

(defun lrep () (load "Bkp/adt-repair-vanilla"))
(defun test1 () (lrep) (show-list (rpv p1)))
(defun test2 () (lrep) (show-list (rpv p2)))
(defun test3 () (lrep) (show-list (rpv p3)))
(defun test4 () (lrep) (show-list (rpv p4)))

;; This program untangles the mess of begin and end blocks in the original
;; adt meta-code examples.  An excellent example of why you should do things
;; right the first time.

(defun rpv ( prog )
  (let* (
	 (block-stack   nil)       ; 
	 (repl-list     nil)       ; ( (put-this for-this) ... )
	 (code-add-list nil)       ; ( (put-this for-this (add code)) ... ) 
	 (compl-code-add-list nil)  
	 (new-prog      nil)       ; 
	 (cur-pos       0)         ; 
	 (end-pos (length prog)) 
	 )
    (loop  (if (= cur-pos end-pos) (return))
	   (let* (  (stmt       (nth cur-pos prog))  )
	     (cond
	      ((eq (first stmt) 'b)   ;; FOUND BEGIN BLOCK
	       (let ( (block-id (second stmt)) )
		 (comment2 "FOUND BEGIN BLOCK: " block-id)
		 (setq new-prog (append new-prog (list stmt)))
		 (push block-id block-stack)
		 ))
	      ((eq (first stmt) 'e)  ;; FOUND END BLOCK
	       (let (
		     (end-id    (second stmt))
		     (expect-id (first block-stack))  )		 
		 (comment2 "FOUND END BLOCK: " end-id expect-id) 
		 (if (equal end-id expect-id) 
		     (progn      ;; FOUND END ID = EXPECTED
		       (comment2 "> FOUND END ID=EXPECTED: " end-id expect-id) 
		       (setq new-prog (append new-prog (list stmt)))
		       (pop block-stack)  )
		   (let* (       ;; FOUND END ID NOT = EXPECTED 
			  (repl-id   (second 
				      (find end-id repl-list
				        :test #'(lambda (x y)
						  (equal x (car y))))))
			  )
		     (comment2 "> FOUND END ID NOT=EXPECTED: " 
			                          end-id expect-id) 
		     (if repl-id   ;; CASE NOT1 : end match prev rename end 
			 (progn
			   (comment3 " > CASE NOT1: " end-id expect-id repl-id)
			   (setq new-prog 
				 (append new-prog (list (list 'e expect-id))))

			   (setq repl-list 
				 (remove-2 end-id expect-id repl-list))
			   (setq compl-code-add-list 
			     (cons
			      (get-expect-code code-add-list end-id expect-id)
			      compl-code-add-list))
			   (setq code-add-list 
				 (remove-2 end-id expect-id code-add-list))
			   (pop block-stack)   )
		       (progn     ;; CASE NOT2 : end not match prev rename end
			 (comment2 " > CASE NOT2: " end-id expect-id)
			 (setq repl-list 
			       (cons (list expect-id end-id) repl-list))
			 (setq new-prog 
			  (append new-prog (list (list 'MK expect-id end-id))))
			 (setq new-prog 
			       (append new-prog (list (list 'e expect-id))))

			 (setq code-add-list
			       (cons (list expect-id end-id) code-add-list))
			 (pop block-stack)         
			 )))) 		 ))
	      (t                    ; FOUND OTHER TYPE BLOCK
	       (progn
		 (comment2 "FOUND OTHER TYPE BLOCK: " (first stmt))
		 (setq new-prog (append new-prog (list stmt)))
		 (setq code-add-list (update-code-add-list code-add-list stmt))
		 ))
	      ) ; cond
	   (setq cur-pos (1+ cur-pos))	   ;; advance to next program statement
	   )) ; let*, loop

    ;; finally, add code back in to marked new-prog from compl-code-add-list
    (setq new-prog
	  (update-marked new-prog compl-code-add-list))

    ;; clean up left-over marks (ie the ones that were empty) 
    (setq new-prog (remove-marks new-prog))

    new-prog   ; return repaired program
    )) ; let*, defun

;; ---------------------------------------------------------------------------

(defun remove-marks (prog)
  (remove-if #'(lambda (x) (eq (first x) 'mk)) prog))

(defun update-marked (new-prog compl-code-add-list)

  (comment1 "UM: " compl-code-add-list)

  (if (null compl-code-add-list)
      new-prog
    (let* (
	   (this-repl (first compl-code-add-list))
	   (at-a      (list (first this-repl) (second this-repl)))
	   (isrt      (third this-repl))
	  )
      (update-marked 
       (in-place at-a new-prog isrt) (cdr compl-code-add-list)))))

(defun in-place (at-a in-list isrt)
  (let (
	(find-pos (position at-a in-list 
			    :test #'(lambda (a b) 
				      (and 
				       (equal (first b) 'mk)
				       (equal (first at-a)  (second b))
				       ))))
	)
    (if find-pos
	(progn
	  (append
	   (subseq in-list 0 find-pos)
	   isrt
	   (subseq in-list (1+ find-pos) (length in-list)))
	  )
      (progn
	(comment1 "Not found at-a = " at-a)
	nil
	))
  ))

(defun get-expect-code (code-add-list end-id expect-id)
  (let (
	(find-it (member  end-id code-add-list
			  :test #'(lambda (a b) (equal a (first b)))))
	)
    (if find-it
	(first find-it)
      (progn
	(comment1 "In code add-list = " code-add-list)
	(comment1 "Not found element for end-id = " end-id)
	(comment1 "                   expect-id = " expect-id)
	nil
	))))


(defun remove-2 ( e1 e2 lst )
    (remove-if #'(lambda (x) 
		   (and (equal e1 (first  x)) (equal e2 (second x))))
	       lst))

(defun update-code-add-list ( code-add-list stmt )
  (if (null code-add-list)
      nil
    (let (  (this (first code-add-list))  )
      (cons  (list (first this) (second this)
		(append (third this) (list stmt)))
	     (update-code-add-list (cdr code-add-list) stmt)) )))

;; ---------------------------------------------------------------------------

(defun comment1 (com &optional (var nil))
  (if (not (eq *output-stream* nil))
      (let ()
	(format *output-stream*	"~&> ~A " com)
	(format *output-stream* " < ~A > ~&" var)
	)) )

(defun show-list ( list1 )
  (format *output-stream* "~& List ... ~&")
  (dolist (this list1)
	  (format *output-stream* "Element = ~A ~&" this))
  (format *output-stream* "~& End List. ~&"))











