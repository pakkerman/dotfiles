#!/usr/bin/env zsh

echo "\n<<<< Starting homebrew setup >>>>\n"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Running installs inside Brewfile
brew bundle --verbose
