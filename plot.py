#!/usr/bin/env python3

import sys

import matplotlib.pyplot as plt

results = []
with open("results.txt", "r") as f:
    for line in f:
        line = line.strip()
        if line:
            fields = line.split()
            fields = [float(x) for x in fields]
            results.append(fields)

aoa = [x[0] for x in results]
if 180 not in aoa or -180 not in aoa:
    results.sort()
    print("Did not find AOA at 180.")
    cm = 0.5 * (results[-1][1] + results[0][1])
    cd = 0.5 * (results[-1][2] + results[0][2])
    cl = 0.5 * (results[-1][3] + results[0][3])
    if 180 not in aoa:
        new_result = [180, cm, cd, cl]
        results.append(new_result)
        with open("results.txt", "a") as f:
            f.write("\n" + "\t".join([str(x) for x in new_result]))
    if -180 not in aoa:
        new_result = [-180, cm, cd, cl]
        results.append(new_result)
        with open("results.txt", "a") as f:
            f.write("\n" + "\t".join([str(x) for x in new_result]))

aoa = [x[0] for x in results]
cl = [x[3] for x in results]
plt.plot(aoa, cl, "x")
cd = [x[2] for x in results]
plt.plot(aoa, cd, "x")
cm = [x[1] for x in results]
plt.plot(aoa, cm, "x")
plt.show()
