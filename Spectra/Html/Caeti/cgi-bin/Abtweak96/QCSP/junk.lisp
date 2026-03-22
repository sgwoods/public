
(princ "Koala Redo Old Data Test Run: 0100, q-i2, FCDR, Dist1") (terpri)(terpri)
(load "load") (load-adt)

(princ "**** Noise 0100 ****") (terpri)(terpri)
(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0100
	   :rand-dist "dist1"
	   :forward-checking      nil
	   :dynamic-rearrangement nil
	   :dfa-rearrangement     t
	   :random-ident "default"
	   :output-file "ADT-Batch/redo-0100-out.1"
	   ))

:exit