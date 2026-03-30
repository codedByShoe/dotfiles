#!/bin/bash

SESSION=${1:-$(basename "$PWD")}
DIR=${2:-$PWD}

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Session '$SESSION' already exists, attaching..."
    tmux attach -t "$SESSION"
    exit 0
fi

tmux new-session -d -s "$SESSION" -c "$DIR" -n "code"
tmux send-keys -t "$SESSION:code" "hx ." Enter

tmux new-window -t "$SESSION" -n "server" -c "$DIR"

tmux new-window -t "$SESSION" -n "claude" -c "$DIR"
tmux send-keys -t "$SESSION:claude" "claude" Enter

tmux select-window -t "$SESSION:code"
tmux attach -t "$SESSION"
