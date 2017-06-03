(ql:quickload :hunchentoot)
(ql:quickload :cl-who)
(ql:quickload :postmodern)
(ql:quickload :simple-date)
(ql:quickload :parenscript)

(asdf:defsystem "aubree"
  :serial t
  :description "A Topological Quantum Computer Simulator"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern
	       #:parenscript)
  
  :components ((:file "package")
	       (:module :src
			:serial t      
			:components ((:file "hello-world")
				     (:module :util
					       :serial t
					       :components ((:file "heroku-utils")))



				     ))))

