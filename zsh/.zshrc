# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000000000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hroberts/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias serverssh="ssh hroberts@5.78.107.252"
alias valheimssh="ssh hroberts@5.78.119.162"
alias throttlefix="repositories/scripts/amd-fix-power/change-profile.sh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="${PATH}:/home/hroberts/.local/bin"
