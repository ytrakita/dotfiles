#!/bin/bash

REPO_ROOT=$(cd $(dirname $0)/..; pwd)

DOT_STATE=$XDG_STATE_HOME/dotfiles/state

has () {
  type "$1" > /dev/null 2>&1
}

err_msg () {
  echo "$(tput setaf 1)Error: $(tput sgr0)$1 $(tput setaf 1)✗$(tput sgr0)" >&2
}

ok_msg () {
  echo "$(tput setaf 2)$1 ✓$(tput sgr0)"
}

start_msg () {
  echo "$(tput setaf 4)==> $(tput sgr0)$(tput bold)$1...$(tput sgr0)"
}

symlink () {
  local str
  str=$(ln -sfnv "$@" \
    | sed -e "s/${HOME//\//\/}/~/g" \
    | awk 'BEGIN {FS = " -> "}; {printf "\033[35m%s\033[0m -> %s\n", $1, $2}')
  echo "$str"
  echo "$str" | sed -e "s/\[35m\(.*\)\[0m -> \(.*\)/\1\t\2/" >> $DOT_STATE
}
