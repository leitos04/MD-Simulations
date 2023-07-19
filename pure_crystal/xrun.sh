#!/bin/bash

####################### RDF #################################

cat >xrdf.py<<!
from ovito.io import *
from ovito.modifiers import CoordinationAnalysisModifier
 
pipeline = import_file('dump.lammpstrj')
pipeline.source.data.cell_.is2D = True
modifier = CoordinationAnalysisModifier(cutoff = 12.0, number_of_bins = 200)
pipeline.modifiers.append(modifier)
rdfdata = pipeline.compute()
export_file(rdfdata,'rdf-pure_crystal.txt','txt/table')
!

python3 xrdf.py

#################### BOND ORDER ###############################

##extract the last_snap.data 

cat >xextract.py<<!
from ovito.io import *

pipeline = import_file('dump.lammpstrj')
qdata=pipeline.compute(frame=100)
export_file(qdata,'last-snap-pure_crystal.data','lammps/data')
!

python3 xextract.py

## get q6 parameters


coff=2.0;

cat >xanalysis-q6.lmp<<!
units          	lj 
dimension       2
boundary        p p p

read_data	last-snap-pure_crystal.data
 
mass            1 1

#variable 	coff equal 2.0 #change the cutoff

pair_style      lj/cut $coff 
pair_coeff      1 1 1.0 1.00 $coff

compute	002 all  hexorder/atom  degree 6 nnn 6 cutoff $coff
dump		001 all custom 1 dump-q.lammpstrj id type xs ys zs c_002[*] 
dump_modify	001 sort id
run		0 
!

lmp_mpi -i xanalysis-q6.lmp

rm xanalysis-q6.lmp




rm x*.py
