(ql:quickload '(hunchentoot cl-who postmodern simple-date parenscript cl-fad
		fiveam css-lite cl-json smackjack zpng l-math cffi clesh cl-forest))
(use-package 'named-readtables)
(in-readtable clesh:syntax)
(asdf:defsystem #:example
  :serial t
  :description "Example cl-heroku application"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern)
  :components ((:file "package")
	       (:module :src
			:serial t      
			:components ((:file "hello-world")))))
