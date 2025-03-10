SHELL = /usr/bin/env bash -xeuEo pipefail

NAME := astartectl
REPO := github.com/astarte-platform/astartectl
LICENCE := Apache-2.0 AND BSD-2-Clause AND BSD-3-Clause AND ISC AND MIT AND MPL-2.0

ARCH := $(shell uname -m)

TOPDIR := $(shell rpmspec -E '%{_topdir}')
SOURCE_DIR ?= $(TOPDIR)/SOURCES

SPECFILE := golang-$(NAME).spec

VERSION := $(shell rpmspec --query $(SPECFILE) --queryformat '%{version}\n' | head -n1)
RELEASE := $(shell rpmspec --query $(SPECFILE) --queryformat '%{release}\n' | head -n1)

TMPDIR := $(shell mktemp -d)

GOVENDOR_FILE := go-vendor-tools.toml
GOVENDOR := $(SOURCE_DIR)/$(GOVENDOR_CONF_FILE)
VENDOR_FILE := $(NAME)-$(VERSION)-vendor.tar.bz2
VENDOR := $(SOURCE_DIR)/$(VENDOR_FILE)
SRC_FILE := $(NAME)-$(VERSION).tar.gz
SRC := $(SOURCE_DIR)/$(SRC_FILE)

SRPM := $(TOPDIR)/SRPMS/golang-$(NAME)-$(VERSION)-$(RELEASE).src.rpm
RPMS := $(TOPDIR)/RPMS/$(ARCH)/golang-$(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm \
	$(TOPDIR)/RPMS/$(ARCH)/$(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm \
	$(TOPDIR)/RPMS/$(ARCH)/golang-$(NAME)-debugsource-$(VERSION)-$(RELEASE).$(ARCH).rpm \
	$(TOPDIR)/RPMS/$(ARCH)/$(NAME)-debuginfo-$(VERSION)-$(RELEASE).$(ARCH).rpm

.PHONY: build rpm srpm sources

build: $(RPMS)

srpm: $(SRPM)
ifdef outdir
	cp -v $(SRPM) $(outdir)
endif

sources: $(CRATE) $(VENDOR)

$(RPMS): $(SRPM)
	rpmbuild -bb $(SPECFILE)

$(SRPM): $(SPECFILE) $(GOVENDOR) $(VENDOR) $(SRC)
	rpmbuild -bs $(SPECFILE)

$(SPECFILE) $(GOVENDOR) $(VENDOR) $(SRC):
	go2rpm -p=vendor --name 'golang-$(NAME)' $(REPO)
	# Fill params
	sed -i -e "s/\(License: \+\).\+$$/\1$(LICENCE)/" $(SPECFILE)
	sed -i -e '/%autopatch/d' $(SPECFILE)
	# fix cmd dir
	sed -i -e '/for cmd/,+2d' $(SPECFILE)
	# install section
	sed -i -e '/%install/a install -Dpm 0644 _astartectl -t %{buildroot}%{zsh_completions_dir}' $(SPECFILE)
	sed -i -e '/%install/a install -Dpm 0644 astartectl.fish -t %{buildroot}%{fish_completions_dir}' $(SPECFILE)
	sed -i -e '/%install/a install -Dpm 0644 astartectl.bash -t %{buildroot}%{bash_completions_dir}' $(SPECFILE)
	sed -i -e '/%install/a %{gobuilddir}/bin/astartectl completion zsh > _astartectl' $(SPECFILE)
	sed -i -e '/%install/a %{gobuilddir}/bin/astartectl completion fish > astartectl.fish' $(SPECFILE)
	sed -i -e '/%install/a %{gobuilddir}/bin/astartectl completion bash > astartectl.bash' $(SPECFILE)
	# Files section
	sed -i -e '/%files/a %{zsh_completions_dir}/_astartectl' $(SPECFILE)
	sed -i -e '/%files/a %{fish_completions_dir}/astartectl.fish' $(SPECFILE)
	sed -i -e '/%files/a %{bash_completions_dir}/astartectl.bash' $(SPECFILE)
	# Copy 
	cp -v $(GOVENDOR_FILE) $(SOURCE_DIR)
	cp -v $(VENDOR_FILE) $(SOURCE_DIR)
	cp -v $(SRC_FILE) $(SOURCE_DIR)

.PHONY: clean
clean:
	rm -v $(GOVENDOR_FILE) $(VENDOR_FILE) $(SRC_FILE) || true
	rm -v $(GOVENDOR) $(VENDOR) $(SRC) $(SRPM) $(RPMS) || true

.PHONY: install-deps
install-deps:
	dnf -y install rpmdevtools go2rpm+vendor
