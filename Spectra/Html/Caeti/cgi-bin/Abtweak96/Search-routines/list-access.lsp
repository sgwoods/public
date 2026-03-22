; Search-routines/list-access.lsp

; open and closed list rountines
; both open and closed are implemented using priority lists
;
; an open list is a list of sorted sublists.  each sublist is
; of the form: (priority (node1 node2 ...)).

(defun get-next-open-node ()
   "Search-routines/list-access
    returns the node on open with the least cost"
   (car (second (car *open*) )))

(defun remove-first-node (list)
   "Search-routines/list-access"
   (let* ((first-sub-list (car *open*))
	  (sub-list-of-nodes 
	   (cdr (second first-sub-list))))
     (if (null sub-list-of-nodes)
	 (cdr *open*)
       (cons (list (first first-sub-list)
		   sub-list-of-nodes)
	     (cdr *open*) ))))

(defun add-node-to-open-list (node)
  (setq *open* (add-node-to-open-list2 node *open*)) )

(defun add-node-to-open-list2 (node open-list)
   "Search-routines/list-access
    inserts node into list-of-nodes either by 
       bfs - least   cost first only. "
   (declare (type node node1) (list list-of-nodes))

   (let ((nodes-alist-elem (car open-list))
	 (priority1 (node-priority node))
	 priority2 )
     (cond ((null open-list)
	    (list (list priority1 (list node))) )
	   ((= (setq priority2 (first nodes-alist-elem))
	       priority1 )
	    (cons (list priority2 ;v list of same-priority nodes
			(cons node (second nodes-alist-elem)) )
		  (cdr open-list) ))
	   ((> priority2 priority1) 
	    (cons (list priority1 (list node))
		  open-list ))
	   (t (cons
	       nodes-alist-elem
	       (add-node-to-open-list2 node (cdr open-list)) )))))

;******************* peek open functions.

(defun length-of-open ()
   "Search-routines/list-access"
  (apply #'+ 
	 (mapcar #'length 
		 (mapcar #'second *open*))))

(defun first-of-open ()
   "Search-routines/list-access"
  (first (second (first *open*))))

(defun last-of-open ()
   "Search-routines/list-access"
   (first (second (car (last *open*)))))


