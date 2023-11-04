#!/bin/sh

TARGRET_DIR=/n/scratch3/users/y/yc00/236-CHUV_test1-2022DEC/mcmicro
SLIDEDIRS=($TARGRET_DIR/*)


for dir in ${SLIDEDIRS[@]:0:4}; do
    # if [[ $dir =~ "10708" ]]; then
    # if [ ! -d "$dir/segmentation" ]; then
    # if [ ! -f "$dir/quantification/unmicst-$(basename $dir)_nucleiRing.csv" ]; then
        cd $dir
        echo $(basename $dir) $dir
        sbatch --job-name $(basename $dir) \
            /home/yc00/project/20230119-236-CHUV_test1-2022DEC/submit_id_template.sh $dir 
    # fi
done