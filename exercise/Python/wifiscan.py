#!/usr/bin/env python
# _*_ coding: UTF8 _*_

import subprocess
import time
import argparse

parser = argparse.ArgumentParser(description='Display WLAN signal strength.')
parser.add_argument(dest='interface', nargs='?', default='wlan2',
                    help='wlan interface (default: wlan0)')
args = parser.parse_args()

print '\n---Press CTRL+Z or CTRL+C to stop.---\n'

while True:
    cmd = subprocess.Popen('iwlist %s scan' % args.interface, shell=True,
                           stdout=subprocess.PIPE)
    for line in cmd.stdout:
        if 'ESSID' in line:
            print line.lstrip(' '),
        if 'Quality' in line:
            print line.lstrip(' '),
        print '\n'
    time.sleep(1)
