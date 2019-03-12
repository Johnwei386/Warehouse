#!/bin/bash

cpath=`pwd`
changeMod(){
    for file in "$1"/*
    do
         if [ -d "$file" ];then
             cd "$file"
             chmod 755 "$file"
             changeMod "$file"
             cd ..
         else
             chmod 644 "$file"
         fi
    done
}

changeMod "$cpath"

