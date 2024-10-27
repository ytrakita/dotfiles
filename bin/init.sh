#!/bin/bash -eu

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

source $REPO_ROOT/config/zsh/.zshenv
source $REPO_ROOT/lib/utils.sh

mk_xdg_dir () {
  mkdir -p $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME
}

texlive () {
  sudo chown -R $(whoami) /usr/local/texlive
}

main () {
  mk_xdg_dir
  start_msg "Initializing config files"
  if [ "$(uname)" == "Darwin" ]; then
    source $REPO_ROOT/lib/macos.sh
    setup_macos
  fi
  $REPO_ROOT/bin/deploy.sh
}

main
