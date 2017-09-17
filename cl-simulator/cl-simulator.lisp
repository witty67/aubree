(in-package :cl-simulator)
;(defparameter *s* (open "epr.lqasm"))
;(defparameter *program* (read *s*))
(defparameter *program* '((H 0)
     (CNOT 0 1)
			  (MEASURE 1)))

(defun square (x)
  (* x x))
(defclass Program ()
  (program
   result_probability
   bloch_vals))

(defvar 1/sqrt2 (/ 1 (sqrt 2)))
(defvar -1/sqrt2 (- 1/sqrt2))

(defstruct Qprog
  n ;Number of qubits
  t ;Number of gates
  a ;opcode
  b ;qubit 1
  c ;qubit 2
  DIPQSTATE ;Whether to display state
  DISPTIME ;Print execution time
  SILENT ;Whether not to print results
  DISPROG ;Whether to print instructions
  SUPPRESSM ;Display actual determinate results
  )
(defstruct Qstate
  n
  x
  z
  r
  pw
  over32)

(defparameter program_blue_state (make-instance 'Program))

(setf (slot-value program_blue_state 'program) 
      "h q[1];
			t q[1];
			h q[1];
			t q[1];
			h q[1];
			t q[1];
			s q[1];
			h q[1];
			t q[1];
			h q[1];
			t q[1];
			s q[1];
			h q[1];
			bloch q[1];")

(defparameter state-vector
  (make-array '(2 1)  :initial-contents '( (1) (0))))
					;(print (slot-value program_blue_state 'program))
(defstruct quantum-register
  (q0 state-vector :type array)
  (q1 state-vector :type array)
  (q2 state-vector :type array)
  (q3 state-vector :type array)
  (q4 state-vector :type array))

(defparameter register (make-quantum-register))
;;Write a macro for these

;;one-qubit gates
(defparameter ket-one
  (make-array '(2 1)  :initial-contents '( (0) (1))))

(defparameter ket-zero
  (make-array '(2 1)  :initial-contents '( (1) (0))))

;;two-qubit gates

(defparameter ket-zero-zero
  (make-array '(4 1)  :initial-contents '( (1) (0) (0) (0))))

(defparameter ket-zero-one
  (make-array '(4 1)  :initial-contents '( (0) (1) (0) (0))))

(defparameter ket-one-zero
  (make-array '(4 1)  :initial-contents '( (0) (0) (1) (0))))

(defparameter ket-one-one
  (make-array '(4 1)  :initial-contents '( (0) (0) (0) (1))))

(defparameter hadamard
  (make-array '(2 2) :initial-contents `((,1/sqrt2 ,1/sqrt2)
					 (,1/sqrt2 ,-1/sqrt2))))


(defparameter pauli-x
  (make-array '(2 2)  :initial-contents `( (0 1)
					   (1 0))))
(defparameter pauli-y
  (make-array '(2 2)  :initial-contents `((0 ,(complex 0 -1))
					  (,(complex 0 1) 0))))

(defparameter pauli-z
  (make-array '(2 2)  :initial-contents `( (1 0)
					   (0 -1))))

(defparameter pi/8
  (make-array '(2 2)  :initial-contents `( (1 0)
					   (0 ,(exp (* (complex 0 1) (complex (/ pi 4))))))))

(defparameter cnot
  (make-array '(4 4) :initial-contents `((1 0 0 0)
					 (0 1 0 0)
					 (0 0 0 1)
					 (0 0 1 0))))


					;(defstruct state-vector  c1	   c2  ket-zero	   ket-one)

					;(defparameter state (make-state-vector :c1 (complex (/ 1 (sqrt 2)) 0) :c2 (complex (/ 1 (sqrt 2)) 0)))
					;(state-vector-c1 state)
					;(state-vector-c2 state)

(defun total-probability  (qubit)
  (+ (square (abs (aref qubit 0 0))) (square (abs (aref qubit 1 0) ))))


					;(print (total-probability state))

					;https://rosettacode.org/wiki/Matrix_multiplication#Common_Lisp
