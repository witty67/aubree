;;;; package.lisp
(defpackage :utilities
  (:use :cl
	:cl-forest)
  (:export :set-key :set-key-1))

(defpackage #:aubree
  (:use #:cl #:cl-who #:hunchentoot #:postmodern #:parenscript  #:cl-fad #:smackjack :cl-forest :utilities))

(defpackage #:simulators
  (:use #:cl #:zpng)
  (:export :process :execute-quantum-program :amplitudes :fact :square :run-python :cl-forest :epr))

(defpackage #:example
  (:use :cl :cl-who :hunchentoot :parenscript :formlets :postmodern :simple-date)
  (:export :*google-analytics*)
  (:shadowing-import-from :cl-mongo  :show)
  (:shadowing-import-from :s-sql  :text))

(defpackage tests
  (:use :cl
        :prove
	:simulators))


