

(mofsf wltf ttm mtle-nbo sicoil)

	    (tcsp :template-id "users-terrain-template"
		  :situation-id "real-terrain-db"              
		  :load-real-terrain-db t
		  :output-file  nil
		  :long-output t
		  :debug-csp t
		  )

(setq *current-template*
'("users-terrain-template"
 (
  (CP2 (PLAIN) (4 5+)     (204 400 206 402))
  (CP1 (PLAIN) (2 3 4 5+) (204 380 206 382))
 )
(
 (LEG-LATERAL-SPACE (CP1 CP2) (1 2 3 4 5+)) 
 (LEG-CLEAR         (CP1 CP2))
 )
 NIL
))
(setq *template-object-list* (list *current-template*))

;  (CP2 (PLAIN) (4 5+)     (200 400 210 410))
;  (CP1 (PLAIN) (2 3 4 5+) (200 380 210 390))

; ---------------------------------------------------------------------------

;  (CP2 (PLAIN FOREST) (4 5+)     (190 400 230 430))
;  (CP1 (PLAIN FOREST) (2 3 4 5+) (190 370 220 390))

;  (CP2 (PLAIN FOREST) (4 5+)     (210 400 220 410))
;  (CP1 (PLAIN FOREST) (2 3 4 5+) (230 400 240 410))


(setq *current-template*
'("users-terrain-template"
 (

  (CP2  (PLAIN) (4 5+)     (200 400 210 410))
  (CP1 (PLAIN) (2 3 4 5+) (200 380 210 390))
 )
(
 (SEP               (CP1 CP2) (10 40))
 (LEG-LATERAL-SPACE (CP1 CP2) (3 4 5+)) 
 (LEG-CLEAR         (CP1 CP2))
 )
 NIL
))