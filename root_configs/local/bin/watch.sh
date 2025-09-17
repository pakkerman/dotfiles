#!/bin/bash

# Path to the script you want to watch
[[ -z "$1" ]] && echo "usage: watch shell-program file [arg] [watchlist]" && exit 1
[[ -z "$2" ]] && echo "Missing script file" && exit 1
program="$1"
script="$2"
arg="$3"
watchlist=("${@:4}")

[[ ${#watchlist[@]} -eq 0 ]] && watchlist=("$script")

# Function to execute the script
execute_script() {
  clear
  echo "file changed, re-running command: $program $script"
  echo "watchlist: ${watchlist[@]}"
  "$program" "$script" "$arg"
}

cleanup() {
  echo -e "\nExiting watcher..."
  exit 0
}

trap cleanup SIGINT

# Execute the script once initially
execute_script

# Watch for changes and execute the script
while true; do
  fswatch -1 "${watchlist[@]}" >/dev/null
  execute_script
done
