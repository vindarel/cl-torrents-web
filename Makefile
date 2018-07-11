LISP?=sbcl

build:
	$(LISP) --non-interactive \
		--load ../cl-torrents/torrents.asd \
		--eval '(ql:quickload :torrents)' \
		--load torrents-reblocks.asd \
		--eval '(ql:quickload "torrents-reblocks")' \
		--eval '(asdf:make :torrents-reblocks)'
