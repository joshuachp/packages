.PHONY: srpm install-deps

SHELL=/usr/bin/env bash -xeuEo pipefail
SPEC_FILE=golang-astartectl.spec
SRPM_FILE="$(shell rpmspec --query $(SPEC_FILE) --queryformat '%{name}-%{version}-%{release}').src.rpm"
TOPDIR=$(shell rpmspec -E '%{_topdir}')

srpm: $(outdir)/$(SRPM_FILE)

$(outdir)/$(SRPM_FILE): $(SPEC_FILE)
	spectool --all -g -R golang-astartectl.spec
	rpmbuild -bs $(SPEC_FILE)
	cp -v $(TOPDIR)/SRPMS/$(SRPM_FILE) $(outdir)/$(SRPM_FILE)

install-deps:
	dnf -y install rpmdevtools
