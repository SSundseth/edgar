#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Enter year and quarter:"
	echo "./run.sh 2019 QTR4"
	exit 1
fi

YEAR=$1
QTR=$2
URL="https://www.sec.gov/Archives/edgar/full-index/$YEAR/$QTR/form.idx"

echo "Getting index from $URL"
curl $URL > form.txt

echo ""
echo "Deleting all files in data folder in 5 seconds. CTRL-C to cancel"
sleep 5
rm -rf data/*

echo ""
echo "Grepping 13F-HR from index"
grep "13F-HR" form.txt | awk '{print $NF}' > 13fAll.txt
CT=$(wc -l 13fAll.txt)
echo "	$CT forms found"
echo ""


echo "Running python to download forms"
python downloader.py
if [ $? -ne 0 ]; then
	echo "Downloading failed"
	exit 1
fi
echo ""


echo "Running python to parse files"
rm data.csv 2>/dev/null
touch data.csv
python parse.py
CT=$(wc -l data.csv)
echo "	$CT records created"
echo ""

rm form.txt 13fAll.txt
echo "Completed successfully"
