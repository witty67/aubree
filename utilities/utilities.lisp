(in-package :utilities)
(defun set-key (key)
  (setq cl-forest:*api-key* key)
  (write-to-string key))

(set-key "nmRPAVunQl19TtQz9eMd11iiIsArtUDTaEnsSV6u")


(defun set-key-1 (key)
  (let ((key-string (write-to-string key)))
  (print (typep key 'string))
  (setq cl-forest:*api-key* key-string)
					;(simulators:run-quil "H 0")

  (cl-forest:run (quil "H 0"
                      "CNOT 0 1"
                      "MEASURE 0 [0]"
                      "MEASURE 1 [1]")
                '(0 1)
                10)
  key-string))
