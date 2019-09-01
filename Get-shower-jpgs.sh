#!/bin/bash

mkdir c:/temp/$1
grep -H -r -l -c "$1 r" **/*.txt | cut -d. -f1 | while read i 
do
 cp "$i"P.JPG c:/temp/$1
done
