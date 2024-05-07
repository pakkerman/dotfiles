#!/bin/bash

# Path to the script you want to watch
[[ -z "$1" ]] && echo "usage: watch file" && exit 1
script="$1"
arg="$2"

# Function to execute the script
execute_script() {
	clear
	echo "Changes detected. Executing $script..."
	bash "$script $arg"
}

# Execute the script once initially
execute_script

# Watch for changes and execute the script
while true; do
	fswatch -1 "$script" >/dev/null
	execute_script "$arg"
done
