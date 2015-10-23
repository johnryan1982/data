#!/bin/bash

# TODO: add timestamp to loop output
# eg.
# 	0000001 ... 000000N `date -u`

# generate random CSV financial data
#
# usage
# 	./generate.sh COUNT
# 	eg. j=100; for i in {1..4}; do j=$(( j * 10 )); ./generate.sh $j; done
#
# params
# 	COUNT: number of rows of data to generate
#
# example output (piped to data-{COUNT}.csv)
# 	date,price,volume,value
# 	22-Oct-15 09:47,17.02
# 	22-Oct-15 09:46,16.98
# 	22-Oct-15 09:45,16.97
# 	22-Oct-15 09:44,16.98

echo "warning this is a VERY SLOW process..."

ctr=${1:-100}

PRICE_MIN=9
PRICE_MAX=15

f=data.csv

# reset tsv
## truncate file
>|${f}
echo "date,price,volume,value">> $f

# cache current date
START_DATE=`date -u`
LOOP=10

for row in $( eval echo "{1..${ctr}}" )
do
	# print loop
	if [ $(( row % LOOP )) -eq 1 ]
	then
		max=$(( row + ( LOOP - 1 ) ))

		if [ $max -gt $ctr ]
		then
			max=$ctr
		fi

		echo ${row} ${max} | awk 'NR==1{ printf "%07d ... %07d\n", $1, $2}'
	fi

	# generate date (%d-%b-%y %H:%M)
#	dt=`eval "date -d '${row} minutes ago' +%d-%b-%y\ %H:%M"`
	dt=`eval "date '+%d-%b-%y %H:%M'" --date=\"${START_DATE} ${row} minutes ago\"`
	# generate (terse) double
	## generate random int in range [PRICE_MIN..PRICE_MAX]
	rInt=$(( ( RANDOM % ( PRICE_MAX - PRICE_MIN ) + PRICE_MIN ) ))
	rFraction=$[100 + ( RANDOM % 100 )]$[1000 + ( RANDOM % 1000 )]
	# generate 2dp (2)
	price=${rInt}.${rFraction:1:2}
	## to generate 5dp (2 + 3)
	##mpg=${rInt}.${rFraction:1:2}${rFraction:4:3}

	volume=$(( ( RANDOM % ( 1000 - 1 ) + 1 ) ))
	value=$( echo $price $volume | awk '{ printf "%.2f", $1 * $2 }' )
	echo ${dt},${price},${volume},${value}>> ${f}
done

# rename file based on row count
masterFile=${f%.*}-${row}.${f##*.}
mv ${f} ${masterFile}

# using generated data, create subsets
#for i in 10 100 1000 10000 100000
#do
#	eval "head -$(( i + 1 )) ${masterFile} > data-${i}.${f##*.}"
#done