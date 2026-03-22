
;; (setq repair-test1
;;      '( (b 1) (w) (b 2) (x) (b 3) (y) (b 4) (z) 
;;	  (e 1) (a) (e 2) (d) (e 3) (c) (e 4) ))

;; (setq repair-test2
;;      '( (b 1) (b 2) (x) (e 1) (y) (e 2) ))

;; This program untangles the mess of begin and end blocks in the original
;; adt meta-code examples.  An excellent example of why you should do things
;; right the first time.

(defun repair-prog ( prog )
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

	      ((eq (first (third stmt)) 'begin)   ; found a begin block
	       (let ( 
		     (block-id (second (third stmt)))
		     )
		 (setq new-prog (append new-prog (list stmt)))
		 (push block-id block-stack)
		 ))

	      ((eq (first (third stmt)) 'end)   ; found an end block
	       (let (
		     (end-id    (second (third stmt)))
		     (expect-id (first block-stack))  ; expect id is from stack
		     )

		 ;; End found is as expected ---------------------------------
		 (if (equal end-id expect-id) 
		     (progn     
		       (setq new-prog (append new-prog (list stmt)))
		       (pop block-stack)
		       )
		   ;; End not found as expected, so 
		   ;;  do end-id and expect-id match prev switched ends ?
		   (let* (
			  (match-prev
			   (member (list end-id expect-id) repl-list
				   :test #'(lambda (a b) 
				     (and (equal (first  a) (first  b))
					  (equal (second a) (second b)) )) ))
			  (repl-id (if match-prev 
				       (second (first match-prev)) nil))
			  )
		     (if repl-id
			 ;; end matches prev renamed end number ---------------
			 (progn
			   (setq new-prog 
				 (append new-prog (list (list 
					 'fix '(0 0) (list 'end repl-id)))))
			   (setq repl-list 
				 (remove-2 end-id expect-id repl-list))
			   (setq compl-code-add-list 
			     (cons
			      (get-expect-code code-add-list end-id expect-id)
			      compl-code-add-list))
			   (setq code-add-list 
				 (remove-2 end-id expect-id code-add-list))
			   (pop block-stack)			   
 			   )
		       ;; bad block found = end-id not = expect-id ------------
		       (progn 
			 (setq repl-list 
			       (cons (list expect-id end-id) repl-list))
			 (setq new-prog 
			  (append new-prog (list (list 
				  'MK expect-id end-id))))
			 (setq new-prog 
			       (append new-prog (list (list 
            			  'fix '(0 0) (list 'end  expect-id)))))
			 (setq code-add-list
			       (cons (list expect-id end-id) code-add-list))
			 (pop block-stack)         
			 ))))
		 ))
	      (t                    ; found some other block type
	       (progn
		 (setq new-prog (append new-prog (list stmt)))
		 (setq code-add-list (update-code-add-list code-add-list stmt))
		 ))
	     ) ; cond
	   (setq cur-pos (1+ cur-pos))	   ;; advance to next program statement
	   )) ; let*, loop

    ;; finally, add code back in to marked new-prog from compl-code-add-list
    (setq new-prog
	  (update-marked new-prog compl-code-add-list))

    new-prog   ; return repaired program
    )) ; let*, defun

;; ---------------------------------------------------------------------------

(defun update-marked (new-prog compl-code-add-list)
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
				       (equal (second at-a) (third  b))))))
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
	(find-it
	 (member (list end-id expect-id) code-add-list
		 :test #'(lambda (a b) 
			   (and (equal (first  a) (first  b))
				(equal (second a) (second b)) )) ))
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














