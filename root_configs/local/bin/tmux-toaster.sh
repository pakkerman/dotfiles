#!/usr/bin/env bash

main() {
  msg=$1
  tmux set -gq @toast "#[fg=black,bg=green,bold] $msg #[default]"
  sleep 2
  tmux set -ug @toast
}

main "$@"
