;;Using racket for (system... ) procedure 
#lang racket
;;(define program "")
(define cnot-test "")
(define output-program "")
(define test-program "from IBMQuantumExperience import IBMQuantumExperience
api = IBMQuantumExperience (\"c413835f96f5c9ce144faa39b7cab48d9f7b06cdaa7a5c00f2da33b3c56dbf453680ae1e9fa47cf58329404ab9ba7b8a7f2b85d961a0d4dac5ff2220e42272d1\")
qasm = 'OPENQASM 2.0;\\n\\ninclude \"qelib1.inc\";\\nqreg q[5];\\ncreg c[5];\\nh q[0];\\ncx q[0],q[2];\\nmeasure q[0] -> c[0];\\nmeasure q[2] -> c[1];\\n'
print api.run_experiment(qasm, device='simulator', shots=1024, name=None, timeout=60)")
(define init-register "qreg q[5];\\ncreg c[5];\\nh q[0];\\nh q[0];\\nh q[0];\\nh q[0];\\nmeasure q[0] -> c[0];\\n")


(define prototype "qreg q[5];\\ncreg c[5];\\nh q[0];\\ncx q[0],q[2];\\nmeasure q[0] -> c[0];\\nmeasure q[2] -> c[1];\\n'")

;; Takes an aubree expression and spits out openqasm 2.0 program as a string
(define (compile expr)
  (let ((input-program expr))
   
    
  (cond
    ((equal? expr 'quit) (raise-syntax-error 'Q "You quit\n"))
    ((eq? (string-length output-program) 0) (begin (display "Enter the number of quantum followed by the number of classical registers you want. Eg  => 5 5\n")
                                                   (set! output-program "hi")))
    ((equal? expr 'run) (begin (display "End of program definition.\nRun \"python machine.py\" to execute you program\n")
                              
                               (write-to-machine (append-program output-program))
                               (set! output-program "")))
    ((list? expr) (let eval-program ((list-expr expr))
                              (display list-expr)                
                             (cond
                               ((null? list-expr) '())
                               ((atom? (cadr list-expr)) (eval-list list-expr))
                               (else
                                ;;(display (flatten (cdr list-expr)))
                               (eval-list (flatten (cdr list-expr)))))))
                               
    (else (cond
            ((number? expr) (begin
                              (display (number? expr))
                              (set! output-program (comma-newline (string-replace "qreg q[x]" "x" (number->string expr))))                                   
                              (set! output-program (comma-newline (string-join (string-replace "creg c[x]" "x" (number->string (read))) output-program)))
                              ))


            (else (set! output-program (string-append input-program output-program ))))))))


;;Takes one expression and writes it to the output program
(define (eval-list expr)
  (let ((gate (car expr))
        (temp-list " "))
    (cond
      ((eq? gate 'h) (set! output-program (comma-newline (string-join (string-replace "h q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 'id) (set! output-program (comma-newline (string-join (string-replace "id q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 'x) (set! output-program (comma-newline (string-join (string-replace "x q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 'y) (set! output-program (comma-newline (string-join (string-replace "y q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 'z) (set! output-program (comma-newline (string-join (string-replace "z q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 's) (set! output-program (comma-newline (string-join (string-replace "s q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 's+) (set! output-program (comma-newline (string-join (string-replace "sdg q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 't) (set! output-program (comma-newline (string-join (string-replace "t q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 't+) (set! output-program (comma-newline (string-join (string-replace "tdg q[x]" "x" (number->string (cadr expr)))output-program))))
      ((eq? gate 'cnot) (begin (set! output-program (string-join (string-replace "cx q[y]," "y" (number->string (cadr expr)))output-program))
                               (set! output-program (comma-newline (string-join (string-replace "q[x]" "x" (number->string (caddr expr)))output-program)))))
      ((eq? gate 'measure) (begin (set! output-program (string-join (string-replace "measure q[x] -> " "x" (number->string (cadr expr)))output-program))
                               (set! output-program (comma-newline (string-join (string-replace "c[x]" "x" (number->string (caddr expr)))output-program)))))
      ((eq? gate 'barrier) (begin  (set! output-program (string-join (string-replace "barrier q[x]," "x" (number->string (cadr expr)))output-program))
                             (let build-barrier ((list-expr (cddr expr)))
                                               
                             (cond
                               ((null? list-expr) '())
                               ((null? (cdr list-expr)) (set! output-program (comma-newline (string-join (string-replace "q[x]" "x" (number->string (car list-expr)))output-program))))
                               (else
                               (set! output-program (string-join (string-replace "q[x]," "x" (number->string (car list-expr)))output-program))
                               (build-barrier (cdr list-expr)))))))
                               
                               
      
      (else
       (display "Not valid\n")))
    gate))
    

;;Append program to the boilerplate that should be run into the API          
(define (append-program source)
  (let ((program-start "from IBMQuantumExperience import IBMQuantumExperience
api = IBMQuantumExperience (\"c413835f96f5c9ce144faa39b7cab48d9f7b06cdaa7a5c00f2da33b3c56dbf453680ae1e9fa47cf58329404ab9ba7b8a7f2b85d961a0d4dac5ff2220e42272d1\")
qasm = 'OPENQASM 2.0;\\n\\ninclude \"qelib1.inc\";\\n")
        (program-end "\nprint api.run_experiment(qasm, device='simulator', shots=1024, name=None, timeout=60)"))
  (begin (set! source (string-append program-start source))
         (set! source (string-join program-end source))
         (display source))
    source))

;;For interactive programming
(define (quantum-repl)
  (compile "")
  (display "=>")
  (compile (read))
  (newline)
  (quantum-repl))

;;Writes compiled code to machine file
(define (write-to-machine qasm)
   (call-with-output-file "greeting4.py" #:exists 'replace
     (lambda (i)
      (display qasm i))))

;;Outputs quantum results to file
(define (program-output-to-file)
   (call-with-output-file "result.txt" #:exists 'replace
     (lambda (i)
      (display (with-output-to-string (lambda () (system "python machine.py"))) i))))

;;Testing
(define (testing-program program)
  (if (equal? init-register program)
      (display "They match\n")
      (display "They don't match\n")
      ))

;;Auxillary procedures
(define (string-join first second)
    (string-append second first))

(define (comma-newline expr)
    (string-append expr ";\\n"))

(define (atom? n)
  (and (not (null? n)) (not (pair? n))))