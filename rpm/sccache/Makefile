SHELL = /usr/bin/env bash -xeuEo pipefail

NAME := sccache
ARCH := $(shell uname -m)

TOPDIR := $(shell rpmspec -E '%{_topdir}')
SOURCE_DIR ?= $(TOPDIR)/SOURCES

SPECFILE := rust-$(NAME).spec

VERSION := $(shell rpmspec --query $(SPECFILE) --queryformat '%{version}\n' | head -n1)
RELEASE := $(shell rpmspec --query $(SPECFILE) --queryformat '%{release}\n' | head -n1)

TMPDIR := $(shell mktemp -d)

# Overwritten in sources
CRATE := $(SOURCE_DIR)/$(NAME)-$(VERSION).crate
VENDOR := $(SOURCE_DIR)/$(NAME)-$(VERSION)-vendor.tar.xz
DIFF := $(SOURCE_DIR)/$(NAME)-fix-metadata-auto.diff

SRPM := $(TOPDIR)/SRPMS/rust-$(NAME)-$(VERSION)-$(RELEASE).src.rpm
RPMS := $(TOPDIR)/RPMS/$(ARCH)/rust-$(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm \
	$(TOPDIR)/RPMS/$(ARCH)/$(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm \
	$(TOPDIR)/RPMS/$(ARCH)/rust-$(NAME)-debugsource-$(VERSION)-$(RELEASE).$(ARCH).rpm \
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

$(SRPM): $(SPECFILE) $(CRATE) $(VENDOR) $(DIFF)
	rpmbuild -bs $(SPECFILE)

$(SPECFILE) $(CRATE) $(VENDOR) $(DIFF): rust2rpm.toml
	rust2rpm -s -t fedora -V auto -C rust2rpm.toml $(NAME)
	cp -v $(NAME)-$(VERSION).crate $(SOURCE_DIR)
	cp -v $(NAME)-$(VERSION)-vendor.tar.xz $(SOURCE_DIR)
	cp -v $(NAME)-$(VERSION)-vendor.tar.xz $(SOURCE_DIR)
	cp -v $(NAME)-fix-metadata-auto.diff $(SOURCE_DIR)

.PHONY: clean install-deps
clean:
	rm -v *-vendor.tar.xz *.crate || true
	rm -v $(CRATE) $(VENDOR) $(SRPM) $(RPMS) || true

install-deps:
	dnf -y install rpmdevtools rust2rpm rust2rpm-helper pkgconf openssl-devel zlib-ng-compat-devel

