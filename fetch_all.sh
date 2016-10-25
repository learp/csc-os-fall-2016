#!/bin/bash
#
# fetching all students repo


students=`ls -1 ./.checking`
repo="csc-os-fall-2016"


for student in ${students}; do
  echo "Processing $student"
  cd .checking/$student/$repo
  git fetch
  cd ../../..
done  
