bindkey -e
bindkey '^u' backward-kill-line

setopt autocd
setopt correct
setopt ignoreeof # avoid log-outing by <C-D>

autoload -Uz colors; colors

alias ls='ls -GF'

# History

mkdir -p $XDG_STATE_HOME/zsh
HISTFILE=$XDG_STATE_HOME/zsh/zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_no_store
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# History completion

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end
bindkey '^[OA' history-beginning-search-backward-end
bindkey '^[OB' history-beginning-search-forward-end
# # bindkey '^[OA' history-beginning-search-backward
# # bindkey '^[OB' history-beginning-search-forward

# Completion

if type brew &>/dev/null; then
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH

  autoload -Uz compinit
  mkdir -p $XDG_CACHE_HOME/zsh/zcompcache
  compinit -d $XDG_CACHE_HOME/zsh/zcompdump
fi

zstyle ':completion:*:default' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ':completion:*' verbose no

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Github CLI

eval "$(gh completion -s zsh)"

# Starship

eval "$(starship init zsh)"

# Julia

__set_julia_alias () {
  local sysimage="$JULIA_DEPOT_PATH/sysimages/startup.so"

  if [ -f $sysimage ]; then
    alias julia="julia --sysimage $sysimage"
  fi
}

__set_julia_alias

# https://github.com/wtsnjp/dotfiles/blob/master/zshrc
__load_lib () {
  [ -f "$1" ] && source "$1"
}

__load_lib "$ZDOTDIR/lib/fz.sh"
