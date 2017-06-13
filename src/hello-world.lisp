(in-package :aubree)
(load "../simulator/qgame.lisp")

;; Utils

(defun heroku-getenv (target)
  #+ccl (ccl:getenv target)
  #+sbcl (sb-posix:getenv target))

(defun db-params ()
  "Heroku database url format is postgres://username:password@host:port/database_name.
TODO: cleanup code."
  (let* ((url (second (cl-ppcre:split "//" (heroku-getenv "DATABASE_URL"))))
	 (user (first (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (password (second (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (host (first (cl-ppcre:split ":" (first (cl-ppcre:split "/" (second (cl-ppcre:split "@" url)))))))
	 (database (second (cl-ppcre:split "/" (second (cl-ppcre:split "@" url))))))
    (list database user password host)))

(defun heroku-slug-dir ()
  (heroku-getenv "HOME"))

;;handler
(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" (concatenate 'string (heroku-slug-dir) "/public/")) hunchentoot:*dispatch-table*)


(defparameter *quantum-program*
	   `((hadamard 2)
	     (hadamard 1)
	     (u-theta 0 ,(/ pi 4))
	     (oracle ORACLE-TT 2 1 0)
	     (hadamard 2)
	     (cnot 2 1)
	     (hadamard 2)
	     (u-theta 2 ,(/ pi 2))
	     (u-theta 1 ,(/ pi 2))))

(defparameter *database* '(0 1 0 0))

(defvar *oracle*
	   (execute-quantum-program 
	    *quantum-program*
	    3
	    *database*))

(defparameter result (mapcar #'round (multi-qsys-output-probabilities *oracle* '(2 1))))



(defun square (n)
  (* n n))

(defparameter *dispatch-table* "")



(eval-when (:compile-toplevel :load-toplevel :execute) 
(defun css-generator()
  	  (css-lite:css
	    (("body") (:background-color "linen"))
	    
	    ))

(defparameter *ending-tag* "</style>")
)



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
  (concatenate 'string "The square of your input is: " (write-to-string (square (read-from-string data)))))


(smackjack:defun-ajax echo-grover () (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "Result: " (write-to-string (print result))))

(smackjack:defun-ajax echo-qgame (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "Result: " data))


(hunchentoot:define-easy-handler (say-yo2 :uri "/") ()
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

	      ; (:p "Click Run Grover to run Grover's Algorithm")
	       ;(:p (:input :id "data" :type "text"))

	       ;(:p (:button :type "button"
                ;   :onclick (ps-inline (run-grover))
                 ;  "Run Grover"))
	       
	       (:p "Enter your program in the textbox and click Run to run it")
	       (:p "<textarea id= \"program\" rows= \"4\" cols=\"50\" name=\"comment\" form=\"usrform\"></textarea>
")
		(:p (:button :type "button"
                   :onclick (ps-inline (run-qgame))
                   "Run!"))

		"<form enctype=\"multipart/form-data\" action=\"upload\" method=\"POST\">
 Upload your program as a file to run it: <input name=\"uploaded\" type=\"file\" /><br />
 <input type=\"submit\" value=\"Upload\" />
 </form>"
		
	       ))))  
      
(setq *dispatch-table* (list 'dispatch-easy-handlers
                             (create-ajax-dispatcher *ajax-processor*)))


(hunchentoot:define-easy-handler (index :uri "/index") ()
    "<form enctype=\"multipart/form-data\" action=\"upload\" method=\"POST\">
 Please choose a file: <input name=\"uploaded\" type=\"file\" /><br />
 <input type=\"submit\" value=\"Upload\" />
 </form>")
(defparameter *data* "")

(hunchentoot:define-easy-handler (upload :uri "/upload") (uploaded)
    (rename-file (car uploaded)
        (concatenate 'string "/tmp/"
        (setf *data* (cl-base64:string-to-base64-string (cadr uploaded)))))
    *data*)















