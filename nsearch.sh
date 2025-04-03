#!/bin/bash

# Simple echo-based Neovim command search tool

SEARCH="$1"

if [ -z "$SEARCH" ]; then
  echo "Usage: $0 <search_term>"
  exit 1
fi

FILE="/home/bin/nsearch.txt"

if [ ! -f "$FILE" ]; then
  echo "Error: $FILE not found!"
  exit 1
fi

# Search and display neatly aligned matches
grep -i "$SEARCH" "$FILE" | column -t -s '|' --output-separator=' | '
