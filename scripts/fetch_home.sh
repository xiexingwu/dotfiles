#!/bin/bash
if [[ -n $(git status --short -uno) ]]; then
  echo "================================================================================="
  echo "  Repo diff is not clean."
  echo "  Commit or stash changes before trying to pull in changes"
  echo "================================================================================="
  exit 1
fi

for file in $(ls -A ./home); do
  echo cp -vr $HOME/$file ./home
done
