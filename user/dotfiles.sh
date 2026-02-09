#!/bin/sh

original_dir=$(pwd)

git clone git@github.com:sblmnl/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

stow .

cd $original_dir
