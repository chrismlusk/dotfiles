# -------------------------------------------------------------------
#  1.  Set Paths
#  2.  Environment Config
#  3.  OH MY ZSH
#  4.  File Management
#  5.  Process Management
#  6.  Networking
#  7.  System Operations
#  8.  Web Development
#  9.  Aliases
# -------------------------------------------------------------------




# -------------------------------------
# 1.  SET PATHS
# -------------------------------------

  # Basic bins (lead with Homebrew)
  export BASIC="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$HOME/.local/bin"

  # N (see http://git.io/n-install-repo)
  export N_PREFIX="$HOME/.n"
  export N_PATH="$N_PREFIX/bin"

  # Path all the things!
  # Why is `N_PATH` before the basic path?
  # https://github.com/Homebrew/homebrew-core/pull/36222#commitcomment-32090028
  export PATH=$N_PATH:$BASIC

  # Added by Docker Desktop to enable Docker CLI completions.
  fpath=($HOME/.docker/completions $fpath)




# -------------------------------------
# 2.  ENVIRONMENT CONFIG
# -------------------------------------

  # Default shell
  export SHELL="$HOMEBREW_PREFIX/bin/zsh"

  # Default editor
  export EDITOR="code -w"

  # Default blocksize
  export BLOCKSIZE="1k"

  # Language environment
  export LANG="en_US.UTF-8"

  export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
  export PROJECT_HOME="$HOME/Code"

  # Hide Homebrew environment hints
  export HOMEBREW_NO_ENV_HINTS=true

  # Set colors
  export CLICOLOR="1"
  export LSCOLORS="dxfxcxcxbxexexbxbxDADA"

  # Load colours
  autoload -U colors
  colors




# -------------------------------------
# 3. OH MY ZSH
# -------------------------------------

  # Path to oh-my-zsh installation
  export ZSH="$HOME/.oh-my-zsh"

  # Set name of the theme to load
  ZSH_THEME="spaceship"

  # Which plugins would you like to load?
  # Standard plugins can be found in ~/.oh-my-zsh/plugins/*
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  plugins=(git git-extras) # Git plugins
  plugins+=(macos last-working-dir) # Standard & MacOS plugins
  plugins+=(npm) # JavaScript plugins

  ## Disable Git zsh integration to help speed things up.
  # See https://blog.jonlu.ca/posts/speeding-up-zsh#observations
  DISABLE_UNTRACKED_FILES_DIRTY="true"

  source $ZSH/oh-my-zsh.sh

  ## Override history settings after loading
  SAVEHIST=50000
  # Enable extended history format (timestamp, duration, etc.)
  setopt EXTENDED_HISTORY
  # Share history across zsh sessions
  setopt SHARE_HISTORY
  # Do not store duplications
  setopt HIST_IGNORE_ALL_DUPS
  # Prefix any command with a space to keep it out of history
  setopt HIST_IGNORE_SPACE




# -------------------------------------
# 4.  FILE MANAGEMENT
# -------------------------------------

  # Create ZIP archive of folder
  zipf () { zip -r "$1".zip "$1" }

  # Extract various archive formats
  extract() {
    if [ -f "$1" ]; then
      case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1"  ;;
        *.tar)     tar xf "$1"  ;;
        *.zip)     unzip "$1"   ;;
        *)         echo "'$1' cannot be extracted" ;;
      esac
    else
      echo "'$1' is not a valid file"
    fi
  }


  # Count non-hidden files in directory
  alias numFiles='echo $(ls -1 | wc -l)'




# -------------------------------------
# 5.  PROCESS MANAGEMENT
# -------------------------------------

  # cpuHogs:  Find CPU hogs
  alias cpu_hogs="ps wwaxr -o pid,stat,%cpu,time,command | head -10"

  # my_ps: List processes owned by my user
  my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }




