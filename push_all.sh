#!/bin/bash

git status

echo "Would you like to continue? (y/n) >"
read cont

if [ "$cont" = 'y' ]; then
	git add -A
	git status
	git commit -m "$1"
	git push origin "$2"
else
	echo "Did not push."
fi
