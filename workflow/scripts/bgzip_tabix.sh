#!/bin/bash

INPUT=$1
THREADS=$2
DIRNAME=`dirname ${1}`
FILENAME=`basename ${1} .gz`

# tabix indexes CHROM and POS columns
gunzip ${INPUT} && bgzip --threads ${THREADS} ${DIRNAME}/${FILENAME} && tabix -f -S 1 -s 1 -b 2 -e 2 ${INPUT}
