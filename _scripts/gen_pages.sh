#!/bin/bash

ptype=$1

PUB_data="_data/publications.yml"
PUB_DIR="publications"
TALK_data="_data/talks.yml"
TALK_DIR="talks"
PRO_data="_data/projects.yml"
PRO_DIR="projects"
RES_data="_data/research.yml"
RES_DIR="research"

function rm_special()
{
    sed 's/[^a-z  A-Z]//g'
}

function space2under()
{
    sed -e 's/ /_/g'
}

function rm_sections()
{
    grep -v '^[a-z|A-Z]'
}

function rm_quotes()
{
    sed -e 's/^"//' -e 's/"$//'
}

function yaml2json()
{
    ruby -ryaml -rjson -e \
         'puts JSON.pretty_generate(YAML.load(ARGF))' $*
}

if [ $ptype == "pub" ]
then
	echo "Publications ..."
	FileN=$PUB_data
	run="first"
	index=0
	while [ $run != "null" ]
	do
		title=$(cat $FileN | rm_sections | yaml2json | jq .[$index].title | rm_quotes )
		filename=$(echo $title | rm_special | space2under)
		fieldid=$(cat $FileN | rm_sections | yaml2json | jq .[$index].id | rm_quotes )
		if [ $filename != "null" ] && [ $fieldid != "null" ]
		then
					
			echo "$fieldid ::::::: $filename"
			cat > $PUB_DIR/$fieldid.html << EOL
---
layout: publications
title: "$title - (Deepthi Devaki Akkoorath)"
header_title: Publication
include_header: publications_header.html
nav_item: publications 
dynaid: $fieldid
---
EOL
			index=$((index +1))
		else
			run="null"
		fi
	done

elif [ $ptype == "talk" ]
then
        echo "Talks ..."
        FileN=$TALK_data
        run="first"
        index=0
        while [ $run != "null" ]
        do
                title=$(cat $FileN | rm_sections | yaml2json | jq .[$index].title | rm_quotes )
                filename=$(echo $title | rm_special | space2under)
                fieldid=$(cat $FileN | rm_sections | yaml2json | jq .[$index].id | rm_quotes )
                if [ $filename != "null" ] && [ $fieldid != "null" ]
                then

                        echo "$fieldid ::::::: $filename"
                        cat > $TALK_DIR/$fieldid.html << EOL
---
layout: talks
title: "$title - (Deepthi Devaki Akkoorath)"
header_title: Talk
include_header: publications_header.html
nav_item: publications 
dynaid: $fieldid
---
EOL
                        index=$((index +1))
                else
                        run="null"
                fi
        done

		
elif [ $ptype == "pro" ]
then
	echo "Projects ..."
        FileN=$PRO_data
        run="first"
        index=0
        while [ $run != "null" ]
        do
                title=$(cat $FileN | yaml2json | jq .[$index].name_long | rm_quotes )
                filename=$(echo $title | rm_special | space2under)
                fieldid=$(cat $FileN | rm_sections | yaml2json | jq .[$index].id | rm_quotes )
                sta=$(cat $FileN | yaml2json | jq .[$index].sta )
                if [ $filename != "null" ] && [ $fieldid != "null" ]
                then

                        echo "$fieldid ::::::: $filename"
                        cat > $PRO_DIR/$fieldid.html << EOL
---
layout: projects
title: "$title - (Deepthi Devaki Akkoorath)"
header_title: Project
include_header: projects_header.html
nav_item: projects
dynaid: $fieldid
dynasta: $sta
---
EOL
                        index=$((index +1))
                else
                        run="null"
                fi
        done

elif [ $ptype == "res" ]
then
        echo "Research ..."
        FileN=$RES_data
        run="first"
        index=0
        while [ $run != "null" ]
        do
                title=$(cat $FileN | yaml2json | jq .[$index].topic | rm_quotes )
                filename=$(echo $title | rm_special | space2under)
                fieldid=$(cat $FileN | yaml2json | jq .[$index].id | rm_quotes )
                sta=$(cat $FileN | yaml2json | jq .[$index].sta )
                if [ $filename != "null" ] && [ $fieldid != "null" ]
                then

                        echo "$fieldid ::::::: $filename"
                        cat > $RES_DIR/$fieldid.html << EOL
---
layout: research
title: "$title - (Deepthi Devaki Akkoorath)"
header_title: Research
include_header: research_header.html
nav_item: research
dynaid: $fieldid
dynasta: $sta
---
EOL
                        index=$((index +1))
                else
                        run="null"
                fi
        done

else
	echo "No other type is defined ..."
	exit 1
fi
