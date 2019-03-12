#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re

a = re.search(r'(tina)(fei)haha\2','tinafeihahafei tinafeihahatina')
print a.group()
print a.groups()
