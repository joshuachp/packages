#!/usr/bin/env bash

set -exEuo pipefail

NAME="astartectl"

cp -v go-vendor-tools.toml ~/rpmbuild/SOURCES/
cp -v "$NAME"-*-vendor.tar.bz2 ~/rpmbuild/SOURCES/
cp -v "$NAME"-*.tar.gz ~/rpmbuild/SOURCES/
cp -v "golang-$NAME.spec" ~/rpmbuild/SPECS/

if [[ ${1:-} == 's' ]]; then
    rpmbuild -bs "$HOME/rpmbuild/SPECS/golang-$NAME.spec"
else
    rpmbuild -ba "$HOME/rpmbuild/SPECS/golang-$NAME.spec"
fi
