#!/usr/bin/env python
# _*_ coding:utf8 _*_

import os
import argparse

def is_chinese(uchar):
    """判断一个unicode是否是汉字"""
    if uchar >= u'\u4e00' and uchar<=u'\u9fa5':
        return True
    else:
        return False

def is_number(uchar):
    """判断一个unicode是否是数字"""
    if uchar >= u'\u0030' and uchar<=u'\u0039':
        return True
    else:
        return False

def is_alphabet(uchar):
    """判断一个unicode是否是英文字母"""
    if (uchar >= u'\u0041' and uchar <= u'\u005a') or (uchar >= u'\u0061' and uchar <= u'\u007a'):
        return True
    else:
        return False

def test_chartype_judge(rstr):
    print(rstr)
    ustr = rstr.decode('utf8')
    line = list(ustr)
    chinese = []
    english = []
    number = []
    special = []
    for word in line:
        if is_chinese(word):
            chinese.append(word)
        elif is_alphabet(word):
            english.append(word)
        elif is_number(word):
            number.append(word)
        else:
            special.append(word)
    print(line)
    print(' ')
    print('chines:', chinese)
    print('english:', english)
    print('number:', number)
    print('special:', special)

def discriminator(chars):
    ret = []
    non_chinese = []
    for char in chars:
        if not is_chinese(char):
            non_chinese.append(char)
        else:
            if non_chinese:
                ret.append(non_chinese)
                non_chinese = []
            ret.append(char)
    if non_chinese:
        ret.append(non_chinese)
    return ret

def combine(part):
    if isinstance(part, list):
        ret = ''.join(part)
    else:
        ret = part
    return ret

def all_char_not_ch(chars):
    ret = True
    for char in chars:
        if is_chinese(char):
            ret = False
            break
    return ret

def transpose(args):
    # 转换分词数据集为.conll格式的数据
    source = args.sdata # 源数据集名称
    target = args.tdata # 要转换的目标数据集名称
    assert source is not None
    assert target is not None
    delimiter = args.delimiter # 分词之间的分隔符
    DIR = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(DIR, source)
    target_path = os.path.join(DIR, target)
    assert os.path.exists(data_path),"data path is not existed!"
    sentences = []
    with open(data_path, 'r') as f:
        sentence = []
        for line in f:
            line = line.decode('utf8')
            if delimiter is not None:
                words = line.strip().split(delimiter)
            else:
                words = line.strip().split()
            for chars in words:
                if len(chars) == 0:
                    continue
                elif len(chars) == 1 or all_char_not_ch(chars):
                    tup = (chars, 'S')
                    sentence.append(tup)
                elif len(chars) == 2:
                    tup_h = (chars[0], 'B')
                    tup_t = (chars[1], 'E')
                    sentence.append(tup_h)
                    sentence.append(tup_t)
                else:
                    parts = discriminator(chars)
                    head = combine(parts[0])
                    tup_h = (head, 'B')
                    sentence.append(tup_h)
                    for i in range(1, len(parts) - 1):
                        medium = combine(parts[i])
                        tup = (medium, 'M')
                        sentence.append(tup)
                    end = combine(parts[-1])
                    tup_t = (end, 'E')
                    sentence.append(tup_t)
            '''for com in sentence:
                print com[0], com[1]
            assert False'''
            sentences.append(sentence)
            sentence = []

    # print(sentences[-1])
    
    with open(target_path, 'w') as f:
        for s in sentences:
            #print(s)
            for w in s:
                line = w[0] + ' ' + w[1] + '\n'
                f.write(line.encode('utf8'))
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
                        default=None,
                        help='set dataset delimiter default: one space')

    args = parser.parse_args()
    
    transpose(args)
    #str1 = "绿箭侠123You have(*´ω`*) o(=•ω•=)m你好、？‘’；"
    #test_chartype_judge(str1)

