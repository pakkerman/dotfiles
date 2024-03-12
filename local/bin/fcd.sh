#!/bin/bash

# Somthing with cd being built-in function that doesn't play alone will with using a alias, which will cause only the subshell to be cd not the top one, useless. Using source and a function to cd the top shell

fcd() {
	dir=$1
	content=$(fd -H . -d 1 -t d -t l | sort -r)
	content="$content\n..\n."

	[[ -z $content ]] && return

	dir=$(
		echo "$content" | fzf --height 50% \
			--preview "exa -TF -L=1 {}" \
			--preview-window=right:40% \
			--preview-label "$(pwd)" \
			--preview-label-pos=bottom \
			--bind "right:change-preview(exa -TF -L=3 {})" \
			--bind "left:change-preview(exa -TF -L=1 {})"
	)

	if [[ -n "$dir" ]]; then
		cd "$dir" || exit
		fcd "$dir"
	fi
}
