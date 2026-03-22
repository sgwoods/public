;; "96"

(defun try6 ()
  (let* (
	 (repair-1 (repair-all-prog2 test-dat6))
	 (repair-2 (repair-prog      repair-1))
	 (repair-3 (repair-prog-for  repair-2))
	 )	
    (setq *r1* repair-1)(setq *r2* repair-2)(setq *r3* repair-3)
    (show-list *r3*)))

(setq test-dat6
'(
 (|sit-gen1482| (119 805)   (ASSIGN FIRSTARRAYI |var-name1401| |var-name1430|))
 (|sit-gen1362| (120 806)   (NOT-EQUALS FIRSTREAL FIRSTREAL |var-name1330|))
 (|sit-gen1483| (121 813)   (BEGIN |block1484|))
 (|sit-gen1319| (122 824)   (ASSIGN FIRSTARRAYR FIRSTINT FIRSTREAL))
 (|sit-gen1322| (123 826)   (ASSIGN |var-name1318| |var-name1318|))
 (|sit-gen1326| (124 834)   (WHILE |var-name1330|))
 (|begin-sid1327| (125 835) (BEGIN |block1328|))
 (|sit-gen1485| (126 836)   (END |block1484|))
 (|sit-gen1425| (127 840)   (FOR |var-name1430| 12 8))
 (|sit-gen1403| (128 841)   (DECL INT |var-name1404|))
 (|sit-gen1342| (129 842)   (CHECK FIRSTINT FIRSTINT))
 (|begin-sid1428| (130 844) (BEGIN |block1427|))
 (|end-sid1329| (131 846)   (END |block1328|))
 (|end-sid1429| (132 847)   (END |block1427|))
 (|other-sid1426| (133 848) (INCREMENT FIRSTARRAYI |var-name1422|))
 (|sit-gen1351| (134 868)   (ASSIGN |var-name1318| |var-name1330|))
))

;; *r2* = 
;; Element 0 = (sit-gen1482 (119 805)   (ASSIGN FIRSTARRAYI var-name1401 var-name1430)) 
;; Element 1 = (sit-gen1362 (120 806)   (NOT-EQUALS FIRSTREAL FIRSTREAL var-name1330)) 
;; Element 2 = (sit-gen1483 (121 813)      (BEGIN block1484)) 
;; Element 3 = (sit-gen1319 (122 824)      (ASSIGN FIRSTARRAYR FIRSTINT FIRSTREAL)) 
;; Element 4 = (sit-gen1322 (123 826)      (ASSIGN var-name1318 var-name1318)) 
;; Element 5 = (sit-gen1326 (124 834)      (WHILE var-name1330)) 
;; Element 6 = (begin-sid1327 (125 835)       (BEGIN block1328)) 
;; Element 7 = (sit-gen1425 (127 840)         (FOR var-name1430 12 8))       << = For to delete 
;; Element 8 = (sit-gen1403 (128 841)         (DECL INT var-name1404)) 
;; Element 9 = (sit-gen1342 (129 842)         (CHECK FIRSTINT FIRSTINT)) 
;; Element 10 = (FIX (0 0)                    (END block1328)) 
;; Element 11 = (sit-gen1425 (127 840)     (FOR var-name1430 12 8))          << = For to keep
;; Element 12 = (sit-gen1403 (128 841)     (DECL INT var-name1404))          << = l to mv
;; Element 13 = (sit-gen1342 (129 842)     (CHECK FIRSTINT FIRSTINT))        << = l to mv
;; Element 14 = (begin-sid1428 (130 844)      (BEGIN block1427))             
                                                                             << = mv dest
;; Element 15 = (FIX (0 0)                    (END block1427))              
;; Element 16 = (FIX (0 0)                 (END block1484)) 
;; Element 17 = (other-sid1426 (133 848)(INCREMENT FIRSTARRAYI var-name1422)) 
;; Element 18 = (sit-gen1351 (134 868)  (ASSIGN var-name1318 var-name1330)) 
