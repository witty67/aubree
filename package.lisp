;;;; package.lisp

(defpackage :utilities
  (:use :cl
	:cl-forest
	:clesh)
  (:export :set-key :set-up :reset))

(defpackage #:aubree
  (:use #:cl #:cl-who #:hunchentoot #:postmodern #:parenscript  #:cl-fad #:smackjack :cl-forest :utilities))

(defpackage #:simulators
  (:use #:cl #:zpng :cl-forest)
  (:export :process :execute-quantum-program :amplitudes :fact :square :run-python :cl-forest :run-quil))

(defpackage #:example
  (:use #:cl))

(defpackage tests
  (:use :cl
        :prove
	:simulators))


