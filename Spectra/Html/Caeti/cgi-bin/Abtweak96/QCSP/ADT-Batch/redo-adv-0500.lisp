
(princ "Koala Redo w/Adv Old Data Test Run: 0500, q-i2, FCDR, Dist1") (terpri)(terpri)
(load "load") (load-adt)

(princ "**** Noise 0500 ****") (terpri)(terpri)
(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "default"
	   :output-file "ADT-Batch/redo-adv-0500-out.1"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "1783960706"
	   :output-file "ADT-Batch/redo-adv-0500-out.2"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "6148712495"
	   :output-file "ADT-Batch/redo-adv-0500-out.3"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "8261581571"
	   :output-file "ADT-Batch/redo-adv-0500-out.4"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "4705297406"
	   :output-file "ADT-Batch/redo-adv-0500-out.5"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "6724813580"
	   :output-file "ADT-Batch/redo-adv-0500-out.6"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "8798969000"
	   :output-file "ADT-Batch/redo-adv-0500-out.7"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "0805098560"
	   :output-file "ADT-Batch/redo-adv-0500-out.8"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "4767135635"
	   :output-file "ADT-Batch/redo-adv-0500-out.9"
	   ))

(time (adt 
       :situation-id "q-i2" 
       :template-id  "quilici-t1"
	   :sit-noise    0500
	   :rand-dist "dist1"
	   :forward-checking t
	   :dynamic-rearrangement t
	   :advance-sort t
	   :random-ident "7685437293"
	   :output-file "ADT-Batch/redo-adv-0500-out.99"
	   ))
:exit

