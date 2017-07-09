(in-package :tests)
(plan 3)

(ok (not (find 4 '(1 2 3))))
(is 5 4)
(isnt 1 #\1)

(finalize)




