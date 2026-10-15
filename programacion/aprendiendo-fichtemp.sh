#!/bin/bash -x
if [ $# = 1 ]; then
# o también if [ "$1" != "" ]; then
	output=$1
else
	output="agenda.dat"
fi
fichtemp=$(tempfile -d . 2>/dev/null)
fichtemp2=$(tempfile -d . 2>/dev/null)

trap "rm -f $fichtemp $fichtemp2" 0 1 2 5 15

cut -d: -f3 $output | sort -nr > $fichtemp
while read linea ; do
	grep :$linea: $output >> $fichtemp2
done < $fichtemp
cat $fichtemp2 > $output
