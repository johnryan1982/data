#!/bin/bash

# generate random CSV rainfall data
#
# usage
# 	./generate.sh COUNT
# 	eg. j=100; for i in {1..4}; do j=$(( j * 10 )); ./generate.sh $j; done
#
# params
# 	COUNT: number of rows of data to generate
#
# example output (piped to data-{COUNT}.csv
# 	year,annual rainfall (mm)
# 	1990,17.26
# 	1991,19.44
#
# note that actual data can be pulled from http://www.metoffice.gov.uk/climate/uk/summaries/datasets

ctr=${1:-100}

YEAR_START=2014

RAINFALL_MIN=90
RAINFALL_MAX=320

f=data.csv

# reset tsv
## truncate file
>|${f}
echo "year,annual rainfall (mm)">> $f

for row in $( eval echo "{$(( YEAR_START - ctr + 1 ))..${YEAR_START}}" )
do
	# generate (terse) double
	## generate random int in range [MPG_MIN..MPG_MAX]
	rInt=$(( ( RANDOM % RAINFALL_MAX ) + RAINFALL_MIN ))
	rFraction=$[100 + ( RANDOM % 100 )]$[1000 + ( RANDOM % 1000 )]
	# generate 1dp (1)
	rainfall=${rInt}.${rFraction:1:1}
	## to generate 5dp (2 + 3)
	##mpg=${rInt}.${rFraction:1:2}${rFraction:4:3}

	echo ${row},${rainfall}>> ${f}
done

# rename file based on row count
mv ${f} ${f%.*}-${row}.${f##*.}
