# -------------------------------------------------------------------
#  1.  Set Paths
#  2.  Environment Config
#  3.  File Management
#  4.  Process Management
#  5.  Networking
#  6.  System Operations
#  7.  Web Development
#  8.  Oh My ZSH
#  9.  Aliases
# -------------------------------------------------------------------




# -------------------------------------
# 1.  SET PATHS
# -------------------------------------

  # Basic bins (lead with Homebrew)
  export BASIC="/opt/homebrew/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"

  # N (see http://git.io/n-install-repo)
  export N_PREFIX="$HOME/.n"
  export N_PATH="$N_PREFIX/bin"

  # Git
  export GIT="/usr/local/git/bin"

  # Path all the things!
  # Why is `N_PATH` before the basic path?
  # https://github.com/Homebrew/homebrew-core/pull/36222#commitcomment-32090028
  export PATH=$N_PATH:$BASIC




# -------------------------------------
# 2.  ENVIRONMENT CONFIG
# -------------------------------------

  # Load avn (see https://github.com/wbyoung/avn)
  [[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"

  # Default shell
  export SHELL="/usr/local/bin/zsh"

  # Default editor
  export EDITOR="code -w"

  # Default blocksize
  export BLOCKSIZE="1k"

  # Language environment
  export LANG="en_US.UTF-8"

  export ARCHFLAGS="-arch x86_64"
  export SSH_KEY_PATH="~/.ssh/rsa_id"
  export MANPATH="/usr/local/man:$MANPATH"
  export PROJECT_HOME="$HOME/Code"

  # Stop Git from asking for merge messages
  export GIT_MERGE_AUTOEDIT="no"

  # Hide Homebrew environment hints
  export HOMEBREW_NO_ENV_HINTS=true

  # Set colors
  export CLICOLOR="1"
  export LSCOLORS="dxfxcxcxbxexexbxbxDADA"

  # Load colours
  autoload -U colors
  colors




# -------------------------------------
# 3.  FILE MANAGEMENT
# -------------------------------------

  zipf () { zip -r "$1".zip "$1" }            # Create ZIP archive of folder
  alias numFiles='echo $(ls -1 | wc -l)'      # Count non-hidden files in dir




# -------------------------------------
# 4.  PROCESS MANAGEMENT
# -------------------------------------

  # cpuHogs:  Find CPU hogs
  alias cpu_hogs="ps wwaxr -o pid,stat,%cpu,time,command | head -10"

  # my_ps: List processes owned by my user
  my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }




# -------------------------------------
# 5.  NETWORKING
# -------------------------------------

  # Find my IP address (public and local)
  alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
  alias iplocal="ipconfig getifaddr en0"

  alias netCons="lsof -i"                            # Show open TCP/IP sockets
  alias flushDNS="dscacheutil -flushcache"           # Flush out DNS Cache
  alias lsock="sudo /usr/sbin/lsof -i -P"            # Show open sockets
  alias lsockU="sudo /usr/sbin/lsof -nP | grep UDP"  # Show open UDP sockets
  alias lsockT="sudo /usr/sbin/lsof -nP | grep TCP"  # Show open TCP sockets
  alias openPorts="sudo lsof -i | grep LISTEN"       # Listening connections




# -------------------------------------
# 6.  SYSTEMS OPERATIONS
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
# 7.  WEB DEVELOPMENT
# -------------------------------------

  # Edit `/etc/hosts` file
  alias editHosts="sudo nano /etc/hosts"

  # Grabs headers from page
  httpHeaders () { /usr/bin/curl -I -L $@ ; }

  # Download a web page and show info on what took time
  httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }




# -------------------------------------
# 8. OH MY ZSH
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

  source $ZSH/oh-my-zsh.sh

  ## History Size and Save History Size
  HISTSIZE=5000
  HISTFILESIZE=10000
  SAVEHIST=5000
  setopt EXTENDED_HISTORY
  HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
  # share history across multiple zsh sessions
  setopt SHARE_HISTORY
  # append to history
  setopt APPEND_HISTORY
  # adds commands as they are typed, not at shell exit
  setopt INC_APPEND_HISTORY
  # do not store duplications
  setopt HIST_IGNORE_DUPS

  ## Disable Git zsh integration to help speed things up.
  # See https://blog.jonlu.ca/posts/speeding-up-zsh#observations
  DISABLE_UNTRACKED_FILES_DIRTY="true"




# -------------------------------------
# 9.  ALIASES
# -------------------------------------

  cd() { builtin cd "$@"; ls -Fahop; }        # List dir contents upon `cd`
  mkd () { mkdir -p "$@" && cd "$@" }         # Makes dir and jumps inside

  alias ..='cd ../'                           # Go back 1 directory level
  alias .2='cd ../../'                        # Go back 2 directory levels
  alias .3='cd ../../../'                     # Go back 3 directory levels
  alias .4='cd ../../../../'                  # Go back 4 directory levels
  alias .5='cd ../../../../../'               # Go back 5 directory levels
  alias c='clear'                             # Clear terminal display
  alias cat='bat'                             # Replace `cat`
  alias cll='clear; ll'                       # Clear and list contents
  alias cp='cp -iv'                           # Preferred `cp`
  alias e='exit'                              # Exit
  alias edit='code'                           # Opens file in my editor
  alias f='open -a Finder ./'                 # Opens dir in Finder
  alias finder='open -a Finder ./'            # Opens dir in Finder
  alias h='cd ~'                              # Go home
  alias home='cd ~'                           # Go home
  alias ll='ls -Fahop'                        # Enhanced `ls`
  alias ls='ls -Fa'                           # Preferred `ls`
  alias lsd='ls -l | grep "^d"'               # List only directories
  alias mv='mv -iv'                           # Preferred `mv`
  alias mkdir='mkdir -p'                      # Preferred `mkdir`
  alias path='echo -e ${PATH//:/\\n}'         # Echo all executable Paths
  alias reload='source ~/.zshrc'              # Reload `.zshrc`
  alias rm='rm -i'                            # Preferred `rm` (ask for confirmation)
  alias which='type -a'                       # Find executables
  alias zshrc='edit ~/.zshrc'                 # Edit this config file

  # Craft CMS
  craft() { ./app/craft "$@" 2>/dev/null || ./craft "$@"; }

  # One Design
  alias osh='cd ~/Code/ODC/oak-street-health' # Go to the Oak Street Health project

  # Homebrew
  alias -g brewme='brew update && brew upgrade --greedy'

  # NPM
  alias nrb='npm run build'
  alias nrs='npm run start'
  alias npmls='npm list -g --depth=0'
  alias npm-check='npx npm-check -u'

  # PIP
  alias pip-check='pip-check --hide-unchanged --show-update'
  alias pip3-check='pip-check --hide-unchanged --show-update --cmd=pip3'

  source ~/.zshrc.private
