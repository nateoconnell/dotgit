# Setup alias for selectively managing dotfiles in home directory with git
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Add standard git command completion for the dotgit alias
if [ -f /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git
  __git_complete dotgit __git_main
else
  echo "Error sourcing git completions from /usr/share/bash-completion/completions/git"
fi

alias glog='git log --oneline --graph -10'
alias dglog='dotgit log --oneline --graph -10'
