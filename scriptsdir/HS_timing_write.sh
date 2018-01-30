##!/bin/bash

while IFS= read -r line; do
    if [[ $line =~ StimType ]]; then
        echo "$line" >>stimtype.txt
    fi
done <eprime.txt

echo "16000" >>durationextract.txt

while IFS= read -r line; do
    if [[ $line =~ VidBlock.Duration\: ]] || [[ $line =~ FixationBlock.Duration\: ]]; then
        echo "$line" >>durationextract.txt
    fi
done <eprime.txt

onset=0

while IFS= read -r line; do
    if [[ $line =~ 16000 ]]; then
	echo "$onset	16	1" >>allcolumn.txt
	onset=$(($onset + 16))
    elif [[ $line =~ 15000 ]]; then
	echo "$onset	15	1" >>allcolumn.txt
	onset=$(($onset + 15))
    elif [[ $line =~ 17000 ]]; then
	echo "$onset	17	1" >>allcolumn.txt
	onset=$(($onset + 17))
    fi
done <durationextract.txt

awk 'NR % 2 == 0' allcolumn.txt >>stimtiming.txt
awk 'NR % 2 == 1' allcolumn.txt >>fixationtiming.txt

line=$(head -1 stimtype.txt)
    if [[ $line =~ Nonsocial ]]; then
	awk 'NR % 2 == 0' stimtiming.txt >>socialtiming.txt
	awk 'NR % 2 == 1' stimtiming.txt >>nonsocialtiming.txt
    elif [[ $line =~ Social ]]; then
	awk 'NR % 2 == 1' stimtiming.txt >>socialtiming.txt
	awk 'NR % 2 == 0' stimtiming.txt >>nonsocialtiming.txt
    fi

rm stimtype.txt durationextract.txt allcolumn.txt stimtiming.txt
