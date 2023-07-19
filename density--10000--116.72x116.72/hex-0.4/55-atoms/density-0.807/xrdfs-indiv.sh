#!/bin/bash

set -ex 
#---------------------------------------- RDF -------------------------------------------

#--------------------------- at 25, 50, 75 and 100 timestep  ------------------------------------

cat >xrdfs-qs.py<<!
from ovito.io import *
from ovito.modifiers import CoordinationAnalysisModifier

number= 55

pipeline = import_file(f'dump-out.lammpstrj')
pipeline.source.data.cell_.is2D = True
modifier = CoordinationAnalysisModifier(cutoff = 12.0, number_of_bins = 200)
pipeline.modifiers.append(modifier) 
at_t25_rdfdata = pipeline.compute(25)
at_t50_rdfdata = pipeline.compute(50)  
at_t75_rdfdata = pipeline.compute(75)
at_t100_rdfdata = pipeline.compute(100)      
export_file(at_t25_rdfdata,f'rdf_at_t25-{number}-atoms.txt','txt/table')
export_file(at_t50_rdfdata,f'rdf_at_t50-{number}-atoms.txt','txt/table')
export_file(at_t75_rdfdata,f'rdf_at_t75-{number}-atoms.txt','txt/table')
export_file(at_t100_rdfdata,f'rdf_at_t100-{number}-atoms.txt','txt/table')
!
python3 xrdfs-qs.py
wait

rm x*.py

#----------------------------- BOND ORDER --------------------------------------------------

#---------------------------extract the half-snap-$.data  ------------------------------------

cat >xqextract.py<<!
from ovito.io import *

number = 55

pipeline = import_file(f'dump-out.lammpstrj')
qdata_at_t25 = pipeline.compute(frame=25)
qdata_at_t50 = pipeline.compute(frame=50)
qdata_at_t75 = pipeline.compute(frame=75)
qdata_at_t100 = pipeline.compute(frame=100)
export_file(qdata_at_t25, f't25-snap-{number}-atoms.data', 'lammps/data')
export_file(qdata_at_t50, f't50-snap-{number}-atoms.data', 'lammps/data')
export_file(qdata_at_t75, f't75-snap-{number}-atoms.data', 'lammps/data')
export_file(qdata_at_t100, f't100-snap-{number}-atoms.data', 'lammps/data')
!
python3 xqextract.py
wait

#------------------------- get q6 parameters for half and last snap ------------------------------


coff=2.0
number=55

for time
in 25 50 75 100; do 

cat >xat_t$time-analysis-q6.lmp<<!
units          	lj 
dimension       2
boundary        p p p

read_data	t$time-snap-$number-atoms.data
 
mass            1 1

#variable 	coff equal 2.0 #change the cutoff

pair_style      lj/cut $coff 
pair_coeff      1 1 1.0 1.00 $coff

compute	002 all  hexorder/atom  degree 6 nnn 6 cutoff $coff
dump		001 all custom 1 dump-q-at_t$time-$number.lammpstrj id type xs ys zs c_002[*] 
dump_modify	001 sort id
run		0 
!

lmp_mpi -i xat_t$time-analysis-q6.lmp
wait

mv log.lammps log-q-at_t$time-$number.lammps

done

