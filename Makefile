TARGETS=dependencies dag run unlock

CONDA_ENV_DIR=$(shell dirname ${CONDA_EXE})
HN=$(shell hostname | sed "s/[0-9]//g")


ifeq ($(HN),$(filter $(HN),cnode gnode))
  CONDA_ENV_NAME=/exchange/healthds/software/envs/snakemake
else
  CONDA_ENV_NAME=snakemake
endif

all:
	@echo "Try one of: ${TARGETS}"

dag:
	source $(CONDA_ENV_DIR)/activate $(CONDA_ENV_NAME) && \
	snakemake --dag | dot -Tsvg > dag.svg

dependencies:
	mamba env update -n snakemake --file environment.yml

dev-dependencies: dependencies
	mamba env update -n snakemake --file environment_dev.yml

dry-run:
	source $(CONDA_ENV_DIR)/activate $(CONDA_ENV_NAME) && \
	snakemake --sdm conda --dry-run --profile slurm --snakefile workflow/Snakefile

pre-commit:
	if [ ! -f .git/hooks/pre-commit ]; then pre-commit install; fi
	pre-commit run --all-files

local-run:
	snakemake --printshellcmds --sdm conda --sdm apptainer --cores 4 --snakefile workflow/Snakefile

run:
	source $(CONDA_ENV_DIR)/activate $(CONDA_ENV_NAME) && \
	snakemake --profile slurm --snakefile workflow/Snakefile

rerun:
	source $(CONDA_ENV_DIR)/activate $(CONDA_ENV_NAME) && \
	snakemake --profile slurm --snakefile workflow/Snakefile --rerun-incomplete --rerun-trigger mtime

unlock:
	source $(CONDA_ENV_DIR)/activate $(CONDA_ENV_NAME) && \
	snakemake --unlock

dockerfile_:
	source $(CONDA_ENV_DIR)/activate $(CONDA_ENV_NAME) && \
	snakemake --containerize --snakefile workflow/Snakefile > Dockerfile
