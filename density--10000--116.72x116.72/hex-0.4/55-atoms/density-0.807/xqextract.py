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
