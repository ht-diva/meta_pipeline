#!/bin/bash

INPUT=$1
THREADS=$2
DIRNAME=`dirname ${1}`
FILENAME=`basename ${1} .gz`
EXT=".bgz"
OUTPUT="${DIRNAME}/${FILENAME}${EXT}"
TMPFILE=$(mktemp $TMPDIR/foo-XXXXXX)


# tabix indexes CHROM and POS columns
echo ${OUTPUT} && \
gunzip -c ${INPUT} >  ${TMPFILE} && \
sed -i -e 's/CHR/#CHR/g' ${TMPFILE} && \
bgzip --stdout --threads ${THREADS}  ${TMPFILE} > ${OUTPUT} && \
tabix -f -s 1 -b 2 -e 2 ${OUTPUT} && \
num_lines=$(tabix -l "$OUTPUT" | wc -l) && \
if [[ "$num_lines" -eq 22 ]]; then
	echo "Number of lines in the index: $num_lines"
else
	echo "Wrong number of lines in the index: $num_lines"
	exit 1
fi