# -------------------------------------
# 6.  NETWORKING
# -------------------------------------

  # Find my IP address (public and local)
  alias ip="dig +short txt ch whoami.cloudflare @1.0.0.1"
  alias localip="ipconfig getifaddr en0"

  # Show open TCP/IP sockets
  alias netCons="lsof -i"

  # Flush out DNS Cache
  alias flushDNS="dscacheutil -flushcache"

  # Show open sockets
  alias lsock="sudo /usr/sbin/lsof -i -P"

  # Show open UDP sockets
  alias lsockU="sudo /usr/sbin/lsof -nP | grep UDP"

  # Show open TCP sockets
  alias lsockT="sudo /usr/sbin/lsof -nP | grep TCP"

  # Listening connections
  alias openPorts="sudo lsof -i | grep LISTEN"

  # What's running on a given port?
  port() { lsof -i ":$1" | grep LISTEN }




# -------------------------------------
# 7.  SYSTEMS OPERATIONS
# -------------------------------------

  # Show or hide hidden files
  hiddenfiles() {
    if [ "$1" = "show" ]; then
      defaults write com.apple.finder AppleShowAllFiles -bool true
    elif [ "$1" = "hide" ]; then
      defaults write com.apple.finder AppleShowAllFiles -bool false
    elif [ "$1" = "toggle" ]; then
      if [ "$(defaults read com.apple.finder AppleShowAllFiles)" = "NO" ]; then
        defaults write com.apple.finder AppleShowAllFiles -bool true
      else
        defaults write com.apple.finder AppleShowAllFiles -bool false
      fi
    else
      echo "Valid options are: show, hide, toggle"
    fi
    killall Finder
  }

  # Enable or disable Spotlight
  spotlight() {
    if [ "$1" = "on" ]; then
      sudo mdutil -a -i on
    elif [ "$1" = "off" ]; then
      sudo mdutil -a -i off
    else
      echo "Valid options are: on, off"
    fi
  }




# -------------------------------------
# 8.  WEB DEVELOPMENT
# -------------------------------------

  # Edit `/etc/hosts` file
  alias editHosts="sudo nano /etc/hosts"

  # Grabs headers from page
  httpHeaders () { /usr/bin/curl -I -L "$@" ; }

  # Download a web page and show info on what took time
  httpDebug () { /usr/bin/curl "$@" -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }




# -------------------------------------
# 9.  ALIASES
# -------------------------------------

  # List dir contents upon `cd`
  cd() { builtin cd "$@"; ls -Fahop; }

  # Makes dir and jumps inside
  mkd () { mkdir -p "$@" && cd "$@" }

  # Go back 1 directory level
  alias ..='cd ../'

  # Go back 2 directory level
  alias .2='cd ../../'

  # Go back 3 directory level
  alias .3='cd ../../../'

  # Clear terminal display
  alias c='clear'

  # Replace `cat`
  alias cat='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"

  # Clear and list contents
  alias cll='clear; ll'

  # Preferred `cp`
  alias cp='cp -iv'

  # Go to dotfiles directory
  alias dotfiles="cd $HOME/dotfiles"
  alias dot="cd $HOME/dotfiles"

  # Exit
  alias e='exit'

  # Opens file in my editor
  alias edit='code'

  # Opens current directory in Finder
  alias f='open -a Finder ./'

  # Go home
  alias h='cd ~'
  alias home='cd ~'

  # Enhanced `ls`
  alias ll='ls -Fahop'

  # Preferred `ls`
  alias ls='ls -Fa'

  # List only directories
  alias lsd='ls -d */'

  # Preferred `mv`
  alias mv='mv -iv'

  # Preferred `mkdir`
  alias mkdir='mkdir -p'

  # Echo all executable Paths
  alias path='echo -e ${PATH//:/\\n}'

  # Reload `.zshrc`
  alias reload='source ~/.zshrc'

  # Preferred `rm` (ask for confirmation)
  alias rm='rm -i'

  # Enable aliases to be sudo’d
  alias sudo='sudo '

  # Find executables
  alias which='type -a'

  # Edit this config file
  alias zshrc='edit ~/.zshrc'

  # Go to the Oak Street Health project
  alias osh='cd ~/Code/oak-street-health'

  # Homebrew
  alias -g brewme='brew update && brew upgrade --greedy'

  # NPM
  alias nrb='npm run build'
  alias nrs='npm run start'
  alias npmls='npm list -g --depth=0'
  alias npm-check='npx npm-check -u'

  source ~/.zshrc.private
