#!/bin/sh

original_dir=$(pwd)

git clone https://github.com/sblmnl/dotfiles ~/.dotfiles

cd ~/.dotfiles

stow .

cd $original_dir
