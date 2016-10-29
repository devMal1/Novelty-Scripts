#!/bin/bash

#Will monitor a file and ftp-put it on a remote server
#Globals
CHECK_CODE=255
GET_ORIGINAL_TIME=2
GET_REMOTE_DIR=3
TIME_PATTERN="[0-9]{1,2}:{1}[0-9]{2}"

#Helper functions
function getLastModifiedTime {
	local _file=$1
	echo "$( ls -l $_file | egrep -o $TIME_PATTERN )"
}
function updateLastModifiedTime {
	local _file=$1
	local _oldTime=$2
	local _newTime=$3
	local _listOfFiles=$4

	local _searchFor="$_file $_oldTime"
	local _replaceWith="$_file $_newTime"

	sed -i "s|${_searchFor}|${_replaceWith}|" "$_listOfFiles"
}
function queryData {
	local _file=$1
	local _column=$2
	local _listOfFiles=$3

	if [ $_column = $GET_ORIGINAL_TIME ]; then
		echo "$( awk -v f=$_file '$1=$f {print $2}' $_listOfFiles )"
	elif [ $_column = $GET_REMOTE_DIR ]; then
		echo "$( awk -v f=$_file '$1=$f {print $3}' $_listOfFiles )"
	else
		echo $CHECK_CODE
	fi
}

#Setup (get file paths from user)
function getFilesInfoFromUser {
	local _listOfFiles=$1
	echo "Enter full paths (do not use '~') for the files you would like to autoput (one file path per line)"
	echo "For each file you will be prompted for the full path remote directory for that file (where the file will be put on the server)"
	echo "Type 'done' when finished."
	rm $_listOfFiles
	touch $_listOfFiles
	local _isDone=0
	while [ $_isDone = 0 ]; do
		local _file=""
		read _file
		if [ $_file = "done" ]; then
			_isDone=1
		else
			if [ -e $_file ]; then
				echo "Remote Directory for ${_file}:"
				local _remoteDir=""
				read _remoteDir
				local _timeLastModified="$( getLastModifiedTime $_file )"
				echo "$_file $_timeLastModified $_remoteDir" >> $_listOfFiles
				echo "$_file added."
			else
				echo "WARNING: File does not exist, ignoring file (make sure using beginning '/')"
			fi
		fi
	done
}
function getSFTPInfoFromUser {
	local _user=$1

	echo "Enter host name for remote server:"
	local _server=""
	read _server

	echo "Enter user name for ${server}:"
	local _username=""
	read _username

	echo "${_username}@${_server}" > $_user
}

#File status
function hasFileChanged {
	local _file=$1
	local _listOfFiles=$2

	local _originalTimeLastModified="$( queryData $_file $GET_ORIGINAL_TIME $_listOfFiles )"
	local _timeLastModified="$( getLastModifiedTime $_file )"
	if [ "$_originalTimeLastModified" = "$_timeLastModified" ]; then
		echo $CHECK_CODE
	else
		updateLastModifiedTime $_file $_originalTimeLastModified $_timeLastModified $_listOfFiles
		echo "$_timeLastModified"
	fi
}

#ftp-put file to remote server
function sftpPut {
	local _file=$1
	local _remoteDir=$2
	local _user="$3"

	local _sftPutFile="sftpPut.txt"
	echo "cd $_remoteDir" > $_sftPutFile
	echo "put $_file" >> $_sftPutFile
	local _userAtHost="$( cat $_user )"
	sftp -b "$_sftpPutFile" "$userAtHost"
}


#Main
function main {
	local _user=".user"
	local _listOfFiles="monitoring.txt"

	#check if $user already exists
	###getSFTPInfoFromUser $_user

	#check if user wants to use previous files.. print out files then ask
	getFilesInfoFromUser $_listOfFiles

	echo "Monitoring the files..."
	echo "To stop the program (if not running in background) hit ctrl-c"
	local _stop=0
	while [ $_stop = 0 ]; do
		#Monitor files
		for file in $( awk '{print $1}' $_listOfFiles ); do
			local _changed=$( hasFileChanged "$file" "$_listOfFiles" )
			if [ "$_changed" != $CHECK_CODE ]; then
				echo "$file changed"
				#local _remoteDir=$( queryData $file $GET_REMOTE_DIR $_listOfFiles )
				##sftpPut $file $_remoteDir $_user
			fi
		done
	done
}

#Run Main
main


#reference to add to the readme.. ssh keys
#www.computerhope.com/unix/sftp.htm
