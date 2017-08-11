(ql:quickload 'l-math)
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

(print (slot-value program_blue_state 'program))


(defparameter ket-zero
	     (make-array '(2 1)  :initial-contents '( (1) (0))))

(defvar ket-one
	     (lm:make-matrix 2 1 :initial-elements '(0 
						     1)))

(defvar hadamard
	     (lm:make-matrix 2 2 :initial-elements `(,(/ 1 (sqrt 2))  ,(/ 1 (sqrt 2))
						     ,(/ 1 (sqrt 2))   ,(/ 1 (sqrt 2)))))

(defvar cnot
	     (lm:make-matrix 4 4 :initial-elements `(1 0 0 0
						     0 1 0 0
						     0 0 0 1
						     0 0 1 0)))
(defvar pauli-x
  (make-array '(2 2)  :initial-contents `( (0 1)
					   (1 0))))
(defvar pauli-y
	     (make-array '(2 2)  :initial-contents `((0 ,(complex 0 -1))
						    (,(complex 0 1) 0))))

(defvar pauli-z
	     (lm:make-matrix 2 2 :initial-elements `(1 0
						     0 -1)))

(defstruct state-vector
	   c1
	   c2)

(defparameter state (make-state-vector :c1 (complex (/ 1 (sqrt 2)) 0) :c2 (complex (/ 1 (sqrt 2)) 0)))
(state-vector-c1 state)
(state-vector-c2 state)

(defun total-probability  (state)
	     (+ (square (abs (state-vector-c1 state))) (square (abs (state-vector-c2 state)))))


(print (total-probability state))


(defun matrix-multiply (a b)
	 ( make-array '(2 1) :initial-contents `(,(cons (+ (* (aref a 0 0) (aref b 0 0 ))  (* (aref a 0 1) (aref b 1 0 )) ) '())
						  ,(cons (+ (* (aref a 1 0) (aref b 0 0 ))  (* (aref a 1 1) (aref b 1 0 )) ) '()))))

(print (matrix-multiply pauli-x ket-zero))
;Temporary
(defun square (x)
  (* x x))
