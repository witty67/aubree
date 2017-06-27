(ql:quickload '(hunchentoot cl-who postmodern simple-date parenscript cl-fad
		prove css-lite cl-json smackjack zpng l-math cffi clesh cl-forest))
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
	       #:smackjack)
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

	       (:module :tests
			:serial t      
			:components ((:file "tests")
				     (:file "run-tests")))

	       

	       )
  :in-order-to ((test-op (test-op aubree-test)))
  )


(defsystem aubree-test
  :depends-on (:example
               :prove)
  :defsystem-depends-on (:prove-asdf)
  :components
  ((:test-file "tests/tests"))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))

