#!/bin/bash

dirs=("$HOME/Dropbox/Coding" "$HOME/Dropbox/Coding/Projects" "$HOME/temp" "$HOME/Dropbox/Coding/learning" "$HOME/scripts")
others="\n$HOME/dotfiles"

session=$(
	echo -e "$(find "${dirs[@]}" -maxdepth 1 -mindepth 1 -type d)" "$others" |
		sed "s|$HOME/||g" |
		fzf --reverse \
			--margin 10% \
			--border=bold \
			--border-label="Project Finder" \
			--preview "bat $HOME/{}/README.md" \
			--preview-window bottom
)

[[ -z $session ]] && exit 1

session="$HOME/$session"
session_name=$(basename "$session" | tr '.' '_')

if ! tmux has-session -t "$session_name" 2>/dev/null; then
	tmux new-session -s "$session_name" -c "$session" -d "tmux new-window -d; nvim"
fi

tmux switch-client -t "$session_name"
