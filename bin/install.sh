#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/repos/dotfiles
fi
DOTFILES_GITHUB="https://github.com/ytrakita/dotfiles"

if [ -d $DOTPATH ]; then
  echo "Dotfiles are already installed"
  exit
fi

mkdir -p $DOTPATH

git clone $DOTFILES_GITHUB $DOTPATH
cd $DOTPATH
make init
