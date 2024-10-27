#!/bin/bash -eu

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

source $REPO_ROOT/lib/utils.sh

clean () {
  local tgt="$(eval "echo $1")"
  if [ -h "$tgt" ]; then
    unlink "$tgt"
    echo "Removed: $(tput setaf 5)$1$(tput sgr0)"
  else
    echo "$(tput setaf 5)$1$(tput sgr0): No such symbolic link"
  fi
}

if [ -e $DOT_STATE ]; then
  start_msg "Removing all symlinks to this repository"
  awk -F '\t' '{print $1}' $DOT_STATE | while read line
  do
    clean "$line"
  done
else
  err_msg "No state file is found."
fi
