#!/bin/bash -eu

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

source $REPO_ROOT/lib/utils.sh

if !(has "git"); then
  err_msg "It is necessary to install git"
  exit
fi

$REPO_ROOT/bin/clean.sh

start_msg "Updating this repository"
git pull origin main

$REPO_ROOT/bin/deploy.sh
