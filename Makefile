TARGETS=dependencies dag run unlock

all:
	@echo "Try one of: ${TARGETS}"

dag:
	snakemake --dag | dot -Tsvg > dag.svg

dependencies:
	mamba env update -n snakemake --file environment.yml

dev-dependencies: dependencies
	mamba env update -n snakemake --file environment_dev.yml

dry-run:
	snakemake --sdm conda --dry-run --profile slurm --snakefile workflow/Snakefile

pre-commit:
	if [ ! -f .git/hooks/pre-commit ]; then pre-commit install; fi
	pre-commit run --all-files

run:
	snakemake --profile slurm --snakefile workflow/Snakefile

rerun:
	snakemake --profile slurm --snakefile workflow/Snakefile --rerun-incomplete

unlock:
	snakemake --unlock

dockerfile_:
	snakemake --containerize --snakefile workflow/Snakefile > Dockerfile
