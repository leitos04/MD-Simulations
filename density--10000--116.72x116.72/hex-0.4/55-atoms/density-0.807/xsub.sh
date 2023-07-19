#!/bin/bash
#SBATCH -N 1 
#SBATCH --ntasks-per-node=32
#SBATCH --ntasks-per-core=1
#SBATCH --time=04:00:00

srun lmp_mpi < xinput-md-55.lmp
