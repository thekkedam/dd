#!/bin/bash

WORKSPACE=$(pwd)
COMMIT_MSG=$(date)

is_git=0

if type "git" > /dev/null 2>&1 ; then
	is_git=1
#    	git --version
fi

function clean_old_logs()
{
	if [ -d $WORKSPACE/_site ]; then
		echo "Clearing old files ..."
    		rm -rf $WORKSPACE/_site
	fi
}

function build_check()
{

	bundle exec jekyll build --trace
	if [ "$?" -eq "0" ]
	then
		echo "Build good ..."
	else
		echo "Error in build ..."
		exit 1
	fi
}

function git_commit()
{
	if [ "$is_git" -eq 1 ]
	then
		for temp_file in $(git diff --name-only)
		do
			echo "Commiting $temp_file in git ..."
			git add $temp_file
			git commit -m"$COMMIT_MSG" $temp_file
		done
	else
		exit 1
	fi		
}

function git_push()
{
        if [ "$is_git" -eq 1 ]
        then
		echo "Pusing chnages to git ..."
                git push
        else
                exit 1
        fi
}

### MAIN ###

clean_old_logs

build_check

git_commit
git_push
