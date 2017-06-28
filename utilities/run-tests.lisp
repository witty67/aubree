(in-package :tests)
(defun run-tests ()
	   (if (equal (prove:run #P"test.lisp" :reporter :list) t) "Tests passed"
	      (error "Not all tests passed")))
