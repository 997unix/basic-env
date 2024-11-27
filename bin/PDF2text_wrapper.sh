#!/bin/bash
FILES=./*.pdf
for f in $FILES
do
    echo "Processing $f file..."
    pdftotext -enc UTF-8 $f
done
unset FILES
