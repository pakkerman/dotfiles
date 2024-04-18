#!/bin/bash

dirs=("$HOME/Dropbox/Coding" "$HOME/temp" "$HOME/Dropbox/Coding/learning/" "$HOME/scripts/")
others="\n$HOME/dotfiles"

session=$(echo -e "$(find "${dirs[@]}" -maxdepth 1 -mindepth 1 -type d)" "$others" |
	fzf --reverse --margin 10% --border=bold --border-label="Project Finder")

session_name=$(basename "$session" | tr '.' '_')

if ! tmux has-session -t "$session_name" 2>/dev/null; then
	tmux new-session -s "$session_name" -c "$session" -d
fi

tmux switch-client -t "$session_name"
