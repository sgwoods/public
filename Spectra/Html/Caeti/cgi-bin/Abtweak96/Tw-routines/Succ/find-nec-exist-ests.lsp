; Tw-routines/Succ/find-nec-exist-ests.lsp

; written by steve woods and qiang yang 1990


;*********************** exist - nec establishers ************************

(defun find-nec-exist-ests (plan u p)
  "Tw-routines/Succ/find-nec-exist-ests.lsp  (oct 11 yr?)
   returns ( (est1 plan-with-cost-added) ...) "
   (declare (type plan plan) (type list u) (type list p))

   (mapcar #'(lambda (nec-est &aux (newplan (make-copy-of-plan plan)))

	       ;; DEBUG!  Nov22/96 
	       ;; DEBUG - this flag is not settable from the planner interface
	       (when *plan-debug-mode*
		     (format *output-stream*
			     "~%>>>~
  			      ~%>>> Parent: ~S   Child: ~S~
			      ~%>>>~
		              ~%>>> Considering effect:~
		              ~%>>>      ~S~
		              ~%>>> of EXISTINGn op: ~S~
		              ~%>>> to satisfy precondition:~
		              ~%>>>      ~S~
		              ~%>>> of op: ~S~
                              ~%>>>"
			     (plan-id plan) (plan-id newplan)
			     'foo nec-est p u))

	       (list nec-est newplan)
	       )
	   (find_establishers plan u p) ))

;; Here is a nice version of the above with no debug requirements (Nov 22/96)
;;   (mapcar #'(lambda (nec-est)
;;	       (list nec-est (make-copy-of-plan plan)))
;;	   (find_establishers plan u p)) )

