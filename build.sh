#!/bin/bash

rm -rf _site
rm -rf .sass-cache

set -e
set -x

sed -i "s/^date:.*$/date: $(date -u +%Y-%m-%dT%H:%M:%S%z)/" _config.yml
git add _config.yml

bundle exec jekyll serve --trace
