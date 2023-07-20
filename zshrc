# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="pygmalion"

plugins=(git)

source $ZSH/oh-my-zsh.sh



source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh




# ----- Dotfiles Course Section -------------
# Set Variables
# Syntax Highlighting for man Pages Using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"

# Change ZSH options


# Create Aliases
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'


# Customize Prompt(s)
# PROMPT='
# %1~ %L %# '
# RPROMPT='%*'


# Add Location to $PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/contents/Resources/app/bin"




# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins

# ...And Other Surprises



# pnpm
export PNPM_HOME="/Users/Pakk/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
