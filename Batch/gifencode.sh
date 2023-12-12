#!/bin/sh
palette="palette.png"
filters="fps=15,scale=0:-1:flags=lanczos"

ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -plays 0 -y $2
rm -f $palette
