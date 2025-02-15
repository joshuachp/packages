#!/usr/bin/env bash

set -exEuo pipefail

rust2rpm -s -t fedora -V auto -C rust2rpm.toml sccache

cp -v sccache-*.crate ~/rpmbuild/SOURCES
cp -v sccache-*-vendor.tar.xz ~/rpmbuild/SOURCES
cp -v sccache-*.diff ~/rpmbuild/SOURCES
cp -v rust-sccache.spec ~/rpmbuild/SPECS

if [[ ${1:-} == 's' ]]; then
    rpmbuild -bs ~/rpmbuild/SPECS/rust-sccache.spec
else
    rpmbuild -ba ~/rpmbuild/SPECS/rust-sccache.spec
fi
