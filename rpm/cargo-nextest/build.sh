#!/usr/bin/env bash

set -exEuo pipefail

rust2rpm -s -t fedora -V auto -C rust2rpm.toml cargo-nextest

cp -v cargo-nextest-*.crate ~/rpmbuild/SOURCES
cp -v cargo-nextest-*-vendor.tar.xz ~/rpmbuild/SOURCES
cp -v cargo-nextest-*.diff ~/rpmbuild/SOURCES || true
cp -v rust-cargo-nextest.spec ~/rpmbuild/SPECS

if [[ ${1:-} == 's' ]]; then
    rpmbuild -bs ~/rpmbuild/SPECS/rust-cargo-nextest.spec
else
    rpmbuild -ba ~/rpmbuild/SPECS/rust-cargo-nextest.spec
fi
