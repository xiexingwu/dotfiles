#!/bin/bash
STAGING=$HOME/.local/share/dotfiles
rm -rf $STAGING
mkdir -p $STAGING
cp -r home/ $STAGING
cd $STAGING
git init
git add .
git commit -m "Initial Staging"

for file in $(ls -A); do
  cp -vr $HOME/$file ./
done

git status --short
