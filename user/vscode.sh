#!/bin/bash

extensions=(
    "ms-dotnettools.csharp"
    "ms-dotnettools.csdevkit"
    "catppuccin.catppuccin-vsc-icons"
    "dbaeumer.vscode-eslint"
    "github.github-vscode-theme"
    "eamodio.gitlens"
    "davidanson.vscode-markdownlint"
    "esbenp.prettier-vscode"
    "humao.rest-client"
    "vue.volar"
)

for extension in "${extensions[@]}"; do
    code --install-extension $extension --force
done

mkdir -p ~/.config/Code/User
