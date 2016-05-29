#!/bin/bash


#get commit id
echo "grabbing the latest commit..."
latestLog="$(git log --pretty=oneline -n 1)"
#commit_msg=$(echo "$latestLog" | egrep -o -v '[a-z0-p]{40}')
#echo ">> $commit_msg"
echo "$latestLog"
echo

echo "Up this tag? [y/n] > "
read upThisTag
if [ $upThisTag = 'y' ]; then
	#up the version
	commit_id=$(echo "$latestLog" | egrep -o '[a-z0-9]{40}')
	echo
	echo "latest commit id => $commit_id"

	#echo "grabbing the latest tag and adding 1..."
	#git tag -l --sort=-refname | [cat or something to grab only first line"
	echo "upping the tag..."
	git tag "$1" "$commit_id"
	wasTagUpped=$?
	echo

	if [ $wasTagUpped != 0 ]; then
		echo "tag was not upped."
	else
		echo "tag is now $1"
	fi
else
	#do not up the version
	#in future can add here to read in the specific commit id
	echo
	echo "Done."
fi
