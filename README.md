# meta_pipeline

## Requirements
* Singularity

see also [environment.yml](environment.yml) and [Makefile](Makefile)

## Getting started

* git clone https://github.com/ht-diva/meta_pipeline.git
* cd meta_pipeline
* adapt the [submit.sbatch](submit.sbatch) and [config/config.yaml](config/config.yaml) files to your environment
* sbatch submit.sbatch

The output is written to the path defined by the **workspace_path** variable in the config.yaml file. By default, this path is `./results`.

At the very beginning, the pipeline tries to match each protein label from the first study with the corresponding one from the second study and writes a mismatch_table.csv file to the workspace.
Only matching datasets are processed with METAL
