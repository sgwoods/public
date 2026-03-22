#!/bin/csh
cd /users/sgwoods/Abtweak96/QCSP

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-0100.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-0100.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-0500.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-0500.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-0750.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-0750.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-1000.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-1000.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-2000.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-2000.messages
