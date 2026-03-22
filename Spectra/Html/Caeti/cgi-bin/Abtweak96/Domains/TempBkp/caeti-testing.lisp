

;;
;; INITIAL -> MOFSF -> CMF -> TTM -> MTLE -> ECOIL -> GOAL
;;

;; Initial
;; in-stat-formation( White   cp1         Herringbone   $security  $exec-speed  $mo-speed )

;; Step 1
;; MOFSF var unify    $group  $leg-start  $sform        $security  $exec-speed  $mv-out-speed 

;; MOFSF var unbound  leg-start, method, tform
;; MOFSF ASSERT
;; (started-on-leg $group $leg $leg-start MoveFrom $tform $method)
;;                 White  cp1  $u         c        $u     $u)
;;
;; (not in-stat-formation $group $leg-start $sform       $security $exec-speed $mv-out-speed)
;;                        White   cp1        Herringbone $u        $u          $u

; ---------------------------------------------------------------------------
;
; initial state
;
(setq initial '( 
		(in-stat-formation White cp1 Herringbone $security $exec-speed $mo-speed)
		))


; ---------------------------------------------------------------------------
;
; goal state
;
(setq goal '(
 	     (started-on-leg White $leg cp1 MoveFrom $tform $method)
	     ))

(setq goal2 '(
	     (FILTER-MOVE-ORDER-GIVEN-TO WHITE CP1 MOVEFROM $TFORM $METHOD)
	     ))


;;  (plan initial goal :planner-mode 'mr :debug-mode t)
;;  (plan initial goal :planner-mode 'mr :debug-mode t :control-strategy 'dfs)
;;  (plan initial goal :planner-mode 'mr )
;;  (plan initial goal :planner-mode 'mr :control-strategy 'dfs)
;;  (find-conflicts *cs*)
(defun fc () (find-conflicts *cs*))
(defun suc () (successors&costs *cs*)) 

(setq ip1 (tw-make-initial-plan initial goal))

(setq p-index1 (determine-user-and-precond ip1))
(setq user1    (first  p-index1))
(setq precond1 (second p-index1))
(setq fee1  (find-exist-ests ip1 user1 precond1))
(setq fne1  (find-new-ests   ip1 user1 precond1))  

(setq ip2 (successors ip1))
(setq ip2a (first ip2))
(setq p-index2 (determine-user-and-precond ip2a))


(setq user2    (first  p-index2))
(setq precond2 (second p-index2))
(setq fee2  (find-exist-ests ip2a user2 precond2))
(setq fne2  (find-new-ests   ip2a user2 precond2))  

(setq ip3 (successors ip2a))
(setq ip3a (first ip3))
(setq ip3b (second ip3))

(setq p-index3a (determine-user-and-precond ip3a))
(setq user3a    (first  p-index3a))
(setq precond3a (second p-index3a))
(setq fee3a  (find-exist-ests ip3a user3a precond3a))
(setq fne3a  (find-new-ests   ip3a user3a precond3a))  

(setq p-index3b (determine-user-and-precond ip3b))
(setq user3b    (first  p-index3b))
(setq precond3b (second p-index3b))
(setq fee3b  (find-exist-ests ip3b user3b precond3b))
(setq fne3b  (find-new-ests   ip3b user3b precond3b))  


;; ---------------------------------------------------------------------------
;; ---------------------------------------------------------------------------

(defun lct () (load "Domains/caeti-testing"))
(defun pcr () (plan-cr *solution*))

