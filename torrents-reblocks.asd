#|
  This file is a part of torrents-reblocks project.
|#

(asdf:defsystem torrents-reblocks
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:weblocks
               :weblocks-ui
               :torrents
               :find-port
               :spinneret
               :bordeaux-threads)
  :components ((:module "src"
                :components
                ((:file "torrents-reblocks"))))
  :description ""

  ;; build executable with asdf:make
  :build-operation "program-op"
  :build-pathname "torrents-web"
  :entry-point "torrents-reblocks:main"

  :in-order-to ((test-op (test-op "torrents-reblocks-test"))))
