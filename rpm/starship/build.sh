#!/usr/bin/env bash

set -exEuo pipefail

rust2rpm -s -t fedora -V auto -C rust2rpm.toml starship

cp -v starship-*.crate ~/rpmbuild/SOURCES
cp -v starship-*-vendor.tar.xz ~/rpmbuild/SOURCES
cp -v starship-fix-metadata-auto.diff ~/rpmbuild/SOURCES
cp -v rust-starship.spec ~/rpmbuild/SPECS

rpmbuild -ba ~/rpmbuild/SPECS/rust-starship.spec
