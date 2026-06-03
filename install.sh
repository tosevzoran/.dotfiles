#!/bin/bash

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  rm -rf $HOME/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  # /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update
brew bundle --file ./Brewfile

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"


# zsh config
rm $HOME/.zshrc
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.p10k.zsh $HOME/.p10k.zsh
exec zsh

# git config
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig

# alacritty config
mkdir -p $CONFIG/alacritty
ln -sf $DOTFILES/alacritty.toml $CONFIG/alacritty/alacritty.toml
ln -sf $DOTFILES/alacritty-catppuccin-frappe.toml $CONFIG/alacritty/alacritty-catppuccin-frappe.toml

# tmux config
rm -rf $CONFIG/tmux
mkdir -p $CONFIG/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm $CONFIG/tmux/plugins/tpm
ln -sf $DOTFILES/tmux.conf $CONFIG/tmux/tmux.conf 
