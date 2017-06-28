(in-package :aubree)

(defparameter local-string "home/vtomole/quicklisp/local-projects/aubree/public/hello.txt")

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

(define-easy-handler (test :uri "/editor") () 
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html 
     (:body
      (:h1 "Quantum Program Editor For the browser")
      (:form :action "/test2" :method "post" :id "addform"
      (:p "Enter your Quantum Program in the textbox and click Submit to run it.")
     (:textarea :type "text" :name "name" :cols "60" :rows "30" :class "txt")
     (:p (:input :type "submit" :class "btn" :value "Submit")))))))

(define-easy-handler (test2 :uri "/test2") (name)
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html 
     (:body
      (:h1 (str name))))))
