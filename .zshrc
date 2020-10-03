export ZSH="/Users/Shane/.oh-my-zsh"

ZSH_THEME="shane"
plugins=(git)
plugins=(web-search)

export JAVA_HOME=$(/usr/libexec/java_home -v11)
export GOPATH="$HOME/dev/go"
export PATH="/anaconda3/bin":$PATH
export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
export PATH="$PATH:$HOME/bin"

KEYTIMEOUT=1
source $ZSH/oh-my-zsh.sh

alias g='git'
alias killn='killAll NotificationCenter'
alias tutorial="cd '/Volumes/Leviathan/2. Progamming Tutorials' && ls"
alias wunder="cd ~/dev/Python/wunderlist_automation && ls"
alias pip='pip3'
alias python='python3'

alias ccolours='for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done'

# For tmux spacing
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/Shane/.sdkman"
[[ -s "/Users/Shane/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/Shane/.sdkman/bin/sdkman-init.sh"
