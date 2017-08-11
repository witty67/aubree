(ql:quickload 'l-math)

;Temporary
(defun square (x)
  (* x x))
(defclass Program ()
	    (program
	     result_probability
	     bloch_vals))

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

;(qprog-n program)


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

;(print (slot-value program_blue_state 'program))


(defparameter state-vector
	     (make-array '(2 1)  :initial-contents '( (1) (0))))

(defparameter ket-one
	     (make-array '(2 1)  :initial-contents '( (0) (1))))

(defvar hadamard
	     (lm:make-matrix 2 2 :initial-elements `(,(/ 1 (sqrt 2))  ,(/ 1 (sqrt 2))
						     ,(/ 1 (sqrt 2))   ,(/ 1 (sqrt 2)))))


(defparameter pauli-x
  (make-array '(2 2)  :initial-contents `( (0 1)
					   (1 0))))
(defparameter pauli-y
	     (make-array '(2 2)  :initial-contents `((0 ,(complex 0 -1))
						    (,(complex 0 1) 0))))

(defparameter pauli-z
	     (make-array '(2 2)  :initial-contents `( (1 0)
						      (0 -1))))

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


(defun apply-gate (qubit gate)
  ( make-array '(2 1) :initial-contents
	       `(,(cons (+ (* (aref gate 0 0) (aref qubit 0 0 ))  (* (aref gate 0 1) (aref qubit 1 0 )) ) '())
		  ,(cons (+ (* (aref gate 1 0) (aref qubit 0 0 ))  (* (aref gate 1 1) (aref qubit 1 0 )) ) '()))))

(defun measure (qubit)
	   (cond ((equalp qubit  #2A((1) (0))) 0)
		 ((equalp qubit  #2A((0) (1))) 1)
		 (t (if (<= (random 2) (square (abs (aref qubit 0 0)))) 1 0))))

;(print (matrix-multiply pauli-x ket-zero))
;(matrix-multiply pauli-y ket-zero)

(defstruct quantum-register
	   (q0 state-vector :type array)
	   (q1 state-vector :type array)
	   (q2 state-vector :type array)
	   (q3 state-vector :type array)
	   (q4 state-vector :type array))

(Defparameter register (make-quantum-register))

(quantum-register-q0 register)
