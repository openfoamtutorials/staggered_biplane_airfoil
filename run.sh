#!/bin/sh

# Quit script if any step has error:
set -e

# Make the mesh:
gmsh -format msh2 -3 -o main.msh mesh/main.geo
# Convert the mesh to OpenFOAM format:
gmshToFoam main.msh -case case
# Adjust polyMesh/boundary:
changeDictionary -case case
# Finally, run the simulation:
simpleFoam -case case

# Parallel
#decomposePar -case case
#mpirun -np 2 simpleFoam -case case -parallel

