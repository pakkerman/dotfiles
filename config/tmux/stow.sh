#!/bin/bash

# get where the script is located and cd
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR" || exit

# stow packages inside the dir where the script is located
STOW_TARGET_DIR="$HOME/"

stow \
  . \
  --ignore='stow.sh' \
  -t "$STOW_TARGET_DIR" \
  --dotfiles

echo -e "stow packages\nfrom:\t$SCRIPT_DIR\nto:\t$STOW_TARGET_DIR"
