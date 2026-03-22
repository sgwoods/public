
;; (defconstant *situations*      sgw March/97 compatability backwards w adt

(setq *situations*
  (list
   '( "terrain-1"
      ( sit1-9  (1 9)  Plain 5+ )
      ( sit2-9  (2 9)  Plain 5+ )
      ( sit3-9  (3 9)  Plain 5+ )
      ( sit4-9  (4 9)  Mountain 0 )
      ( sit5-9  (5 9)  Mountain 0 )
      ( sit6-9  (6 9)  Plain 5+ )
      ( sit7-9  (7 9)  Plain 5+ )
      ( sit8-9  (8 9)  Plain 5+ )

      ( sit1-8  (1 8)  Plain 5+ )
      ( sit2-8  (2 8)  Plain 5+ )
      ( sit3-8  (3 8)  Mountain 0 )
      ( sit4-8  (4 8)  Mountain 0 )
      ( sit5-8  (5 8)  Plain 5+ )
      ( sit6-8  (6 8)  Plain 5+ )
      ( sit7-8  (7 8)  Mountain 0 )
      ( sit8-8  (8 8)  Mountain 0 )
      
      ( sit1-7  (1 7)  Mountain 0 )
      ( sit2-7  (2 7)  Mountain 0 )
      ( sit3-7  (3 7)  Mountain 0 )
      ( sit4-7  (4 7)  Forest 5+ )
      ( sit5-7  (5 7)  Plain 5+ )
      ( sit6-7  (6 7)  Mountain 0 )
      ( sit7-7  (7 7)  Mountain 0 )
      ( sit8-7  (8 7)  Mountain 0 )
      
      ( sit1-6  (1 6)  Plain 5+ )
      ( sit2-6  (2 6)  Mountain 0 )
      ( sit3-6  (3 6)  Plain 5+ )
      ( sit4-6  (4 6)  Plain 5+ )
      ( sit5-6  (5 6)  Plain 5+ )
      ( sit6-6  (6 6)  Mountain 0 )
      ( sit7-6  (7 6)  Mountain 0 )
      ( sit8-6  (8 6)  Plain 5+ )
      
      ( sit1-5  (1 5)  Mountain 0 ) ; minefield actually
      ( sit2-5  (2 5)  Plain 5+ )
      ( sit3-5  (3 5)  Plain 5+ )
      ( sit4-5  (4 5)  Plain 5+ )
      ( sit5-5  (5 5)  Plain 5+ )
      ( sit6-5  (6 5)  Plain 5+ )
      ( sit7-5  (7 5)  Plain 5+ )
      ( sit8-5  (8 5)  Plain 5+ )
      
      ( sit1-4  (1 4)  Mountain 0 ) ; minefield actually
      ( sit2-4  (2 4)  Mountain 0 ) ; minefield actually
      ( sit3-4  (3 4)  Mountain 0 ) ; minefield actually   
      ( sit4-4  (4 4)  Plain 5+ )
      ( sit5-4  (5 4)  Plain 5+ )
      ( sit6-4  (6 4)  Plain 5+ )
      ( sit7-4  (7 4)  Plain 5+ )
      ( sit8-4  (8 4)  Plain 5+ )
      
      ( sit1-3  (1 3)  Mountain 0 ) ; minefield actually   
      ( sit2-3  (2 3)  Mountain 0 ) ; minefield actually   
      ( sit3-3  (3 3)  Mountain 0 ) ; minefield actually   
      ( sit4-3  (4 3)  Plain 5+ )
      ( sit5-3  (5 3)  Plain 5+ )
      ( sit6-3  (6 3)  Forest 5+ )
      ( sit7-3  (7 3)  Plain 5+ )
      ( sit8-3  (8 3)  Plain 5+ )
      
      ( sit1-2  (1 2)  Plain 5+ )
      ( sit2-2  (2 2)  Plain 5+ )
      ( sit3-2  (3 2)  Plain 5+ )
      ( sit4-2  (4 2)  Plain 5+ )
      ( sit5-2  (5 2)  Plain 5+ )
      ( sit6-2  (6 2)  Plain 5+ )
      ( sit7-2  (7 2)  Forest 5+ )
      ( sit8-2  (8 2)  Plain 5+ )
      
      ( sit1-1  (1 1)  Plain 5+  1)
      ( sit2-1  (2 1)  Plain 5+ )
      ( sit3-1  (3 1)  Plain 5+ )
      ( sit4-1  (4 1)  Plain 5+ )
      ( sit5-1  (5 1)  Plain 5+ )
      ( sit6-1  (6 1)  Plain 5+ )
      ( sit7-1  (7 1)  Plain 5+ )
      ( sit8-1  (8 1)  Plain 5+ )
      )
   ))

