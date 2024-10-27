#!/bin/bash -eu

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

source $REPO_ROOT/config/zsh/.zshenv
source $REPO_ROOT/lib/utils.sh

mk_xdg_dir () {
  mkdir -p $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME
}

setup_macos () {
  source $REPO_ROOT/lib/macos.sh
  set_macos_defaults

  echo "Would you like to install Homebrew? [y/n]"
  read reply
  if [ "$reply" = "n" ]; then
    echo "Skip installing Homebrew."
  elif [ "$reply" = "y" ]; then
    $REPO_ROOT/bin/brew.sh
  else
    echo "Invalid reply. Please enter either 'y' or 'n'."
  fi
}

main () {
  mk_xdg_dir
  start_msg "Initializing config files"
  if [ "$(uname)" == "Darwin" ]; then
    setup_macos
  fi
  $REPO_ROOT/bin/deploy.sh
}

main
