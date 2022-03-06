#!/usr/bin/env bash

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

install_iterm2() {
  wget https://iterm2.com/downloads/stable/iTerm2-3_4_15.zip
  unzip iTerm2-3_4_15.zip
  rm iTerm2-3_4_15.zip
  sudo cp -r iTerm.app /Applications/
  rm iTerm.app
  open /Applications/iTerm.app
}

install_notion() {
  wget https://www.notion.so/desktop/apple-silicon/download
}

install_intellj() {
  wget https://download.jetbrains.com/idea/ideaIC-2021.3.2-aarch64.dmg
  wget open ideaIC-2021.3.2-aarch64.dmg
}

install_vlc() {
  https://videolan.mirrors.nublue.co.uk/vlc/3.0.16/macosx/vlc-3.0.16-arm64.dmg
  open vlc-3.0.16-arm64.dmg
}


install_with_brew() {
  brew install node
  brew install wget
  brew install tmux
  brew install Java11
  brew tap adoptopenjdk/openjdk
  brew install --cask adoptopenjdk8
  brew install mvn
  brew install redis
  brew install cask 
  brew install ctags 
  brew install bluetoothconnector 
  brew install glow 
  brew install python
  brew install jupyter
  brew install coreutils
  brew install --cask amethyst
}

install_chrome() {
  wget https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg --no-check-certificate
  open googlechrome.dmg
  sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
  rm ~/Downloads/googlechrome.dmg
}

install_spotify() {
  wget https://download.scdn.co/SpotifyInstaller.zip --no-check-certificate
  unzip SpotifyInstaller.zip
  rm SpotifyInstaller.zip
  open Install\ Spotify.app
  rm -r Install\ Spotify.app
}

install_docker() {
  wget https://desktop.docker.com/mac/main/arm64/Docker.dmg
  open Docker.dmg
}

install_obs() {
  wget https://cdn-fastly.obsproject.com/downloads/obs-mac-27.2.2.dmg
  open obs-mac-27.2.2.dmg
}

install_netnewswire() {
  wget https://netnewswire.com/NetNewsWire.zip
  unzip NetNewsWire.zip
  rm NetNewsWire.zip
  sudo mv -r NetNewsWire.app /Applications/
}

install_aws_cli() {
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  rm AWSCLIV2.pkg
}

install_aliases() {
  ln -s  ~/.bin/dotfiles/.gitconfig .gitconfig
  ln -s  ~/.bin/dotfiles/.vimrc .vimrc
  ln -s  ~/.bin/dotfiles/.tmux.conf .tmux.conf
  ln -s  ~/.bin/dotfiles/.zprofile .zprofile
  ln -s  ~/.bin/dotfiles/.zshrc .zshrc
  ln -s  ~/.bin/dotfiles/.ideavimrc .ideavimrc
}

install_homebrew
install_with_brew
install_iterm2
install_aliases
install_chrome
install_spotify
install_docker
install_intellj
install_obs
install_netnewswire
install_notion
install_neobundle
# install_aws_cli

