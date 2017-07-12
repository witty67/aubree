(ql:quickload '(hunchentoot cl-who postmodern simple-date parenscript cl-fad
		prove css-lite cl-json smackjack zpng l-math cffi clesh cl-forest cl-mongo formlets postmodern))
(use-package 'named-readtables)
(in-readtable clesh:syntax)
(asdf:defsystem #:example
  :serial t
  :description "A Quantum Computing Playground"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern
	       #:parenscript
	       #:cl-fad
	       #:smackjack
	       #:cl-forest)
  :components ((:file "package")

	       (:module :simulators
			:serial t      
			:components (
				     
				     (:file "qgame")
				     (:file "braiding")
				     (:file "em")))

	       (:module :web
			:serial t      
			:components (
				     (:file "topological-intro")
				     (:file "index")))
	       
	       (:module :src
			:serial t      
			:components ((:file "hello-world")))

	       (:module :utilities
			:serial t      
			:components ((:file "tests")
				     (:file "run-tests")
				     (:file "utilities")
				     (:file "setup")))

	       

	       )
  ;:in-order-to ((test-op (test-op aubree-test)))
  )




