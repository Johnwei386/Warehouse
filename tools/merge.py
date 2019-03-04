#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import logging

logger = logging.getLogger('merge')
logger.setLevel(logging.DEBUG)
logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)

file_name = ['as', 'cityu', 'msr', 'pku', 'nlpcc']
data_name = "data.txt"
current_path = os.path.abspath('.')
raw_data = []
sen_count = 0

for item in file_name:
    file_path = os.path.join(current_path, item)   
    with open(file_path, 'r') as f:
        sentence = []
        for line in f:
            line = line.strip().split()
            if len(line) == 0:
                raw_data.append(sentence)
                sen_count += 1
                sentence = []
                if sen_count % 100000 == 0:
                    logger.info("Read %d sentences", sen_count)                    
            else:
                sentence.append(line[0])              
data_path = os.path.join(current_path, data_name)
sen_count = 0
with open(data_path, 'w') as f:
    for sen in raw_data:
        sen_count += 1
        if sen_count % 100000 == 0:
            logger.info("Write %d sentences", sen_count)
        line = ''
        for char in sen:
            line += char + ' '
        line += '\n'
        f.write(line)
