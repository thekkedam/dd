#!/bin/bash

rm -rf _site
rm -rf .sass-cache

set -e
set -x

sed -i "s/^date:.*$/date: $(TZ=UTC date "+%Y-%m-%d %H:%M:%S %Z")/" _config.yml
git add _config.yml

bundle exec jekyll serve --trace
