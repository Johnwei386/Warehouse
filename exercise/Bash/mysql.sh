#!/usr/bin/env bash

# 按行读取文件，然后处理每一行
list=$(cat mysql.list)
printf "%b\n" "${list}" | \
while read -r line; do
	sudo chown -R john:mysql ${line}
	stat ${line}
	echo "\n"
done
