NAME := starship
hasdiff := true

include ../Makefile.rust

.PHONY: install-deps
install-deps:
	dnf -y install rpmdevtools rust2rpm rust2rpm-helper pkgconf openssl-devel zlib-ng-compat-devel

