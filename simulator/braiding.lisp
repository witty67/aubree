(ql:quickload 'l-math)
;;define quantum gates based on the anyonic topological model.-My favorite set of gates, Hadamard, CNOT and pi/8
;;definitions of constants
;; When 2 anyons fuse, the probability of seeing 1 is po = 1/golden-ratio^2= 0.38196 and the probability of seeing t is p1 1/golden ratio =0.61803



(defparameter *init* #(1 2 3 4 5 6 7 8))

;;Test program and database definitions found on:https://www.linkedin.com/pulse/how-write-your-first-quantum-program-view-supply-christoph
(defparameter *quantum-program*
	   `((hadamard 2)
	     (hadamard 1)
	     (u-theta 0 ,(/ pi 4))
	     (oracle ORACLE-TT 2 1 0)
	     (hadamard 2)
	     (cnot 2 1)
	     (hadamard 2)
	     (u-theta 2 ,(/ pi 2))
	     (u-theta 1 ,(/ pi 2))))

(defparameter *database* '(0 1 0 0))

(defvar *oracle*
	   (execute-quantum-program 
	    *quantum-program*
	    3
	    *database*))
(defparameter result (mapcar #'round (multi-qsys-output-probabilities *oracle* '(2 1))))

(defvar golden-ratio 1.61803398)
(defvar f-matrix (lm:make-matrix 2 2 :initial-elements `(,golden-ratio ,golden-ratio
								 ,golden-ratio ,golden-ratio)))
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

(defun hello-world ()
	   (progn
	        (vector-swap *init* 2 3)
		(vector-swap *init* 4 5)
		(vector-swap *init* 6 7)
		(vector-swap *init* 2 5)
		(vector-swap *init* 6 8)
		(vector-swap *init* 2 4)
		(vector-swap *init* 7 8)
		))

#|may 26 2017: Define fusion trees.
If two well-separated anyons Yi and Yj are exchanged slowly enough, the system will  be in another 
ground state equals sum of biei in V(S,pi,Yi)


|#
(defun product-sum (l y)
	   (let ((random_num 0))
	   (cond
	    ( (and (eq l 1) (eq y t)) 't)
	    ((and (eq l t) (eq y 1)) 't)
	    ((and (eq l t) (eq y t)) (progn
				       (setf random_num  (if (<= (random 2) (/ 1 golden-ratio)) 1 0))
				       (if (eq random_num 1) 't 1))))))


 ;Just a place holder.
(defun quantum-system (surface location anyon)
  (+ surface location anyon))



;;May 28
(defun pauli (a)
	   (labels ((kronecker (i j)
			      (if (equal i j) 1 0)))
			   `( ,(kronecker a 3) ,(- (kronecker a 1) (complex  0 (kronecker a 2)))
			      ,(+ (kronecker a 1) (complex  0 (kronecker a 2))) ,(- 0 (kronecker a 3)))))
