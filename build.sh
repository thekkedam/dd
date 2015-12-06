#!/bin/bash

rm -rf _site

git add _config.yml

bundle exec jekyll serve --trace $@
