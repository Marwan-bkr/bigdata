#!/usr/bin/env python3
import sys

for line in sys.stdin:
    line = line.strip()
    if line:
        # Input:  word\tcount
        # Output: freq\tword\tcount (constant key forces single reducer)
        print("freq\t{}".format(line))
