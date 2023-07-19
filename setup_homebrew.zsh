#!/usr/bin/env zsh

echo "\n<<<< Starting homebrew setup >>>>\n"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Packages
brew install httpie
brew install bat

# Apps
brew install brave-browser
brew install visual-studio-code

