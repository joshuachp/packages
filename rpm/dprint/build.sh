#!/usr/bin/env bash

set -exEuo pipefail

rust2rpm -s -t fedora -V auto -C rust2rpm.toml dprint

cp -v dprint-*.crate ~/rpmbuild/SOURCES
cp -v dprint-*-vendor.tar.xz ~/rpmbuild/SOURCES
cp -v dprint-*.diff ~/rpmbuild/SOURCES
cp -v rust-dprint.spec ~/rpmbuild/SPECS

if [[ ${1:-} == 's' ]]; then
    rpmbuild -bs ~/rpmbuild/SPECS/rust-dprint.spec
else
    rpmbuild -ba ~/rpmbuild/SPECS/rust-dprint.spec
fi
