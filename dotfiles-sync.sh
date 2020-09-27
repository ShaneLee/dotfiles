#!/usr/bin/env bash
rm tags

cp ../../.zshrc . 
cp ../../.vimrc . 
cp ../../.tmux.conf . 
cp ../../.init.vim . 
cp ../../.on-my-zsh/themes/shane.zsh-theme . 

git add . 
git commit -m 'Cron update'
git push 
