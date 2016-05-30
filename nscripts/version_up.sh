#!/bin/bash

#check if any tags are being used
anyTags=$(git tag -l)
if [ -z "$anyTags" ]; then
	echo "no tags being used..."
	echo "Use <git tag> for any commit, and after commiting again, run this script to up the latest tag to the latest commit."
	return
fi

#get latest commit
echo "grabbing latest commit..."
latestLog="$(git log --pretty=oneline -n 1)"
if [ -z "$latestLog" ]; then
	echo "no previous commits... "
	echo "Make sure you have a commit, have tagged the commit, and then have another untagged commit in order this script to up the latest tag and tag the latest commit."
	return
fi
#commit_msg=$(echo "$latestLog" | egrep -o -v '[a-z0-p]{40}')
#echo ">>> $commit_msg"
echo "$latestLog"
echo

echo "Up tag to this commit? [y/n] > "
read upThisTag
if [ $upThisTag = 'y' ]; then

	echo
	echo "grabbing latest commit id..."
	commit_id=$(echo "$latestLog" | egrep -o '[a-z0-9]{40}')
	echo ">>> latest commit id => $commit_id"

	echo "grabbing the latest tag..."
	latestTag=$(git tag -l --sort=-refname | head -n 1)
	echo ">>> latest tag => $latestTag"
	
	latestTag="${latestTag}."
	uppedTag=""
	count=1
	echo "Which digit-place of the tag would you like to up (by 1)? [1,2,3] tag:<1>.<2>.<3> > "
	read placeToUp
	#placeToUp=3
	echo "upping the tag..."
	for i in `echo "$latestTag" | egrep -o '[0-9]+\.'`; do
		num=$(echo "$i" | egrep -o '[0-9]+')
		if [ $count = $placeToUp ]; then
			num=$((num+1))
		fi
		if [ $count = 1 ]; then
			uppedTag="$num"
		else 
			uppedTag="${uppedTag}.${num}"
		fi
		count=$((count+1))
	done
		
	git tag "$uppedTag" "$commit_id"
	wasTagUpped=$?
	echo

	if [ $wasTagUpped != 0 ]; then
		echo "tag was not upped."
	else
		echo "tag is now $uppedTag"
	fi
else
	#do not up the version
	#in future can add here to read in the specific commit id
	echo
	echo "Done."
fi
