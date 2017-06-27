(in-package :tests)
(plan 4)

(ok (not (find 4 '(1 2 3))))
(is 5 4)
(isnt 1 #\1)

;;Aubree Tests

;;Simulator tests
(is (simulators:square 2) 5) 

;;Example Tests

(finalize)
