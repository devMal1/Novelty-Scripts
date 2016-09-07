#!/bin/bash

#Display files that will be deleted in bulk
echo "Files to be deleted:"
ls | grep '~'

#Confirm delete all
echo "Delete all? (yes/no) : "
read delete

if [ $delete = 'yes' ]; then
    #Create backup (just in case)
    nowTime=$(date +%H_%M_%S)
    backupDir="backup${nowTime}"
    mkdir "$backupDir"
    cp ./* ./"$backupDir" |

    #Delete files
    echo #new line
    for autoFile in `ls | grep '~'`; do
	echo "deleting ${autoFile}..."
	rm $autoFile
    done
    echo "deleted."

    #Delete backup?
    echo
    echo "Folder content:"
    ls ./
    echo "Does everything look good.. shall we delete the backup dir? (yes/no) : "
    read deleteBackup
    if [ $deleteBackup = 'yes' ]; then
	echo
	echo "Removing backup dir..."
	rm -r "$backupDir"
	echo "done and done."
    fi
else
    echo
    echo "No files were deleted."
fi