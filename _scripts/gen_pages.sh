#!/bin/bash 

if [ -z $1 ]
then
    exit 1
else
    ptype=$1
fi

PUB_data="_data/publications.yml"
PUB_DIR="publications"
TALK_data="_data/talks.yml"
TALK_DIR="talks"
PRO_data="_data/projects.yml"
PRO_DIR="projects"
RES_data="_data/research.yml"
RES_DIR="research"
CV_data="_data/config.yml"
CV_DIR="cv"

function replace_coma-semicolon()
{
    sed -e "s/,/;/g"
}

function replace_cr-coma()
{
    sed -e 'H;${x;s/\n/, /g;s/^,//;p;};d'
}

function replace_cr-semicolon()
{   
    sed -e 'H;${x;s/\n/; /g;s/^;//;p;};d'
}

function rm_special()
{
    sed 's/[^a-z  A-Z]//g'
}

function space2under()
{
    sed -e 's/ /_/g'
}

function rm_1st-space()
{
    sed 's/^ *//g'
}

function rm_sections()
{
    grep -v '^[a-z|A-Z]'
}

function rm_quotes()
{
    sed -e 's/^"//' -e 's/"$//'
}

function rm_leading_slash()
{
     sed -e 's/^\///'
}

function yaml2json()
{
    ruby -ryaml -rjson -e \
         'puts JSON.pretty_generate(YAML.load(ARGF))' $*
}

function get_file()
{
	wget $1 -O $2 --no-check-certificate
}

function gen_image_1pdf()
{
	if [ ! -f $1 ]
	then
		echo "Generating image ::: $1 "
		gs -o $1 -sDEVICE=jpeg -dLastPage=1 $2
	fi
}

function gen_text()
{
	if [ ! -f $2 ]
	then
		echo "Generating text ::: $2 "
		pdftotext $1 $2
	fi
}

function gen_image()
{
        pdfimages -j $1 $2
	for ppmimg in $(ls -1 "$2"-*.ppm)
	do
		imgsz=$(ls -l $ppmimg | cut -d" " -f5)
		if [ "$imgsz" -gt "200000"  ]
		then
			filenp=$( echo $ppmimg | cut -f 1 -d '.')
				jpegimg="$filenp.jpeg"
			convert $ppmimg $jpegimg
		fi
		rm -f $ppmimg
	done
	for img in $(ls -1 "$2"-*)
	do
		imgsz=$(ls -l $img | cut -d" " -f5)
		if [ "$imgsz" -lt "10000"  ]
		then
			rm -f $img
		fi
	done
}

if [ $ptype == "cv" ]
then
	echo "Profile ..."
	TDIR=$CV_DIR
	FileN=$CV_data

	CV_FILE=$(cat $FileN | grep -e ^resume_path: | cut -d"\"" -f2 | rm_leading_slash )
        F_NAME=$(cat $FileN | grep -e ^full_name: | cut -d"\"" -f2)
        F_KEY=$(cat $FileN | grep -e ^keywords: | cut -d"\"" -f2 | replace_coma-semicolon | rm_1st-space )
        F_TYPE="Resume"

        if [ ! -z $CV_FILE ] && [ -f $CV_FILE ]
       	then
		exiftool -overwrite_original -Title="$F_NAME - $F_TYPE" -Author="$F_NAME" -Subject="$F_TYPE of $F_NAME" -Keywords="$F_KEY" $CV_FILE
                gen_image_1pdf assets/img/cv/Deepthi_Devaki_Akkoorath_profile.jpeg $CV_FILE 
	fi
	if [ ! -d _includes/text/cv ]
	then
		mkdir -p _includes/text/cv
	fi
        gen_text $CV_FILE _includes/text/cv/Deepthi_Devaki_Akkoorath_cv.txt

