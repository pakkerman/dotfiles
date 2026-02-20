#!/usr/bin/env bash
# ~/.local/bin/tmux-ai-agent-pane.sh
# Manages AI tools in a dedicated side pane using window-swapping

TOOLS="opencode codex gemini coderabbit claude"
SIDE_PANE_MARKER="@ai_side"
TOOL_MARKER="@ai_tool"
BG_WINDOW_PREFIX="agent-"

# Require an active tmux session/server.
if [[ -z "${TMUX:-}" ]] || ! tmux display-message -p '#{session_id}' >/dev/null 2>&1; then
  echo "tmux-ai-agent-pane: not in an active tmux session" >&2
  exit 1
fi

# Get current window
current_window=$(tmux display-message -p '#{window_id}')

# Find existing AI side pane in current window
find_side_pane() {
  tmux list-panes -t "$current_window" -F "#{pane_id} #{@ai_side}" |
    awk '$2 == "1" {print $1; exit}'
}

# Get current tool name from side pane title
get_current_tool() {
  local pane="$1"
  local tool_name
  tool_name=$(tmux show-options -p -v -t "$pane" "$TOOL_MARKER" 2>/dev/null)
  if [[ -n "$tool_name" ]]; then
    echo "$tool_name"
  else
    tmux display-message -p -t "$pane" '#T' 2>/dev/null
  fi
}

# Build per-tool background window name
tool_bg_window_name() {
  local tool="$1"
  echo "${BG_WINDOW_PREFIX}${tool}"
}

# Check if a tool background window exists
tool_bg_window_exists() {
  local tool="$1"
  local window_name
  window_name=$(tool_bg_window_name "$tool")
  tmux list-windows -F '#{window_name}' | grep -qx "$window_name"
}

# Return first pane id from a tool background window
tool_bg_pane_id() {
  local tool="$1"
  local window_name
  window_name=$(tool_bg_window_name "$tool")
  if tool_bg_window_exists "$tool"; then
    tmux list-panes -t "$window_name" -F '#{pane_id}' 2>/dev/null | head -n 1
  fi
}

# Generate fzf input with status markers
generate_fzf_input() {
  local side_pane="$1"
  local current_tool="$2"

  for tool in $TOOLS; do
    local status=""
    if [[ "$tool" = "$current_tool" && -n "$side_pane" ]]; then
      status=" [ACTIVE]"
    elif tool_bg_window_exists "$tool"; then
      status=" [BG]"
    fi
    echo "$tool$status"
  done
}

# Move current side pane to its own background window
move_to_bg() {
  local pane="$1"
  local tool_name="$2"
  local target_window

  if [[ -z "$tool_name" ]]; then
    tool_name=$(get_current_tool "$pane")
  fi
  [[ -z "$tool_name" ]] && tool_name="unknown"
  target_window=$(tool_bg_window_name "$tool_name")

  # Unmark as side pane
  tmux set-option -p -t "$pane" "$SIDE_PANE_MARKER" 0
  tmux set-option -p -t "$pane" "$TOOL_MARKER" "$tool_name"

  # Keep one background window per tool.
  if tool_bg_window_exists "$tool_name"; then
    tmux kill-window -t "$target_window" 2>/dev/null
  fi

  # Break pane into a detached tool-specific background window.
  tmux break-pane -d -s "$pane" -n "$target_window"
  local moved_pane
  moved_pane=$(tool_bg_pane_id "$tool_name")
  [[ -n "$moved_pane" ]] && tmux set-option -p -t "$moved_pane" "$TOOL_MARKER" "$tool_name"
  [[ -n "$moved_pane" ]] && tmux select-pane -t "$moved_pane" -T "$tool_name"
}

