#!/usr/bin/env bash

if (($# == 0)); then
  echo "Usage: watch <cmd>" >&2
  exit 1
fi

watchlist=(*.*)
echo "watching ${watchlist[*]}"

# [[ ${#watchlist[@]} -eq 0 ]] && watchlist=("$script")

# Function to execute the script
execute_script() {
  clear
  echo "file changed, re-running command: $*"
  "$@"
}

cleanup() {
  echo -e "\nExiting watcher..."
  exit 0
}

trap cleanup SIGINT

# Execute the script once initially
execute_script "$@"

# Watch for changes and execute the script
while true; do
  fswatch -1 "${watchlist[@]}" >/dev/null
  execute_script "$@"
done
