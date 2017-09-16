
;Temporary
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
(defstruct quantum-register
	   (q0 state-vector :type array)
	   (q1 state-vector :type array)
	   (q2 state-vector :type array)
	   (q3 state-vector :type array)
	   (q4 state-vector :type array))

(defparameter register (make-quantum-register))

(defparameter state-vector
	     (make-array '(2 1)  :initial-contents '( (1) (0))))

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
		 (t (if (<= (random 2) (square (abs (aref qubit 0 0)))) 1 0))))

(defparameter superposition '(+ (* amplitude (ket 0)) (* amplitude (ket 1))))
;(print (matrix-multiply pauli-x ket-zero))
;(matrix-multiply pauli-y ket-zero)



(quantum-register-q0 register)

(defun hadamard (qubit)
	      (case (second qubit)
		(0 '(/ (+ (ket 0) (ket 1)) (sqrt 2)))
		(1 '(/ (- (ket 0) (ket 1)) (sqrt 2)))))

;;Derived gates
(defparameter not-y-positive (apply-gate-cnot pauli-z (apply-gate-cnot pauli-x pauli-y)))

(defun qeval (1st)
	      (case (car 1st)
		(H 'hadamard)))
;;Tests
(measure (apply-gate ket-one pauli-x)) ;=> |0>
(measure (apply-gate ket-zero pauli-x)); => |1>
(apply-gate ket-one hadamard);=> 0.7|0> - 0.7|1>
(apply-gate (apply-gate ket-one hadamard) hadamard); => 0|0> - 1|1>
(setf (slot-value register 'q0) (apply-gate ket-one hadamard))
(setf (slot-value register 'q1) (apply-gate ket-one hadamard))
(measure (apply-gate ket-zero hadamard)); 50/50

#|(cl-forest:run (quil "H 0"
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
