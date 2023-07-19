
# Set Variables
# Syntax Highlighting for man Pages Using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Change ZSH options


# Create Aliases
alias ls='ls -lAFh'

# Customize Prompt(s)
PROMPT='
%1~ %L %# '
RPROMPT='%*'


# Add Location to $PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/contents/Resources/app/bin"




# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins



# ...And Other Surprises
