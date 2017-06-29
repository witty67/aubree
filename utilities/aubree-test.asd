(defsystem aubree-test
  :depends-on (:example
               :prove)
  :defsystem-depends-on (:prove-asdf)
  :components
  ((:test-file "utilities/tests"))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
