#!/bin/sh
#SBATCH -p medium
#SBATCH -J mc-236-CHUV
#SBATCH -t 0-36:00
#SBATCH --mem 4G
#SBATCH --mail-type ALL
#SBATCH --mail-user yc00@hms.harvard.edu

SAMPLEDIR=$1
SAMPLEID=$(basename $SAMPLEDIR)

module purge
module load java
module load git

cd $SAMPLEDIR

/home/$USER/bin/nextflow run labsyspharm/mcmicro \
    -r master \
    -resume \
    -profile        O2,GPU \
    -w              /n/scratch3/users/y/yc00/nf-work \
    --in            $SAMPLEDIR \
    --params        /home/yc00/project/20230119-236-CHUV_test1-2022DEC/params.yml \
    -c              /home/yc00/project/20230119-236-CHUV_test1-2022DEC/5g.config \
    -with-report    $SAMPLEID.html \
    -with-timeline  ${SAMPLEID}_timeline.html