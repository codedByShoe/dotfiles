#!/bin/bash
# Toggle claude pane: break it to a hidden window or join it back as a split

if tmux list-windows -F "#{window_name}" | grep -q "^claude$"; then
  RETURN=$(tmux show-environment CLAUDE_RETURN_WINDOW 2>/dev/null | cut -d= -f2)
  if [ -n "$RETURN" ]; then
    tmux join-pane -s claude -t "$RETURN" -h -l 40%
  else
    tmux join-pane -s claude -h -l 40%
  fi
else
  # Always break the non-helix pane, regardless of which pane is focused
  NVIM_PANE=$(tmux list-panes -F "#{pane_id} #{pane_current_command}" | grep -iE "nvim|neovim" | awk '{print $1}' | head -1)
  if [ -n "$NVIM_PANE" ]; then
    TARGET=$(tmux list-panes -F "#{pane_id}" | grep -v "^$NVIM_PANE$" | head -1)
  else
    CURRENT=$(tmux display-message -p "#{pane_id}")
    TARGET=$(tmux list-panes -F "#{pane_id}" | grep -v "^$CURRENT$" | head -1)
  fi
  if [ -n "$TARGET" ]; then
    tmux set-environment CLAUDE_RETURN_WINDOW "$(tmux display-message -p '#{window_id}')"
    tmux break-pane -s "$TARGET" -d -n claude
  else
    exit 1
  fi
fi
