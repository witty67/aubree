(ql:quickload '(hunchentoot cl-who postmodern simple-date parenscript cl-fad
		fiveam css-lite cl-json smackjack zpng l-math))

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
	       (:module :web
			:serial t      
			:components ((:file "index")
				     (:file "topological-intro")))

	       (:module :simulators
			:serial t      
			:components ((:file "qgame")
				     (:file "braiding")
				     (:file "em")))
	       ))

