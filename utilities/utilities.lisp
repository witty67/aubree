(in-package :utilities)
(defun set-key (key)
  (setq cl-forest:*api-key* key)
  (write-to-string key))

(set-key "nmRPAVunQl19TtQz9eMd11iiIsArtUDTaEnsSV6u")
