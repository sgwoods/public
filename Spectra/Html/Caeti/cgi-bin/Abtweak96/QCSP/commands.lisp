(load "new-dep.fasl")

(load "new-setup.fasl") 
(test-main "testdata/dmaxc.component" "testdata/dmaxc.control" "testdata/dmaxc.stats")
(adt :forward-checking t :dynamic-rearrangement t )   

(load "new-setup.fasl") 
(test-main "testdata/dmax3c.component" "testdata/dmax3c.control" "testdata/dmax3c.stats")
(adt :forward-checking t :dynamic-rearrangement t )  

(load "new-setup.fasl") 
(test-main "testdata/dmax6c.component" "testdata/dmax6c.control" "testdata/dmax6c.stats")
(adt :forward-checking t :dynamic-rearrangement t )  

(load "new-setup.fasl") 
(test-main "testdata/dmax9c.component" "testdata/dmax9c.control" "testdata/dmax9c.stats")
(adt :forward-checking t :dynamic-rearrangement t ) 

(load "new-setup.fasl") 
(test-main "testdata/dmax12c.component" "testdata/dmax12c.control" "testdata/dmax12c.stats")
(adt :forward-checking t :dynamic-rearrangement t )  

(load "new-setup.fasl") 
(test-main "testdata/dmax15c.component" "testdata/dmax15c.control" "testdata/dmax15c.stats")
(adt :forward-checking t :dynamic-rearrangement t ) 

(load "new-setup.fasl") 
(test-main "testdata/dmax18c.component" "testdata/dmax18c.control" "testdata/dmax18c.stats")
(adt :forward-checking t :dynamic-rearrangement t ) 

(load "new-setup.fasl") 
(test-main "testdata/dmax21c.component" "testdata/dmax21c.control" "testdata/dmax21c.stats")
(adt :forward-checking t :dynamic-rearrangement t ) 

(load "new-setup.fasl") 
(test-main "testdata/dmax24c.component" "testdata/dmax24c.control" "testdata/dmax24c.stats")
(adt :forward-checking t :dynamic-rearrangement t ) 



