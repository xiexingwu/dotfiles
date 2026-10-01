#!/bin/bash
# Copy the files tracked under home/ into $HOME (never deletes anything in $HOME).
git ls-files home | while read -r f; do
  rel=${f#home/}
  mkdir -p "$HOME/$(dirname "$rel")"
  cp -vaf "$f" "$HOME/$rel"
done
