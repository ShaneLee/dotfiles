export ZSH="/Users/Shane/.oh-my-zsh"

ZSH_THEME="shane"

plugins=(git)
plugins=(web-search)

export JAVA_HOME=$(/usr/libexec/java_home -v11)

source $ZSH/oh-my-zsh.sh

alias g='git'

alias gpy='cd ~/dropbox/python && ls'
alias gjscript='cd ~/dropbox/javascript && ls'
alias gjava='cd ~/dropbox/java && ls'
alias killn='killAll NotificationCenter'
alias mvpdf='mv ***.pdf _pdf'
alias mvmobi='mv ***.mobi _mobi'
alias mvepub='mv ***.epub _epub'
alias mvbooks='mkdir _pdf && mkdir _epub && mkdir _mobi && mvpdf || mvepub || mvmobi'
alias master="open ~/Dropbox/'1 Learning'/'1 Spreadsheets'/MasterSpreadSheet.xlsx"
alias nutrition='open open ~/Dropbox/1\ Learning/1\ Spreadsheets/Nutrition/Nutrition.xlsm'
alias skiphiredbphp='cd ~/dev/php/skiphiredatabase_php/ && ls '
alias wunderlistbg="sudo cp /Users/Shane/Library/Application\ Support/Google/wunderlistshane1/1.0.13_0/wlbackground10.jpg /Applications/Wunderlist.app/Contents/Resources/"

alias postcodemap="cd /Users/Shane/dev/Python/postcode_map && ls"
alias tutorial="cd '/Volumes/Leviathan/9. Progamming Tutorials' && ls"

alias wunder="cd ~/dev/Python/wunderlist_automation && ls && atom goals.txt "

alias pip='pip3'
alias python='python3'

export GOPATH="$HOME/dev/go"
export PATH="/anaconda3/bin":$PATH
export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
