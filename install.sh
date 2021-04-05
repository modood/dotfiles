#!/usr/bin/env bash

bakdir="$HOME/.dotfiles.backup"
timestr=$(date +%Y%m%d%H%M)
repo=https://github.com/modood/dotfiles/raw/master
dotfiles=(
  .ackrc
  .ansible.cfg
  .ctags
  .myclirc
  .vimshrc
  .Xmodmap
  .zshrc
)

if [ ! -d "$bakdir" ]; then
    mkdir "$bakdir"
fi

for i in ${dotfiles[@]};
do
    echo "Setting $i"
    if [ -f "$HOME/$i" ] || [ -h "$HOME/$i" ]; then
        cat "$HOME/$i" > "$bakdir/$timestr$i"
    fi
    curl -Ls $repo/$i > $HOME/$i
done
