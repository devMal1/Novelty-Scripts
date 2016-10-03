#!/bin/bash

#Will monitor a file and ftp-put it on a remote server

#Helper functions
function getLastModifiedTime {
	local _file=$1
	echo "$( ls -l $_file | egrep -o "[0-9]{1,2}:{1}[0-9]{2}" )"
}
function updateLastModifiedTime {
	local _file=$1
	local _newTime=$2
	local _listOfFiles=$3
	echo "updateLastModifiedTime"
}

#Setup (get file paths from user)
function getFilesInfoFromUser {
	local $_listOfFiles=$1
	echo "Enter full paths (do not use '~') for the files you would like to autoput (one file path per line):"
	echo "Type 'done' when finished."
	echo "" > $_listOfFiles #clear list
	local _isDone=0
	while [ $_isDone = 0 ]; do
		read _file
		if [ $_file = "done" ]; then
			_isDone=1
		else
			if [ -e $_file ]; then
				echo "adding $_file ..."
				local _timeLastModified="$( getLastModifiedTime $_file )"
				echo "$_file  $_timeLastModified" >> $_listOfFiles
			else 
				echo "WARNING: File does not exist, ignoring file (make sure using beginning '/')"
			fi
		fi
	done
}

#File status
function hasFileChanged {
	local _file=$1
	local _listOfFiles=$2

	local _originalTimeLastModified="$( awk -v f=$_file '$1=$f {print $2}' $_listOfFiles )" 
	local _timeLastModified="$( getLastModifiedTime $_file )"
	if [ "$_originalTimeLastModified" = "$_timeLastModified" ]; then
		echo 0
	else
		echo "$_timeLastModified"
	fi
}

#ftp-put file to remote server
function ftpPut {
	local _file=$1
	echo "ftpPut"	
}


#Main
function monitorFiles {
	local _listOfFiles="monitoring.txt"
	
	getFilesInfoFromUser $_listOfFiles

	echo "Monitoring the files..."
	echo "To stop the program (if not running in background) hit ctrl-c"
	local _stop=0
	while [ $_stop = 0 ]; do
		#Monitor files
		for file in $( awk '{print $1}' $_listOfFiles ); do
			local _newTime=$( hasFileChanged "$file" "$_listOfFiles" )
			if [ "$_newTime" != 0 ]; then
				echo "$_file changed"
				updateLastModifiedTime $file $_newTime $_listOfFiles
				ftpPut $file
			fi
		done
	done
}

monitorFiles
