#!/bin/bash -eu

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

source $REPO_ROOT/lib/utils.sh

install_homebrew () {
  if has "brew"; then
    ok_msg "Homebrew is already installed"
  else
    start_msg "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  start_msg "Installing Homebrew apps"
  brew bundle --file $REPO_ROOT/config/homebrew/Brewfile --no-lock
}

set_default_hammerspoon () {
  # https://github.com/Hammerspoon/hammerspoon/issues/2175
  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
}

chown_texlive () {
  sudo chown -R $(whoami) /usr/local/texlive
}

install_homebrew
set_default_hammerspoon
chown_texlive
