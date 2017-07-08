(in-package :aubree)

(defparameter local-string "home/vtomole/quicklisp/local-projects/aubree/public/hello.txt")
(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/repl-api"))

(defparameter *cover-page* "
<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <meta name='description' content=''>
    <meta name='author' content=''>
    <link rel='icon' href='../../favicon.ico'>

    <title>Cover Template for Bootstrap</title>

    <!-- Bootstrap core CSS -->
    <link href='https://raw.githubusercontent.com/vtomole/aubree/master/public/bootstrap/css/bootstrap.min.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='cover.css' rel='stylesheet'>
  </head>

  <body>

    <div class='site-wrapper'>

      <div class='site-wrapper-inner'>

        <div class='cover-container'>

          <div class='masthead clearfix'>
            <div class='inner'>
              <h3 class='masthead-brand'>Cover</h3>
              <nav class='nav nav-masthead'>
                <a class='nav-link active' href='#'>Home</a>
                <a class='nav-link' href='#'>Features</a>
                <a class='nav-link' href='#'>Contact</a>
              </nav>
            </div>
          </div>

          <div class='inner cover'>
            <h1 class='cover-heading'>Cover your page.</h1>
            <p class='lead'>Cover is a one-page template for building simple and beautiful home pages. Download, edit the text, and add your own fullscreen background photo to make it your own.</p>
            <p class='lead'>
              <a href='#' class='btn btn-lg btn-secondary'>Learn more</a>
            </p>
          </div>

          <div class='mastfoot'>
            <div class='inner'>
              <p>Cover template for <a href='https://getbootstrap.com'>Bootstrap</a>, by <a href='https://twitter.com/mdo'>@mdo</a>.</p>
            </div>
          </div>

        </div>

      </div>

    </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src='https://code.jquery.com/jquery-3.2.1.slim.min.js' integrity='sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN' crossorigin='anonymous'></script>
    <script>window.jQuery || document.write('<script src='../../../../assets/js/vendor/jquery.min.js'><\/script>')</script>
    <script src='../../../../assets/js/vendor/popper.min.js'></script>
    <script src='../../../../dist/js/bootstrap.min.js'></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src='../../../../assets/js/ie10-viewport-bug-workaround.js'></script>
  </body>
</html>
")
(defparameter *cover-css* 
"
/*
 * Globals
 */

/* Links */
a,
a:focus,
a:hover {
  color: #fff;
}

/* Custom default button */
.btn-secondary,
.btn-secondary:hover,
.btn-secondary:focus {
  color: #333;
  text-shadow: none; /* Prevent inheritance from `body` */
  background-color: #fff;
  border: .05rem solid #fff;
}


/*
 * Base structure
 */

html,
body {
  height: 100%;
  background-color: #333;
}
body {
  color: #fff;
  text-align: center;
  text-shadow: 0 .05rem .1rem rgba(0,0,0,.5);
}

/* Extra markup and styles for table-esque vertical and horizontal centering */
.site-wrapper {
  display: table;
  width: 100%;
  height: 100%; /* For at least Firefox */
  min-height: 100%;
  -webkit-box-shadow: inset 0 0 5rem rgba(0,0,0,.5);
          box-shadow: inset 0 0 5rem rgba(0,0,0,.5);
}
.site-wrapper-inner {
  display: table-cell;
  vertical-align: top;
}
.cover-container {
  margin-right: auto;
  margin-left: auto;
}

/* Padding for spacing */
.inner {
  padding: 2rem;
}


/*
 * Header
 */

.masthead {
  margin-bottom: 2rem;
}

.masthead-brand {
  margin-bottom: 0;
}

.nav-masthead .nav-link {
  padding: .25rem 0;
  font-weight: bold;
  color: rgba(255,255,255,.5);
  background-color: transparent;
  border-bottom: .25rem solid transparent;
}

.nav-masthead .nav-link:hover,
.nav-masthead .nav-link:focus {
  border-bottom-color: rgba(255,255,255,.25);
}

.nav-masthead .nav-link + .nav-link {
  margin-left: 1rem;
}

.nav-masthead .active {
  color: #fff;
  border-bottom-color: #fff;
}

@media (min-width: 48em) {
  .masthead-brand {
    float: left;
  }
  .nav-masthead {
    float: right;
  }
}


/*
 * Cover
 */

.cover {
  padding: 0 1.5rem;
}
.cover .btn-lg {
  padding: .75rem 1.25rem;
  font-weight: bold;
}


/*
 * Footer
 */

.mastfoot {
  color: rgba(255,255,255,.5);
}


/*
 * Affix and center
 */

@media (min-width: 40em) {
  /* Pull out the header and footer */
  .masthead {
    position: fixed;
    top: 0;
  }
  .mastfoot {
    position: fixed;
    bottom: 0;
  }
  /* Start the vertical centering */
  .site-wrapper-inner {
    vertical-align: middle;
  }
  /* Handle the widths */
  .masthead,
  .mastfoot,
  .cover-container {
    width: 100%; /* Must be percentage or pixels for horizontal alignment */
  }
}

@media (min-width: 62em) {
  .masthead,
  .mastfoot,
  .cover-container {
    width: 42rem;
  }
}
")


(defun topological-page () (hunchentoot:define-easy-handler (tutorial3 :uri "/topological-intro") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (cl-who:str example:*google-analytics*)
     (:head
      (:title "Parenscript tutorial: 2nd example")
      (:link :rel "stylesheet" :href "cover.css")
      (:script :type "text/javascript"
               (str (ps
                      (defun greeting-callback ()
                        (alert "Hello World"))))))
     (:body
      (:h2 "Parenscript tutorial: 2nd example")
     (:p (:a :href local-string "hell"))
      (:a :href "#" :onclick (ps (greeting-callback))
          "Hello World2"))))))

(smackjack:defun-ajax echo-key (data) (*ajax-processor* :callback-data :response-text)
					;(concatenate 'string "Your key has been set, you can now run the program: " (utilities:set-key data))
  (concatenate 'string "The triple of your input is: " (write-to-string (utilities:set-key-1 (read-from-string data))))
  )
  
		     

(defun editor () (hunchentoot:define-easy-handler (editor :uri "/editor") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (cl-who:str example:*google-analytics*)
    (:head       
	      (str (generate-prologue *ajax-processor*))
	      (:script :type "text/javascript"
          (str
            (ps
              (defun callback (response)
                (alert response))
		
              (defun on-click-key ()
                (chain smackjack (echo-key (chain document
                                              (get-element-by-id "data-key")
                                              value)
                                       callback)))        

	          

	      ))))
			
              (:body
	       
	       (:h1 "Quantum Program Editor For the browser")
	       (:p "Enter Your API key into the box")
	       (:p (:input :id "data-key" :type "text"))
	       (:p (:button :type "button"
                   :onclick (ps-inline (on-click-key))
                   "Submit!"))

	       (:form :action "/test2" :method "post" :id "addform"
      (:p "Enter your Quantum Program in the textbox and click Submit to run it.")
     (:textarea :type "text" :name "name" :cols "60" :rows "30" :class "txt")
     (:p (:input :type "submit" :class "btn" :value "Submit")))
		
)))))

(define-easy-handler (test2 :uri "/test2") (name)
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html 
     (:body
      (:h1 (str name))))))

(defun cover()
  (hunchentoot:define-easy-handler (hello-sbcl :uri "/cover") ()
  (cl-who:with-html-output-to-string (s)   
    (:link :rel "stylesheet" :href "cover.css")
     (cl-who:str *cover-page*))))
