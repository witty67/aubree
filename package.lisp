;;;; package.lisp

(defpackage #:aubree
  (:use #:cl #:cl-who #:hunchentoot #:postmodern #:parenscript  #:cl-fad #:smackjack))

(defpackage #:simulators
  (:use #:cl #:zpng)
  (:export :process :execute-quantum-program :amplitudes :fact :square :run-python))

(defpackage #:example
  (:use #:cl))

(defpackage tests
  (:use :cl
        :prove
	:simulators))
