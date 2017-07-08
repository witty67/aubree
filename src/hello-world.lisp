(in-package :example)
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
    <link href='static/bootstrap/css/bootstrap.min.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='static/bootstrap/css/cover.css' rel='stylesheet'>
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
;; Domain model
;; ============

;; A simple domain model of our games together with
;; access methods.

(defclass game ()
  ((name  :reader   name
          :initarg  :name)
   (votes :accessor votes
          :initform 0)))

;; By default the printed representation of CLOS objects isn't
;; particularly informative to a human. We can override the default
;; behaviour by specializing the generic function
;; print-object for our game (print-unreadable-object is
;; just a standard macro that helps us with the stream set-up
;; and display of type information).
(defmethod print-object ((object game) stream)
  (print-unreadable-object (object stream :type t)
    (with-slots (name votes) object
      (format stream "name: ~s with ~d votes" name votes))))

(defmethod vote-for (game)
  (incf (votes game)))

;; Backend
;; =======

;; A prototypic backend that stores all games in
;; a list. Later, we'll move to a persistent storage and
;; only need to modify these accessor functions:

(defvar *games* '())

;; We encapsulate all knowledge of the concrete storage
;; medium in the following functions:

(defun game-from-name (name)
  (find name *games* :test #'string-equal :key  #'name))

(defun game-stored? (game-name)
  (game-from-name game-name))

(defun games ()
  (sort (copy-list *games*) #'> :key #'votes))

(defun add-game (name)
  (unless (game-stored? name)
    (push (make-instance 'game :name name) *games*)))

;; Web Server - Hunchentoot

(defun start-server (port)
  (start (make-instance 'easy-acceptor :port port)))


;; DSL for our web pages
;; =====================

;; Here we grow a small domain-specific language for
;; creating dynamic web pages.

; Control the cl-who output format (default is XHTML, we
; want HTML5):
(setf (html-mode) :html5)

;; This is the initial version of our standard page template.
;; We'll evolve it later in the tutorial, making it accept
;; scripts as well (used to inject JavaScript for validation
;; into the HTML header).
(defmacro standard-page-1 ((&key title) &body body)
  "All pages on the Retro Games site will use the following macro;
   less to type and a uniform look of the pages (defines the header
   and the style sheet)."
  `(with-html-output-to-string
    (*standard-output* nil :prologue t :indent t)
    (:html :lang "en"
           (:head
            (:meta :charset "utf-8")
            (:title ,title)
            (:link :type "text/css"
                   :rel "stylesheet"
                   :href "static/retro.css"))
           (:body
            (:div :id "header" ; Retro games header
                  (:img :src "static/logo.jpg"
                        :alt "Commodore 64"
                        :class "logo")
                  (:span :class "strapline"
                         "Vote on your favourite Retro Game"))
            ,@body))))

(defmacro standard-page ((&key title script) &body body)
  "All pages on the Retro Games site will use the following macro;
   less to type and a uniform look of the pages (defines the header
   and the stylesheet).
   The macro also accepts an optional script argument. When present, the
   script form is expected to expand into valid JavaScript."
  `(with-html-output-to-string
    (*standard-output* nil :prologue t :indent t)
    (:html :lang "en"
           (:head
            (:meta :charset "utf-8")
            (:title ,title)
            (:link :type "text/css"
                   :rel "stylesheet"
                   :href "static/retro.css")
            ,(when script
               `(:script :type "text/javascript"
                         (str ,script))))
           (:body
            (:div :id "header" ; Retro games header
                  (:img :src "static/logo.jpg"
                        :alt "Commodore 64"
                        :class "logo")
                  (:span :class "strapline"
                         "Vote on your favourite Retro Game"))
            ,@body))))

;; HTML
;; ====

;; The functions responsible for generating the actual pages of our app go here.
;; We use the Hunchentoot macro define-easy-handler to automatically
;; push our uri to the dispatch table of the server and associate the
;; request with a function that will handle it.

(define-easy-handler (retro-games :uri "/retro-games") ()
  (standard-page (:title "Top Retro Games")
     (:h1 "Vote on your all time favourite retro games!")
     (:p "Missing a game? Make it available for votes " (:a :href "new-game" "here"))
     (:h2 "Current stand")
     (:div :id "chart" ; Used for CSS styling of the links.
       (:ol
	(dolist (game (games))
	 (htm
	  (:li (:a :href (format nil "vote?name=~a" (url-encode ; avoid injection attacks
                                                     (name game))) "Vote!")
	       (fmt "~A with ~d votes" (escape-string (name game))
                                       (votes game)))))))))

(define-easy-handler (new-game :uri "/new-game") ()
  (standard-page (:title "Add a new game"
                         :script (ps  ; client side validation
                                  (defvar add-form nil)
                                  (defun validate-game-name (evt)
                                    "For a more robust event handling
                                     mechanism you may want to consider
                                     a library (e.g. jQuery) that encapsulates
                                     all browser-specific quirks."
                                    (when (= (@ add-form name value) "")
                                      (chain evt (prevent-default))
                                      (alert "Please enter a name.")))
                                  (defun init ()
                                    (setf add-form (chain document
                                                          (get-element-by-id "addform")))
                                    (chain add-form
                                           (add-event-listener "submit" validate-game-name false)))
                                  (setf (chain window onload) init)))
     (:h1 "Add a new game to the chart")
     (:form :action "/game-added" :method "post" :id "addform"
            (:p "What is the name of the game?" (:br)
                (:input :type "text" :name "name" :class "txt"))
            (:p (:input :type "submit" :value "Add" :class "btn")))))

(define-easy-handler (game-added :uri "/game-added") (name)
  (unless (or (null name) (zerop (length name))) ; In case JavaScript is turned off.
    (add-game name))
  (redirect "/retro-games")) ; back to the front page

(define-easy-handler (vote :uri "/vote") (name)
  (when (game-stored? name)
    (vote-for (game-from-name name)))
  (redirect "/retro-games")) ; back to the front page

;; Alright, everything has been defined - launch Hunchentoot and have it
;; listen to incoming requests:

(defparameter *google-analytics*
	  "<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-100856109-1', 'auto');
  ga('send', 'pageview');

</script>")




;; Utils
(defun heroku-getenv (target)
  #+ccl (ccl:getenv target)
  #+sbcl (sb-posix:getenv target))

(defun heroku-slug-dir ()
  (if (string= (heroku-getenv "HOME") "/home/vtomole") "/home/vtomole/quicklisp/local-projects/aubree" (heroku-getenv "HOME")))
  

(defun db-params ()
  "Heroku database url format is postgres://username:password@host:port/database_name.
TODO: cleanup code."
  (let* ((url (second (cl-ppcre:split "//" (heroku-getenv "DATABASE_URL"))))
	 (user (first (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (password (second (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (host (first (cl-ppcre:split ":" (first (cl-ppcre:split "/" (second (cl-ppcre:split "@" url)))))))
	 (database (second (cl-ppcre:split "/" (second (cl-ppcre:split "@" url))))))
    (list database user password host)))

;; Handlers
(defun publish-static-content ()

(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" (concatenate 'string (heroku-slug-dir) "/public/")) hunchentoot:*dispatch-table*)

;(push (create-static-file-dispatcher-and-handler
 ;        "/logo.jpg" "static/Commodore64.jpg") *dispatch-table*)
 ; (push (create-static-file-dispatcher-and-handler
					;        "/retro.css" "static/retro.css") *dispatch-table*)
)

(defun index () (hunchentoot:define-easy-handler (temp-index :uri "/cover") ()
  (cl-who:with-html-output-to-string (s)   
    (:html
      (cl-who:str *google-analytics*)
     (:head
      (:title "Quantum Computing Playground"))
     (:body
      (:h1 "Aubree")
      (:link :type "text/css"
                   :rel "stylesheet"
:href "/retro.css")
      (:div
       (:a :href "static/index.html" "hello"))

      (:div
       (:a :href "/prototypes" "prototypes"))
      )))))

(defun cover()
  (hunchentoot:define-easy-handler (hello-sbcl :uri "/") ()
  (cl-who:with-html-output-to-string (s)   
     (cl-who:str *cover-page*))))
(index)
(cover)
(publish-static-content)
(when (string= (heroku-slug-dir) "/home/vtomole/quicklisp/local-projects/aubree") (start-server 8080))
