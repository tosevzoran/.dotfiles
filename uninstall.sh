#!/usr/bin/env bash

set -e

CONFIG="$HOME/.config"

rm -rf $CONFIG/nvim
rm -rf $CONFIG/tmux
rm -rf $CONFIG/alacritty
rm -rf $HOME/.oh-my-zsh
rm -f $HOME/.p10k.zsh
[ -s "$HOME/.zshrc.backup" ] && mv $HOME/.zshrc.backup $HOME/.zshrc
[ -s "$HOME/.gitconfig.backup" ] && mv $HOME/.gitconfig.backup $HOME/.gitconfig

rm -rf ~/.cache/p10k-*
rm -rf ~/.cache/nvim

if command -v nvm >/dev/null; then
  nvm_dir="${NVM_DIR:-~/.nvm}" && nvm unload && rm -rf "$nvm_dir"
fi

if command -v rustup >/dev/null; then
  rustup self uninstall
  rm -rf $HOME/.cargo
  rm -rf $HOME/.rustp
fi


brew bundle --file ./Brewfile cleanup --force
