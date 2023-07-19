from ovito.io import *

#numbers=['37','55','109']
numbers=['37']
for number in numbers: 
	pipeline = import_file(f'{number}-atoms/dump-out-{number}.lammpstrj')
	qdata_at_t25 = pipeline.compute(frame=25)
	qdata_at_t50 = pipeline.compute(frame=50)
	qdata_at_t75 = pipeline.compute(frame=75)
	qdata_at_t100 = pipeline.compute(frame=100)
	export_file(qdata_at_t25, f'{number}-atoms/t25-snap-{number}-atoms.data', 'lammps/data')
	export_file(qdata_at_t50, f'{number}-atoms/t50-snap-{number}-atoms.data', 'lammps/data')
	export_file(qdata_at_t75, f'{number}-atoms/t75-snap-{number}-atoms.data', 'lammps/data')
	export_file(qdata_at_t100, f'{number}-atoms/t100-snap-{number}-atoms.data', 'lammps/data')
