#!/usr/bin/env python3
import sys

max_word = None
max_count = 0

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    # Input: freq\tword\tcount
    parts = line.split('\t')
    if len(parts) == 3:
        word = parts[1]
        try:
            count = int(parts[2])
            if count > max_count:
                max_count = count
                max_word = word
        except ValueError:
            continue

if max_word:
    print("{}\t{}".format(max_word, max_count))
