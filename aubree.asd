(ql:quickload '(hunchentoot cl-who postmodern simple-date parenscript cl-fad
		fiveam css-lite cl-json))

(asdf:defsystem "aubree"
  :serial t
  :description "A Topological Quantum Computer Simulator"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern
	       #:parenscript
	       #:cl-fad)
  
  :components ((:file "package")
	       (:module :src
			:serial t      
			:components ((:file "hello-world")
				    



				     ))))

