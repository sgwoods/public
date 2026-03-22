;; utility.lisp
(defun cu () (compile-file "utility")  (load "utility"))

(setq *output-stream* *standard-output*)

;; **********************************************************************
;; Global var initialization

(defun set-globals ( raw-variables 
		     dom 
		     search-mode 
		     node-consis 
		     node-type-consis
		     node-force-all 
		     arc-consis
		     fc 
		     dr 
		     dfa-r
		     adv 
		     sortc 
		     adv-sortc
		     os 
		     cpu 
		     ckpt
		     debug 
		     debug-csp 
		     debug-node
		     output-file )

  ;; **********************************************************************
  ;; Parameter globals

  (setq *error* 0)

  (setq *repair-key* 'unset)
  (setq *input-file* 'unset)

  ;; (if (not (find-symbol "*terrain-realdb-loaded*"))
  ;;  (setq *terrain-realdb-loaded* nil))

  (if raw-variables
      (setq *raw-variables* raw-variables
	    *variables* 'not-yet-assigned
	    *var-order* (mapcar #'(lambda (x) (first x)) raw-variables)
	    *var-order-note* 'initial
	    *number-of-units* (length *raw-variables*) )
    (progn
      (setq *error* 1)
      (comment1 "Initial raw variables in error") ))

  ;; domain name
  (setq *domain-name* dom)    

  ;; search mode
  (setq *backjump* nil)
  (setq *backtrack* nil)
  (setq *backmark* nil)

  (setq *search-mode* search-mode)   

  (if (find *search-mode* '("bt" "bm" "bj" "qu" "gsat") :test #'equalp)
      (if (equal search-mode "bj")
	  (setq *backjump* t)
	(if (equal search-mode "bm")
	    (setq *backmark* t) 
	  (if (equal search-mode "bm")
	      (setq *backtrack* t)
	    (if (equal search-mode "gsat")
		(setq *gsat* t)
	      (if (equal search-mode "qu")
		  (setq *quilici* t) )))))
    (progn
      (setq *error* 2)
      (comment1 "Search mode in error" search-mode)))

  ;; node consistency
  (if (find node-consis '(t nil))
      (setq *node-consis* node-consis)
    (progn
      (setq *error* 3)
      (comment1 "Node consis in error" node-consis)))

  ;; node type consistency
  (if (find node-type-consis '(t nil))
      (setq *node-type-consis* node-type-consis)
    (progn
      (setq *error* 3.5) ;was 3b (no quote!) :DP 8/97
      (comment1 "Node Type consis in error" node-type-consis)))

  ;; node force all
  (if (find node-force-all '(t nil))
      (setq *node-force-all* node-force-all)
    (progn
      (setq *error* 4)
      (comment1 "Node force-all in error" node-force-all)))

  ;; arc consistency
  (if (find arc-consis '(nil before during both))
      (if (and (equal *search-mode* "qu")
	       (or (eq arc-consis 'during) (eq arc-consis 'both)))
	  (progn
	    (comment1 "Inconsistent arc-consis value with Quilici." arc-consis)
	    (setq *error* 4.5) )
	(setq *arc-consis* arc-consis))
    (progn
      (setq *error* 5)
      (comment1 "Arc consis in error" arc-consis)))

  ;; forward checking
  (if (find fc '(t nil))
      (setq *forward-checking* fc)
    (progn
      (setq *error* 6)
      (comment1 "Forward checking in error" fc)))

  ;; advance-sort (variables !!)
  (if (find adv '(t nil random quilici))
      (setq *advance-sort* adv)
    (progn
      (setq *error* 7)
      (comment1 "Advance sort in error" adv)))

  ;; sort-const (inline)
  (if (find sortc '(t nil random))
      (setq *sort-const* sortc)
    (progn
      (setq *error* 7.5)
      (comment1 "Sort Const in error" sortc)))

  ;; sort-const (in advance !!)
  (if (find adv-sortc '(nil random quilici))
      (setq *adv-sort-const* adv-sortc)
    (progn
      (setq *error* 7.7)
      (comment1 "Advance Sort Const in error" adv-sortc)))

  ;; dynamic rearrangement
  (if (find dr '(t nil))
      (setq *dynamic-rearrangement* dr)
    (progn
      (setq *error* 8)
      (comment1 "Dynamic rearrangement checking in error" dr)))

  ;; dfa rearrangement
  (if (find dfa-r '(t nil))
      (setq *dfa-rearrangement* dfa-r)
    (progn
      (setq *error* 8.5) ;was 8b (no quote!) :DP
      (comment1 "Data Flow Analysis rearrangement checking in error" dfa-r)))

  ;; one solution only
  (if (find os '(t nil))
      (setq *one-solution-only* os)
    (progn
      (setq *error* 9)
      (comment1 "One solution only in error" os)))

  ;; cpu limit
  (if (numberp cpu)
      (setq *cpu-sec-limit* cpu)
    (progn
      (setq *error* 10)
      (comment1 "Not numberp cpu limit" cpu)))

  ;; ckpt limit
  (if (numberp ckpt)
      (progn
	(setq *check-point-interval* ckpt
	      *this-check-point* ckpt) )
    (progn
      (setq *error* 11)
      (comment1 "Not numberp ckpt intercal" ckpt)))

  ;; debug
  (if (find debug '(t nil))
      (setq *debug* debug)
    (progn
      (setq *error* 12)
      (comment1 "Debug in error" debug)))

  ;; debug csp
  (if (find debug-csp '(t nil))
      (setq *debug-consis* debug-csp
	    *debug-ac* debug-csp
	    *debug-q* debug-csp )
    (progn
      (setq *error* 13)
      (comment1 "Debug-csp in error" debug-csp)))


  ;; debug node
  (if (find debug-node '(t nil))
      (setq *debug-node* debug-node)
    (progn
      (setq *error* 13.5) ;was 13b (no quote!) :DP 8/97
      (comment1 "Debug-node in error" debug-node)))

  ;; file output
  (setq *file-output* nil
	*whole-file-name* 
	(if *unix* 
	    (concatenate 'string "" output-file)
	  (concatenate
	   'string
	   "Macintosh HD:Languages:Allegro Common Lisp:qcsp:ADT-Batch:Test-"
	   output-file)))

  (setq *output-stream* 
	(cond ((or (eq output-file t) (null output-file)) 
	       *standard-output*)
	      ((equal output-file "no-output") nil)
	      (t 
	       (setq *file-output* t)
	       (comment1 "Opening output file/stream for :" *whole-file-name*)
	       (open *whole-file-name*
		     :direction :output 
		     :if-exists :append 
		     :if-does-not-exist :create)
	       )))

  ;; **********************************************************************
  ;; State globals

  (reset-node-id)  ;; reset search node counter

  ;; **********************************************************************
  ;; Result globals

  (setq *internal-end-time*   0
	*internal-start-time* 0

	*internal-advance-end-time*   0
	*internal-advance-start-time* 0
	
	*internal-sort-start-time*   0 
	*internal-sort-end-time*   0

	*node-consis-decision* nil
	*constraint-fail* nil
	*arc-constraint-fail* nil

	*satisfy-p-calls* 0
	*satisfy-p-cost* 0

	*constraint-cks* 0
	*node-consistency-checks* 0

	*node-consistency-cks-ok* 0
	*consistent-p-calls* 0
	*consistent-null-arcs* 0

	;; junk cut in to make stuff work ok
	*node-type-consistency-checks* 0
	*node-type-consistency-ck-ok* 0
	*node-type-consistency-ck-fail*  0

	*backtrack-nodes-created* 0
	*backjump-count* 0

	*ac-count-compat* 0
	*ac-count-notcompat* 0

	*nodes-visited* 0

	*for-check-calls* 0
	*for-check-cost* 0

	*dyn-rearr-calls* 0
	*dyn-rearr-cost*  0

	*dfa-rearr-calls* 0
	*dfa-rearr-cost*  0

	*type-a-savings* 0
	*type-b-savings* 0

	*solution-set* nil )

  (> *error* 0) )

;; ---------------------------------------------------------------------------

;; **********************************************************************
;; Recording functions
;;
;; *constraint-fail*  
;;     all cases where a constraint failed in consistent-p
;; *node-consis-decision*
;;     at assignment time, why a sit was rejected for a slot (all)

(defun explain ()
  (show-node-fail)
  (show-cons-fail) )

(defun record-fail (ts1 s1 ts2 s2 constraint)
  "Keep track of failed constraint justifications."
  (setq *constraint-fail*
	(append *constraint-fail*
		(list (list ts1 s1 ts2 s2 constraint)) )))

(defun show-cons-fail ()
  (format *output-stream* "~% Failed Constraint checks (ARC-pre) ... ~2%")
  (dolist (element *arc-constraint-fail*)
	  (format *output-stream* "~A ~%" element))

  (format *output-stream* "~% Failed Constraint checks (Search) ... ~2%")
  (dolist (element *constraint-fail*)
	  (format *output-stream* "~A ~%" element)) )

(defun record-node-fail (tslot-id sit-obj-id match-type match-orient
				  match-activity match-abs-loc match-size)
  "Keep track of failed node domain assignments."
  (setq *node-consis-decision*
	(append *node-consis-decision*
		(list
		 (list (list tslot-id sit-obj-id)
		       (list match-type match-orient 
			     match-activity match-abs-loc
			     match-size ))))))

(defun explain-node-fail (ts1 s1)
  "Return node consistent rejection if it exists for ts1 assigned s1."
  (assoc (list ts1 s1) *node-consis-decision* :test #'equalp) )

(defun abort-fail (commentIn)
  (format *output-stream* 
	  "~&~& ABORT :: ~A ~&" commentIn) )


(defun show-node-fail ()
  (format *output-stream*
	  "~% Node consistency checks ... ~%~
	   ~%      Slot Value         Type  Size   Act  Or   Loc~2%" )
  (dolist (element *node-consis-decision*)
	  (format *output-stream*
		  "~5T<~A~11T~A>~25T~A~31T~A~37T~A~43T~A~49T~A~%"
		  (first  (first element))
		  (second (first element))
		  (first (second element))
		  (second (second element))
		  (third (second element))
		  (fourth (second element))
		  (fifth (second element)) )))

(defun var-set-characterize (var-set &optional (where 'default) )
  (let* ((var-lengths (get-var-lengths var-set))    ;; -> ((var length) ... )
	 (max    (max-var-domain-size var-lengths)) ;; -> (var max-size)
	 (min    (min-var-domain-size var-lengths)) ;; -> (var min-size)
	 (avg    (avg-var-domain-size var-lengths)) ;; -> avg-size
	 )
    (unless *single-line-override*
	    (format *output-stream*
		    "Domain size ( ~A ) statistics ... ~%~
		     Max[~A]  Min[~A]  Avg[~A] ~2%"
		    where max min avg ))))

(defun get-var-lengths (var-set)
  (mapcar
   #'(lambda (var-alist)
       (list (first var-alist)            ;variable
	     (length (rest var-alist)) )) ;domain size
   var-set ))

(defun max-var-domain-size (var-size-pairs &aux (var nil) (max-domain-size 0))
  (dolist (var-size-pair var-size-pairs)
	  (when (> (second var-size-pair) max-domain-size)
		(setq max-domain-size (second var-size-pair)
		      var             (first var-size-pair) )))
  (list var max-domain-size) )

(defun min-var-domain-size (var-size-pairs
			    &aux (var nil)
			    (min-domain-size (second (car var-size-pairs))) )
  (dolist (var-size-pair var-size-pairs)
	  (when (< (second var-size-pair) min-domain-size)
		(setq min-domain-size (second var-size-pair)
		      var             (first var-size-pair) )))
  (list var min-domain-size) )

(defun avg-var-domain-size (var-len)
  (let ((total   0)
	(count   (length var-len)) )
    (if (= count 0)
	0
      (progn
	(dolist (element var-len)
	  (incf total (second element)) )
	(/ (* total 1.0) ;coerce to floating-point format? :DP
	   count )))))
  
;; **********************************************************************
;; Utility functions

(defun l () (load "load"))
(defun c () (compile-all))
(defun lm () (load "mpr-simple"))
(defun la () (load "adt-simple") (load "adt-setup"))
(defun lyja () (load "yj-adt-simple") (load "yj-adt-setup"))
(defun lqueens   () (load "queens"))
(defun lmpr () (load "mpr-simple") (load "mpr-setup"))
(defun ltcsp () (load "terrain-simple") (load "terrain-setup"))

(defun create-node-id ()
  "create new node identifier"
  (incf *last-node*) )

(defun reset-node-id (&optional (val 0))
  "reset to zero node identifier"
  (setq *last-node* val) )

(defun show-options ()
  (unless (or (null *output-stream*)
	      *single-line-override* )
	  (format *output-stream*
		  "~&~&***** OPTIONS for CSP ( ~A ) ***** ~2&" *domain-name*)

	  (when (eq *domain-loaded* 'mpr)
		(format *output-stream*
			"~&~& Situation id         :   ~A ~&~
     		         ~&~& Situation noise add  :   ~A ~&~
		         ~&~& Total Situation Size :   ~A ~&~
		         ~&~& Template id          :   ~A ~&~
		         ~&~& Template Size        :   ~A ~&~
		         ~&~& Distribution id      :   ~A ~&"
			*sit-object-id*
			*situation-noise-added*
			(length *current-situation*)
			*template-id*
			(length (second *current-template*))
			*random-dist-name* )
		(show-dist)

		(format *output-stream*
			"~&~& Num of constraints   :   ~A ~2&" 
			(length (get-templ-constraints *current-template*)) ))

	  (when (eq *domain-loaded* 'adt)
		(format *output-stream*
			"~&~& Situation id         :   ~A ~&~
	  	         ~&~& Situation noise add  :   ~A ~&~
		         ~&~& Total Situation Size :   ~A ~&~
		         ~&~& Template id          :   ~A ~&~
		         ~&~& Template Size        :   ~A ~&~
		         ~&~& Distribution id      :   ~A ~&"
			*sit-object-id*
			*situation-noise-added*
			(length *current-situation*)
			*template-id*
			(length (second *current-template*))
			*random-dist-name* )
		(show-dist)

		(format *output-stream*
			"~&~& Num of constraints   :   ~A ~2&" 
			(length (get-templ-constraints *current-template*)) ))

	  (format *output-stream*
		  "~&~& Search Mode          : ~A ~&~
		   ~&~& Node Consis Mode     : ~A ~&~
		   ~&~& Node Type Cons Mode  : ~A ~&~
		   ~&~& Node Force all       : ~A ~&~
		   ~&~& Arc  Consis Mode     : ~A ~&~
		   ~&~& Forward Checking     : ~A ~&~
		   ~&~& Dynamic Rearrangement: ~A ~&~
		   ~&~& DFA     Rearrangement: ~A ~&~
		   ~&~& Advance sort option  : ~A ~&~
		   ~&~& Inline  sort cstr opt: ~A ~&~
		   ~&~& Advance sort cstr opt: ~A ~&~
		   ~&~& Backjump option      : ~A ~&~
		   ~&~& One Solution Only    : ~A ~&~
		   ~&~& CPU Seconds limit    : ~A ~&~
		   ~&~& CK Point interval    : ~A ~&~
		   ~&~& Debug                : ~A ~&~
		   ~&~& Debug CSP            : ~A ~2&"
		  *search-mode*
		  *node-consis*
		  *node-type-consis*
		  *node-force-all*
		  *arc-consis*
		  *forward-checking*
		  *dynamic-rearrangement*
		  *dfa-rearrangement*
		  *advance-sort*
		  *sort-const*
		  *adv-sort-const*
		  *backjump*
		  *one-solution-only*
		  *cpu-sec-limit*
		  *check-point-interval*
		  *debug*
		  *debug-consis* )

	  (when (eq *domain-loaded* 'mpr)
		(format *output-stream*
			"~&~& Random Ident         : ~A ~&~
		         ~&~& Spatial Cohes Prune  : ~A ~2&"
			*random-ident*
			*constraint-sch-on* ))

	  (when (eq *domain-loaded* 'adt)
		(format *output-stream*
			"~&~& Random Ident         : ~A ~&" *random-ident* ))

	  ;; repair-key flag
	  (format *output-stream*
		  "~&~& Repair Key           : ~A ~&" *repair-key*)

	  ;; noise added level
	  (format *output-stream*
		  "~&~& Noise Added          : ~A ~&" *Situation-noise-added*)
	  
	  ;; input file *input-file*
	  (format *output-stream*
		  "~&~& Input  File          : ~A ~&" *input-file*)
	  ;; output file 
	  (format *output-stream*
		  "~&~& Output File          : ~A ~2&" *whole-file-name*)
	  ))

(defun rl () (load "load"))
(defun doc (f) (documentation f 'function))

;; **********************************************************************
;;

(defun show-bt-state (bt-state)
  (show-state        
   :node-id           (bt-state-node-id bt-state)
   :prev-node-id      (bt-state-prev-node-id bt-state)
   :partial-solution  (bt-state-partial-solution bt-state)
   :symbol            (bt-state-symbol bt-state)
   :value             (bt-state-value bt-state)
   :domain            (bt-state-domain bt-state)
   :variables-left    (bt-state-variables-left bt-state)
   :arc-cost          (bt-state-arc-cost bt-state)
   :depth             (bt-state-depth bt-state)
   :max-fail-level    (bt-state-max-fail-level bt-state)
   :parent-state      (bt-state-parent-state bt-state)
   :where             'show-bt-state) )

(defun show-state (&key (node-id  nil)
			(prev-node-id  nil)
			(partial-solution nil)
			(symbol nil)
			(value nil)
			(domain nil)
			(variables-left nil)
			(arc-cost nil)
			(depth nil)
			(max-fail-level nil)
			(parent-state nil)
			(where 'nowhere)
			&aux par-out )

  (when *output-stream*
	(format *output-stream*
		"~&~&***** ~A State Description ***** ~2&~
		 ~&~& Node id: ~A ~&~
		 ~&~& Partial solution: ~A ~&~
		 ~&~& Symbol: ~A ~&~
		 ~&~& Symbol value: ~A ~&~
		 ~&~& Domain: ~A ~&~
		 ~&~& Variables left: ~A ~&~
		 ~&~& Arc Cost: ~A ~&~
		 ~&~& Depth: ~A ~&~
		 ~&~& Max fail level: ~A ~&"
		where
		node-id
		partial-solution
		symbol
		value
		domain
		variables-left
		arc-cost
		depth
		max-fail-level )
	(if prev-node-id
	    (setq par-out prev-node-id)
	  (setq par-out 'None) )
	(format *output-stream*
		"~&~& Prev Node id: ~A ~&~
		 ~&~& Parent id: ~A ~2&"
		par-out
		parent-state )))

(defun comment (com)
  (when *output-stream*
	(format *output-stream*	"~&> ~A ~& " com) ))

(defun comment1 (com &optional (var nil))
  (when *output-stream*
	(format *output-stream*	"~&> ~A  < ~A > ~&"
		com var )))

(defun comment1s (com &optional (var nil))
  (when *output-stream*
	(format *output-stream*	"~2&> ~A  < ~A > ~&"
		com var )))

(defun comment2 (com &optional (var nil) (var2 nil))
  (when *output-stream*
	(format *output-stream*	"~&> ~A  < ~A, ~A > ~&"
		com var var2 )))

(defun comment3 (com &optional (var nil) (var2 nil) (var3 nil))
  (when *output-stream*
	(format *output-stream*	"~&> ~A  < ~A, ~A, ~A > ~&"
		com var var2 var3 )))

(defun comment4 (com &optional (var nil) (var2 nil) (var3 nil) (var4 nil))
  (when *output-stream*
	(format *output-stream*	"~2&> ~A  < ~A, ~A, ~A, ~A > ~&"
		com var var2 var3 var4 )))

(defun comment5 (com &optional (var nil) (var2 nil) (var3 nil) (var4 nil)
		    (var5 nil) )
  (when *output-stream*
	(format *output-stream*	"~2&> ~A  < ~A, ~A, ~A, ~A, ~A > ~&"
		com var var2 var3 var4 var5 )))

(defun comment6 (com &optional (var nil) (var2 nil) (var3 nil) (var4 nil)
		    (var5 nil) (var6 nil) )
  (when *output-stream*
	(format *output-stream*	"~2&> ~A  < ~A, ~A, ~A, ~A, ~A, ~A > ~&"
		com var var2 var3 var4 var5 var6 )))

(defun show-dist ()
	(format *output-stream*	"~&~& Distributions    : ~&" )
	(dolist (this *random-dist*) 
		(format *output-stream* "~A ~&" this))  )





;         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7

;123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789--123456789--123456789-

;Size	Mo/NC /AC /FC /DR   Ident	Dsize	NCC	TCC	BT/V	    AP      S	     Total    NumS    BJ   TypA/B    FCcost    DRcost    ASort/AStime ConsSort AdvSrtC ReprKey NdTypeCs DFAcst

(defun write-single-header ()
  (format *output-stream* 
	  "~A~9T~A/~12T~A/~16T~A/~20T~A/~24T~A~29T~A~41T~A~49T~A~57T~A~65T~A/~A~76T~A~84T~A~92T~A~101T~A~109T~A~114T~A/~A~124T~A~135T~A~144T~A/~A~156T~A~165T~A~174T~A~183T~A~192T~A~&" 
	  "Size" "Mo" "NC" "AC" "FC" "DR" "Ident" "Dsize" "NCC" "TCC" "BT" "V" "AP" "S" "Total" "NumS" "BJ" "TypA" "B" "FCcost" "DRcost"  "AS" "AStime" "ConsSort" "AdvSrtC" "ReprKey" "NdTypCs" "DFAcst") )



(defun show-solution (&key (solution-set *solution-set*) 
			   (exit-location 'repeat)
			   (replace-values  nil)
			   (memory-key      nil) )
  (let ((override-output (or *single-line-override* memory-key)))

    ;; This option resets the global variables for printing
    ;; primarily called from memory-csp.lisp with this option
    (if (not (null replace-values))
	(reload-values replace-values)
      ;;
      ;; standard case - compute these values right now rather than from saved
      ;;
      (progn
	(setq *RECALL-avg-var-len*    
	      (get-avg-var-len (get-var-lengths *variables*)))
	(setq *RECALL-adv-proc-time*  
	      (/ (- *internal-advance-end-time* 
		    *internal-advance-start-time*)
		 (* 1.0 internal-time-units-per-second))) 
	(setq *RECALL-search-time* 			
	      (/ (- *internal-end-time* *internal-start-time*)
		 (* 1.0 internal-time-units-per-second)))
	(setq *RECALL-total-time* 			
	      (/ (- *internal-end-time* *internal-advance-start-time*)
		 (* 1.0 internal-time-units-per-second)))
	(setq *RECALL-adv-sort-time* 
	      (/ (- *internal-sort-end-time* *internal-sort-start-time*)
		 (* 1.0 internal-time-units-per-second)))
	))

    (if override-output
	(progn
	  ;; Output single line for compilation of test results only
	  ;;  if single line suppressed, output only the solution
	  (if (not (eq *output-stream* nil)) 
	      (let (
		    (num-sols (length solution-set))
		    )
		(setq *solution-set* solution-set)

		(if (or (not *suppress-single-line*) memory-key)
		    (progn
		      (if *long-output*
			  (write-single-header))

		      (format *output-stream* 
			      "~A~9T~A/~12T~A/~16T~A/~20T~A/~24T~A~29T~A~41T~A~49T~A~57T~A~65T~A / ~A~76T~A~84T~A~92T~A~101T~A~109T~A~114T~A/~A~124T~A~135T~A~144T~A/~A~156T~A~165T~A~174T~A~183T~A~192T~A~&" 
			      (length *current-situation*)
			      *search-mode*
			      *node-consis*
			      *arc-consis*
			      *forward-checking*
			      *dynamic-rearrangement* 
			      *random-ident*
			      *RECALL-avg-var-len*
			      *node-consistency-checks*
			      *constraint-cks*
			      *backtrack-nodes-created*
			      *nodes-visited*
			      *RECALL-adv-proc-time* 
			      *RECALL-search-time* 
			      *RECALL-total-time*
			      num-sols
			      *backjump-count*
			      *type-a-savings*
			      *type-b-savings*
			      *for-check-cost*
			      *dyn-rearr-cost*
			      *advance-sort*
			      *RECALL-adv-sort-time* 
			      *sort-const* 
			      *adv-sort-const* 
			      *repair-key*
			      (if *node-type-consis* 
				  *node-type-consistency-checks* nil)
			      *dfa-rearr-cost*
			      )
		      ))

		(if (and *file-output* 
			 (not (eq exit-location 'CHECKPOINT))
			 (not memory-key))
		    (progn
		      (close *output-stream*)
		      (setq *output-stream* *standard-output*)
		      (setq *file-output* nil)
		      (format *output-stream*
			      "~&~& File Closed (at 1). ~2&"))) 
		) ;; let
	    ;; else case ... return solution set only
	    ) ;; if
	  )  ;; progn

      ;; resume normal programming in this case !
      (show-solution1 solution-set exit-location) )) )


(defun show-solution1 (solution-set exit-location)
  "Show output values at end. ALL DOMAIN VERSIONS."

  (let ((print-long
	 (or (eq exit-location 'repeat) 
	     *file-output*
	     *long-output* ))
	)
    (setq *solution-set* solution-set)

    (when *output-stream*
	  (let ((num (length solution-set))
		(desc-string
		 (if (equal *search-mode* "bt")
		     'Backtrack
		   (if (equal *search-mode* "bj")
		       'BackJump
		     (if (equal *search-mode* "bm")
			 'BackMark
		       (if (equal *search-mode* "qu")
			   'quilici
			 'Error )))))
		)
	    (format *output-stream*
		    "~&~&***** ~A Information ***** ~2&~
		     ~&~& Exit Location    : ~A ~&~
		     ~&~& No. Solutions    : ~A ~&"
		    desc-string
		    exit-location
		    (length solution-set) )
	    (when (and (> num 0)
		       print-long )
		  (format *output-stream* "~&~& Solutions... ~&")
		  (dolist (sol solution-set)
			  (format *output-stream* "~A ~&" sol) ))
	    (when *node-consis*
		  ;;(format *output-stream*
		  ;;"~&~& Node Consis. calls : ~A ~&" *node-consistency-calls*)
		  (format *output-stream*
			  "~&~& Node Consis. cks   : ~A ~&~
	                   ~&~& Node Type Cons cks : ~A ~&~
	                   ~&~& Node Type Cons ok  : ~A ~&~
	                   ~&~& Node Type Cons fail: ~A ~&"
			  *node-consistency-checks*
			  *node-type-consistency-checks*
			  *node-type-consistency-ck-ok*
			  *node-type-consistency-ck-fail* )
		  (when (and print-long (eq *domain-loaded* 'mpr))
			(format *output-stream*
				"~&~&   >Matches-type       : ~A ~&~
	                         ~&~&   >Matches-orient     : ~A ~&~
	                         ~&~&   >Matches-activity   : ~A ~&~
	                         ~&~&   >Matches-abs-loc    : ~A ~&~
	                         ~&~&   >Matches-size       : ~A ~&"
				*ts-match-type-count*
				*ts-match-orient-count*
				*ts-match-activity-count*
				*ts-match-abs-loc-count*
				*ts-match-size-count* ))
		  (when (and print-long (eq *domain-loaded* 'tcsp))
			(format *output-stream*
				"~&~&   >Matches-type       : ~A ~&~
	                         ~&~&   >Matches-radial     : ~A ~&~
	                         ~&~&   >Matches-abs-loc    : ~A ~&"
				*ts-match-type-count*
				*ts-match-radial-count*
				*ts-match-abs-loc-count* ))
		  ) ;when
	    (when print-long
		  (format *output-stream*
			  "~&~& Satisfy-p calls  : ~A ~&~
		           ~&~& Satisfy-p cost   : ~A ~&~
		           ~&~& Consistent calls : ~A ~&"
			  *satisfy-p-calls*
			  *satisfy-p-cost*
			  *consistent-p-calls* )
		  (when (eq *domain-loaded* 'mpr)
			(format *output-stream*
				"~&~&     >Consistent nulls : ~A ~&~
		                 ~&~&     >Unique restricts : ~A ~&"
				*consistent-null-arcs*
				*unique-restrict-count* )))
	    (format *output-stream*
		    "~&~& Ttl constr chks  : ~A ~&" *constraint-cks*)
	    (when (and (or (eq *domain-loaded* 'mpr)
			   (eq *domain-loaded* 'tcsp) )
		       print-long )
		  (format *output-stream*
			  "~&~&    >AC     compat results: ~A ~&~
	                   ~&~&    >AC not compat results: ~A ~&~
	                   ~&~&    >Spatial Cohes cks: ~A ~&~
	                   ~&~&    >Spatial Cohes savings : ~A ~&~
	                   ~&~&    >Leg Clear cks   : ~A ~&~
	                   ~&~&    >Leg Lat Spc cks : ~A ~&~
	                   ~&~&    >X Greater Than cks : ~A ~&~
	                   ~&~&    >Y Greater Than cks : ~A ~&~
	                   ~&~&    >Separation cks   : ~A ~&~
	                   ~&~&    >Positional cks   : ~A ~&~
	                   ~&~&    >Medial cks       : ~A ~&~
	                   ~&~&    >Echelon cks      : ~A ~&~
   	                   ~&~&    >Same type cks    : ~A ~&~
   	                   ~&~&    >Same orient cks  : ~A ~&~
 	                   ~&~&    >Same activity cks: ~A ~&~
 	                   ~&~&    >Same size cks    : ~A ~&"
			  *ac-count-compat*
			  *ac-count-notcompat*
			  *constraint-sch-cks*
			  *sch-save*
			  *constraint-legclr-cks*
			  *constraint-leglatspc-cks*
			  *constraint-xgt-cks*
			  *constraint-ygt-cks*
			  *constraint-sep-cks*
			  *constraint-pos-cks*
			  *constraint-med-cks*
			  *constraint-ech-cks*
			  *constraint-same-type-cks*
			  *constraint-same-orient-cks*
			  *constraint-same-activity-cks*
			  *constraint-same-size-cks* ))
	    (when (and (eq *domain-loaded* 'adt) print-long)
		  (format *output-stream*
			  "~&~&    >AC     compat results: ~A ~&~
	                   ~&~&    >AC not compat results: ~A ~&~
	                   ~&~&    >Before-p cks         : ~A ~&~
	                   ~&~&    >Same-name-p cks      : ~A ~&~
	                   ~&~&    >Close-to-p cks       : ~A ~&~
   	                   ~&~&    >Same type cks        : ~A ~&"
			  *ac-count-compat*
			  *ac-count-notcompat*
			  *constraint-before-cks*
			  *constraint-same-name-cks*
			  *constraint-close-to-cks*
			  *constraint-same-type-cks* ))
	    (if (equal *search-mode* "qu")
		(format *output-stream*
			"~&~& Quilici open states created : ~A ~&"
			*backtrack-nodes-created* )
	      (format *output-stream*
		      "~&~& BT nodes created : ~A ~&~
	               ~&~& Nodes visited    : ~A ~&"
		      *backtrack-nodes-created*
		      *nodes-visited* ))
	    (when *backjump*
		  (format *output-stream*
			  "~&~& Backjumps        : ~A ~&" *backjump-count*))
	    (when *backmark*
		  (format *output-stream*
			  "~&~& BM Type-A Savings : ~A ~&~
		           ~&~& BM Type-B Savings : ~A ~&"
			  *type-a-savings*
			  *type-b-savings* ))
	    (when *forward-checking*
		  ;;(format *output-stream*
		  ;;        "~&~& Forward ck calls : ~A ~&" *for-check-calls*)
		  (format *output-stream*
			  "~&~& Forward ck cost  : ~A ~&" *for-check-cost* ))
	    (when *dynamic-rearrangement*
		  ;;(format *output-stream*
		  ;;        "~&~& Dyn Rearr calls  : ~A ~&" *dyn-rearr-calls*)
		  (format *output-stream*
			  "~&~& Dyn Rearr cost   : ~A ~2&" *dyn-rearr-cost* ))
	    (when *dfa-rearrangement*
		  ;;(format *output-stream*
		  ;;        "~&~& DFA Rearr calls  : ~A ~&" *dfa-rearr-calls*)
		  (format *output-stream*
			  "~&~& DFA Rearr cost   : ~A ~2&" *dfa-rearr-cost* ))
	    (format *output-stream*
		    "~2&Advance Processing CPU Seconds: ~D ~&" 
		    (/ (- *internal-advance-end-time*
			  *internal-advance-start-time* )
		       (* 1.0 internal-time-units-per-second) ))
	    (when *advance-sort*
		  (format *output-stream* 
			  "Advance Sort       CPU Seconds: ~D ~&" 
			  (/ (- *internal-sort-end-time*
				*internal-sort-start-time* )
			     (* 1.0 internal-time-units-per-second) )))
	    (format *output-stream*
		    "Search             CPU Seconds: ~D ~&" 
		    (/ (- *internal-end-time* *internal-start-time*)
		       (* 1.0 internal-time-units-per-second) ))
	    (format *output-stream* 
		    "Total              CPU Seconds: ~D ~2&" 
		    (/ (- *internal-end-time* *internal-advance-start-time*)
		       (* 1.0 internal-time-units-per-second) ))
	    (when (and *file-output*
		       (not (eq exit-location 'CHECKPOINT)) )
		  (close *output-stream*)
		  (setq *output-stream* *standard-output*)
		  (setq *file-output* nil)
		  (format *output-stream* "~&~& File Closed (at 2). ~2&") )
	    ))))

(defun show-backmark ()
  (format *output-stream*
	  "~&~& DoList Count       : ~A ~&~
	   ~&~& GreaterEqual Count : ~A ~&~
	   ~&~& Loop Count         : ~A ~&~
	   ~&~& BackMark Calls     : ~A ~2&"
	  *dolist-count*
	  *greater-equal-count*
	  *loop-count*
	  *backmark-calls* ))

(defun show-bm-bt-state ( U F &optional (where 'default) )
  (when *output-stream*
	(format *output-stream*
		"~&~&***** ~A BackMark BT State ***** ~2&~
	         ~&~& U       : ~A ~&~
	         ~&~& F       : ~A ~& -------------- ~2&"
		where
		(get_U U)
		F )))

(defun show-bm-visit-state ( U F_U F Mark LowUnit &optional (where 'default) )
  (when *output-stream*
	(format *output-stream*
		"~&~&***** ~A BackMark Visit State ***** ~2&~
	         ~&~& U       : ~A ~&~
	         ~&~& F_U     : ~A ~&~
	         ~&~& F       : ~A ~&~
	         ~&~& LowUnit : ~A ~&~
	         ~&~& Mark ... ~&"
		where
		(get_U U)
		F_U
		F
		LowUnit )
	(dolist (mark1 mark) (format *output-stream* "~A ~&" mark1))
	(format *output-stream*  " +++++++++++++++ ~2&") ))

;; **************************************************
;; Random accessor functions

(defun num-to-string ( num )
  "Positive numbers only."
  (if (< num 10)
      (num-to-letter num)
    (let* ((rest-digits (truncate (/ num 10.0)))
	   (last-digit  (- num (* 10 rest-digits))) )
      (concatenate 'string
		   (num-to-string rest-digits)
		   (num-to-letter last-digit) ))))

(defun num-to-letter ( num )
  (case num
	(0 "0")
	(1 "1")
	(2 "2")
	(3 "3")
	(4 "4")
	(5 "5")
	(6 "6")
	(7 "7")
	(8 "8")
	(9 "9") ))

(defun select-type (type sit)
  "Return locational information only as tuples for a given type."
  (and sit
       (let* ((this-item (car sit))
	      (this-type (third this-item)) )
	 (if (eq type this-type)
	     (append 
	      (list (list (first (second this-item))
			  (second (second this-item)) ))
	      (select-type type (cdr sit)) )
	   (select-type type (cdr sit)) ))))


;; **************************************************
;; Additional utility selection functions 

(defun select-all-type (type &optional (sit *current-situation*) )
  "Return situational object set with this type."
  (and sit
       (let* ((this-item (car sit))
	      (this-type (third this-item)) )
	 (if (eq type this-type)
	     (append
	      (list this-item)
	      (select-all-type type (cdr sit)) )
	   (select-all-type type (cdr sit)) ))))


(defun select-all-loc (&optional (xmin 0) (xmax 0) (ymin 0) (ymax 0)
				 (sit *current-situation*) )
  "Return situational object set satisfying this x y location range.
   ...  SPATIAL DOMAIN  x, y ...."
  (and sit
       (let* ((this-item (car sit))
	      (this-loc (second this-item))
	      (this-x   (first this-loc))
	      (this-y   (second this-loc)) )
	 (if (and (<= xmin this-x)
		  (>= xmax this-x)
		  (<= ymin this-y)
		  (>= ymax this-y) )
	     (append
	      (list this-item)
	      (select-all-loc xmin xmax ymin ymax (cdr sit)) )
	   (select-all-loc xmin xmax ymin ymax (cdr sit)) ))))
 

(defun list-element-pos (list element)
  (let* ((listlen (length list))
	 (mem     (member element list))
	 (memlen  (length mem)) )
    (1+ (- listlen memlen)) ))


(defun constraint-exists-p (c-type  &optional (c *constraints*))
  (not (null (find c-type
		   (mapcar #'(lambda (x) (first x))
			   c )))))

(defun in-range (number number-range-list)
  "True if element number is in number-range-list '(x y)"
  (let ((min (first  number-range-list))
	(max (second number-range-list)) )
    (and (>= number min)
	 (<= number max) )))

(defun member-count (element list)
  (member-count-fn element list 1))

(defun member-count-fn (element list n)
  (if (null list)
      -1
    (if (eq element (caar list))
	n
      (member-count-fn element (cdr list) (1+ n)) )))



;; line number maintenance routines

(defun gen-nums-to ( min max )
  (if (= min max)
      (list min)
    (cons min (gen-nums-to (1+ min) max)) ))

(defun remove-nums ( nums lst )
  (if (null nums)
      lst
    (remove-if #'(lambda (x) (equal x (car nums)))
	       (remove-nums (cdr nums) lst))))

(defun get-orig-nums ( orig-sit )
  (mapcar #'(lambda (x) (second x)) orig-sit))

(defun get-orig-nums2 ( orig-sit )
  (mapcar #'(lambda (x) (second (second x))) orig-sit))

; ---------------------------------------------------------------------------

(defun remove-dest-num ( num )
  (setq *line-number-set*
	(remove-if #'(lambda (x) (equal x num)) *line-number-set*)))

(defun get-line-number ()
  (let* (
	 (sz  (length *line-number-set*))
	 (ps  (random-position sz))
	 (val (nth ps *line-number-set*))
	)
    (remove-dest-num val)
    val
    ))

(defun get-specific-line ( num )
"
 Get the desired line or the nearest one available (increasing).
"
  ;; extend number set if requesting a number outside the range
  (if (> num *max-line-number*)
      (let* (
	     (new-nums (gen-nums-to (1+ *max-line-number*) (+ 100
							      *max-line-number*)))
	     )
	
	(setq *max-line-number* (+ 100 *max-line-number*))
	(setq *line-number-set* (append *line-number-set* new-nums))
	))

  (if (member num *line-number-set*)
      (progn
	(remove-dest-num num)
	num
	)
    (get-specific-line (1+ num)) ))

(defun get-max ( nums n )
  (if (null nums)
      n
    (if (> (car nums) n)
	(get-max (cdr nums) (car nums))
      (get-max (cdr nums) n))))

(defun remove-var (var varset)
" DFA Update April 28/97
  return varset with var entry removed "
  (remove-if #'(lambda (x) (equal var (car x))) varset))