#!/usr/bin/env bash

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}


install_neobundle() {
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
  sh ./install.sh
  rm install.sh
}

install_with_brew() {
  brew install node
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
}

install_aws_cli() {
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  rm AWSCLIV2.pkg
}


install_homebrew
install_neobundle
install_aws_cli