;; ---------------------------------------------------------------------------

;; (defconstant *distributions*    sgw March/97
(setq *distributions*
  '(
    ( "terrain-dist1" 
      ( (Mountain 1) (Plain 3) (Forest 2) )
      ( (Minefield 1) (Clear 5) )
      )
    ))

;; ---------------------------------------------------------------------------

;; slotid  terrain-type
;;
;;(defconstant *template-object-list*    sgw March/97 
(setq *template-object-list*           
  (list 
   '( "terrain-templ1"
      (
       (cp1 (Plain Forest) (2 3 4 5+) * )
       (cp2 (Plain Forest) (4 5+)     * )
       )
      (
       (sep               (cp1 cp2) (8 9))
       (leg-clear         (cp1 cp2) )
       (leg-lateral-space (cp1 cp2) (4))
       )
      ( )  ; radial component localities
      )
   '( "terrain-templ1b"
      (
       (cp1 (Plain Forest) (2 3 4 5+) * )
       (cp2 (Plain Forest) (4 5+)     * )
       )
      (
       (sep               (cp1 cp2) (8 9))    ; will need preferentials here 
       (xloc-greater-than (cp1 cp2) )
       (yloc-greater-than (cp1 cp2) )
       (leg-clear         (cp1 cp2) )
       (leg-lateral-space (cp1 cp2) (4))
       )
      ( )  ; radial component localities
      )
   '( "terrain-templ1c"
      (
       (cp1 (Plain Forest) (2 3 4 5+) * )
       (cp2 (Plain Forest) (4 5+)     * )
       )
      (
       (sep               (cp1 cp2) (5 9))
       (leg-clear         (cp1 cp2))
       (leg-lateral-space (cp1 cp2) (4))
       )
      ( )  ; radial component localities
      )
   '("terrain-templ-dp1"
      ((cp1 (Plain Forest) (2 3 4 5+) *)
       (cp2 (Plain Forest) (4 5+)     *) )
      ((sep               (cp1 cp2) (8 9))
       (leg-clear         (cp1 cp2))
       (leg-lateral-space (cp1 cp2) (4)) )
      () )
   ))

;=======================================================

