#!/usr/bin/env bash

set -e

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  rm -rf $HOME/.oh-my-zsh
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

bash -c "$(curl -fsSL https://sh.rustup.rs)"

brew update
brew bundle --file ./Brewfile

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"


# zsh config
[ -s "$HOME/.zshrc" ] && mv $HOME/.zshrc $HOME/.zshrc.backup
ln -sf $DOTFILES/aliases.zsh $HOME/.oh-my-zsh/custom/aliases.zsh
ln -sf $DOTFILES/.p10k.zsh $HOME/.p10k.zsh
ln -sf $DOTFILES/.zshrc $HOME/.zshrc

# nvm setup
PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh)" "" --no-use
bash -c "source $NVM_DIR/nvm.sh && nvm install --lts && nvm use --lts"

# git config
[-s "$HOME/.gitconfig" ] && mv $HOME/.gitconfig $HOME/.gitconfig.backup
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

# neovim config
rm -rf $CONFIG/nvim
ln -sf $DOTFILES/nvim $CONFIG/nvim
