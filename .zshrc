export ZSH=$HOME/.bin/.oh-my-zsh

ZSH_THEME="shane"
plugins=(git)
plugins=(web-search)

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_17_HOME=$(/usr/libexec/java_home -v17)

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java17='export JAVA_HOME=$JAVA_17_HOME'

source $HOME/.bin/dotfiles/.bluetooth.zconfig
source $HOME/.bin/dotfiles/.work.zconfig
source $HOME/.bin/dotfiles/.home.zconfig
source $HOME/.bin/dotfiles/.useful.zconfig
source $HOME/.bin/dotfiles/.git.zconfig
source $HOME/.bin/todos/.todos.zconfig
source $HOME/.bin/sorg/.sorg.config

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^F' forward-word
bindkey '^B' backward-word

export GOPATH=$HOME/dev/Go
export PATH=$PATH:$GOPATH/bin

export PATH=/usr/local/bin:$PATH
export PATH="/anaconda3/bin":$PATH
export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
export PATH="$HOME/.bin/dotfiles/bin:$PATH"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/wbin"

ZSH_COMPDUMP="~/.cache/zsh/zcompdump"

export LESSSHISTFILE="-"

KEYTIMEOUT=1
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
