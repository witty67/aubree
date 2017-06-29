(in-package :aubree)

(defparameter local-string "home/vtomole/quicklisp/local-projects/aubree/public/hello.txt")
(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/repl-api"))

(defun topological-page () (hunchentoot:define-easy-handler (tutorial3 :uri "/topological-intro") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
      (:title "Parenscript tutorial: 2nd example")
      (:script :type "text/javascript"
               (str (ps
                      (defun greeting-callback ()
                        (alert "Hello World"))))))
     (:body
      (:h2 "Parenscript tutorial: 2nd example")
     (:p (:a :href local-string "hell"))
      (:a :href "#" :onclick (ps (greeting-callback))
          "Hello World2"))))))

(smackjack:defun-ajax echo-key (data) (*ajax-processor* :callback-data :response-text)
					;(concatenate 'string "Your key has been set, you can now run the program: " (utilities:set-key data))
  (concatenate 'string "The triple of your input is: " (write-to-string (utilities:set-key-1 (read-from-string data))))
  )
  
		     

(defun editor () (hunchentoot:define-easy-handler (editor :uri "/editor") ()
  (cl-who:with-html-output-to-string (s)
   (:html
    (:head
     
	       
	      (str (generate-prologue *ajax-processor*))
	      (:script :type "text/javascript"
          (str
            (ps
              (defun callback (response)
                (alert response))
		
              (defun on-click-key ()
                (chain smackjack (echo-key (chain document
                                              (get-element-by-id "data-key")
                                              value)
                                       callback)))        

	          

	      ))))
			
              (:body
	       
	       (:h1 "Quantum Program Editor For the browser")
	       (:p "Enter Your API key into the box")
	       (:p (:input :id "data-key" :type "text"))
	       (:p (:button :type "button"
                   :onclick (ps-inline (on-click-key))
                   "Submit!"))

	       (:form :action "/test2" :method "post" :id "addform"
      (:p "Enter your Quantum Program in the textbox and click Submit to run it.")
     (:textarea :type "text" :name "name" :cols "60" :rows "30" :class "txt")
     (:p (:input :type "submit" :class "btn" :value "Submit")))
		
)))))

(define-easy-handler (test2 :uri "/test2") (name)
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html 
     (:body
      (:h1 (str name))))))
