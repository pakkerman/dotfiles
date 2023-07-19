#!/usr/bin/env zsh

echo "\n<<<< Starting homebrew setup >>>>\n"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Formulae
brew install httpie
brew install bat

# Casks
brew install --no-quarantine brave-browser
brew install --no-quarantine visual-studio-code
brew install --no-quarantine alfred

