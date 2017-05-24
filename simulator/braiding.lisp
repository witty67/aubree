(ql:quickload 'l-math)

(defparameter first-braid (lm:make-matrix 5 9 :initial-elements
	      '(4 0 0 0 0 0 0 0 0
		3 0 0 0 0 0 0 0 0
		2 0 0 0 0 0 0 0 0
		1 0 0 0 0 0 0 0 0
		0 1 2 3 4 5 6 7 8)))
(defun first-pair (matrix)
  (cons (lm:matrix-elt matrix 4 1) '()))

(defun move (matrix first-location final-location)
  (setf (lm:matrix-elt matrix 3 1) 68)
  (setf (lm:matrix-elt matrix 4 1) 20))
