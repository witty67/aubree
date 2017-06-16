(in-package :simulators)

(defun dot-product (a b)
  (+ (* (first a) (first b)) (* (second a) (second b)) (* (third a) (third b))))

(defun cross-product (a b)
	  (concatenate 'list (cons (- (* (second a) (third b)) (* (third a) (second b))) '(i))
	    (cons  (- (* (third a) (first b)) (* (first a) (third b))) '(j))
	    (cons  (- (* (first a) (second b)) (* (second a) (first b))) '(k))))

 (defun lorentz (q E v B)
   (* q (+ E (cross-product v B))))

(defun force (q E v B)
	   (lorentz q E v b))
