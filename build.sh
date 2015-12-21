#!/bin/bash

site_test="-t"
site_run="-r"
update="-u"

function rm_site_temp()
{
    rm -rf _site
    rm -rf .sass-cache
}

function dep_update()
{
    bundle update
}

function site_build()
{
    bundle exec jekyll build
}

function run_htmlproof()
{
    bundle exec htmlproof ./_site --disable-external
}

function rm_proff_temp()
{
    rm -rf tmp
}

function site_run()
{
    bundle exec jekyll serve --trace
}
if [ "$1" == "$update" ]
then
    dep_update
elif [ "$1" == "$site_test" ]
then
    rm_site_temp
    rm_proff_temp
    site_build
    run_htmlproof
elif [ "$1" == "$site_run" ]
then
   rm_site_temp
   rm_proff_temp
   site_run
else
   echo "    Error in usage ..."
   echo "    ./build.sh < -t | -r | -u> "
   echo "    "
   exit 1
fi
      
