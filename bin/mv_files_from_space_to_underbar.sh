#!/bin/bash

while read i ; do
	FIXED=$(echo $i | tr ' ' '_')
	mv -v "$i" $FIXED
done
