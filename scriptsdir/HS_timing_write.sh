#!/bin/bash

while IFS= read -r line; do
    if [[ $line =~ StimType ]]; then
        echo "$line" >>stimtypetest.txt
    fi
done <eprime.txt

echo "16000" >>durationextracttest.txt

while IFS= read -r line; do
    if [[ $line =~ VidBlock.Duration\: ]] || [[ $line =~ FixationBlock.Duration\: ]]; then
        echo "$line" >>durationextracttest.txt
    fi
done <eprime.txt

onset=0

while IFS= read -r line; do
    if [[ $line =~ 16000 ]]; then
	echo "$onset	16	1" >>allcolumntest.txt
	onset=$(($onset + 16))
    elif [[ $line =~ 15000 ]]; then
	echo "$onset	15	1" >>allcolumntest.txt
	onset=$(($onset + 15))
    elif [[ $line =~ 17000 ]]; then
	echo "$onset	17	1" >>allcolumntest.txt
	onset=$(($onset + 17))
    fi
done <durationextracttest.txt

awk 'NR % 2 == 0' allcolumntest.txt >>stimtimingtest.txt
awk 'NR % 2 == 1' allcolumntest.txt >>fixationtimingtest.txt

line=$(head -1 stimtypetest.txt)
    if [[ $line =~ Nonsocial ]]; then
	awk 'NR % 2 == 0' stimtimingtest.txt >>socialtimingtest.txt
	awk 'NR % 2 == 1' stimtimingtest.txt >>nonsocialtimingtest.txt
    elif [[ $line =~ Social ]]; then
	awk 'NR % 2 == 1' stimtimingtest.txt >>socialtimingtest.txt
	awk 'NR % 2 == 0' stimtimingtest.txt >>nonsocialtimingtest.txt
    fi

rm stimtypetest.txt durationextracttest.txt allcolumntest.txt stimtimingtest.txt

