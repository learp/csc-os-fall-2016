#!/bin/bash
#
# go to solution dir, checkout branch, and build


echo "Checking task $1 student $2"
s_path="./.checking/$2/csc-os-fall-2016"

echo "trying to cd into $s_path"
cd $s_path
pwd

echo "Select branch "$3

git checkout $3
cd  $2/$1
git reset --hard

make
