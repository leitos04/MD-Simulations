#!/bin/bash
#SBATCH -N 1 
#SBATCH --ntasks-per-node=32
#SBATCH --ntasks-per-core=1
#SBATCH --time=24:00:0
  
for density # to vary the densities
#in 10000; do
#in 9359; do
in 10217 10490 10762; do

mkdir density--$density--116.72x116.72
cd density--$density--116.72x116.72/

cat>input-density<<!
variable        nn equal $density   #check correct density
!

cat input-density ../xgeneral1.lmp > xinput-md-$density.lmp

for scale # to vary the hex scale factor
#in 0.3 0.4 0.5 0.6 0.7 0.8; do
in 0.3 0.4; do

mkdir hex-$scale
cd hex-$scale

cat>input-scale<<!
variable        scale equal $scale #check correct hex scaling factor
!

cat ../xinput-md-$density.lmp input-scale > xinput-md-$scale.lmp

for atoms  #to vary number of atoms
#in 37 55 109; do
in 37; do

mkdir $atoms-atoms
cd $atoms-atoms

if [ $atoms -eq 19 ]
then 
	r=2.5
elif [ $atoms -eq 37 ]
then
	r=3.25
elif [ $atoms -eq 55 ]
then
	r=3.75
elif [ $atoms -eq 109 ]
then
    r=5.5
elif [ $atoms -eq 163 ]
then
	r=6.75
fi

cat>input-r<<!
variable        r equal $r #check correct radius; $r for $atoms atoms 
!
cat ../xinput-md-$scale.lmp input-r ../../../xgeneral2.lmp > xinput-md-$atoms.lmp

srun lmp_mpi < xinput-md-$atoms.lmp  #-------- running simulation!!

mv log.lammps log-$atoms.lammps
mv dump.lammpstrj dump-$atoms.lammpstrj
mv dump-out.lammpstrj dump-out-$atoms.lammpstrj

cd ../

done

cd ../

done

cd ../ 

done
