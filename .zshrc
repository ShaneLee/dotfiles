export ZSH="/Users/Shane/.oh-my-zsh"

ZSH_THEME="shane"
plugins=(git)
plugins=(web-search)

source $HOME/.bin/dotfiles/.bluetooth.zconfig

export JAVA_HOME=$(/usr/libexec/java_home -v11)

export GOPATH=$HOME/dev/Go
export PATH=$PATH:$GOPATH/bin

export PATH=/usr/local/bin:$PATH
export PATH="/anaconda3/bin":$PATH
export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
export PATH="$PATH:$HOME/bin"

KEYTIMEOUT=1
source $ZSH/oh-my-zsh.sh

alias g='git'
alias killn='killAll NotificationCenter'
alias tutorial="cd '/Volumes/Leviathan/2. Progamming Tutorials' && ls"
alias pip='pip3'
alias python='python3'
alias idea='python ~/.bin/notion-bucket/notion-bucket.py'
alias win='python ~/.bin/notion-bucket/w.py'
alias goal='python ~/.bin/notion-bucket/g.py'

alias finalcut="open '~/Applications/Final\ Cut\ Pro.app/Contents/MacOS/Final\ Cut\ Pro ; exit;'"

function mcdir {
  command mkdir $1 && cd $1
}

# For tmux spacing
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/Shane/.sdkman"
[[ -s "/Users/Shane/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/Shane/.sdkman/bin/sdkman-init.sh"
