#!/usr/bin/env bash

for line in `cat depend`
do
	echo "安装${line}...... "
	apt-get install ${line}
	echo "   "
	echo "   "
	echo "   "
	echo "   "
	echo "   "
	echo "   "
done