#|
;; **********************************************************************
;; All situation options
(defconstant *situations*
      (list
       '( "terrain-1"
	     ( sit1-1  (1 1)  Plain 5+ )
	     ( sit1-2  (1 2)  Plain 5+ )
	     ( sit1-3  (1 3)  Plain 5+ )
	     ( sit1-4  (1 4)  Mountain 0 )
	     ( sit1-5  (1 5)  Mountain 0 )
	     ( sit1-6  (1 6)  Plain 5+ )
	     ( sit1-7  (1 7)  Plain 5+ )
	     ( sit1-8  (1 8)  Plain 5+ )

	     ( sit2-1  (2 1)  Plain 5+ )  
	     ( sit2-2  (2 2)  Plain 5+ )
	     ( sit2-3  (2 3)  Mountain 0 )
	     ( sit2-4  (2 4)  Mountain 0 )
	     ( sit2-5  (2 5)  Plain 5+ )
	     ( sit2-6  (2 6)  Plain 5+ )
	     ( sit2-7  (2 7)  Mountain 0 )
	     ( sit2-8  (2 8)  Mountain 0 )

	     ( sit3-1  (3 1)  Mountain 0 )  
	     ( sit3-2  (3 2)  Mountain 0 )
	     ( sit3-3  (3 3)  Mountain 0 )
	     ( sit3-4  (3 4)  Forest 5+ )
	     ( sit3-5  (3 5)  Plain 5+ )
	     ( sit3-6  (3 6)  Mountain 0 )
	     ( sit3-7  (3 7)  Mountain 0 )
	     ( sit3-8  (3 8)  Mountain 0 )

	     ( sit4-1  (4 1)  Plain 5+ )  
	     ( sit4-2  (4 2)  Mountain 0 )
	     ( sit4-3  (4 3)  Plain 5+ )
	     ( sit4-4  (4 4)  Plain 5+ )
	     ( sit4-5  (4 5)  Plain 5+ )
	     ( sit4-6  (4 6)  Mountain 0 )
	     ( sit4-7  (4 7)  Mountain 0 )
	     ( sit4-8  (4 8)  Plain 5+ )

	     ( sit5-1  (5 1)  Mountain 0 ) ; minefield actually
	     ( sit5-2  (5 2)  Plain 5+ )
	     ( sit5-3  (5 3)  Plain 5+ )
	     ( sit5-4  (5 4)  Plain 5+ )
	     ( sit5-5  (5 5)  Plain 5+ )
	     ( sit5-6  (5 6)  Plain 5+ )
	     ( sit5-7  (5 7)  Plain 5+ )
	     ( sit5-8  (5 8)  Plain 5+ )

	     ( sit6-1  (6 1)  Mountain 0 ) ; minefield actually
	     ( sit6-2  (6 2)  Mountain 0 ) ; minefield actually
	     ( sit6-3  (6 3)  Mountain 0 ) ; minefield actually   
	     ( sit6-4  (6 4)  Plain 5+ )
	     ( sit6-5  (6 5)  Plain 5+ )
	     ( sit6-6  (6 6)  Plain 5+ )
	     ( sit6-7  (6 7)  Plain 5+ )
	     ( sit6-8  (6 8)  Plain 5+ )

	     ( sit7-1  (7 1)  Mountain 0 ) ; minefield actually   
	     ( sit7-2  (7 2)  Mountain 0 ) ; minefield actually   
	     ( sit7-3  (7 3)  Mountain 0 ) ; minefield actually   
	     ( sit7-4  (7 4)  Plain 5+ )
	     ( sit7-5  (7 5)  Plain 5+ )
	     ( sit7-6  (7 6)  Forest 5+ )
	     ( sit7-7  (7 7)  Plain 5+ )
	     ( sit7-8  (7 8)  Plain 5+ )

	     ( sit8-1  (8 1)  Plain 5+ )  
	     ( sit8-2  (8 2)  Plain 5+ )
	     ( sit8-3  (8 3)  Plain 5+ )
	     ( sit8-4  (8 4)  Plain 5+ )
	     ( sit8-5  (8 5)  Plain 5+ )
	     ( sit8-6  (8 6)  Plain 5+ )
	     ( sit8-7  (8 7)  Forest 5+ )
	     ( sit8-8  (8 8)  Plain 5+ )

	     ( sit9-1  (9 1)  Plain 5+ )  
	     ( sit9-2  (9 2)  Plain 5+ )
	     ( sit9-3  (9 3)  Plain 5+ )
	     ( sit9-4  (9 4)  Plain 5+ )
	     ( sit9-5  (9 5)  Plain 5+ )
	     ( sit9-6  (9 6)  Plain 5+ )
	     ( sit9-7  (9 7)  Plain 5+ )
	     ( sit9-8  (9 8)  Plain 5+ )
	     )
       ))

;; ---------------------------------------------------------------------------

(defconstant *distributions*
      '(
	( "terrain-dist1" 
	  ( (Mountain 1) (Plain 3) (Forest 2) )
	  ( (Minefield 1) (Clear 5) )
	  )
	))

;; ---------------------------------------------------------------------------

;; slotid  terrain-type
;;
(defconstant *template-object-list* 
      (list 
       '( "terrain-templ1"
	  (
	   (cp1 (Plain Forest) (2 3 4 5+) * )    
	   (cp2 (Plain Forest) (4 5+)     * )    
	   )
	  (
	   (sep               (cp1 cp2) (8 9))
	   (leg-clear         (cp1 cp2) )    
	   (leg-lateral-space (cp1 cp2) (4))
	   )
	  ( )  ; radial component localities
	  )
       '( "terrain-templ1b"
	  (
	   (cp1 (Plain Forest) (2 3 4 5+) * )    
	   (cp2 (Plain Forest) (4 5+)     * )    
	   )
	  (
	   (sep               (cp1 cp2) (8 9))
	   (xloc-greater-than (cp1 cp2) )
	   (yloc-greater-than (cp1 cp2) )
	   (leg-clear         (cp1 cp2) )    
	   (leg-lateral-space (cp1 cp2) (4))
	   )
	  ( )  ; radial component localities
	  )
       '( "terrain-templ1c"
	  (
	   (cp1 (Plain Forest) (2 3 4 5+) * )    
	   (cp2 (Plain Forest) (4 5+)     * )    
	   )
	  (
	   (sep               (cp1 cp2) (5 9))
	   (leg-clear         (cp1 cp2))    
	   (leg-lateral-space (cp1 cp2) (4))
	   )
	  ( )  ; radial component localities
	  )
       ))
|#
