#!/usr/bin/env python3

lines = open("results.txt", "r").readlines()
lines = [line.split() for line in lines]
lines = [[float(x) for x in line] for line in lines]
lines.sort()
with open("results.txt.tmp", "w") as w:
    line = [str(x) for x in lines[0]]
    w.write("\t".join(line))
    for line in lines[1:]:
        line = [str(x) for x in line]
        w.write("\n" + "\t".join(line))

