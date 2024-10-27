#!/bin/bash -eu

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

source $REPO_ROOT/lib/utils.sh

start_msg "Deploying config files"

mkdir -p $(dirname $DOT_STATE)

if [ -e $DOT_STATE ]; then
  rm $DOT_STATE
fi

symlink $REPO_ROOT/config                ${XDG_CONFIG_HOME:="$HOME/.config"}
symlink $XDG_CONFIG_HOME/aquaskk/*.conf  $HOME/Library/Application\ Support/AquaSKK
symlink $XDG_CONFIG_HOME/julia           $JULIA_DEPOT_PATH/config
symlink $XDG_CONFIG_HOME/texmf/texmf.cnf $(kpsewhich -var-value TEXMFLOCAL)/web2c
symlink $ZDOTDIR/.zshenv                 $HOME/.zshenv
