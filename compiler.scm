;; Copyright Victory Omole 2017

(define test-program "from IBMQuantumExperience import IBMQuantumExperience
api = IBMQuantumExperience (\"c413835f96f5c9ce144faa39b7cab48d9f7b06cdaa7a5c00f2da33b3c56dbf453680ae1e9fa47cf58329404ab9ba7b8a7f2b85d961a0d4dac5ff2220e42272d1\")
qasm = 'OPENQASM 2.0;\\n\\ninclude \"qelib1.inc\";\\nqreg q[5];\\ncreg c[5];\\nh q[0];\\ncx q[0],q[2];\\nmeasure q[0] -> c[0];\\nmeasure q[2] -> c[1];\\n'
print api.run_experiment(qasm, device='simulator', shots=1024, name=None, timeout=60))


" )

;; Takes an aubree expression and spits out openqasm 2.0 program as a string
(define (compile expr)
  (cond

    ((equal? expr 'run) (begin (display "End of program definition.\nRun \"python machine.py\" to execute you program\n"))
                               
    (else (display "Nothing was here\n")))
  expr)

(define (quantum-repl)
  (display "=>")
  (compile (read))
  (newline)
  (quantum-repl))


;;
(define (write-to-machine qasm)
   (call-with-output-file "greeting1.py" #:exists 'replace
     (lambda (i)
      (display qasm i))))