
# make sure $HOME/.local/bin is in $PATH
if [[ ! "$PATH" =~ "$HOME/.local/bin" ]]
then
  export PATH="$HOME/.local/bin:$PATH"
fi

alias l='ls -CF --color=auto'
alias ll='ls -Fltr'
alias la='ls -FAltr'
alias vi=nvim
alias vim=nvim

export EDITOR=nvim
export VISUAL=nvim
