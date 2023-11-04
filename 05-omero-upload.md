Find all the files to be uploaded, write the file paths to a csv (`mosaics.csv`)

```bash
find /n/scratch3/users/y/yc00/232-DDLP_2022-2022NOV/mcmicro -type f -wholename */registration/*.ome.tif | sort >> mosaics.csv
find /n/scratch3/users/y/yc00/232-DDLP_2022-2022NOV/mcmicro -type f -wholename */qc/*.ome.tif | sort >> mosaics.csv
```

Login to omero in an interactive session, change group if necessary

```bash
module load omero
omero login -t 86400
omero sessions group 'Gray Data Portal'
```

For each row, submit one upload job, remember to change `-d DATASETID` in the following command

```bash
cat mosaics.csv | xargs -I {} sbatch -p short -t 0-12 --mem 2G --wrap 'module load omero && omero import --exclude=clientpath --skip=upgrade --skip=checksum --skip=minmax -d 19698 {}'
```

IDP
```bash
cat mosaics.csv | xargs -I {} sbatch -p short -t 0-12 --mem 2G --wrap 'module load omero && omero import --exclude=clientpath --skip=upgrade --skip=checksum --skip=minmax -d 1484 {}'
```

https://gist.github.com/Yu-AnChen/afeba25f8a541f9dde62651370993037#file-upload-mcmicro-ome-tiffs-md
