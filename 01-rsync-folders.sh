#!/bin/sh
#SBATCH -p short
#SBATCH -J to-imstor
#SBATCH -t 0-12:00
#SBATCH --mem 4G
#SBATCH --mail-type ALL
#SBATCH --mail-user yc00@hms.harvard.edu

# \\files.med.harvard.edu\ImStor\sorger\data\RareCyte\JL503_JERRY\236-CHUV_test1-2022DEC


# ImStor to O2
rsync -ahv transfer:/n/files/ImStor/sorger/data/RareCyte/JL503_JERRY/236-CHUV_test1-2022DEC/ /n/scratch3/users/y/yc00/236-CHUV_test1-2022DEC/ --include "*/" --include "*.rcpnl" --include "*.rcjob" --exclude "*"
