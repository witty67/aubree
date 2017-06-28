(in-package :utilities)
(defun set-up ()
  (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 8080)))

(defun reset ()
  (clesh:script " ~/quicklisp/local-projects/aubree/utilities/kill.sh"))
