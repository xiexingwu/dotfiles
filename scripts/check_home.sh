#!/bin/bash
# Show how $HOME differs from the files tracked under home/, without touching either.
STAGING=$HOME/.local/share/dotfiles
FILES=$(git ls-files home)
rm -rf $STAGING
mkdir -p $STAGING

for f in $FILES; do
  rel=${f#home/}
  mkdir -p "$STAGING/$(dirname "$rel")"
  cp "$f" "$STAGING/$rel"
done
cd $STAGING
git init -q
git add .
git commit -q -m "Initial Staging"

for f in $FILES; do
  rel=${f#home/}
  if [[ -e "$HOME/$rel" ]]; then
    cp "$HOME/$rel" "$rel"
  else
    rm "$rel"
  fi
done

git status --short
