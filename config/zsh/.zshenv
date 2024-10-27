setopt no_global_rcs

export LANG="en_US.UTF-8"

export EDITOR="nvim"
export VISUAL="nvim"

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export LESSHISTFILE=-

export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

export FZF_DEFAULT_OPTS="--reverse --height 90%"\
" --prompt='▶ ' --pointer='▶'"\
" --color=fg+:regular,bg+:#1d508d,gutter:-1"\
" --color=hl:#ffc83f,hl:bold,hl+:#ffc83f,hl+:bold"

export PATH="$HOME/.local/bin:"\
"$CARGO_HOME/bin:"\
"/opt/homebrew/opt/ruby/bin:"\
"$PATH:"\
"/Library/TeX/texbin:"\
"/opt/X11/bin"
