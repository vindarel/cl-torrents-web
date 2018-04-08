LISP?=sbcl

build:
	$(LISP) --quit \
		--load ../cl-torrents/torrents.asd \
		--eval '(ql:quickload :torrents)' \
		--load torrents-reblocks.asd \
		--eval '(ql:quickload "torrents-reblocks")' \
		--eval '(asdf:make :torrents-reblocks)' 
