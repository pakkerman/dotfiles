#!/bin/bash

dirs=(
	"$HOME/Dropbox/Coding"
	"$HOME/Dropbox/Coding/learning"
	"$HOME/Dropbox/Coding/Projects"
	"$HOME/temp"
	"$HOME/git"
	"$HOME/scripts"
)
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

#TODO: Fix when exit nvim the window will close.
#Lead: on the "remain-on-exit" option
#
existing_session=$(tmux has-session -t "$session_name" 2>/dev/null)
if ! "$existing_session"; then
	tmux new-session \
		-d \
		-c "$session" \
		-s "$session_name" \
		"tmux new-window -d; nvim"
fi

tmux switch-client -t "$session_name"
