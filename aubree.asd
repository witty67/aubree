(ql:quickload '(hunchentoot cl-who postmodern simple-date parenscript cl-fad
		fiveam css-lite cl-json smackjack zpng l-math cffi))

(asdf:defsystem "aubree"
  :serial t
  :description "A Topological Quantum Computer Simulator"
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
				     (:file "index"))
			)
	       

	       
	       ))

