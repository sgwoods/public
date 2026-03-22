;; coll-utils.lsp
;; A collection (coll) can be NIL, a single element, or a list* of elements

(defun listify (coll1) ;To be used only if no coll fn can be written
  ;; (a . b) -> (a b)
  ;;       a -> (a)
  ;;   (a b) -> (a b)
  (and coll1
       (if (consp coll1)
	   (cons (car coll1) (listify (cdr coll1)))
	 (list coll1) )))

(defun length-1 (coll1)
  ;;     nil -> 0
  ;;       a -> 1
  ;;     (a) -> 2
  ;; (a . b) -> 3
  ;;   (a b) -> 4 = 2 * length
  (if coll1
      (if (consp coll1)
	  (+ 2 (length-1 (cdr coll1)))
	1 )
    0 ))

(defun position-1 (item1 coll1 coll2) ;find the equivalent of item1 in coll2
  (if (consp coll1)
      (or (and (eq item1 (car coll1))
	       (car coll2) )
	  (position-1 item1 (cdr coll1) (cdr coll2)) )
    (and (eq item1 coll1)
	 coll2 )))

(defun some-1 (fn1 coll1)
  (and coll1
       (if (consp coll1)
	   (or (funcall fn1 (first coll1))
	       (some-1 fn1 (rest coll1)) )
	 (funcall fn1 coll1) )))

(defun every-1 (fn1 coll1)
  (and coll1
       (if (consp coll1)
	   (and (funcall fn1 (first coll1))
		(every-1 fn1 (rest coll1)) )
	 (funcall fn1 coll1) )))

(defun find-1 (item1 coll1 &key (test #'eq))
  (declare (function test))
  (and coll1
       (if (consp coll1)
	   (or (funcall test item1 (first coll1))
	       (find-1 item1 (rest coll1) :test test) )
	 (funcall test item1 coll1) )))

(defun find-if-1 (fn1 coll1)
  (declare (function fn1))
  (and coll1
       (if (consp coll1)
	   (or (funcall fn1 (car coll1))
	       (find-if-1 fn1 (cdr coll1)) )
	 (funcall fn1 coll1) )))

(defun remove-1 (item1 coll1)
  (if (consp coll1)
      (if (eq item1 (car coll1))
	  (cdr coll1)
	(if (consp (cdr coll1))
	    (cons (car coll1) (remove-1 item1 (cdr coll1)))
	  (if (eq item1 (cdr coll1))
	      (car coll1)
	    coll1 )))
    (if (eq item1 coll1)
	nil ;bad: will result in a list instead of a list*
      coll1 )))

(defun mapc-1 (fn1 coll1) ;coll is single node or list* of nodes
  (declare (function fn1))
  (and coll1
       (if (consp coll1)
	   (prog1 'diddly
	     (funcall fn1 (car coll1))
	     (mapc-1 fn1 (cdr coll1)) )
	 (funcall fn1 coll1) )))

(defun mapcar-1 (fn1 coll1)
  (declare (function fn1))
  (and coll1
       (if (consp coll1)
	   (cons (funcall fn1 (car coll1))
		 (mapcar-1 fn1 (cdr coll1)) )
	 (funcall fn1 coll1) )))


(defun non-nil-intersection (coll1 coll2 &key (test #'eq))
  (some-1
   #'(lambda (x) (find-1 x coll2 :test test))
   coll1 ))

(defun subsetp-1 (coll1 coll2 &key (test #'eq))
  (every-1
   #'(lambda (x) (find-1 x coll2 :test test))
   coll1 ))