elif [ $ptype == "pub" ]
then
	echo "Publications ..."
	TDIR=$PUB_DIR
	if [ -d $TDIR ]
	then
        	rm -rf $TDIR/*.html
	fi
	FileN=$PUB_data
	run="first"
	index=0
	while [ $run != "null" ]
	do
		title=$(cat $FileN | rm_sections | yaml2json | jq .[$index].title | rm_quotes | rm_1st-space)
                authors=$(cat $FileN | rm_sections | yaml2json | jq .[$index].author[] | rm_quotes | replace_cr-semicolon | rm_1st-space)
                keywords=$(cat $FileN | rm_sections | yaml2json | jq .[$index].keyword[] | rm_quotes | replace_cr-semicolon | rm_1st-space)
                short_name=$(cat $FileN | rm_sections | yaml2json | jq .[$index].short_name | rm_quotes | rm_1st-space)
		subject="Publication - $short_name"

		filename=$(echo $title | rm_special | space2under)
		fieldid=$(cat $FileN | rm_sections | yaml2json | jq .[$index].id | rm_quotes )
		pdffile=$(cat $FileN | rm_sections | yaml2json | jq .[$index].pdf | rm_quotes | rm_leading_slash )
		
		if [ $filename != "null" ] && [ $fieldid != "null" ]
		then
					
			echo "$fieldid ::::::: $filename"
			cat > $TDIR/$fieldid.html << EOL
---
layout: publications
type: publications
include_header: publications_header.html
nav_item: publications 
dynaid: $fieldid
---
EOL

			index=$((index +1))

                	if [ $pdffile != "null" ] && [ $fieldid != "null" ] && [ ! -f assets/img/publications/$fieldid.jpeg ]
                	then
                        	if [ ! -f $pdffile ]
                        	then
                                	get_file $pdffile /tmp/$fieldid.pdf
                                	if [ -f /tmp/$fieldid.pdf ]
                                	then
                                        	pdffile="/tmp/$fieldid.pdf" 
                                	else
                                        	continue
                                	fi
                        	fi

                        	gen_image_1pdf assets/img/publications/$fieldid.jpeg $pdffile 

				if [ ! -d assets/img/publications/$fieldid ]
				then
					mkdir -p assets/img/publications/$fieldid
				fi
				gen_image $pdffile assets/img/publications/$fieldid/fig
                                if [ ! -d _includes/text/publications ]
                                then
                                        mkdir -p _includes/text/publications
                                fi
				gen_text $pdffile _includes/text/publications/$fieldid.txt
				exiftool -overwrite_original -Title="$title" -Author="$authors" -Subject="$subject" -Keywords="$keywords" $pdffile
			fi
		else
			run="null"
		fi
	done

elif [ $ptype == "talk" ]
then
        echo "Talks ..."
        FileN=$TALK_data
        TDIR=$TALK_DIR
        if [ -d $TDIR ]
        then
                rm -rf $TDIR/*.html
        fi
        run="first"
        index=0
        while [ $run != "null" ]
        do
                title=$(cat $FileN | rm_sections | yaml2json | jq .[$index].title | rm_quotes | rm_1st-space)
                authors=$(cat $FileN | rm_sections | yaml2json | jq .[$index].author[] | rm_quotes | replace_cr-semicolon | rm_1st-space)
                keywords=$(cat $FileN | rm_sections | yaml2json | jq .[$index].keyword[] | rm_quotes | replace_cr-semicolon | rm_1st-space)
                short_name=$(cat $FileN | rm_sections | yaml2json | jq .[$index].short_name | rm_quotes | rm_1st-space)
                subject="Presentation - $short_name"

                filename=$(echo $title | rm_special | space2under)
                fieldid=$(cat $FileN | rm_sections | yaml2json | jq .[$index].id | rm_quotes )
		pdffile=$(cat $FileN | rm_sections | yaml2json | jq .[$index].presentation | rm_quotes | rm_leading_slash )

                if [ $filename != "null" ] && [ $fieldid != "null" ]
                then

                        echo "$fieldid ::::::: $filename"
                        cat > $TDIR/$fieldid.html << EOL
---
layout: talks
type: talks
include_header: publications_header.html
nav_item: publications 
dynaid: $fieldid
---
EOL

			index=$((index +1))

                	if [ $pdffile != "null" ] && [ $fieldid != "null" ] && [ ! -f assets/img/talks/$fieldid.jpeg ]
                	then
                        	if [ ! -f $pdffile ]
                        	then
                                	get_file $pdffile /tmp/$fieldid.pdf 
                                	if [ -f /tmp/$fieldid.pdf ]
                                	then
                                        	pdffile="/tmp/$fieldid.pdf"
                                	else
                                        	continue
                                	fi
                        	fi
                        	echo "$fieldid ::::::: $pdffile"
                        	gen_image_1pdf assets/img/talks/$fieldid.jpeg $pdffile

                                if [ ! -d assets/img/talks/$fieldid ]
                                then
                                        mkdir -p assets/img/talks/$fieldid
                                fi
                                gen_image $pdffile assets/img/talks/$fieldid/fig
				if [ ! -d _includes/text/talks ]
				then
					mkdir -p _includes/text/talks
				fi
				gen_text $pdffile _includes/text/talks/$fieldid.txt
                                exiftool -overwrite_original -Title="$title" -Author="$authors" -Subject="$subject" -Keywords="$keywords" $pdffile
                        fi
                else
                        run="null"
                fi
        done

		
elif [ $ptype == "pro" ]
then
	echo "Projects ..."
        FileN=$PRO_data
        TDIR=$PRO_DIR
        if [ -d $TDIR ]
        then
                rm -rf $TDIR/*.html
        fi
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
                        cat > $TDIR/$fieldid.html << EOL
---
layout: projects
type: projects
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
        TDIR=$RES_DIR
        if [ -d $TDIR ]
        then
                rm -rf $TDIR/*.html
        fi
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
                        cat > $TDIR/$fieldid.html << EOL
---
layout: research
type: research
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
