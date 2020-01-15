#!/bin/bash

YEAR=$(date +%Y)
DAY=$(date +%Y%m%d)
DATE=$(date +%m%d)

if [ $DATE -lt 331 ]; then
	QTR="QTR1"
elif [ $DATE -lt 630 ]; then
	QTR="QTR2"
elif [ $DATE -lt 930 ]; then
	QTR="QTR3"
else
	QTR="QTR4"
fi


URL="https://www.sec.gov/Archives/edgar/daily-index/$YEAR/$QTR/form.$DAY.idx"

echo "Getting index from $URL"
curl $URL > form.txt

echo ""
echo "Grepping 13F-HR from index"
grep "13F-HR" form.txt | awk '{print $NF}' > 13fAll.txt
CT=$(wc -l 13fAll.txt)
echo "	$CT forms found"
echo ""

if [ ! -s 13fAll.txt ]; then
	echo "No forms found, quitting"
	exit
fi


echo ""
echo "Deleting all files in data folder in 5 seconds. CTRL-C to cancel"
sleep 5
rm -rf data/*
rm data.csv 2>&1
rm dataAddition.csv 2>&1


echo "Running python to download forms"
python downloader.py
if [ $? -ne 0 ]; then
	echo "Downloading failed"
	exit 1
fi
echo ""

echo "Running python to parse files"
touch data.csv dataAddition.csv
python parse.py
if [ $? -ne 0 ]; then
	echo "Parsing failed"
	exit 1
fi
CT=$(wc -l data.csv)
echo "	$CT records created"
echo ""

echo "Running python to load and calculate"
cp data.csv "/c/ProgramData/MySQL/MySQL Server 5.7/Uploads/"
cp dataAddition.csv "/c/ProgramData/MySQL/MySQL Server 5.7/Uploads/"
python load.py

rm form.txt 13fAll.txt
echo "Completed successfully"
