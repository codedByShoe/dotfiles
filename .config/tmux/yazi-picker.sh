#!/bin/bash
# Opens yazi as a file picker. If a file is selected, sends :open <file> to
# the originating tmux pane (assumed to be running Helix).
PANE_ID="$1"
TMPFILE=$(mktemp /tmp/yazi-chosen.XXXXXX)

yazi --chooser-file="$TMPFILE"

if [ -s "$TMPFILE" ]; then
  FILE=$(cat "$TMPFILE")
  tmux send-keys -t "$PANE_ID" Escape
  tmux send-keys -t "$PANE_ID" ":open $FILE" Enter
fi

rm -f "$TMPFILE"
