#!/bin/bash

WORKSPACE=$(pwd)
COMMIT_TIME=$(date +"%m-%d-%Y-%H:%M")
COMMIT_MSG="Updated-$COMMIT_TIME"

is_git=0

if type "git" > /dev/null 2>&1 ; then
	is_git=1
#    	git --version
fi

function run_cmd()
{
	$@ > $WORKSPACE/run-update.log 2>&1
	ret=$?
	if [ "$ret" -eq "0" ]
	then
		echo "Excuted $@ ..."
	else
		echo "Error in excuting $@ ..."
		cat $WORKSPACE/run-update.log
		exit $ret
	fi
}

function clean_old_logs()
{
	if [ -d $WORKSPACE/_site ]; then
		echo "Clearing old files ..."
    		run_cmd rm -rf $WORKSPACE/_site
	fi
}

function build_check()
{

	run_cmd bundle exec jekyll build --trace
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
			run_cmd git add $temp_file
			run_cmd git commit $temp_file -m"$COMMIT_MSG"
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
                run_cmd git push
        else
                exit 1
        fi
}

### MAIN ###

clean_old_logs

build_check

git_commit
git_push
