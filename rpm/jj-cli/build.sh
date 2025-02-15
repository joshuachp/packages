#!/usr/bin/env bash

set -exEuo pipefail

rust2rpm -s -t fedora -V auto -C rust2rpm.toml jj-cli

cp -v jj-cli-*.crate ~/rpmbuild/SOURCES
cp -v jj-cli-*-vendor.tar.xz ~/rpmbuild/SOURCES
cp -v rust-jj-cli.spec ~/rpmbuild/SPECS

if [[ ${1:-} == 's' ]]; then
    rpmbuild -bs ~/rpmbuild/SPECS/rust-jj-cli.spec
else
    rpmbuild -ba ~/rpmbuild/SPECS/rust-jj-cli.spec
fi
