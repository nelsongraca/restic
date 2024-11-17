#!/bin/bash

backup_dir () {
  location=$1
  echo "Backing up $location"
  restic backup "$location"

}

export -f backup_dir

restic cat config

status=$?
if [ $status == 10 ]; then
    echo "Restic repository '${RESTIC_REPOSITORY}' does not exists. Running restic init."
    restic init

    init_status=$?
    echo "Repo init status $init_status"

    if [ $init_status != 0 ]; then
        echo "Failed to init the repository: '${RESTIC_REPOSITORY}'"
        exit 1
    fi
fi

find /backup/ -type d -maxdepth 1 -mindepth 1 -exec bash -c 'backup_dir $1' shell {} \;


if [ -z ${FORGET_ARGS+x} ]; then
  echo "FORGET_ARGS not set, not running forget"
else
  restic forget "${FORGET_ARGS}"
fi

