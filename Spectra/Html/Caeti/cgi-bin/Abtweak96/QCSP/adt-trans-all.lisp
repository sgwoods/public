(defun translate-code ()
  (load "adt-translate")
  (trans100)
  (trans250) 
  (trans500) 
  (trans750) 
  (trans1000) 
  (trans2000)  
  )

(defun trans100 ()
  (comment "Translating programs of size 100")
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "08010098560" 100 )  ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6724813580" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "1783960706" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "7685437293" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4705297406" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8261581571" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4767135635" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8798969000" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6148712495" 100 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "default"    100 )   ;; 
  )

(defun trans250 ()
  (comment "Translating programs of size 250")
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "08025098560" 250 )  ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6724813580" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "1783960706" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "7685437293" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4705297406" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8261581571" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4767135635" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8798969000" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6148712495" 250 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "default"    250 )   ;; 
  )

(defun trans500 ()
  (comment "Translating programs of size 500")
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "08050098560" 500 )  ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6724813580" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "1783960706" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "7685437293" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4705297406" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8261581571" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4767135635" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8798969000" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6148712495" 500 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "default"    500 )   ;; 
  )

(defun trans750 ()
  (comment "Translating programs of size 750")
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "08075098560" 750 )  ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6724813580" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "1783960706" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "7685437293" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4705297406" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8261581571" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4767135635" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8798969000" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6148712495" 750 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "default"    750 )   ;; 
  )

(defun trans1000 ()
  (comment "Translating programs of size 1000")
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "080100098560" 1000 )  ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6724813580" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "1783960706" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "7685437293" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4705297406" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8261581571" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4767135635" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8798969000" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6148712495" 1000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "default"    1000 )   ;; 
  )


(defun trans2000 ()
  (comment "Translating programs of size 2000")
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "080200098560" 2000 )  ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6724813580" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "1783960706" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "7685437293" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4705297406" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8261581571" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "4767135635" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "8798969000" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "6148712495" 2000 )   ;; 
  (clear-closure)  (translate-adt-to-c 'q-i2 'dist1 "default"    2000 )   ;; 
  )