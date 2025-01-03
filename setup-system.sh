#!/usr/bin/env bash

CASK_INSTALLS=(
  NetNewsWire
  google-chrome
  spotify
  docker
  vlc
  tor-browser
  notion
  obs
  amethyst
  intellij-idea-ce
  dropbox
  iterm2
  shiftit
  android-file-transfer
  calibre
  anki
  min
  anaconda
)

BREW_INSTALLS=(
  nvm
  yarn
  npm
  wget
  rg
  tmux
  mvn
  redis
  cask 
  ctags 
  bluetoothconnector 
  glow 
  python
  jupyter
  coreutils
  ffmpeg
  git-credential-manager
  yq
  openjdk@21
)

PIP_INSTALLS=(
  pylint
  black
)

BREW_TAPS=(
  adoptopenjdk/openjdk
)

install_tmux_plugin_manager() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_homebrew() {
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/shane/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_neobundle() {
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
  sh ./install.sh
  rm install.sh
}

install_diff_so_fancy() {
  brew install diff-so-fancy
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  git config --global interactive.diffFilter "diff-so-fancy --patch"
}

install_oh_my_zsh() {
  # sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # mv .oh-my-zsh .bin/
  ln -s ~/.bin/dotfiles/shane.zsh-theme ~/.bin/.oh-my-zsh/themes/shane.zsh-theme

}

install_lts_node() {
  nvm install --lts
}

brewInstall() { if brew ls --versions "$1"; then brew upgrade "$1"; else brew install "$1"; fi }

brewCaskInstall() { if brew ls --cask --versions "$1"; then brew upgrade --cask "$1"; else brew install --cask "$1"; fi }

install_with_cask() {
  for APP in ${CASK_INSTALLS[@]}; do
    brewCaskInstall $APP
  done
}

brew_tap() {
  for APP in ${BREW_TAPS[@]}; do
    brew tap $APP
  done
}

install_with_brew() {
  for APP in ${BREW_INSTALLS[@]}; do
    brewInstall $APP
  done
}

install_with_pip() {
  for APP in ${PIP_INSTALLS[@]}; do
    pip install --upgrade $APP
  done
}


install_aws_cli() {
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  rm AWSCLIV2.pkg
}

install_aliases() {
  ln -s  ~/.bin/dotfiles/.gitconfig ~/.gitconfig
  ln -s  ~/.bin/dotfiles/.vimrc ~/.vimrc
  ln -s  ~/.bin/dotfiles/.tmux.conf ~/.tmux.conf
  ln -s  ~/.bin/dotfiles/.zprofile ~/.zprofile
  ln -s  ~/.bin/dotfiles/.zshrc ~/.zshrc
  ln -s  ~/.bin/dotfiles/.vimrc ~/.ideavimrc
  touch ~/.bin/dotfiles/.work.zconfig
}

install_todos() {
  cd ~/.bin
  git clone git@github.com:ShaneLee/todos.git
  cd -
}

install_homebrew
install_with_brew
install_oh_my_zsh
install_with_cask
install_aliases
install_neobundle
install_tmux_plugin_manager
install_lts_node
install_todos
install_with_pip
#install_aws_cli

  
sudo ln -sfn /usr/local/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
