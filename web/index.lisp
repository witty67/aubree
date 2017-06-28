(in-package :aubree)


(defparameter *data* "")
;; Utils



(eval-when (:compile-toplevel :load-toplevel :execute) 
(defun css-generator()
  	  (css-lite:css
	    (("body") (:background-color "linen"))
	    
	    ))

(defparameter *ending-tag* "</style>"))



(defun css-generator-properties ()
(css-lite:css
  (("#foo")
    (:length "50px"
     :margin "50 px 30 px"
     :border "1px solid red")
   (("li")
    (:width "50px"
     :float "left"
     :margin "50 px 30 px"
     :border "1px solid red")))))
(defmacro css-maker ()
	  (let ((local-header "<style type = \"text/css\" media = \"all\">"))
	    ` (hunchentoot:define-easy-handler (say-yo :uri "/css") ()
	       (cl-who:with-html-output-to-string (s)
	       (:html
		(:head
		  ,(concatenate 'string local-header (concatenate 'string (css-generator) *ending-tag*)) 
		  (:title "Introduction to Quantum Computing")
		  )
		(:body
		 (:p "aubree uses QGame as for a backend")

		 )

		)))))

(css-maker)


(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/repl-api"))

(smackjack:defun-ajax echo (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "The square of your input is: " (write-to-string (simulators:square (read-from-string data)))))

(smackjack:defun-ajax echo-fact (data) (*ajax-processor* :callback-data :response-text)
		      (concatenate 'string "The factorial of your input is: " (write-to-string (simulators:fact (read-from-string data)))))

(smackjack:defun-ajax echo-numpy (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "Output of python program: "  (simulators:run-python)))

(smackjack:defun-ajax echo-check-file (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "File location: "  (namestring (probe-file "~/quicklisp/local-projects/aubree/simulators"))))

(hunchentoot:define-easy-handler (say-yo2 :uri "/prototypes") ()
  (cl-who:with-html-output-to-string (s)
   (:html
              (:head
	       (:title "Aubree")
	      (str (generate-prologue *ajax-processor*))
	      (:script :type "text/javascript"
          (str
            (ps
              (defun callback (response)
                (alert response))
		
              (defun on-click ()
                (chain smackjack (echo (chain document
                                              (get-element-by-id "data")
                                              value)
                                       callback)))

	      (defun on-click-fact ()
                (chain smackjack (echo-fact (chain document
                                              (get-element-by-id "data-fact")
                                              value)
					    callback)))

	      (defun on-click-numpy ()
                (chain smackjack (echo-numpy (chain document
                                              (get-element-by-id "data-fact")
                                              value)
					     callback)))

	      (defun on-click-check-file ()
                (chain smackjack (echo-check-file (chain document
                                              (get-element-by-id "check-file")
                                              value)
                                       callback)))


	      ;(defun run-grover ()
                ;(chain smackjack (echo-grover)))

	      (defun run-qgame ()
                (chain smackjack (echo-qgame (chain document
                                              (get-element-by-id "program")
                                              value)
                                       callback)))

	      ))))
			
              (:body
	       (:h1 "Aubree: A Quantum Computer Simulator on the Cloud")
	       (:p "Aubree is powered by <a href=http://faculty.hampshire.edu/lspector/qgame.html\>\QGAME</a>")
	       (:p "Enter a number into the input box. You will get a square of it")
	       (:p (:input :id "data" :type "text"))
	       (:p (:button :type "button"
                   :onclick (ps-inline (on-click))
                   "Submit!"))


	       (:p "Enter a number into the input box. You will get a factorial called from a C Procedure")
	       (:p (:input :id "data-fact" :type "text"))
	       (:p (:button :type "button"
                   :onclick (ps-inline (on-click-fact))
                   "Submit!"))

	       (:p (:button :type "button"
                   :onclick (ps-inline (on-click-numpy))
                   "python-test"))

	       (:p (:button :type "button"
                   :onclick (ps-inline (on-click-check-file))
                   "file-test"))

	       (:a :href "static/hello.txt" "hello")

	      ; (:p "Click Run Grover to run Grover's Algorithm")
	       ;(:p (:input :id "data" :type "text"))

	       ;(:p (:button :type "button"
                ;   :onclick (ps-inline (run-grover))
                 ;  "Run Grover"))
	       
	       
	       ;(:p "<textarea id= \"program\" rows= \"4\" cols=\"50\" name=\"comment\" form=\"usrform\"></textarea>")
		;(:p (:button :type "button"
                ;  :onclick (ps-inline (run-qgame))
                 ;  "Run!"))

		"<form enctype=\"multipart/form-data\" action=\"upload\" method=\"POST\">
 Upload your quantum program as a file to run it: <input name=\"uploaded\" type=\"file\" /><br />
 <input type=\"submit\" value=\"Upload\" />
 </form>"
		(:p "Or, you could use the <a href=/editor\>\Online Text Editor</a>")
		
))))  
      
(setq *dispatch-table* (list 'dispatch-easy-handlers
                             (create-ajax-dispatcher *ajax-processor*)))

(hunchentoot:define-easy-handler (upload :uri "/upload") (uploaded)
    (rename-file (car uploaded)
        (concatenate 'string "/tmp/"
		     (setf *data* (cl-base64:string-to-base64-string (cadr uploaded)))))
    
    (simulators:process *data*))
    



(hunchentoot:define-easy-handler (say-yo1 :uri "/u1") (name)
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "Hey~@[ ~A~]!" name))

(hunchentoot:define-easy-handler (tutorial1 :uri "/tutorial1") ()
  (with-html-output-to-string (s)
    (:html
     (:head (:title "Parenscript tutorial: 1st example"))
     (:body (:h2 "Parenscript tutorial: 1st example")
            "Please click the link below." :br
            (:a :href "#" :onclick (ps (alert "Hello World"))
                "Hello World")))))

;;Loading other pages
(topological-page)
(editor)







