LISP?=sbcl

build:
	$(LISP) --non-interactive \
		--eval '(ql:quickload :torrents)' \
		--load torrents-reblocks.asd \
		--eval '(ql:quickload "torrents-reblocks")' \
		--eval '(asdf:make :torrents-reblocks)'

install:

	cd ~/quicklisp/local-projects/ && git clone https://github.com/vindarel/replic/  # for cl-torrents
	cd ~/quicklisp/local-projects/ && git clone https://github.com/vindarel/cl-torrents
	# weblocks deps should be in Ultralisp now.
	cd ~/quicklisp/local-projects/ && git clone https://github.com/40ants/log4cl-json
	cd ~/quicklisp/local-projects/ && git clone https://github.com/40ants/weblocks
	cd ~/quicklisp/local-projects/ && git clone https://github.com/40ants/weblocks-ui
	cd ~/quicklisp/local-projects/ && git clone https://github.com/40ants/weblocks-parenscript
