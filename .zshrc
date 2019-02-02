###############################################################################
# YOU FIRST NEED TO HAVE THESE PACKAGES INSTALLED:
# 1. oh-my-zsh        https://github.com/robbyrussell/oh-my-zsh
# 2. tmux             https://github.com/tmux/tmux
# 3. nvm              https://github.com/creationix/nvm
# 4. gvm              https://github.com/moovweb/gvm
# 5. autojump         https://github.com/wting/autojump
# 6. fzf              https://github.com/junegunn/fzf
###############################################################################

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    vi-mode                     # https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/vi-mode
    history-substring-search    # https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/history-substring-search
)

source $ZSH/oh-my-zsh.sh

# CONFIGURATIONS OF PLUGINS
c-history-substring-search () {
    # bind k and j for VI mode
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
}
c-history-substring-search

# Set language environment
export LANG=en_US.UTF-8

# Set personal aliases
alias c="clear"
alias C="clear"

alias gs="git status"
alias gp="git pull"

alias ns="npm start"

alias sc="vi ~/.zshrc"
alias scs=". ~/.zshrc"

alias h="history | grep"
function diff () { colordiff -u $@ | less; }

# socks-cli
if [ ! -d "$HOME/.socks-cli" ]; then
  git clone https://github.com/zjx20/socks-cli $HOME/.socks-cli
fi
alias ss="source ~/.socks-cli/activate"

alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dl="docker logs"
alias dn="docker network ls"
alias drm="docker rm"
alias drmi="docker rmi"
alias drmn="docker network rm"

# Source tmux configuration
[ -f /tmp/tmux-1000/default ] && tmux source-file ~/.tmux.conf

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load gvm
[ -s "$HOME/.gvm/scripts/gvm" ] && \. "$HOME/.gvm/scripts/gvm"

# Load autojump
[ -f /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Little cat
cat="
              /\\_/\\
            =( °w° )=
              )   (  _     Nothing todo.
             (__ __)//     Why don't you take a little break? \n"

# todo - a simple todo list
todo () {
    test -f $HOME/.todo || touch $HOME/.todo
    if [ $# = 0 ]
    then
        if [[ ! -s $HOME/.todo ]]
        then
            echo $cat
        else
            cat -n $HOME/.todo
        fi
    elif [ $1 = -h ] || [ $1 = --help ]
    then
        echo '\ntodo - a simple TODO list\n'
        echo 'Usage: todo [-h] [content]'
        echo 'Option:'
        echo '    -h --help       Print usage'
        echo 'Example:'
        echo '    $ todo'
        echo '    $ todo eat your own dog food'
        echo '    $ todo --help\n'
    else
        echo $@ >> $HOME/.todo
    fi
}

# ok - finish todo item
ok () {
    test -f $HOME/.todo || touch $HOME/.todo
    if [ $# = 0 ]
    then
        if [[ ! -s $HOME/.todo ]]
        then
            echo $cat
        else
            cat -n $HOME/.todo
            echo -ne "\n     Type a number to remove: "
            read NUMBER
            sed -ie ${NUMBER}d $HOME/.todo
        fi
    elif [ $1 = -h ] || [ $1 = --help ]
    then
        echo '\nok - finish TODO item\n'
        echo 'Usage: ok [-h] [number]'
        echo 'Option:'
        echo '    -h --help       Print usage'
        echo 'Example:'
        echo '    $ ok'
        echo '    $ ok 2'
        echo '    $ ok --help\n'
    else
        sed -ie $1d $HOME/.todo
    fi
}

# fs - determine size of a file or total size of a directory
fs () {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
}

# x - extract or unpack(uncompress) a compressed file
x() {
    if [ -f $1 ]; then
        case $1 in
            *.tar)       tar xvf $1;;
            *.tar.bz2)   tar jxvf $1;;
            *.tbz2)      tar jxvf $1;;
            *.tar.gz)    tar zxvf $1;;
            *.tgz)       tar zxvf $1;;
            *.zip)       unzip -O gbk $1;;
            *.gz)        gunzip $1;;
            *.bz2)       bunzip2 $1;;
            *.rar)       unrar e $1;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1;;
            *)           echo "'$1' cannot be extracted via x()";
        esac
    else
        echo "'$1' is not a valid file";
    fi;
}

# fbi - show FBI warning. just for fun. :)
fbi () {
    _COLUMNS=$(tput cols)
    _MESSAGE=" FBI Warining "
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")

    echo " "
    echo -e "${spaces}\033[41;37;5m FBI WARNING \033[0m"
    echo " "
    _COLUMNS=$(tput cols)
    _MESSAGE="Ferderal Law provides severe civil and criminal penalties for"
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")
    echo -e "${spaces}${_MESSAGE}"

    _COLUMNS=$(tput cols)
    _MESSAGE="the unauthorized reproduction, distribution, or exhibition of"
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")
    echo -e "${spaces}${_MESSAGE}"

    _COLUMNS=$(tput cols)
    _MESSAGE="copyrighted motion pictures (Title 17, United States Code,"
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")
    echo -e "${spaces}${_MESSAGE}"

    _COLUMNS=$(tput cols)
    _MESSAGE="Sections 501 and 508). The Federal Bureau of Investigation"
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")
    echo -e "${spaces}${_MESSAGE}"

    _COLUMNS=$(tput cols)
    _MESSAGE="investigates allegations of criminal copyright infringement"
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")
    echo -e "${spaces}${_MESSAGE}"

    _COLUMNS=$(tput cols)
    _MESSAGE="(Title 17, United States Code, Section 506)."
    y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
    spaces=$(printf "%-${y}s" " ")
    echo -e "${spaces}${_MESSAGE}"
    echo " "
}

# sz - source xmodmap
sx () {
    xmodmap ~/.Xmodmap
}

# j - fzf integration with autojump
j () {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sed '/_____/Q; s/^[0-9,.:]*\s*//' |  fzf --height 40% --reverse --inline-info)"
}

# ch - fzf integration chrome history
ch () {
    local cols sep google_history open
    cols=$(( COLUMNS / 3 ))
    sep='{::}'

    if [ "$(uname)" = "Darwin" ]; then
        google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
        open=open
    else
        google_history="$HOME/.config/google-chrome/Default/History"
        open=xdg-open
    fi
    cp -f "$google_history" /tmp/h
    sqlite3 -separator $sep /tmp/h \
        "select substr(title, 1, $cols), url
        from urls order by last_visit_time desc" |
    awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
    fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# gshow - fzf integration git commit browser
gshow () {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
}
