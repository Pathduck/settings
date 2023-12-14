#!/bin/sh
# This tells the system what terminal you are using or emulating.
export TERM="xterm-256color"

# stty (Set TTY) sets up your TTY.  Note, if you have problems with
# your backspace key, try changing the "erase '^h'" to "erase '^?'".
# If that still does not help, type stty erase at the shell prompt
# and then hit your backspace key.
stty erase '^?' echoe

# Strip exe from completion
shopt -s completion_strip_exe

# AutoCD up with '..'
shopt -s autocd

# Append history
#shopt -s histappend
#PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Ignore list for filename completion
export FIGNORE=".dll:.cpl"

# Variables
export DISPLAY="localhost:0.0"
export EDITOR="nano"
export LANG="en_GB"
export LESS="-iRM"
export LYNX_CFG="~/.lynx/lynx.cfg"
export PATH="/usr/sbin:~/bin:$PATH:."
export TZ="Europe/Oslo"

# Aliases
alias bb="ssh -t tty.sdf.org bboard"
alias btop="/cygdrive/d/bin/btop4win/btop4win"
alias cd..="cd .."
alias cls="printf '\ec'" # Clear screen+scrollback
alias cp="cp -i"
alias cyg-get="/cygdrive/e/Install/Cygwin/setup-x86_64.exe -qn -P"
alias cyg-update="/cygdrive/e/Install/Cygwin/setup-x86_64.exe -qng"
alias del="rm -i"
alias dir="ls -la"
alias ga="git add -A"
alias gc="git commit"
alias gl="git log --oneline --all --graph --decorate"
alias grep="grep --color"
alias gs="git status"
alias gw="git whatchanged"
alias keychaininit="eval \$(keychain --eval)"
alias la="ls -la"
alias ll="ls -l"
alias ls="ls --color=auto --group-directories-first"
alias mv="mv -i"
alias npp="cygstart /cygdrive/d/bin/Notepad++/notepad++.exe"
alias pastebin="pb" # https://tildegit.org/tomasino/pb
alias rm="rm -i"
alias shn="pb -u"
alias start="cygstart"
alias sublime="cygstart /cygdrive/d/bin/Sublime/sublime_text.exe"
alias sudo="elevate -k" "$@" # https://code.kliu.org/misc/elevate/

# Git Prompt
source /usr/share/git-core/git-prompt.sh
export PS1='\n\033[32m\]\u@\h \[\033[33m\w\033[0m\]$(__git_ps1 " (%s)")\n\$ '

# Dircolors
#eval $(dircolors -b $HOME/.config/dircolors/dircolors.monokai)

# Keychain for SSH Agent
#eval $(keychain --eval)

# Greeting
echo "Welcome to the SDF Public Access UNIX system. (est. 1987)"
date -R
