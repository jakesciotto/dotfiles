#------------------------------------------------------
# :: .bash_profile
# -------------------------------------------------------

# add coreutils to manpath
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# for colorized output
eval "$(gdircolors -b ~/.dir_colors)"

export LS_COLORS

export EDITOR=/usr/bin/vim

# shell prompt
export PS1="\t [\u@\h \[\e[00;038;5;190m\]\W\[\e[0m\]]\$ \[$(tput sgr0)\]"

# export PS1="\[\e[00;038;5;111m\][\[\e[0m\]\@\[\e[00;038;5;111m\]]\[\e[0m\] [\[\e[00;038;5;212m\]\u\[\e[0m\]\[\e[00;038;5;119m\]@\[\e[0m\]\h \[\e[00;38;5;190m\]\W\[\e[0m\]]\[\e[00;38;5;119m\]\$\[\e[0m\]\[$(tput sgr0)\] "

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias bp='cd; subl .bash_profile'
alias bbc='cd ~/Library/Application\ Support/BBedit/'
alias cellar='cd /usr/local/cellar'
alias desktop='cd ~/desktop'
alias dropbox='cd ~/Dropbox'
alias gd='cd ~/Google\ Drive'
alias hd='cd /'
alias main='cd ~/desktop/main'
alias sites='cd /users/jakesciotto/sites'
alias music='cd /Users/jakesciotto/music/iTunes/iTunes\ Media/music'
alias ugalax='cd /users/jakesciotto/sites/ugalax.com'
alias sandbox='cd ~/desktop/sandbox'
alias wordpress='cd ~/sites/wordpress'
alias templates='cd /users/jakesciotto/library/containers/com.textasticapp.textastic-mac/data/library/application\ support/textastic/templates'
alias languagemodules='cd ~/Library/Application\ Support/Bbedit/Language\ Modules'

# useful alias commands 
alias f='open -a Finder ./'
alias cp='cp -iv'
alias ls='/usr/local/opt/coreutils/libexec/gnubin/ls --color=always'
alias ll='ls -lrhoS --group-directories-first'
alias mv='mv -iv'
alias nvm='ssh student@172.17.152.64'
alias nike='ssh sciotto@nike.cs.uga.edu'
alias cask='brew cask'
alias path='echo -e ${PATH//:/\\n}'
alias trash='trash -v'
alias mkdir='mkdir -pv'
alias clean='rm *.aux *.log *.gz *.pdf'
alias local2='ssh jakesciotto@192.168.1.224'
alias refresh='. ~/.bash_profile'
alias pdflatex='pdflatex -output-directory tmp'

# temporary directory changes
alias bs='cd ~/desktop/fall2016/csci4370/cs4370/bookstore'
alias jc='cd /users/jakesciotto/sites/wordpress/wp-content/themes/jobify-child'
alias dp1='cd ~/desktop/fall2016/csci4370/cs4370/project1'
alias dp2='cd ~/desktop/fall2016/csci4370/cs4370/project2'
alias dp3='cd ~/desktop/fall2016/csci4370/cs4370/project3'
alias dp4='cd ~/desktop/fall2016/csci4370/cs4370/project4'
alias dbm='cd ~/desktop/fall2016/csci4370'
alias fall='cd ~/desktop/fall2016'
alias span='cd ~/desktop/fall2016/span2001'
alias arch='cd ~/desktop/fall2016/csci4720'
alias range='cd ~/desktop/fall2016/csci4760/cs4760/range'
alias webproxy='cd ~/desktop/fall2016/csci4760/cs4760/webproxy'
alias networks='cd ~/desktop/fall2016/csci4760'

# networking
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias speedtest='wget --report-speed=bits --user-agent=Mozilla -O /dev/null http://speedtest.atlanta.linode.com/100MB-atlanta.bin'
alias ip='ipconfig getifaddr en0'

# applications

alias mail='open -a Mail'
alias vim='/usr/bin/vim'

# mysql
alias sqlload='sudo launchctl load -F  /Library/LaunchDaemons/com.oracle.oss.mysql.mysqld.plist;'
alias sqlunload='sudo launchctl unload -F  /Library/LaunchDaemons/com.oracle.oss.mysql.mysqld.plist'
alias sqlstart='sudo /usr/local/mysql/support-files/mysql.server start'
alias sqlstop='sudo /usr/local/mysql/support-files/mysql.server stop'

# returns size for directory
size () { for f in "$@"
				do du -sh "$f"
			 done ; }

# sends files to folder in dropbox
archive () { for f in "$@"
				do mv -ifv "$f" ~/Dropbox/unsorted/
			 done ; }

# sends files to backup folder on desktop
backup () { for f in "$@"
				do cp -rv "$f" ~/desktop/backups/
			done ; }

# moves all pictures in argument to dropbox folder
store () { for f in "$@"
				do mv -ifv "$f" ~/Dropbox/pictures/2016/
			done ; }

zipf () { zip -r "$1".zip "$1" ; } 

# quick files
alias numFiles='echo $(ls -1 | wc -l)'
alias make1mb='mkfile 1m ./1MB.dat'  
alias make5mb='mkfile 5m ./5MB.dat'
alias make10mb='mkfile 10m ./10MB.dat'
alias apacheLogs='less +F /var/log/apache2/error_log'

alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'



