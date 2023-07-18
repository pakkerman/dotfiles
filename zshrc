
# Set Variables


# Change ZSH options


# Create Aliases
alias ls='ls -lAFh'

# Customize Prompt(s)
PROMPT='
%1~ %L %# '
RPROMPT='%*'


# Add Location to $PATH Variable



# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins



# ...And Other Surprises
