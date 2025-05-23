export ZSH=$HOME/.bin/.oh-my-zsh

ZSH_THEME="shane"
plugins=(web-search)
plugins=(z)

#Allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY

# Add comamnds as they are typed, don't wait until shell exit
setopt INC_APPEND_HISTORY

# Do not write events to history that are duplicates of previous events
setopt HIST_IGNORE_DUPS

# When searching history don't display results already cycled through twice
setopt HIST_FIND_NO_DUPS

# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# Include more information about when the command was executed, etc
setopt EXTENDED_HISTORY

alias eloc='vi ~/.zshrc'

export PYTHONPATH=$HOME/dev/py-logging-config:$PYTHONPATH

export CONDA_AUTO_ACTIVATE_BASE=false
export JAVA_HOME=$(/usr/libexec/java_home)

export XDG_CONFIG_HOME="$HOME/.bin/dotfiles/config"

source $HOME/.bin/dotfiles/.bluetooth.zconfig
[[ -f $HOME/.bin/dotfiles/.work.zconfig ]] && source $HOME/.bin/dotfiles/.work.zconfig
source $HOME/.bin/dotfiles/.home.zconfig
source $HOME/.bin/dotfiles/.useful.zconfig
source $HOME/.bin/dotfiles/.branches.zconfig
source $HOME/.bin/dotfiles/.directories.zconfig
alias euseful="vi $HOME/.bin/dotfiles/.useful.zconfig"
source $HOME/.bin/dotfiles/.git.zconfig
source $HOME/.bin/todos/.todos.zconfig

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^F' forward-word
bindkey '^B' backward-word

export GOPATH=$HOME/dev/Go
export PATH=$PATH:$GOPATH/bin

export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
export PATH="$HOME/.bin/dotfiles/bin:$PATH"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/wbin"

ZSH_COMPDUMP="~/.cache/zsh/zcompdump"

export LESSSHISTFILE="-"

KEYTIMEOUT=1

zstyle ':completion:*' menu select

source $ZSH/oh-my-zsh.sh

# For tmux spacing
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/Shane/.sdkman"
[[ -s "/Users/Shane/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/Shane/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Initialise conda, but because this is slow
# do it in a subshell and prevent it logging anything
(conda_init &) > /dev/null 2>&1

# Created by `pipx` on 2024-07-23 16:40:18
export PATH="$PATH:/Users/shane/.local/bin"
