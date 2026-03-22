(defun node-consistent-variables (variable-list &key (force nil) )
"
Accept domain variable list, return the list in node 
 consistent form only.  This dramatically reduces search
 in a single pass.
"
(format *standard-output* "check point ncv 1 processing:~&")

 ;; node if *terrain-realdb-loaded* we are assuming that
 ;;  type info pre-calculated in domain set-up

  (let ( (newvarlist nil) )
    (dolist (node variable-list newvarlist)
      (setq newvarlist 
	    (append 
	     newvarlist
	     (list (node-consistent-one-node node :force force)) ))
      )))

(defun node-consistent-one-node ( node &key (force nil) )
"
Accept a node defined by a variable and its domain and return that node
 with the domain filtered by applying the node consistency check to 
 each possible domain value.
 node = (slot sit1 sit2 ... sitn)
"

(if *debug-dot* (format *standard-output* "~&Var = ~A~&" (first node)))

(let (
      (variable (car node))
      (domain   (cdr node))
      (newnode  (list (car node)))
      )
  (dolist (domval domain newnode)
    (if (node-consistent-p variable domval :force force)
	(progn
	  (if *debug-dot* (output-80 "+"))   
	  (setq newnode (append newnode (list domval)))
	  )
      (progn
	(if *debug-dot* (output-80 "-"))
	nil
	)))))
