(ql:quickload 'l-math)

(defparameter first-braid (lm:make-matrix 5 9 :initial-elements
	      '(4 0 0 0 0 0 0 0 0
		3 0 0 0 0 0 0 0 0
		2 0 0 0 0 0 0 0 0
		1 0 0 0 0 0 0 0 0
		0 1 2 3 4 5 6 7 8)))
(defun first-pair (matrix)
  (cons (lm:matrix-elt matrix 4 1) '()))

(defun move (matrix first-location final-location elem)
  (setf (lm:matrix-elt matrix (first first-location) (second first-location)) elem)
  (setf (lm:matrix-elt matrix (first final-location) (second final-location))
	(lm:matrix-elt matrix (first first-location) (second first-location))))

(defun matrix-swap (matrix first-location second-location)
	   (let ((tmp (lm:matrix-elt matrix (first first-location) (second first-location))))
	     (setf (lm:matrix-elt matrix (first first-location) (second first-location))
		   (lm:matrix-elt matrix (first second-location) (second second-location)))
		 (setf (lm:matrix-elt matrix (first second-location) (second second-location)) tmp)
		 matrix))

(defun vector-swap (vector first-location second-location)
	   (let ((tmp (aref vector (position first-location vector)))
		 (tmp-index  (position second-location vector)))
	     (setf (aref vector (position first-location vector)) (aref vector (position second-location vector)))
	     (setf (aref vector tmp-index) tmp)
	     )vector)
  
