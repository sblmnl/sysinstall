#!/bin/sh

original_dir=$(pwd)

git clone https://github.com/sblmnl/dotfiles ~/.dotfiles

cd ~/.dotfiles

git remote set-url origin git@github.com:sblmnl/dotfiles.git

cd ~/

rm -f .bashrc .profile .zshrc .zprofile .config/user-dirs.dirs
stow .

cd $original_dir
