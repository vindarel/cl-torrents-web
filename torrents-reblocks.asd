#|
  This file is a part of torrents-reblocks project.
|#

(asdf:defsystem torrents-reblocks
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:weblocks
               :torrents
               :spinneret)
  :components ((:module "src"
                :components
                ((:file "torrents-reblocks"))))
  :description ""
  :in-order-to ((test-op (test-op "torrents-reblocks-test"))))
