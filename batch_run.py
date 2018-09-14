#!/usr/bin/env python3

import os

def __get_last_line(file_path):
    with open(file_path, "r") as f:
        last = None
        for line in f:
            line = line.strip()
            if line:
                last = line
    return last

def __get_coeffs(file_path):
    coeffs = __get_last_line(file_path)
    coeffs = coeffs.strip().split()
    coeffs = [float(x) for x in coeffs]
    cm = coeffs[1]
    cd = coeffs[2]
    cl = coeffs[3]
    return (cm, cd, cl)

def __get_int_folders():
    paths = []
    base_dir = "./case/"
    for x in os.listdir(base_dir):
        if x.isdigit() and x != "0":
            paths.append(base_dir + "/" + x)
    return paths


int_folders = __get_int_folders()
print(int_folders)

# positive
coeffs = __get_coeffs("./case/postProcessing/forceCoeffs1/0/forceCoeffs.dat")
print(coeffs)

