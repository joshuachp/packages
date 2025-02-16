.PHONY: srpm

SHELL=/usr/bin/env bash -xeuEo pipefail

srpm:
ifndef outdir
	$(error outdir is undefined)
endif
ifndef spec
	$(error spec file is undefined)
endif
	$(MAKE) -f "$$(dirname $(spec))/Makefile" srpm
