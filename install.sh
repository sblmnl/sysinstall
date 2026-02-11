#!/bin/bash

original_dir=$(pwd)
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

current_user=$(id -u -n)
script_mode=$([ $current_user = "root" ] && echo "root" || echo "user")

cd $script_dir

git remote set-url origin git@github.com:sblmnl/sysinstall.git

cd $script_mode

function run_script() {
    path=$1
    echo "Executing script '$path'..."
    ./$path > >(tee -a ~/install.log) 2> >(tee -a ~/install-errors.log >&2)
}

function run_scripts() {
    dir=$1

    for script in $(ls -a $dir); do
        if [[ $script == "." || $script == ".." ]]; then
            continue
        fi

        run_script $dir/$script
    done
}

function install_root() {
    read -p "Enter your non-root username: " non_root_user

    # run core configuration scripts
    run_script core/storage.sh
    run_script core/prerequisites.sh
    run_script core/grub.sh
    run_script core/hostname.sh
    run_script core/network.sh
    run_script core/clock.sh
    run_script core/graphics.sh
    run_script core/audio.sh
    run_script core/gui.sh
    run_script core/shell.sh

    # run configuration scripts by category
    run_scripts security
    run_scripts apps
    run_scripts dev
    run_scripts extras

    # move log files to user home directory
    mv ~/install*.log /home/$non_root_user/
    chown $non_root_user /home/$non_root_user/install*.log

    # print any logged installation errors
    cat /home/$non_root_user/install-errors.log

    # move files to user home folder
    cd ~/
    mv $script_dir /home/$non_root_user/.sysinstall
    chown -R $non_root_user /home/$non_root_user/.sysinstall

    # ask before rebooting
    read -p "Installation complete! Reboot now? (Y/n) " user_input

    if [ "${user_input,,}" = "y" ]; then
        echo "Rebooting..."
        reboot now
    fi

    echo "Exiting..."
}

function install_user() {
    # configure vscode
    run_script vscode.sh

    # import dotfiles
    run_script dotfiles.sh

    # update xdg user directories
    xdg-user-dirs-update
    xdg-user-dirs-gtk-update

    # install node.js
    run_script nodejs.sh

    # install autotiling
    run_script autotiling.sh

    # configure flatpak
    flatpak --user override --filesystem=/home/$USER/.icons/:ro
    flatpak --user override --filesystem=/usr/share/icons/:ro
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    # install steam
    run_script steam.sh

    # install oh my zsh
    run_script oh-my-zsh.sh
}

[ $script_mode = "root" ] && install_root || install_user

cd $original_dir
