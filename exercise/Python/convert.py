#!/usr/bin/env python
# _*_ coding:utf8 _*_

import os
import argparse

def transpose(args):
    # 转换分词数据集为.coll格式的数据
    source = args.sdata # 源数据集名称
    target = args.tdata # 要装换的目标数据集名称
    delimiter = args.delimiter # 分词之间的分隔符
    DIR = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(DIR, source)
    target_path = os.path.join(DIR, target)
    sentences = []
    with open(data_path, 'r') as f:
        sentence = []
        for line in f:
            words = line.strip().split(delimiter)
            #print(words)
            for char in words:
                if len(char) == 0:
                    continue
                elif len(char) == 1:
                    tup = (char, 'S')
                    sentence.append(tup)
                elif len(char) == 2:
                    tup_h = (char[0], 'B')
                    tup_t = (char[1], 'E')
                    sentence.append(tup_h)
                    sentence.append(tup_t)
                else:
                    tup_h = (char[0], 'B')
                    sentence.append(tup_h)
                    for i in range(1, len(char) - 1):
                        tup = (char[i], 'M')
                        sentence.append(tup)
                    tup_t = (char[-1], 'E')
                    sentence.append(tup_t)
                #print(char)
                #print(sentence)
                #assert False
            sentences.append(sentence)
            sentence = []

    # print(sentences[-1])

    with open(target_path, 'w') as f:
        for s in sentences:
            #print(s)
            for w in s:
                line = w[0] + ' ' + w[1] + '\n'
                f.write(line)
                #print(line)
            f.write('\n')
            #assert False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Turn datasets to .coll format')
    
    parser.add_argument('-s', '--sdata',
                        type=str,
                        default=None,
                        help='location of source data corpus name')

    parser.add_argument('-t', '--tdata',
                        type=str,
                        default=None,
                        help='being converted corpus name')


    parser.add_argument('-d', '--delimiter',
                        type=str,
                        default='　',
                        help='set dataset delimiter default: one space')

    args = parser.parse_args()
    if args.sdata is None or args.tdata is None:
        parser.print_help()
        sys.exit(1)
    else:
        transpose(args)
