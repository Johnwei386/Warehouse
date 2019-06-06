#!/usr/bin/env python
# _*_ coding:utf8 _*_
# python2.7

import os
import argparse

# 常用中文标点符号unicode编码
puncs = set([u'\u3002', u'\uFF1F', u'\uFF01', u'\uFF0C', u'\u3001',
             u'\uFF1B', u'\uFF1A', u'\u300C', u'\u300D', u'\u300E',
             u'\u300F', u'\u2018', u'\u2019', u'\u201C', u'\u201D',
             u'\uFF08', u'\uFF09', u'\u3014', u'\u3015', u'\u3010',
             u'\u3011', u'\u2014', u'\u2026', u'\u2013', u'\uFF0E'
             u'\u300A', u'\u300B', u'\u3008', u'\u3009', u'"'])

def is_chinese(uchar):
    """判断一个unicode是否是汉字"""
    if uchar >= u'\u4e00' and uchar<=u'\u9fa5':
        return True
    elif uchar in puncs: # 中文标点符号也算中文字符
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
        buff = []
        for line in f:
            words = line.decode('utf8')
            #print(words)
            #assert False
            
            for char in words:
                if is_chinese(char): # 当前字符为中文字符
                    if buff: # buff不为空
                        sentence.append(''.join(buff))
                        buff = []
                    sentence.append(char)
                else:
                    # 非中文字符作为一个整体
                    buff.append(char)
                
            #print(sentence)
            #assert False
            sentences.append(sentence)
            sentence = []

    #print(''.join(sentences[0]))
    #print(sentences[0])
    #assert False
    
    with open(target_path, 'w') as f:
        for sen in sentences:
            #print(sen)
            line = ''
            for char in sen:
                line = line + ' ' + char.encode('utf8')
            line.strip()
            f.write(line)
            #print(line)

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

