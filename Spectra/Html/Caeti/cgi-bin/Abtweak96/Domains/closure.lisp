
;; Steve Woods- (12/96) examples of "closure" use for avoidance of global
;;   variables - thus achieving information hiding  - note functions
;;   are now easily configured (even dynamically) to behave in a particular
;;   way - ie "state" may be preserved

;; closure of a value x 

(let (
      (x 0)              ;; attribute
      )

  (defun testfunc ()     ;; method-like behaviour
    (print 
     (setf x (1+ x))))    

  (defun getfunc ()       ;; accessor-like behaviour 
    (print  x))
  )

;; use it
;; (testfunc)   ; increment
;; (getfunc)    ; access  or print in this case
;;


;; example 2 - update a constant list that could have been global

(let (
      (list-d '(- @ *))   ;; for example, a list of delimiters that may change 
      )

  (defun get-list-d ()    ;; functions that depend on the delimiter list 
    list-d)               ;;   note changes to the list occur once, and
                          ;;   most nb - no globals, and list-d can only
                          ;;   change as a result of calling accessors

  (defun is-d (a)
    (member a list-d))

  (defun update-d (b)
    (setf list-d (cons b list-d)))

  )

;; use it
;;(is-d '#)   ;; not a delimiter
;;(is-d '@)   ;; is a delimiter
;;(update-d '%)  ;; add a new delimiter


;; example 3 - maintain a tree/graph/etc with structure embedded in the
;;  closure

(let (
      (table-of-parents (make-hash-table ))
      )
  
  (defun parent-of (child)
    (gethash child table-of-parents))

  (defun make-parent (child parent)
    (setf (gethash child table-of-parents)
	  parent))

  )

;; ie define
;;(make-parent 'steve 'dorothy)
;;(make-parent 'dorothy 'elizabeth)
;;(make-parent 'elizabeth 'oreilly)

;; then call
;;(get-parent 'steve)