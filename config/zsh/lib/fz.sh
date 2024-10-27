zd () {
  local _arg
  local _opt

  local dir
  local fd_dir="fd --type=directory --exclude='.git'"

  while (( $# > 0 )) ; do
    case $1 in
      -r)
        _opt="r"
        ;;
      --hidden)
        fd_dir+=" --hidden"
        ;;
      -h)
        fd_dir+=" --hidden"
        ;;
      -*)
        echo "invalid option"
        return 1
        ;;
      *)
        _arg="$1"
        ;;
    esac
    shift
  done

  if [ -z "$_opt" ]; then
    fd_dir+=" \
    --follow \
    --base-directory ~ \
    --exclude .Trash \
    --exclude 'Google Drive' \
    --exclude Library \
    --exclude Pictures \
    --exclude Music \
    --exclude Movies \
    --exclude Public"
  fi

  if [ -z "$_arg" ]; then
    dir=$(eval $fd_dir | fzf)
  else
    dir=$(eval $fd_dir | fzf --query "$_arg")
  fi

  if [ "$(echo $dir)" ]; then
    cd "$HOME/$dir"
  fi
}

zat () {
  local dir

  if [ $# = 0 ];then
    dir=$(fd --type=file | fzf)
  elif [ -f $1 ]; then
    dir=$1
  else
    dir=$(fd --type=file | fzf --query "$1")
  fi

  if [ "$(echo $dir)" ]; then
    bat "$dir"
  fi
}
