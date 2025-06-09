#!/usr/bin/env bash

set -exEuo pipefail

for dir in rpm/*/; do
    pkg=$(basename "$dir")
    version=$(rpmspec --queryformat '%{version}\n' --query "$dir/"*"$pkg.spec" | sort -u)
    package_key=${dir%/}

    jsonpath=$(printf '.packages."%s"."release-as" = "%s"' "$package_key" "$version")

    res=$(jq "$jsonpath" release-please-config.json)
    echo "$res" >release-please-config.json
done
