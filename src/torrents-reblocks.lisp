(defpackage torrents-reblocks
  (:use #:cl
        #:torrents ;; local project
        #:weblocks/html)
  (:import-from #:weblocks/app
                #:defapp)
  (:import-from #:weblocks-ui/form
                #:with-html-form
                #:render-form-and-button))
(in-package :torrents-reblocks)

(defapp torrents)

(defvar *port* (find-port:find-port))


(defparameter *title* "cl-torrents")

(defun assoc-value (alist key &key (test #'equalp))
  ;; Don't import Alexandria just for that.
  ;; See also Quickutil to import only the utility we need.
  ;; http://quickutil.org/lists/
  (cdr (assoc key alist :test test)))

(defmethod weblocks/session:init ((app torrents))
  (let (results)
    (flet ((query (&key query &allow-other-keys)
             (format t "searching for ~a~&" query)
             (setf results (async-torrents query))
             (weblocks/widget:update (weblocks/widgets/root:get)))
           (see-magnet (&key index &allow-other-keys)
             (declare (ignorable index))
             (format t "see-magnet~&")
             (weblocks/widget:update (weblocks/widgets/root:get))))
      (lambda ()
        (with-html
          (:doctype)
          (:html
           (:head
            (:meta :http-equiv "Content-Type" :content "text/html; charset=utf-8") ;; useless
            (:meta :charset "UTF-8")
            (:meta :charset "UTF-8")
            (:link :rel "stylesheet" :type "text/css" :href "../node_modules/semantic-ui/dist/semantic.min.css")
            (:title *title*))

           (:h1 "cl-torrents")
           (with-html-form (:POST #'query)
             (:div :class "ui action input"
              (:input :type "text"
                      :name "query"
                      :class "ui input"
                      :placeholder "search...")
              (:input :type "submit"
                      :value "Search")))

           (:table :class "ui selectable table"
            (:thead
             (:th "Title")
             (:th "Seeders")
             (:th "Leechers")
             (:th ))
            (:tbody)
            (dolist (it results)
              (with-html
                (:tr
                 (:td (:a :href (assoc-value it :href)
                          (assoc-value it :title)))
                 (:td (assoc-value it :seeders))
                 (:td (assoc-value it :leechers))
                 (:td
                  (with-html-form (:POST #'see-magnet)
                    (:input :type "hidden"
                            :name "index"
                            :value (position it results))
                    (:input :type "submit"
                            :class "ui primary button"
                            :value "see-magnet")))))))))))))

(defun start ()
  (weblocks/debug:on)
  (weblocks/server:start :port *port*))

;; restart
(weblocks/debug:reset-latest-session)
