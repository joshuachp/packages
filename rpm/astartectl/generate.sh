#!/usr/bin/env bash

set -exEuo pipefail

NAME="astartectl"

go2rpm -p=vendor --name "golang-$NAME" github.com/astarte-platform/astartectl

# Fill params
LICENCE='Apache-2.0 AND BSD-2-Clause AND BSD-3-Clause AND ISC AND MIT AND MPL-2.0'
sed -i -e "s/\(License: \+\).\+$/\1$LICENCE/" golang-$NAME.spec
sed -i -e '/%autopatch/d' golang-$NAME.spec

# Set Source url
VENDOR_URL='https://github.com/joshuachp/packages/releases/download/astartectl-v%{version}/'
SRC_REGEX='\(Source[12]: \+\)\(.\+\)$'
sed -i -e "s|$SRC_REGEX|\1$VENDOR_URL\2|" golang-$NAME.spec

# fix cmd dir
sed -i -e '/for cmd/,+2d' golang-$NAME.spec

# install section
sed -i -e '/%install/a install -Dpm 0644 _astartectl -t %{buildroot}%{zsh_completions_dir}' golang-$NAME.spec
sed -i -e '/%install/a install -Dpm 0644 astartectl.fish -t %{buildroot}%{fish_completions_dir}' golang-$NAME.spec
sed -i -e '/%install/a install -Dpm 0644 astartectl.bash -t %{buildroot}%{bash_completions_dir}' golang-$NAME.spec
sed -i -e '/%install/a %{gobuilddir}/bin/astartectl completion zsh > _astartectl' golang-$NAME.spec
sed -i -e '/%install/a %{gobuilddir}/bin/astartectl completion fish > astartectl.fish' golang-$NAME.spec
sed -i -e '/%install/a %{gobuilddir}/bin/astartectl completion bash > astartectl.bash' golang-$NAME.spec

# Files section
sed -i -e '/%files/a %{zsh_completions_dir}/_astartectl' golang-$NAME.spec
sed -i -e '/%files/a %{fish_completions_dir}/astartectl.fish' golang-$NAME.spec
sed -i -e '/%files/a %{bash_completions_dir}/astartectl.bash' golang-$NAME.spec

spec_version=$(
    rpmspec -q golang-$NAME.spec --queryformat '%{version}'
)
release_version=$(cat version.txt)

if [[ "$spec_version" != "$release_version" ]]; then
    echo "Release version differs rom spec"
    exit 1
fi

rpmlint golang-$NAME.spec
