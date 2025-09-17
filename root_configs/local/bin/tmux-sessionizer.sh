#!/bin/bash

dirs=(
  "$HOME/Dropbox/Coding"
  "$HOME/Dropbox/Coding/learning"
  "$HOME/Dropbox/Coding/Projects"
  "$HOME/temp"
  "$HOME/git"
  "$HOME/scripts"
  "$HOME/image-generation/stable-diffusion-webui"
)

others="\n$HOME/dotfiles"

FZF_TITLE="| Project Sessionizer |"
FZF_COLOR_OPTS=$(echo "
dark,
border:#89ddff,
pointer:#add7ff,
bg:#191919,
label:#89ddff,
info:#89ddff,
bg:#030712
" | tr -d "\n")

session=$(
  echo -e "$(find "${dirs[@]}" -maxdepth 1 -mindepth 1 -type d)" "$others" |
    sed "s|$HOME/||g" |
    fzf \
      --reverse \
      --tmux 70% \
      --border=rounded \
      --margin=0% \
      --border-label="$FZF_TITLE" \
      --preview "if [ -f $HOME/{}/README.md ]; then bat $HOME/{}/README.md; else echo No README.md found in this directory; fi" \
      --preview-window bottom \
      --color="$FZF_COLOR_OPTS"

)

[[ -z $session ]] && exit 0

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
    "tmux new-window -d lazygit; nvim"
fi

tmux switch-client -t "$session_name"
