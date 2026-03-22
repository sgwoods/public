#!/bin/csh
cd /users/sgwoods/Abtweak96/QCSP

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-0100.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-0100.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-0500.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-0500.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-0750.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-0750.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-1000.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-1000.messages

nice time /extra/acl4.2/bin/cl <\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-2000.lisp >\
	/users/sgwoods/Abtweak96/QCSP/ADT-Batch/redo-adv-2000.messages
