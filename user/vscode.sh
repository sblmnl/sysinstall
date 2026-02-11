#!/bin/sh

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

for extension in $extensions; do
    code --install-extension $extension
done

mkdir -p ~/.config/Code/User
