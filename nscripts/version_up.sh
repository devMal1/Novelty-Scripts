#!/bin/bash


#get commit id
echo "getting latest commit id..."
commit_id=$(git log --pretty=oneline -n 1 | egrep -o '[a-z0-9]{40}')
echo
echo "latest commit id => $commit_id"

#up the version
echo "upping the version..."
git tag "$1" "$commit_id"
echo
echo "tag is now $1"
