#!/bin/bash

. config.cfg

IFS_BACKUP=$IFS
IFS=$'\n'

function log()
{
  local logfile=$LOG_FILE
  echo $1 >> logfile
}

function getPublicIP()
{
  local url=$PUBLIC_IP_URL
  local public_ip=`curl -s $url`

  if [ -z "$public_ip" ]
  then
    log "Unable to reach the public ip api or get a correct response."
    exit 1
  fi

  echo $public_ip
}

function getOldPublicIP()
{
  local datafile=$DATA_FILE
  if ! test -f $datafile
  then
    touch $datafile
  fi

  local old_public_ip=`cat $datafile`

  echo $old_public_ip
}

function updatePublicIP()
{
  local new_public_ip=$1
  local datafile=$DATA_FILE
  echo "$new_public_ip" > $datafile
}

function executeFile()
{
  for line in `cat $2`
  do
    eval $line   
  done
}

function loadAnExecuteFiles()
{
  files_directory=$FILES_DIRECTORY

  if ! test -d $files_directory
  then
    mkdir $files_directory
  fi

  for file in `ls $files_directory`
  do
    executeFile $1 $files_directory"/"$file
  done
}

function executeActions()
{
  local public_ip=$1

  loadAnExecuteFiles $public_ip
}

function run()
{
  local new_public_ip=$(getPublicIP)
  local old_public_ip=$(getOldPublicIP)

  if [ "$new_public_ip" != "$old_public_ip" ]
  then
    executeActions $new_public_ip
    updatePublicIP $new_public_ip
  fi
}

# Call the main function
run

IFS=$IFS_BACKUP