# Bring tool from its background window to current window as side pane
bring_from_bg() {
  local tool="$1"

  # Find tool pane in tool-specific background window
  local bg_pane=$(tool_bg_pane_id "$tool")

  if [[ -n "$bg_pane" ]]; then
    # Create a temporary side slot, then replace it with the BG pane.
    local temp_pane
    temp_pane=$(tmux split-window -t "$current_window" -h -b -l "30%" -d -P -F '#{pane_id}' \
      "echo 'Moving $tool...'; sleep 0.1")

    # Kill the temp pane
    tmux kill-pane -t "$temp_pane"

    # Capture pane ids before/after to identify the moved pane deterministically.
    local before_panes=$(tmux list-panes -t "$current_window" -F '#{pane_id}')

    # Move the BG pane to the side position
    tmux move-pane -d -s "$bg_pane" -t "$current_window" -h -b -l "30%"

    # Get the moved pane ID and mark it
    local after_panes=$(tmux list-panes -t "$current_window" -F '#{pane_id}')
    local new_side_pane=""
    for pane in $after_panes; do
      if ! echo "$before_panes" | grep -qx "$pane"; then
        new_side_pane="$pane"
        break
      fi
    done

    [[ -z "$new_side_pane" ]] && new_side_pane=$(find_side_pane)

    if [[ -n "$new_side_pane" ]]; then
      tmux set-option -p -t "$new_side_pane" "$SIDE_PANE_MARKER" 1
      tmux set-option -p -t "$new_side_pane" "$TOOL_MARKER" "$tool"
      tmux select-pane -t "$new_side_pane" -T "$tool"
    fi
  fi
}

# Create new side pane with tool
create_new_side_pane() {
  local tool="$1"

  # Get panes before split
  local before_panes=$(tmux list-panes -t "$current_window" -F '#{pane_id}')

  # Create side pane
  tmux split-window -t "$current_window" -h -b -l "30%" -d "zsh -ic 'echo \"Starting $tool...\"; $tool; code=\\$?; echo; echo \"[$tool exited with status \\$code]\"; exec zsh -i'"

  # Find the new pane
  local after_panes=$(tmux list-panes -t "$current_window" -F '#{pane_id}')
  local new_pane=""
  for pane in $after_panes; do
    if ! echo "$before_panes" | grep -qx "$pane"; then
      new_pane="$pane"
      break
    fi
  done

  if [[ -n "$new_pane" ]]; then
    tmux set-option -p -t "$new_pane" "$SIDE_PANE_MARKER" 1
    tmux set-option -p -t "$new_pane" "$TOOL_MARKER" "$tool"
    tmux select-pane -t "$new_pane" -T "$tool"
  fi
}

# Main logic
side_pane=$(find_side_pane)
current_tool=""

if [[ -n "$side_pane" ]]; then
  current_tool=$(get_current_tool "$side_pane")
fi

# Show fzf selector with status
selected=$(generate_fzf_input "$side_pane" "$current_tool" |
  fzf \
    --reverse \
    --tmux 30% \
    --border=rounded \
    --margin=0% \
    --border-label="| Agents |" \
    "${FZF_COLOR_OPTS}")

[[ -z "$selected" ]] && exit 0

# Extract tool name (remove status markers)
selected_tool=$(echo "$selected" | sed 's/ \[ACTIVE\]$//; s/ \[BG\]$//')

# Do nothing if same tool already active
if [[ "$selected_tool" = "$current_tool" ]] && [[ -n "$side_pane" ]]; then
  # Just ensure pane is selected
  tmux select-pane -t "$side_pane"
  exit 0
fi

# Move current side pane to BG if it exists.
# Move regardless of title so we never leave stale side panes behind.
if [[ -n "$side_pane" ]]; then
  move_to_bg "$side_pane" "$current_tool"
fi

# Check if selected tool is in BG
bg_pane=$(tool_bg_pane_id "$selected_tool")

if [[ -n "$bg_pane" ]]; then
  # Bring it from BG
  bring_from_bg "$selected_tool"
else
  # Create new side pane with selected tool
  create_new_side_pane "$selected_tool"
fi

# Select the side pane
new_side_pane=$(find_side_pane)
[[ -n "$new_side_pane" ]] && tmux select-pane -t "$new_side_pane"
