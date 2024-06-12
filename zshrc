# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# The Instant Prompt is disable for now
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# source ~/powerlevel10k/powerlevel10k.zsh-theme

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh


# Load fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--reverse --margin 5% --border=bold"

# zoxide
eval "$(zoxide init zsh)"

# Use nvim as man pager
# Reference: Man section in help
export MANPAGER='nvim +Man! +set\ nu +set\ rnu +set\ nowrap'
export MANWIDTH=65


export HOMEBREW_CASK_OPTS="--no-quarantine"

# Change ZSH options

# Command Aliases
alias vim='nvim'
alias ls='exa -laFh --git --ignore-glob=".DS_Store"'
alias tree='exa -FT -L=1 --ignore-glob=node_modules'
alias fman='compgen -c | fzf | xargs man'

# Customize Prompt(s)
# PROMPT='
# %1~ %L %# '
# RPROMPT='%*'


# Add Location to $PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/contents/Resources/app/bin"

# Open remote repo on Github.com
function openremote(){
    git remote -v | grep origin | grep github.com -m 1 | awk '{print $2}' | cut -d'@' -f2 | xargs open
}

# keybinds for cursor nav
bindkey "[D" backward-word
bindkey "[C" forward-word

# bun completions
[ -s "/Users/pakk/.bun/_bun" ] && source "/Users/pakk/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/Pakk/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Golang
export PATH=$PATH:$(go env GOPATH)/bin

# scripts
alias convertPNG="~/scripts/exif-tools/convert.sh $1"
alias cht="~/scripts/cht.sh"
alias flog="~/.local/bin/flog.sh"
alias fadd="~/.local/bin/fadd.sh"
alias watch="~/.local/bin/watch.sh"
alias zrc="nvim ~/.zshrc"
source ~/.local/bin/fcd.sh

# key bind to scripts
bindkey -s ^f "~/.local/bin/tmux-sessionizer.sh\n"

# Created by `pipx` on 2024-05-30 07:38:29
export PATH="$PATH:/Users/pakk/.local/bin"
if [ -f "/Users/pakk/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/pakk/.config/fabric/fabric-bootstrap.inc"; fi