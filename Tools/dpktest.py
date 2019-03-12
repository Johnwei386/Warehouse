#!/usr/bin/env python
# -*- coding:utf8 -*-

import dpkt
import os
import time
import socket

def inet_to_str(inet):
    try:
        return socket.inet_ntop(socket.AF_INET,inet)
    except:
        return False

def getip():
    #print(time.tzname) #打印本机时区
    filepath = '/tmp/test.pcap'
    with open(filepath, 'rb') as f:
        packages = dpkt.pcap.Reader(f)
        for ts,buf in packages:
            #print(time.localtime(ts), len(buf))
            eth = dpkt.ethernet.Ethernet(buf)
            
            if eth.type != dpkt.ethernet.ETH_TYPE_IP:
                continue
            ip = eth.data
            print(dpkt.ip.IP.get_proto(ip))
            tcp = ip.data
            print(tcp.dport)
            continue
            ip_src = inet_to_str(ip.src)
            ip_dst = inet_to_str(ip.dst)
            print(ip_src+'==>'+ip_dst)

getip()
