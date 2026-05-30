# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update
brew bundle --file ./Brewfile

# rm -rf $HOME/.zshrc
# ln -sw $HOME/.dotfiles/.zshrc $HOME/.zshrc

# alacritty configs
mkdir -p $HOME/.config/alacritty
ln -sf $HOME/.dotfiles/alacritty.toml $HOME/.config/alacritty/alacritty.toml
ln -sf $HOME/.dotfiles/alacritty-catppuccin-frappe.toml $HOME/.config/alacritty/alacritty-catppuccin-frappe.toml

# git configs
ln -sf $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
