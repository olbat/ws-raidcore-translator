#!/bin/bash
set -e
set -x

[ $# -ge 2 ] || (echo "usage: $0 <convert|i18n> <raidcore_dir> <dump_dir> [-- <options>]"; exit 1)

mode=$1
[ "$mode" == "convert" ] || [ "$mode" == "i18n" ] || (echo "invalid mode '$mode'"; exit 1)
shift
rcdir=$1
shift
dumpdir=$1
shift

mkdir -p $dumpdir

for file in ${rcdir}/*
do
	name=$(basename $file .lua)

	raidcore-translator $mode -d -n -l fr -v -o ${dumpdir}/${name}-fr.json $@ \
		${rcdir}/${name}.lua 2>&1 | tee ${dumpdir}/${name}-fr.log

	raidcore-translator $mode -d -n -l de -v -o ${dumpdir}/${name}-de.json $@ \
		${rcdir}/${name}.lua 2>&1 | tee ${dumpdir}/${name}-de.log
done

raidcore-translator $mode -d -n -l fr -v -o ${dumpdir}/All-fr.json \
	$@ ${rcdir} 2>&1 | tee ${dumpdir}/All-fr.log

raidcore-translator $mode -d -n -l de -v -o ${dumpdir}/All-de.json \
	$@ ${rcdir} 2>&1 | tee ${dumpdir}/All-de.log
