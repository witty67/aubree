;;;; package.lisp
(defpackage :utilities
  (:use :cl
	:cl-forest)
  (:export :set-key))

(defpackage #:aubree
  (:use #:cl #:cl-who #:hunchentoot #:postmodern #:parenscript  #:cl-fad #:smackjack :cl-forest :utilities))

(defpackage #:simulators
  (:use #:cl #:zpng)
  (:export :process :execute-quantum-program :amplitudes :fact :square :run-python :cl-forest :epr))

(defpackage #:example
  (:use #:cl))

(defpackage tests
  (:use :cl
        :prove
	:simulators))


