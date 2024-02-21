#!/bin/bash 

session=$(find ~/Dropbox/Coding ~/temp -maxdepth 1 -mindepth 1 -type d | fzf)
session_name=$(basename "$session" | tr '.' '_')

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -s "$session_name" -c "$session" -d
fi

tmux switch-client -t "$session_name"
 