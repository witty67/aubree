(in-package :simulators)
;;define quantum gates based on the anyonic topological model.-My favorite set of gates, Hadamard, CNOT and pi/8
;;definitions of constants
;; When 2 anyons fuse, the probability of seeing 1 is po = 1/golden-ratio^2= 0.38196 and the probability of seeing t is p1 1/golden ratio =0.61803


;;auxillary functions

(defun process (data)
  (print data))

(defun square(x)
  (* x x))

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
(defparameter *result* (mapcar #'round (multi-qsys-output-probabilities *oracle* '(2 1))))

(defvar golden-ratio 1.61803398)
(defvar f-matrix (lm:make-matrix 2 2 :initial-elements `(,golden-ratio ,golden-ratio
								 ,golden-ratio ,golden-ratio)))
(defparameter *first-braid* (lm:make-matrix 5 9 :initial-elements
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
  "(matrix-swap *first-braid* '(1 1) '(4 4)): Move "
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

;;May 29
(defun pauli (a)
	   (labels ((kronecker (i j)
			      (if (equal i j) 1 0)))
	     (if (equal a 0) (map 'list (lambda (n) (if (equal n 0) 1 0)) (pauli 1))
			   `( ,(kronecker a 3) ,(- (kronecker a 1) (complex  0 (kronecker a 2)))
			       ,(+ (kronecker a 1) (complex  0 (kronecker a 2))) ,(- 0 (kronecker a 3))))))


;;June 5th 2017:https://arxiv.org/abs/0708.0261
(defparameter c1 #c(5 3))
(defparameter c2 #c(-3 -2))
(defparameter test-vector (coerce '(#c(0 1)) 'vector))

(defun modulus (a b)
  (sqrt (+ (square a) (square b))))

(defun probability (c)
  (square (modulus (realpart c) (imagpart c))))

(setf (symbol-value '-1/sqrt2)  (/ -1 (sqrt 2)))
(setf (symbol-value '1/sqrt2)  (/ 1 (sqrt 2)))

(defvar 1/sqrt2 (/ 1 (sqrt 2)))
(defvar -1/sqrt2 (/ -1 (sqrt 2)))

(defparameter *test-vector*  `( ,1/sqrt2 ,1/sqrt2 ,0
	   (0 -1/sqrt2) (0 1/sqrt2) 0
	   0 0 (0 1)))

 (defun make-complex (list)
	   (cond ((and (symbolp (first list)) (symbolp (second list))) (complex (symbol-value (first list)) (symbol-value (second list))))
		 ((and (not (symbolp (first list))) (symbolp (second list))) (complex (first list) (symbol-value (second list))))
		 ((and (symbolp (first list)) (not (symbolp (second list)))) (complex (first list) (symbol-value (second list))))
		 ((and (not (symbolp (first list))) (not (symbolp (second list)))) (complex (first list) (second list)))
		 ))

(defun eval-list (n)
	   (cond ((null  n)'finished)
		 ((listp (car n)) (progn (print (make-complex (car n)))
					 (eval-list (cdr n))))
		 (t
		  (eval-list (cdr n)))))


#|
June 6th 2017
Ways to implement qubits: atoms, photon, subatomic particle.
|#

(defparameter v '(#c(5 3) #c(0 6)))

(defun square-complex (x)
  (+ (square (realpart x)) (square  (imagpart x))))

(defun complex-modulus (a b)
  (sqrt (+ (square-complex a) (square-complex b))))

(defparameter norm (complex-modulus #c(5 3) #c(0 6)))

(defun qstate (v)
	   (let ((norm  (complex-modulus #c(5 3) #c(0 6))))
	    `(,(/ (first v) norm) ,(/ (second v) norm))))

(defparameter physical-state (qstate v))

(defparameter my-classical-not (lm:make-matrix 2 2 :initial-elements '(0 1
								       1 0)))


(defun apply-not (n)
	   (lm:* my-classical-not n))

(defparameter input (lm:make-matrix 2 2 :initial-elements '(1 0
							    0 0)))

(defparameter hadamard `(,1/sqrt2 ,1/sqrt2 ,1/sqrt2  ,1/sqrt2))


(defparameter cnot (lm:make-matrix 4 4 :initial-elements '( 1 0 0 0
							      0 1 0 0
							      0 0 0 1
							      0 0 1 0)))


(defparameter function1 (lm:make-matrix 2 2 :initial-elements '(1 1
								0 0)))


;;June 16th 2017: Topologically manipulating ising anyons and matrix multiplication on single qubits

#|
[I]* (a b)= (a*I + b*s)
[S]  (c d)  (c*I + d*s)



|#

#| Notes on Ising Anyons: http://quantum.leeds.ac.uk/fileadmin/user_upload/Jiannis/IntroTQC.pdf
σ × σ = 1 + ψ
σ × ψ = σ
ψ × ψ = 1

Let us now give the explicit forms of the F and R matrices for the Ising model. We
postpone their derivation to the next subsection.

x gate: (R23)^2
F matrix: 

|#






#| Notes on Fibonacci anyons



|#

(defparameter *quantum-program* 
			 '((qnot 0)
			   (measure 0
			    )))

(defparameter *system* (execute-quantum-program  *quantum-program* 1))

(defparameter *answer* (amplitudes (car *system*)))


;;6/24/2017:gcc call_function.c -I/usr/include/python2.7 -lpython2.7 ; ./a.out
