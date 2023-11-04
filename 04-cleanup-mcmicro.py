import pathlib

curr = pathlib.Path('/n/scratch3/users/y/yc00/236-CHUV_test1-2022DEC/mcmicro')

for p in sorted(curr.glob('*')):
    if p.is_dir():
        (p / 'job-log').mkdir(exist_ok=True)
        log_files = list(p.glob('*.log*')) + list(p.glob('*.out*')) + list(p.glob('*.html*'))
        for f in log_files:
            # print(f.name)
            f.replace(f.parent / 'job-log' / f.name)
