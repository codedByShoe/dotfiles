#!/bin/bash

# Find sqlite files in current directory, pick with fzf, open with litecli
DB=$(find "${1:-.}" \( -name "*.sqlite3" -o -name "*.sqlite" -o -name "*.db" \) \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    2>/dev/null | fzf --prompt="Select database: ")

[ -z "$DB" ] && exit 0

litecli "$DB"
