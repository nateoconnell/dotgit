#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias dotgit='/usr/bin/git --git-dir=$HOME/.dotgit.git --work-tree=$HOME'
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
PS1='[\u@\h \W]\$ '
