#!/bin/bash

dirs=("$HOME/Dropbox/Coding" "$HOME/temp" "$HOME/Dropbox/Coding/learning/" "$HOME/scripts/")
session=$(find "${dirs[@]}" -maxdepth 1 -mindepth 1 -type d | fzf --margin 10% --border=bold --border-label="Project Finder" --border-label-pos=bottom)
session_name=$(basename "$session" | tr '.' '_')

if ! tmux has-session -t "$session_name" 2>/dev/null; then
	tmux new-session -s "$session_name" -c "$session" -d
fi

tmux switch-client -t "$session_name"
