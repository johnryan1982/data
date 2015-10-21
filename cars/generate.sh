#!/bin/bash

# generate random CSV car data
#
# usage
# 	./generate.sh COUNT
# 	eg. j=100; for i in {1..4}; do j=$(( j * 10 )); ./generate.sh $j; done
#
# params
# 	COUNT: number of rows of data to generate
#
# example output (piped to data-{COUNT}.csv
# 	name,economy (mpg),cylinders,displacement (cc),power (hp),weight (lb),0-60 mph (s),year
# 	1,16.3,4,343,105,2074,12.8,107
# 	2,50,9,237,251,3672,10.3,104
# 	3,45.3,8,155,271,5037,28.7,142

ctr=${1:-406}

MPG_MIN=8
MPG_MAX=46

CYLINDERS_MIN=3
CYLINDERS_MAX=8

CC_MIN=70
CC_MAX=460

HP_MIN=50
HP_MAX=230

WEIGHT_MIN=1200
WEIGHT_MAX=5100

ACCELERATION_MIN=8
ACCELERATION_MAX=25

YEAR_MIN=70
YEAR_MAX=82

f=data.csv

# reset tsv
## truncate file
>|${f}
echo "name,economy (mpg),cylinders,displacement (cc),power (hp),weight (lb),0-60 mph (s),year">> $f

for row in $( eval echo "{1..$ctr}" )
do
	# generate (terse) double
	## generate random int in range [MPG_MIN..MPG_MAX]
	rInt=$(( ( RANDOM % MPG_MAX ) + MPG_MIN ))
	rFraction=$[100 + ( RANDOM % 100 )]$[1000 + ( RANDOM % 1000 )]
	# generate 1dp (1)
	mpg=${rInt}.${rFraction:1:1}
	## to generate 5dp (2 + 3)
	##mpg=${rInt}.${rFraction:1:2}${rFraction:4:3}

	cylinders=$(( ( RANDOM % CYLINDERS_MAX ) + CYLINDERS_MIN ))
	cc=$(( ( RANDOM % CC_MAX ) + CC_MIN ))
	hp=$(( ( RANDOM % HP_MAX ) + HP_MIN ))
	weight=$(( ( RANDOM % WEIGHT_MAX ) + WEIGHT_MIN ))

	# generate (terse) double
	## generate random int in range [MPG_MIN..MPG_MAX]
	rInt=$(( ( RANDOM % ACCELERATION_MAX ) + ACCELERATION_MIN ))
	rFraction=$[100 + ( RANDOM % 100 )]$[1000 + ( RANDOM % 1000 )]
	# generate 1dp (1)
	acceleration=${rInt}.${rFraction:1:1}
	## to generate 5dp (2 + 3)
	##mpg=${rInt}.${rFraction:1:2}${rFraction:4:3}

	year=$(( ( RANDOM % YEAR_MAX ) + YEAR_MIN ))
	echo ${row},${mpg},${cylinders},${cc},${hp},${weight},${acceleration},${year}>> ${f}
done

# rename file based on row count
mv ${f} ${f%.*}-${row}.${f##*.}
