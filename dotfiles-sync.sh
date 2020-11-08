#!/usr/bin/env bash
cd ~/bin/dotfiles

rm tags

mv ../../.zshrc . 
mv ../../.vimrc . 
mv ../../.tmux.conf . 
mv ../../.init.vim . 
cp ../../.on-my-zsh/themes/shane.zsh-theme . 

git add . 
git commit -m 'Cron update'
git push 

cd 
