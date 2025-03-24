#!/bin/bash

# Path to the script you want to watch
[[ -z "$1" ]] && echo "usage: watch shell-program file [arg] " && exit 1
[[ -z "$2" ]] && echo "Missing script file" && exit 1
program="$1"
script="$2"
arg="$3"
script_root=$(dirname "$script")

# Function to execute the script
execute_script() {
  clear
  echo "Changes detected. Executing $script..."
  "$program" "$script" "$arg"
}

# Execute the script once initially
execute_script

# Watch for changes and execute the script
while true; do
  fswatch -1 "$script_root" >/dev/null
  execute_script
done
