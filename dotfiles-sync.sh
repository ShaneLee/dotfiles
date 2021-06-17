#!/usr/bin/env bash
cd ~/bin/dotfiles

rm tags

cp ../../.zshrc .
cp ../../.vimrc .
cp ../../.tmux.conf .
cp ~/.on-my-zsh/themes/shane.zsh-theme . 

git add . 
git commit -m 'Cron update'
git push 

cd 
