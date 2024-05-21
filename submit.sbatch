#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@fht.org
#SBATCH --job-name meta_pipeline
#SBATCH --output %j_meta_pipeline.log
#SBATCH --partition cpuq
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 48:00:00

source ~/.bashrc
module -s load singularity/3.8.5

# set some singularity directories depending on frontend/computing node/vm
case $(hostname) in
  hnode*)
    export SINGULARITY_TMPDIR=/tmp/
    export SINGULARITY_BIND="/cm,/exchange,/processing_data,/project,/scratch,/center,/group,/facility,/ssu"
    ;;
  cnode*|gnode*)
    export SINGULARITY_TMPDIR=$TMPDIR
    export SINGULARITY_BIND="/cm,/exchange,/processing_data,/project,/localscratch,/scratch,/center,/group,/facility,/ssu"
    ;;
  lin-hds-*)
    export SINGULARITY_TMPDIR=/tmp/
    export SINGULARITY_BIND="/processing_data,/project,/center,/group,/facility,/ssu,/exchange"
    ;;
  *)
    export SINGULARITY_TMPDIR=/var/tmp/
    ;;
esac

# run the pipeline
make run
