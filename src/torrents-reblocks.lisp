(defpackage torrents-reblocks
  (:use #:cl
        #:torrents ;; local project
        #:weblocks-ui/form
        #:weblocks/html)
  (:import-from #:weblocks/app
                #:defapp)
  (:import-from #:weblocks/widget
                #:get-html-tag
                #:render
                #:update
                #:defwidget)
  (:import-from #:weblocks/actions
                #:make-js-action)

  (:export #:start
           #:main))
(in-package :torrents-reblocks)

(defapp torrents)

(weblocks/debug:on)

(defvar *port* (find-port:find-port :min 4000))

(defparameter *title* "torrents-web")

(defun assoc-value (alist key &key (test #'equalp))
  ;; Don't import Alexandria just for that.
  ;; See also Quickutil to import only the utility we need.
  ;; http://quickutil.org/lists/
  (cdr (assoc key alist :test test)))

(defwidget result ()
  ((torrent
    :initarg :torrent
    :accessor result-torrent)
   ;xxx the magnet should be in a "torrent" object, not alist.
   (magnet
    :initform nil
    :accessor result-magnet)
   (clicked-p
    :initform nil
    :accessor result-clicked-p)))

(defun make-result (torrent)
  (make-instance 'result :torrent torrent))


(defmethod render ((it result))
  (let ((torrent (result-torrent it)))
    (flet ((see-magnet (&key &allow-other-keys)
             (log:info "see-magnet of widget ~a~&" (result-torrent it))
             (setf (result-magnet it) (magnet-link-from torrent))
             (update it)))
      (with-html
        (:td (:a :href (href torrent)
                 (title torrent)))
         (:td (seeders torrent))
         (:td (leechers torrent))
         (:td (source torrent))
         (:td
          (with-html-form (:POST #'see-magnet)
            (:input :type "submit"
                    :class "ui primary button"
                    :value "magnet")))
        (when (result-magnet it)
           (:tr
            (:td :colspan 5
                 (:h4 (format nil "magnet:"))
                 (:div (result-magnet it)))))))))

(defwidget results-list ()
  ((results
    :initarg :results
    :accessor results)))

(defun make-results-list (results)
  (make-instance 'results-list :results results))

(defmethod render ((it results-list))
  (let ((results (results it)))
    (flet ((query (&key query &allow-other-keys)
             (let (search-results)
               (log:info "searching for" query)
               (setf search-results (async-torrents query))
               (setf (results it) (loop for res in search-results
                                     :collect (make-result res)))
               (log:info "finished search")
               (weblocks/widget:update (weblocks/widgets/root:get)))))
      (with-html
        (with-html
          (:doctype)
          (:html
           (:head
            (:meta :http-equiv "Content-Type" :content "text/html; charset=utf-8") ;; useless
            (:meta :charset "UTF-8")
            (:meta :charset "UTF-8")
            (:link :rel "stylesheet" :type "text/css" :href "https://cdn.jsdelivr.net/npm/semantic-ui@2.3.1/dist/semantic.min.css" )
            (:title *title*))

           (:h1 (:a :href "https://github.com/vindarel/cl-torrents-web" "cl-torrents"))
           (with-html-form (:POST #'query)
             (:div :class "ui action input"
                   (:input :type "text"
                           :name "query"
                           :class "ui input"
                           :placeholder "search...")
                   (:input :type "submit"
                           :value "Search")))

           (when results
             (:table :class "ui selectable table"
                     (:thead
                      (:th "Title")
                      (:th "Seeders")
                      (:th "Leechers")
                      (:th "Source")
                      (:th ))
                     (:tbody)
                     (dolist (it results)
                       (render it))))))))))

(defmethod weblocks/session:init ((app torrents))
  (make-results-list nil))

(defun start ()
  (weblocks/debug:on)
  (weblocks/server:start :port *port*))

(defun stop ()
  (weblocks/server:stop))

(defun reset ()
  "Restart (development), take code changes into account."
  (weblocks/debug:reset-latest-session))

(defun main ()
  (defvar *port* (find-port:find-port))

  (start)
  (handler-case (bt:join-thread (find-if (lambda (th)
                                             (search "hunchentoot" (bt:thread-name th)))
                                         (bt:all-threads)))
    (#+sbcl sb-sys:interactive-interrupt
      #+ccl  ccl:interrupt-signal-condition
      #+clisp system::simple-interrupt-condition
      #+ecl ext:interactive-interrupt
      #+allegro excl:interrupt-signal
      () (progn
           (format *error-output* "Aborting.~&")
           ;; (weblocks:stop)
           (uiop:quit 1))
    ;; for others, unhandled errors (we might want to do the same).
      (error (c) (format t "Woops, an unknown error occured:~&~a~&" c)))))