(defun apply-gate (qubit gate)  
  (if (equal (array-dimensions gate) '(2 2))
      (make-array '(2 1) :initial-contents
		  `(,(cons (+ (* (aref gate 0 0) (aref qubit 0 0 ))  (* (aref gate 0 1) (aref qubit 1 0 )) ) '())
		     ,(cons (+ (* (aref gate 1 0) (aref qubit 0 0 ))  (* (aref gate 1 1) (aref qubit 1 0 )) ) '())))
      (let* ((m (car (array-dimensions qubit)))
	     (n (cadr (array-dimensions qubit)))
	     (l (cadr (array-dimensions gate)))
	     (C (make-array `(,m ,l) :initial-element 0))
	     (D (make-array `(,m ,l) :initial-element 0)))
	(print l)
	(loop for i from 0 to (- m 1) do
	     (loop for k from 0 to (- l 1) do
		  (setf (aref C i k)
			(loop for j from 0 to (- n 1)
			   sum (* (aref qubit i j)
				  (aref gate j k))))))
	(setf D (make-array '(4 1)  :initial-contents `( (,(aref C 0 0)) (,(aref C 1 0)) (,(aref C 2 0)) (,(aref C 3 0))))) 
	D)))

(defun apply-gate-cnot (A B)
  (let* ((m (car (array-dimensions A)))
         (n (cadr (array-dimensions A)))
         (l (cadr (array-dimensions B)))
         (C (make-array `(,m ,l) :initial-element 0)))
    (loop for i from 0 to (- m 1) do
	 (loop for k from 0 to (- l 1) do
	      (setf (aref C i k)
		    (loop for j from 0 to (- n 1)
		       sum (* (aref A i j)
			      (aref B j k))))))
    C))

(defun n-wire-gate (gate qubits register) 
  (cond ((null qubits) 'done)
	(t  (progn
	      (setf (slot-value register (first qubits)) (apply-gate (slot-value register (first qubits)) gate))
	      (n-wire-gate gate (rest qubits) register)))))

(defun measure (qubit)
  (cond ((equalp qubit  #2A((1) (0))) 0)
	((equalp qubit  #2A((0) (1))) 1)
	;((equalp (array-dimensions qubit) '(4 1)) (measure-two-qubit qubit)) 
	(t (if (<= (random 2) (square (abs (aref qubit 0 0)))) 1 ))))

(defun measure-two-qubit (qubit)
	   (case (measure (make-array '(2 1)  :initial-contents `( (,(aref qubit 0 0)) (,(aref qubit 1 0)))))
	     (1 (make-array '(4 1)  :initial-contents `( (0) (1) (,(aref qubit 1 0)) (,(aref qubit 0 0)))))
	     (t qubit)))

(defparameter superposition '(+ (* amplitude (ket 0)) (* amplitude (ket 1))))
					;(print (matrix-multiply pauli-x ket-zero))
					;(matrix-multiply pauli-y ket-zero)
(defun hadamard (qubit)
  (case (second qubit)
    (0 '(/ (+ (ket 0) (ket 1)) (sqrt 2)))
    (1 '(/ (- (ket 0) (ket 1)) (sqrt 2)))))


(defun epr (x y local-register qubit1 qubit2)
  ;;(print qubit1)
  ;;(print qubit2)
  (cond ((and (equal x 0) (equal y 0)) (progn (setf (slot-value local-register qubit1) (make-array '(2 1)  :initial-contents `((,1/sqrt2) (0))))
					      (setf (slot-value local-register qubit2) (make-array '(2 1)  :initial-contents `((0) (,1/sqrt2))))
					     ))
					      
		 ((and (equal x 0) (equal y 1)) (make-array '(4 1)  :initial-contents `((0) (,1/sqrt2) (,1/sqrt2) (0))))
		 ((and (equal x 1) (equal y 0)) (make-array '(4 1)  :initial-contents `((,1/sqrt2) (0) (0) (,-1/sqrt2))))
		 ((and (equal x 1) (equal y 1)) (make-array '(4 1)  :initial-contents `((0) (,1/sqrt2) (,-1/sqrt2) (0))))		
		 (t 'nothing)))
  

;;Derived gates
(defparameter not-y-positive (apply-gate-cnot pauli-z (apply-gate-cnot pauli-x pauli-y)))
(defun reset-file () (defparameter *s* (open "grover.lqasm")))

(defun match (qubit)
  (case qubit
    (0 'q0)
    (1 'q1)
    (2 'q2)
    (3 'q3)
    (4 'q4)))

(defun scan-qubit (qubit register)
  (let ((literal-qubit (slot-value register (match qubit))))
    (cond ((equalp literal-qubit #2A((0.70710677) (0.70710677))) 0)
	  ((equalp literal-qubit #2A((0.70710677) (-0.70710677))) 1)
	  ((equalp literal-qubit #2A((1) (0))) 0)
	  ((equalp literal-qubit #2A((0) (1))) 1)
	  (t 'nothing))))

(defun match-cnot (qubit)
  (cond ((equal qubit '(0 0)) ket-zero-zero)
	((equal qubit '(0 1)) ket-zero-one)
	((equal qubit '(1 0)) ket-one-zero)
	((equal qubit '(1 1)) ket-one-one)
	(t 'nothing)))

(defun handle-h (program-list local-register)
  (progn
    (setf (slot-value local-register (match (cadar program-list))) (apply-gate (slot-value local-register (match (cadar program-list))) hadamard))))

(defun handle-cnot (program-list local-register)
  (match-cnot (cdar program-list))
  (progn
    (setf (slot-value local-register (match-cnot (cdar program-list))) (apply-gate-cnot (slot-value local-register (match-cnot (cdar program-list))) (slot-value local-register (match-cnot (cdar program-list)))))))

(defun handle-cnot-kets (ket local-register second-qubit)
	   (cond ((eq (aref (apply-gate-cnot ket cnot) 0 0) 1) 'ket-zero-zero)
		 ((eq (aref (apply-gate-cnot ket cnot) 1 0) 1) 'ket-zero-one)
		 ((eq (aref (apply-gate-cnot ket cnot) 2 0) 1) (slot-value local-register (match second-qubit)))
		 ((eq (aref (apply-gate-cnot ket cnot) 3 0) 1) 'ket-one-one)
		 (t 'nothing)))

(defun qeval (program-list register) 
  ;(print program-list)
  ;(print (cadar program-list))
  (let ((local-register register)(measurement-value 0))
    (labels ((inner-qeval (program-list measurement-value)
	       (cond ((null program-list) measurement-value)
		     ((eq (caar program-list) 'h) (progn						    
						    (handle-h program-list local-register)						    
						    (inner-qeval (cdr program-list)measurement-value)))
		     
		     ((eq (caar program-list) 'cnot) (progn
						       
						       ;;(handle-cnot-kets (match-cnot (cdar program-list)) local-register (caddar '((cnot 0 1))))
						       
						       (epr (scan-qubit (cadar program-list) local-register) (scan-qubit (caddar program-list) local-register) local-register (match (cadar program-list)) (match (caddar program-list)))
						       (inner-qeval (cdr program-list)measurement-value)))

		     ((eq (caar program-list) 'measure) (progn					 
							 
						      (setf measurement-value (measure (slot-value local-register (match (cadar program-list)))))					  
						       
						       (inner-qeval (cdr program-list)measurement-value)))
		     
		     (t   (inner-qeval (cdr program-list)  measurement-value)))))(inner-qeval program-list measurement-value))))


(defun sanity-check (times)
	   (let ((counter 0))
	     (dotimes (i times) (if (equal (qeval *program* register) 1) (incf counter) nil))counter))

(defun process (data)
  (let* ((path (concatenate 'string "/tmp/" (coerce data 'string)))  (s (open path))  (program (read s)))
  (format nil "Result~@[ ~A~]!"(sanity-check 1))))
;;Tests
#|(measure (apply-gate ket-one pauli-x)) ;=> |0>
(measure (apply-gate ket-zero pauli-x)); => |1>
(apply-gate ket-one hadamard);=> 0.7|0> - 0.7|1>
(apply-gate (apply-gate ket-one hadamard) hadamard); => 0|0> - 1|1>
(setf (slot-value register 'q0) (apply-gate ket-one hadamard))
(setf (slot-value register 'q1) (apply-gate ket-one hadamard))
(measure (apply-gate ket-zero hadamard)); 50/50

(cl-forest:run (quil "H 0"
"CNOT 0 1"
"MEASURE 0 [0]"
"MEASURE 1 [1]")
'(0 1)
10)

(run '((h 0)1
       (cnot 0 1)
       (measure 0 [0])
       (measure 1 [1])))
|#
