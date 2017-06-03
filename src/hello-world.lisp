(in-package :aubree)

;; Utils
(defun heroku-getenv (target)
  #+ccl (ccl:getenv target)
  #+sbcl (sb-posix:getenv target))

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


(hunchentoot:define-easy-handler (say-yo :uri "/") ()
  (cl-who:with-html-output-to-string (s)
    (:html
              (:head
                 (:title "Test page"))
              (:body
                 (:p "CL-WHO is really easy to use")))))
 

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
                        (alert "Hello World2"))))))
     (:body
      (:h2 "Parenscript tutorial: 2nd example")
      (:a :href "#" :onclick (ps (greeting-callback))
          "Hello World2")))))

(defun css-generator()
	  (css-lite:css
  (("body") (:background-color "red"))))

(defmacro css-maker ()
	  (let ((local-header "<style type = \"text/css\" media = \"all\">"))
	    ` (cl-who:with-html-output-to-string (s)
	       (:html
		(:head
		 ,(concatenate 'string local-header (css-generator))
		 (:title "Test page5"))
		(:body
		 (:p "CL-WHO is really easy to use Test"))))))


(hunchentoot:define-easy-handler (say-yo2 :uri "/") ()
    (css-maker))
