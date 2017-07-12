(in-package :example)

;(pomo:connect-toplevel "aubreedb" "vtomole" "19962014V" "localhost")
(defparameter *cover-page* "
<!DOCTYPE html>
<html lang='en'>
  <head>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-100856109-1', 'auto');
  ga('send', 'pageview');

</script>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <meta name='description' content=''>
    <meta name='author' content=''>
    <link rel='icon' href='../../favicon.ico'>

    <title>Aubree: Quantum Computing Payground</title>

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
             <h3 class='masthead-brand'>Aubree</h3>    
            <div class='inner'>        
              <nav class='nav nav-masthead'>
                <a class='nav-link' href='#'>Blog</a>
                <a class='nav-link' href='#'>Resources</a>
                <a class='nav-link' href='#'>Sign In</a>
                <a class='nav-link' href='/forum'>Forum</a>
              </nav>
            </div>
          </div>

          <div class='inner cover'>
            <h1 class='cover-heading'>Acess to all of your Quantum Computing needs</h1>
            <p class='lead'>Aubree is where you can learn about quantum computing, run quantum algorithms, communicate with other quantum computing hackers and keep up with the cutting edge knowledge of the field.</p>
            <p class='lead'>
              <a href='#' class='btn btn-lg btn-secondary'>Learn more</a>
            </p>
          </div>

          <div class='mastfoot'>
            <div class='inner'>
            </div>
          </div>

        </div>

      </div>

    </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src='https://code.jquery.com/jquery-3.2.1.slim.min.js' integrity='sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN' crossorigin='anonymous'></script>
 <script>window.jQuery || document.write('<script src='../../../../assets/js/vendor/jquery.min.js'><\\/script>')</script>
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
  (if (string= (heroku-getenv "HOME") "/home/vtomole") (list "aubreedb" "vtomole" "19962014V" "localhost")
  (let* ((url (second (cl-ppcre:split "//" (heroku-getenv "DATABASE_URL"))))
	 (user (first (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (password (second (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (host (first (cl-ppcre:split ":" (first (cl-ppcre:split "/" (second (cl-ppcre:split "@" url)))))))
	 (database (second (cl-ppcre:split "/" (second (cl-ppcre:split "@" url))))))
    (list database user password host))))


(defmacro create-table (name)
  `(with-connection (db-params)
  (unless (table-exists-p ',name)
    (execute (dao-table-definition ',name)))))



(defclass movie ()
    ((id :col-type serial :reader movie-id)
     (title :col-type string :initarg :title :accessor movie-title)
     (rating :col-type string :initarg :rating :accessor movie-rating)
     (release-date :col-type date :initarg :release-date :accessor movie-release-date))
    (:metaclass dao-class) 
    (:keys id))

(defclass comment-class ()
    ((id :col-type serial :reader thread-id)
     (author :col-type string :initarg :author :accessor comment-author)
     (email :col-type string :initarg :email :accessor comment-email)
     (subject :col-type string :initarg :subject :accessor comment-subject)
     (body :col-type string :initarg :body :accessor comment-body)
     (comment-date :col-type date :initarg :comment-date :accessor post-comment-date))
    (:metaclass dao-class) 
    (:keys id))

;;CRUD
(defmacro comment-create (&rest args)
  `(with-connection (db-params)
     (make-dao 'comment-class ,@args)))

(defun comment-get-all ()
  (with-connection (db-params)
    (select-dao 'comment-class)))

(defun comment-get (id)
  (with-connection (db-params)
    (select-dao 'comment-class id)))

(defmacro comment-select (sql-test &optional sort)
  `(with-connection (db-params)
     (select-dao 'comment-class ,sql-test ,sort)))

(defun comment-update (comment)
  (With-connection (db-params)
    (update-dao comment)))

(defun comment-delete (comment)
  (with-connection (db-params)
    (delete-dao comment)))

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
       ;(cl-who:str (pomo:query "select 22, 'vtomole', 4.5"))
       (:a :href "static/index.html" "hello"))

      (:div
       (:a :href "/prototypes" "prototypes"))
      (:h3 "App Database")
      (:div
       (:pre "SELECT version();"))
      (:div (format s "~A" (postmodern:with-connection (db-params)
(postmodern:query "select version()")))
      ))))))



(defun cover()
  (hunchentoot:define-easy-handler (hello-sbcl :uri "/") ()
  (cl-who:with-html-output-to-string (s)   
    (cl-who:str *cover-page*))))

(defclass comment ()
   ((author :reader author :initarg :author :initform nil)
    (email :reader email :initarg :email :initform nil)
    (subject :reader subject :initarg :subject :initform nil)
    (body :reader body :initarg :body :initform nil)
    (date-and-time :reader date-and-time :initarg :date-and-time)))

(defparameter test-comment
	   (make-instance 'comment
			  :author "Victory" :email "vtomole@iastate.edu" :subject "First one"
			  :body "Hey folks"
			  :date-and-time (get-universal-time)))

(defparameter test-comment2
  (make-instance 'comment
		 :author "vtomole" :email "vtomole@gmail.com" :subject "Hey welcome to this board"
		 :date-and-time (get-universal-time)))

(defmethod echo ((a-comment comment-class))
  (with-html-output-to-string (*standard-output* nil :indent t)
    (with-slots (author email subject body comment-date) a-comment
      (htm (:div :class "comment"
                 (:span :class "header" 
                        (str author) (str email) 
                        (str comment-date) (str subject))
                 (:span :class "body" 
                        (:p (str body))))))))


(defmethod echo ((a-comment comment))
  (with-html-output-to-string (*standard-output* nil :indent t)
    (with-slots (author email subject body date-and-time) a-comment
      (htm (:div :class "comment"
                 (:span :class "header" 
                        (str author) (str email) 
                        (str date-and-time) (str subject))
                 (:span :class "body" 
                        (:p (str body))))))))
(defclass board()
  ((name :reader name :initarg :name)
   (threads :accessor threads :initarg :threads :initform nil)))
(defclass thread ()
  ((board :reader board :initarg :board)
   (comments :accessor comments :initarg :comments)))

(defparameter test-comment3
  (make-instance 'comment
		 :subject "Hey what's up guys"
		 :body "This feels like the usernet"
		 :date-and-time (get-universal-time)))

(defparameter test-comment4
  (make-instance 'comment
		 :body "Scheme is awesome!"
		 :date-and-time (get-universal-time)))

(defparameter test-thread-temp
  (make-instance 'thread
		 :board "a"
		 :comments (list test-comment3 test-comment4)))

(defparameter test-thread
  (make-instance 'thread
		 :board "a"
		 :comments nil))

;(setf (comments test-thread) 
;           (append (comments test-thread) 
;                   (list test-comment3 test-comment4)))

(defparameter test-thread2
  (make-instance 'thread
		 :board "a"
		 :comments (list test-comment test-comment2)))

(defparameter test-thread3
  (make-instance 'thread
		 :board "a"
		 :comments (list test-comment3 test-comment4)))

(defparameter test-board (make-instance 'board
					:name "a"
					:threads (list test-thread-temp
						       test-thread2
						       test-thread-temp
						       test-thread2
						       test-thread-temp)))

(defmethod summarize ((thread thread) &optional (preview-comment-count 5))
  (let* ((preview-comments (last (cdr (comments thread)) preview-comment-count))
         (omitted-count (- (length (cdr (comments thread))) (length preview-comments)))
         (first-comment (car (comments thread))))
    (with-html-output (*standard-output* nil :indent t)
      (:div :class "thread"
            (echo-header first-comment)
            (:span :class "body" 
                   (:p (str (body first-comment))))
            (when (> omitted-count 0)
              (htm (:p :class "omitted" 
                       (str (format nil "~a comments omitted (and we don't do pictures yet)" 
                                    omitted-count)))))
            (dolist (r preview-comments)
              (str (echo r)))))))

(defmethod echo ((thread thread))
  (let ((first-comment (car (comments thread))))
    (cl-who:with-html-output (*standard-output* nil :indent t)
      (with-slots (author email subject body date-and-time) first-comment
        (htm (:div :class "thread"
                   (:span :class "header" 
                          (cl-who:str author) (cl-who:str email) 
                          (cl-who:str date-and-time) (cl-who:str subject))
                   (:span :class "body" 
                          (:p (cl-who:str body)))
                   (dolist (r (cdr (comments thread)))
                     (cl-who:str (echo r)))))))))

(defmethod echo-header ((comment comment))
  (cl-who:with-html-output (*standard-output*)
    (:span :class "header"
	   (dolist (elem '(author email date-and-time subject))
	     (htm (:span :class (format nil "~(~a~)" elem) (cl-who:str (slot-value comment elem))))))))


(defmethod echo ((board board))
  (with-html-output (*standard-output* nil :indent t)
    (:h1 (str (name board))) (:hr)
    (dolist (thread (threads board))
      (summarize thread))))

(defmacro page-template ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml" :xml\:lang "en" :lang "en"
	    (:head (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8")
(:title (str ,title))
       (:link :rel "stylesheet" :type "text/css" :href "static/bootstrap/css/forum.css"))
(:body ,@body))))

(defun forum () (hunchentoot:define-easy-handler (forum :uri "/forum") ()
		  (page-template (:title "Forum")
					(echo test-board)
		    )))


(defun thread () (hunchentoot:define-easy-handler (thread :uri "/thread") ()
		    (page-template (:title (board test-thread))
		      (show-formlet post-comment-form)
		      (setf (comments test-thread) (list test-comment3))
		      (dolist (comment (comment-get-all))
	   (setf (comments test-thread) (append (comments test-thread) (list comment))))
       (echo test-thread))))

(formlets:define-formlet (post-comment-form)
    ((author formlets:text) (email formlets:text) (subject formlets:text) (body formlets:textarea) ;(captcha formlets:recaptcha)
     )
  (let ((new-comment (make-instance 'comment
                                    :author author :email email 
                                    :subject subject :body body
                                    :date-and-time (get-universal-time))))
    ;(setf (comments test-thread)
     ;     (append (comments test-thread) (list new-comment)))
    (comment-create :author (author new-comment) :email (email new-comment) :subject (subject new-comment) :body (body new-comment) :comment-date (encode-date 2017 7 11))
    (redirect "/thread")))


;(defclass comment ()
;  ( (id :col-type serial :reader thread-id)
;   (author :col-type string :initarg :author :accessor author)
;   (email :col-type string :initarg :email :accessor email)
;   (subject :col-type string :initarg :subject :accessor subject)
;   (body :reader body :initarg :body :initform nil)
;    (date-and-time :reader date-and-time :initarg :date-and-time))
;  (:metaclass postmodern:dao-class)
					;  (:keys id))
;(defun sign-in () (hunchentoot:define-easy-handler (login-page :uri "/sign-in") ()
  ;(formlets:page-template (show-formlet login))))
(index)
(cover)
(create-table comment-class)
(forum)
(thread)
(publish-static-content)
(when (string= (heroku-slug-dir) "/home/vtomole/quicklisp/local-projects/aubree") (start-server 8080))
