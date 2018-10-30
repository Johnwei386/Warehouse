#!/bin/sh

if [ ! -d src ];then
    mkdir src
    chmod 766 src
fi

for i in *.tgz
do
    tar -xvzf ${i} -C src/
done

rm -rf MD5 SHA512
rm -rf *.tgz
