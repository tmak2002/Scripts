#!/bin/bash
files=$(ls)
for file in $files
do
	end_file=${file%.*}
	magick $file -quality 100 -define webp:lossless=true ${end_file}.webp
done
