#!/bin/bash

echo -e "Backuping existing apt configuration"
timestr=$(date +%Y%m%d%H%M)
sudo tar -zcPf /etc/apt.$timestr.tar.gz /etc/apt

aptKeys=(
  https://download.docker.com/linux/ubuntu/gpg # docker-ce
)
for k in ${aptKeys[@]}; do echo "Adding apt key: ${k}"; curl -fsSL $k | sudo apt-key add -; done

aptRepositories=(
  ppa:git-core/ppa # git
  ppa:ansible/ansible # ansible
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" # docker-ce
)
for ((i = 0; i < ${#aptRepositories[@]}; i++));
do
  echo "Adding apt repository: ${aptRepositories[$i]}"
  sudo add-apt-repository -y -n "${aptRepositories[$i]}"
done

############################################################################################################################################
# name                          bin                                   desc
############################################################################################################################################
# sudo                          sudo                                  Provide limited super user privileges to specific users
# net-tools                     ifconfig, netstat, ...                NET-3 networking toolkit
# telnet                        telnet                                basic telnet client
# wget                          wget                                  retrieves files from the web
# curl                          curl                                  command line tool for transferring data with URL syntax
# make                          make                                  utility for directing compilation
# git                           git                                   fast, scalable, distributed revision control system
# git-extras                    git-summary, git-line-summary, ...    Extra commands for git
# gcc                           gcc                                   GNU C compiler
# g++                           g++                                   GNU C++ compiler
# pkg-config                    pkg-config                            manage compile and link flags for libraries
# unzip                         unzip                                 De-archiver for .zip files
# rar                           rar                                   Archiver for .rar files
# unrar                         unrar                                 Unarchiver for .rar files (non-free version)

# mercurial                     hg                                    easy-to-use, scalable distributed version control system
# binutils                      as, ar, ...                           GNU assembler, linker and binary utilities
# build-essential                                                     Informational list of build-essential packages
# bison                         bison                                 YACC-compatible parser generator
# apt-transport-https                                                 https download transport for APT
# ca-certificates               update-ca-certificates                Common CA certificates
# software-properties-common    add-apt-repository                    manage the repositories that you install software from (common)
# gdebi                         gdebi                                 simple tool to view and install deb files - GNOME GUI

# sysstat                       sar, mpstat, iostat, pidstat, ...     system performance tools for Linux
# nmon                          nmon                                  performance monitoring tool for Linux
# htop                          htop                                  interactive processes viewer
# atop                          atop, atopsar                         Monitor for system resources and process activity
# iotop                         iotop                                 simple top-like I/O monitor
# iftop                         iftop                                 displays bandwidth usage information on an network interface
# nethogs                       nethogs                               Net top tool grouping bandwidth per process
# ethtool                       ethtool                               display or change Ethernet device settings
# nicstat                       nicstat                               print network traffic statistics
# dstat                         dstat                                 versatile resource statistics tool
# vnstat                        vnstat, vnstatd                       console-based network traffic monitor
# pstack                        pstack                                Display stack trace of a running process
# strace                        strace                                System call tracer
# collectl                      collectl, colmux                      Utility to collect Linux performance data

# python-pip                    pip, pip2                             alternative Python package installer
# python-pip                    pip3                                  alternative Python package installer - Python 3 version of the package
# tmux                          tmux                                  terminal multiplexer
# zsh                           zsh                                   shell with lots of features
# autojump                      autojump                              shell extension to jump to frequently used directories
# ack-grep                      ack, ack-grep                         grep-like program specifically for large source trees
# vim                           vim                                   Vi IMproved - enhanced vi editor
# vim-gtk                       vim-gtk                               Vi IMproved - enhanced vi editor - with GTK2 GUI
# exuberant-ctags               ctags, ctags-exuberant                build tag file indexes of source code definitions
# i3                            i3, i3lock, i3-dmenu-desktop, ...     metapackage (i3 window manager, screen locker, menu, statusbar)
# suckless-tools                dmenu, slock, wmname, ...             simple commands for minimalistic window managers
# flameshot                     flameshot                             Powerful yet simple-to-use screenshot software
# ansible                       ansible, ansible-playbook, ...        Configuration management, deployment, and task execution system
# fcitx                         fcitx, fcitx-configtool, ...          Flexible Input Method Framework

# mycli                         mycli                                 CLI for MySQL/MariaDB
# mongodb-clients               mongo                                 object/document-oriented database (client apps)
# mongo-tools                   mongodump, mongoexport, mongotop, ... collection of tools for administering MongoDB servers
# redis-tools                   redis-cli, redis-benchmark, ...       object/document-oriented database (client apps)

# transmission                  transmission-gtk                      lightweight BitTorrent client
# vlc                           vlc                                   multimedia player and streamer
# libreoffice                   writer, calc, impress, draw, ...      office productivity suite (metapackage)

# docker-ce
############################################################################################################################################
sudo apt update
sudo apt install -y sudo net-tools telnet wget curl git git-extras make gcc g++ pkg-config unzip rar unrar \
                    mercurial binutils build-essential bison apt-transport-https ca-certificates software-properties-common gdebi \
                    sysstat nmon htop atop iotop iftop nethogs ethtool nicstat dstat vnstat pstack strace collectl \
                    python-pip python3-pip tmux zsh autojump ack-grep vim vim-gtk exuberant-ctags i3 suckless-tools flameshot ansible fcitx \
                    mycli mongodb-clients mongo-tools redis-tools \
                    libreoffice transmission vlc \
                    docker-ce

# install debian packages
aptCache=/var/cache/apt/archives
debPackages=(
  http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
)
for i in ${debPackages[@]};
do
  filename=$aptCache/$(basename $i)
  if [ ! -f $filename ]; then
    echo -e "\nInstalling $i"
    sudo curl -L -o$filename $i
    sudo gdebi -n $filename
  fi
done


# https://github.com/robbyrussell/oh-my-zsh
sudo chsh -s /bin/zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  echo -e "\nInstalling oh-my-zsh..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# https://github.com/junegunn/fzf
if [ ! -d $HOME/.fzf ]; then
  echo -e "\nInstalling fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
fi

# https://github.com/creationix/nvm
if [ ! -d $HOME/.nvm ]; then
  echo -e "\nInstalling nvm..."
  curl -L https://github.com/creationix/nvm/raw/v0.33.11/install.sh | bash
  nvm install 8
  nvm use 8
  nvm alias default 8

  npm install -g http-server cleaver
fi

# https://github.com/moovweb/gvm
if [ ! -d $HOME/.gvm ]; then
  echo -e "\nInstalling gvm..."
  curl -L https://github.com/moovweb/gvm/raw/master/binscripts/gvm-installer | bash
  gvm install go1.4 -B
  gvm use go1.4
  gvm install go1.11
  gvm use go1.11 --default

  go get -u github.com/rgburke/grv/cmd/grv
fi

# https://github.com/modood/dotfiles
echo -e "\nSetting https://github.com/modood/dotfiles"
curl -sL https://github.com/modood/dotfiles/raw/master/install.sh | bash

# https://github.com/modood/i3wmconfig
echo -e "\nSetting https://github.com/modood/i3wmconfig"
curl -sL https://github.com/modood/i3wmconfig/raw/master/install.sh | bash

# https://github.com/modood/tmuxconfig
echo -e "\nSetting https://github.com/modood/tmuxconfig"
curl -sL https://github.com/modood/tmuxconfig/raw/master/install.sh | bash

# https://github.com/modood/vimrc
echo -e "\nSetting https://github.com/modood/vimrc"
curl -sL https://github.com/modood/vimrc/raw/master/install.sh | bash

# Add user account to the docker group
sudo usermod -aG docker $(whoami)

# https://github.com/docker/compose
(command -v docker-compose >/dev/null 2>&1) || {
  echo -e "\nInstalling docker-compose..."
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

# Remove automatically all unused packages
sudo apt autoremove -y
