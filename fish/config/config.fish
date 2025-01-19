if status is-interactive
    # Commands to run in interactive sessions can go here
end

function starship_transient_prompt_func
  starship module character
end
starship init fish | source
enable_transience

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
set SDKMAN_DIR $HOME/.sdkman
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

set PATH $PATH $HOME/.local/bin

starship init fish | source
