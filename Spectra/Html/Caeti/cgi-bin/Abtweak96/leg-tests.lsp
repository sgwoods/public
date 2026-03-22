
(defun test1 () ;for LEG 1
  (plan '((390 175)
	  (IN-STAT-FORMATION WHITE (390 175) herringbone $security16 0.0))
	'(cp15 (AT-LOCATION WHITE cp15 $exec-time17)
	       (MOVING-ALONG-LEG WHITE (390 175) cp15 $security18
				 $method19))
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:required-ops (create-requireds-list
		       '(MTLEFNBO CWSAFD NTM TICF MOFSF) )
	:print-output-p t
	:plan-debug-mode t ))

(defun test2 () ;for LEG 2
  (plan '(cp15 (AT-LOCATION WHITE cp15 $exec-time17)
	       (MOVING-ALONG-LEG WHITE (390 175) cp15 $security18
				 $method19))
	'(cp20 (STOPPED-AT WHITE cp20 $exec-time21))
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:required-ops (create-requireds-list
		       '(DAPAA TWBO MFLS) ) ;removed 'mtle-bo
	:print-output-p t
	:plan-debug-mode t ))

(defun test3 () ;for LEG 3
  (plan '(cp20 (STOPPED-AT WHITE cp20 $exec-time21))
	'(cp14
	  (IN-STAT-FORMATION WHITE cp14 COIL $security23 $exec-time22))
	:subgoal-determine-mode 'closest-to-initial
	:exist-est-heuristic 'diff-stage-nece-and-poss
	:required-ops (create-requireds-list
		       '(MTLEFNBO NBD TWO TIvF SICF MOFSBO) )
	:print-output-p t
	:plan-debug-mode t ))
