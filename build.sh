#!/bin/bash

rm -rf _site
rm -rf .sass-cache

bundle exec jekyll serve --trace
