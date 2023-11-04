#!/bin/sh
#SBATCH -p short
#SBATCH -J mc-236-CHUV
#SBATCH -t 0-12:00
#SBATCH --mem=1G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yc00@hms.harvard.edu


# \\files.med.harvard.edu\ImStor\sorger\data\RareCyte\JL503_JERRY\236-CHUV_test1-2022DEC\ 
# cat mosaics.csv | xargs -I {} sbatch /home/yc00/project/20230119-236-CHUV_test1-2022DEC/06-transfer-registration.sh {}

DEST='/n/files/ImStor/sorger/data/RareCyte/JL503_JERRY/236-CHUV_test1-2022DEC/mcmicro'
SAMPLEDIR=$1
SAMPLEID=$(basename $SAMPLEDIR)

ssh transfer "mkdir -p '$DEST'"
rsync -ahv \
        "'$SAMPLEDIR/'" \
        "'transfer:$DEST/$SAMPLEID/'" \
        --exclude "raw/" --exclude ".nextflow/" --include "*/" --include "*" --exclude "*"
