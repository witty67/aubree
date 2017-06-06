(in-package :cl-user)

(print ">>> Building system....")

(load (merge-pathnames "aubree.asd" *build-dir*))

(ql:quickload :aubree)

;;; Redefine / extend heroku-toplevel here if necessary.

(print ">>> Done building system")
