#!/bin/bash

while read line
do
  echo "git checkout branch-B-tmp $line"
  git checkout 05-trunk-tmp $line
done < mergeFile.list
