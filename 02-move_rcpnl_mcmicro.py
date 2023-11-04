import pathlib

file_type = '.rcpnl'

# Specify mcmicro directory and the slide IDs
mcmicro_dir = pathlib.Path('/n/scratch3/users/y/yc00/236-CHUV_test1-2022DEC/mcmicro')
slide_names = [
    "LSP10830",
    "LSP10845",
    "LSP10854",
    "LSP10857",
]

import json
# For a given slide, check if there's one file per cycle 
for name in slide_names:
    for dir in mcmicro_dir.parent.iterdir():
        if dir.name == 'mcmicro': continue
        if not dir.is_dir(): continue
        files = sorted(dir.rglob('*{}*{}'.format(name, file_type)))
        n_files = len(files)
        if n_files != 1:
            print(f"check <{dir}> - slide '{name}':  {n_files} files")
            for p in files:
                rcjob = p.parent / p.name.replace('rcpnl', 'rcjob')
                if not rcjob.exists(): continue
                print(p)
                print(json.load(open(rcjob))['scanner']['assay']['biomarkers'])
            print()


# Move RCPNLs to raw/ under slide folders
mcmicro_dir.mkdir(exist_ok=True)
actions = [('raw_location', 'mcmicro_location')]
for name in slide_names:
    raw_images = sorted(mcmicro_dir.parent.rglob('*{}*{}'.format(name, file_type)))
    print(f"{name}: {len(raw_images)} files")
    for f in raw_images:
        destination = mcmicro_dir / name / 'raw' / f.name
        destination.parent.mkdir(parents=True, exist_ok=True)
        f.replace(destination)
        actions.append((str(f), str(destination)))
with open(str(mcmicro_dir.parent / 'move_file.log'), 'w') as log:
    log.write(
        '\n'.join([','.join(a) for a in actions])
    )

# Copy markers.csv to each of the slide folder
markers_str = open('/home/yc00/project/20230119-236-CHUV_test1-2022DEC/markers.csv').read()
for name in slide_names:
    marker_csv_path = mcmicro_dir / name / 'markers.csv'
    with open(mcmicro_dir / name / 'markers.csv', 'w') as f:
        f.write(markers_str)

# Move cycle folders into raw_folders/ next to mcmicro/
(mcmicro_dir.parent / 'raw_folders').mkdir(exist_ok=True)
folders_to_move = sorted(filter(lambda x: x.is_dir(), mcmicro_dir.parent.glob('*/')))
for ff in folders_to_move:
    if ff.name not in ['mcmicro', 'raw_folders']:
        ff.replace(ff.parent / 'raw_folders' / ff.name)