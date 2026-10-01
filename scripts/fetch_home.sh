#!/bin/bash
# Copy $HOME versions of the files tracked under home/ into the repo.
# Only tracked files are synced, so partial dirs (e.g. ~/.claude) work.
# To add a new file: copy it into home/ once and `git add` it.
if [[ -n $(git status --short -uno) ]]; then
  echo "================================================================================="
  echo "  Repo diff is not clean."
  echo "  Commit or stash changes before trying to pull in changes"
  echo "================================================================================="
  exit 1
fi

git ls-files home | while read -r f; do
  rel=${f#home/}
  if [[ -e "$HOME/$rel" ]]; then
    cp -v "$HOME/$rel" "$f"
  else
    echo "missing in \$HOME: $rel"
  fi
done
