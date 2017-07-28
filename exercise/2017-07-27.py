#!/usr/bin/env python
# _*_ coding: UTF8 _*_

import re

a = re.search(r'(tina)(fei)haha\2','tinafeihahafei tinafeihahatina')
print a.group()
print a.groups()
