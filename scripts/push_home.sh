#!/bin/bash
cd home
for file in $(ls -A); do
 cp -vaf $file $HOME/$file
done
