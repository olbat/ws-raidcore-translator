#!/bin/bash
set -e
set -x

[ $# -ge 2 ] || (echo "usage: $0 <raidcore_dir> <dump_dir> [-- <options>]"; exit 1)

rcdir=$1
shift
dumpdir=$1
shift

mkdir -p $dumpdir

for file in ${rcdir}/*
do
	name=$(basename $file .lua)

	raidcore-translator dump -l fr -v -o ${dumpdir}/${name}-fr.json $@ \
		${rcdir}/${name}.lua 2>&1 | tee ${dumpdir}/${name}-fr.log

	raidcore-translator dump -l de -v -o ${dumpdir}/${name}-de.json $@ \
		${rcdir}/${name}.lua 2>&1 | tee ${dumpdir}/${name}-de.log
done

raidcore-translator dump -l fr -v -o ${dumpdir}/All-fr.json \
	$@ ${rcdir} 2>&1 | tee ${dumpdir}/All-fr.log

raidcore-translator dump -l de -v -o ${dumpdir}/All-de.json \
	$@ ${rcdir} 2>&1 | tee ${dumpdir}/All-de.log
