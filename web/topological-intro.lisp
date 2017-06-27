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
      <link rel="import" href="/home/vtomole/quicklisp/local-projects/aubree/public/hello.txt">
      (:a :href "#" :onclick (ps (greeting-callback))
          "Hello World2"))))))
