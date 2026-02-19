#!/usr/bin/env bash

dirs=(
  "$HOME/Dropbox/Coding"
  "$HOME/Dropbox/Coding/learning"
  "$HOME/Dropbox/Coding/Projects"
  "$HOME/temp"
  "$HOME/git"
  "$HOME/scripts"
  "$HOME/image-generation/stable-diffusion-webui"
)

others="$HOME/dotfiles"

FZF_TITLE="| Project Sessionizer |"
FZF_COLOR_OPTS="dark,bg:#18181b,border:#89ddff,pointer:#add7ff,label:#89ddff,info:#89ddff"

session=$(
  {
    find "${dirs[@]}" -maxdepth 1 -mindepth 1 -type d 2>/dev/null
    echo "$others"
  } |
    sed "s|$HOME/||g" |
    fzf \
      --reverse \
      --tmux 70% \
      --color="$FZF_COLOR_OPTS" \
      --border=rounded \
      --margin=0% \
      --border-label="$FZF_TITLE" \
      --preview-window bottom \
      --preview 'if [[ -f $HOME/{}/README.md ]]; then\
                  bat \
                    --theme Dracula \
                    --terminal-width=$FZF_PREVIEW_COLUMNS \
                    --color=always \
                    $HOME/{}/README.md 2>/dev/null \
                    || cat $HOME/{}/README.md; 
                  else echo No README.md found in {};
                  fi'
)

[[ -z $session ]] && exit 0

session_path="$HOME/$session"
session_name=$(basename "$session_path" | tr '.' '_')

if ! tmux has-session -t "$session_name" 2>/dev/null; then
  # Create new session with a shell, so it doesn't close when nvim exits
  tmux new-session -d -s "$session_name" -c "$session_path"

  # Setup windows
  tmux new-window -d -t "$session_name" -n "lazygit" -c "$session_path" "lazygit"

  # Launch nvim in the first window
  tmux send-keys -t "$session_name:1" "nvim" C-m
fi

tmux switch-client -t "$session_name"
