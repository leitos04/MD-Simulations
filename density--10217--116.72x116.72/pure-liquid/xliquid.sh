#!/bin/bash
#SBATCH -N 1 
#SBATCH --ntasks-per-node=32
#SBATCH --ntasks-per-core=1
#SBATCH --time=01:00:00

srun lmp_mpi < xinput.lmp

mv log.lammps log-md-liquid.lammps
