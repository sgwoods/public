;; load.lsp

(setq *load-verbose* nil)  ;; no loading messages
(defvar *unix* t)

(defun ladt-all ()
  (load "adt-simple")    ;; functionality
  (load "adt-setup")     ;; template, situation information
  (load "adt-translate") ;; repair gen'd meta code, translate into C equiv
  )

(defun load-adt ()
  (loadit) (ladt-all))

(defun lcaeti-all ()
  (load "terrain-simple")   ;; functionality
  (load "terrain-setup")    ;; template, situation information
  (load "terrain-setup-dp") ;; template, situation information
  (load "caeti-db-all")     ;; database array for map
  (load-mapdb)
  )

(if (not *unix*)
    (progn   ;; prepare any flags, etc for Macintosh specific control

      (setq *output-stream* t)  ;; force output stream definition

      ))

(defun loadit (&optional (sys *unix*) )
  (if sys                ;; unix load
    (progn
      (load "bm")
      (load "bt")
      (load "ct")
      (load "gsat")

      (load "utility")
      (load "compile")

      ;; load Queens domain
      ;; (load "queens")   

      ;; load MPR domain
      ;;(load "mpr-simple")   ;; functionality
      ;;(load "mpr-setup")    ;; template, situation information

      ;; load ADT domain
      ;; (load "adt-simple")     ;; functionality
      ;; (load "adt-setup")      ;; template, situation information
      ;;  (load "adt-translate") ;; repair gen'd meta code, translate into C equiv

      ;; load TERRAIN/CAETI domain
      (load "terrain-simple")   ;; functionality
      (load "terrain-setup")    ;; template, situation information
      (load "terrain-setup-dp")    ;; template, situation information
      (load "caeti-db-all")     ;; database array for map
      (load-mapdb)
      (load-mapndx)

      ;; load quilici search single phase
      (load "quilici-search") 

      ;; load new memory-csp in two phases
      (load "memory-csp")
      )
  (progn              ;; mac load (out of date)
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:bm")
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:bt")
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:ct")
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:gsat")

      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:utility")
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:compile")

      ;; load Queens domain
      ;; (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:queens")   

      ;; load MPR domain
      ;;(load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:mpr-simple")   
      ;;(load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:mpr-setup")    

      ;; load ADT domain variations
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:adt-simple")   
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:adt-setup")    

      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:terrain-simple")   
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:terrain-setup")    

      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:quilici-search") 
      (load "Macintosh HD:Languages:Allegro Common Lisp:qcsp:memory-csp")
    )) )

(loadit)