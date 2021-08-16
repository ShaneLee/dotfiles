export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="shane"
plugins=(git)
plugins=(web-search)

source $HOME/.bin/dotfiles/.bluetooth.zconfig
source $HOME/.bin/dotfiles/.work.zconfig
source $HOME/.bin/dotfiles/.home.zconfig
source $HOME/.bin/dotfiles/.useful.zconfig
source $HOME/.bin/dotfiles/.git.zconfig

export JAVA_HOME=$(/usr/libexec/java_home -v11)

export GOPATH=$HOME/dev/Go
export PATH=$PATH:$GOPATH/bin

export PATH=/usr/local/bin:$PATH
export PATH="/anaconda3/bin":$PATH
export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
export PATH="$HOME/.bin/dotfiles/bin:$PATH"
export PATH="$PATH:$HOME/bin"

KEYTIMEOUT=1
source $ZSH/oh-my-zsh.sh

# For tmux spacing
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/Shane/.sdkman"
[[ -s "/Users/Shane/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/Shane/.sdkman/bin/sdkman-init.sh"
