(in-package :aubree)

(defun square (n)
  (* n n))
(defparameter *ending-tag* "</style>")
(defparameter *dispatch-table* "")
;; Utils
(defun heroku-getenv (target)
  #+ccl (ccl:getenv target)
  #+sbcl (sb-posix:getenv target))



(eval-when (:compile-toplevel :load-toplevel :execute) 
(defun css-generator()
  	  (css-lite:css
	    (("body") (:background-color "linen"))
	    
	    )))

(defun css-generator-cl-css ()
  (cl-css:css '((body :margin 5px :padding 0px))))

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




(defun heroku-slug-dir ()
  (heroku-getenv "HOME"))

(defun db-params ()
  "Heroku database url format is postgres://username:password@host:port/database_name.
TODO: cleanup code."
  (let* ((url (second (cl-ppcre:split "//" (heroku-getenv "DATABASE_URL"))))
	 (user (first (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (password (second (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (host (first (cl-ppcre:split ":" (first (cl-ppcre:split "/" (second (cl-ppcre:split "@" url)))))))
	 (database (second (cl-ppcre:split "/" (second (cl-ppcre:split "@" url))))))
    (list database user password host)))

;; Handlers

(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" (concatenate 'string (heroku-slug-dir) "/public/")) hunchentoot:*dispatch-table*)

(hunchentoot:define-easy-handler (hello-sbcl :uri "/placeholder") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
      (:title "Heroku CL Example App"))
     (:body
      (:h1 "Heroku CL Example App")
      (:h3 "Using")
      (:ul
       (:li (format s "~A ~A" (lisp-implementation-type) (lisp-implementation-version)))
       (:li (format s "Hunchentoot ~A" hunchentoot::*hunchentoot-version*))
       (:li (format s "CL-WHO")))
      (:div
       (:a :href "static/lisp-glossy.jpg" (:img :src "static/lisp-glossy.jpg" :width 100)))
      (:div
       (:a :href "static/hello.txt" "hello"))
      (:h3 "App Database")
      (:div
       (:pre "SELECT version();"))
      (:div (format s "~A" (postmodern:with-connection (db-params)
(postmodern:query "select version()"))))))))

(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/repl-api"))

(smackjack:defun-ajax echo (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "The square of your input is: " (write-to-string (square (read-from-string data)))))


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
                                       callback)))))))
			
              (:body
	       (:h1 "Aubree: A Quantum Computer Simulator on the Cloud")
	       (:p "Aubree is powered by <a href=http://faculty.hampshire.edu/lspector/qgame.html\>\QGAME</a>")
	       (:p "Enter a number into the input box. You will get a square of it")
	       (:p
          (:input :id "data" :type "text"))
	       (:p
          (:button :type "button"
                   :onclick (ps-inline (on-click))
                   "Submit!"))))))   
      
(setq *dispatch-table* (list 'dispatch-easy-handlers
                             (create-ajax-dispatcher *ajax-processor*)))


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

(hunchentoot:define-easy-handler (tutorial3 :uri "/tutorial3") ()
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
      (:a :href "#" :onclick (ps (greeting-callback))
          "Hello World2")))))









