#!/usr/bin/env python3

import os

def __run(cmd):
    print(cmd)
    os.system(cmd)

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
    cm = coeffs[1]
    cd = coeffs[2]
    cl = coeffs[3]
    return (cm, cd, cl, coeffs[0])

def __get_int_folders():
    paths = []
    base_dir = "./case/"
    for x in os.listdir(base_dir):
        if x.isdigit() and x != "0":
            paths.append(base_dir + "/" + x)
    return paths

def __clean_case():
    int_folders = __get_int_folders()
    for f in int_folders:
        __run("rm -r " + f)
    __run("rm -rf ./case/postProcessing")
    __run("rm -rf case/constant/polyMesh")
    __run("rm -f main.msh")

def __change_config(field, value):
    parameters_path = "./mesh/parameters.geo"
    tmp_path = "./mesh/parameters.geo.tmp"
    with open(tmp_path, "w") as w:
        with open(parameters_path, "r") as r:
            for line in r:
                line = line.strip()
                if field in line:
                    line = line.split()
                    line[2] = str(value) + ";"
                    line = " ".join(line)
                w.write(line + "\n")
    __run("mv " + tmp_path + " " + parameters_path)

def __run_aoa(aoa):
    __clean_case()
    __change_config("globalAoa", aoa)
    height = 0.1
    if aoa < 0:
        height *= -1
    __change_config("bendHeight", height)
    __run("./run.sh")

output_path = "results.txt"
#for aoa in range(30):
for aoa in range(30, 181, 5):
    __clean_case()
    __run_aoa(aoa)
    coeffs = __get_coeffs("./case/postProcessing/forceCoeffs1/0/forceCoeffs.dat")
    with open(output_path, "a") as f:
        f.write(str(aoa) + "\t" + "\t".join(coeffs) + "\n")

__clean_case()
