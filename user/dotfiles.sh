#!/bin/sh

original_dir=$(pwd)

git clone https://github.com/sblmnl/dotfiles ~/.dotfiles

cd ~/.dotfiles

git remote set-url origin git@github.com:sblmnl/dotfiles.git

stow .

cd $original_dir
