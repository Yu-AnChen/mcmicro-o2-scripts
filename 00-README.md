# Run mcmicro on HMS O2 HPC

For the context, here's the file structure I started with (on ImStor/HiTS
server) - it's organized by cycle (imaging date), and each cycle directory
contains multiple scanning folders. In each scanning folder, I'm taking the
.rcpnl and .rcjob file to O2 scratch drive.

```bash
# NOTE: the tree output is manually editted
[yc00@transfer03 ~]$ tree -L 3 /n/files/ImStor/sorger/data/RareCyte/JL503_JERRY/236-CHUV_test1-2022DEC/
/n/files/ImStor/sorger/data/RareCyte/JL503_JERRY/236-CHUV_test1-2022DEC/
├── CHUV_test1-20221215-background
│   ├── LSP10830@20221215_162456_919264
│   │   ├── LSP10830@20221215_162456_919264.extraFeat
│   │   ├── LSP10830@20221215_162456_919264.metadata
│   │   ├── LSP10830@20221215_162456_919264_R40.stc
│   │   ├── LSP10830@20221215_162456_919264_R40.stc.tmp.metadata
│   │   ├── LSP10830@20221215_162456_919264.rcanalysis
│   │   ├── LSP10830@20221215_162456_919264.rcglyph.err
│   │   ├── LSP10830@20221215_162456_919264.rcjob
│   │   ├── LSP10830@20221215_162456_919264.rcpnl
│   │   ├── LSP10830@20221215_162456_919264.shift
│   │   └── LSP10830@20221215_162456_919264.zip
│   ├── LSP10845@20221215_142258_245849
│   │   ├── LSP10845@20221215_142258_245849.extraFeat
│   │   ├── LSP10845@20221215_142258_245849.metadata
│   │   ├── LSP10845@20221215_142258_245849_R40.stc
│   │   ├── LSP10845@20221215_142258_245849_R40.stc.tmp.metadata
│   │   ├── LSP10845@20221215_142258_245849.rcanalysis
│   │   ├── LSP10845@20221215_142258_245849.rcglyph.err
│   │   ├── LSP10845@20221215_142258_245849.rcjob
│   │   ├── LSP10845@20221215_142258_245849.rcpnl
│   │   ├── LSP10845@20221215_142258_245849.shift
│   │   └── LSP10845@20221215_142258_245849.zip
│   ├── LSP10854@20221215_142525_521936
│   └── LSP10857@20221215_162533_660559
├── CHUV_test1-20221216
│   ├── LSP10830@20221216_161352_078722
│   ├── LSP10845@20221216_161352_101223
│   ├── LSP10854@20221216_161352_060222
│   └── LSP10857@20221216_161352_044224
├── CHUV_test1-20221220
│   ├── LSP10830@20221220_142120_266232
│   ├── LSP10845@20221220_142120_215231
│   ├── LSP10854@20221220_142120_231231
│   └── LSP10857@20221220_142120_247232
.
.
.
```

1. rsync from HiTS server to O2 scratch drive

    Note: require [setting up ssh access on
    O2](https://gist.github.com/Yu-AnChen/104cc79e645922b14f8ce8bd6720bf12)

    Edit filepaths in `01-rsync-folder.sh` then submit the rsync job

    ```bash
    sbatch 01-rsync-folder.sh
    ```

1. Re-organize raw files into mcmicro format

    - generate the main `markers.csv`
    - Edit filepaths and slide ids in `02-move_rcpnl_mcmicro.py` and run it
      block by block to make sure the numbers of files are accurate

1. Batch submit nextflow jobs

    - Edit filepaths in `03-submit_multiple.sh`
    - Set resource requirements in `5g.config`
    - Set mcmicro parameters in `params.yml`
    - Edit filepaths in `submit_id_template.sh`
    - Launch multiple jobs

        ```bash
        bash 03-submit_multiple.sh
        ```

    - Refer to `05-omero-upload.md` for batch uploading to omero from scratch
      drive
    - The recommendation is to first `stop-at: registartion` and upload the
      stitched-and-registered image to omero for visual inspection and select
      the desired channel(s) for segmentation
    - Next, `start-at: segmentation` and `stop-at: segmentation` and upload the
      segmentation QC file to omero again to inspect the segmentation quality.
      Adjust segmentation parameters as needed
    - Run the quantification once the segmentation result is confirmed.

1. Cleanup log and reporting files in each of the slide folder

    Edit filepath in `04-cleanup-mcmicro.py` and run the script

    ```bash
    python 04-cleanup-mcmicro.py
    ```

1. Transfer processed results back to HiTS server

    - Make the mosaics.csv as in `rsync-imstor/mosaics.csv`
    - Edit filepaths in `06-transfer-registration.sh`
    - In `rsync-imstor/` run command

        ```bash
        cat mosaics.csv | xargs -I {} sbatch /home/yc00/project/20230119-236-CHUV_test1-2022DEC/06-transfer-registration.sh {}
        ```
